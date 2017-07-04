package com.landray.kmss.common.convertor;

import java.beans.PropertyDescriptor;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.beanutils.NestedNullException;
import org.apache.commons.beanutils.PropertyUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionServlet;

import com.landray.kmss.code.examine.ExamineContext;
import com.landray.kmss.common.exception.KmssRuntimeException;
import com.landray.kmss.common.forms.IExtendForm;
import com.landray.kmss.common.model.IBaseModel;
import com.landray.kmss.util.ObjectUtil;

/**
 * 将Form模型转换为域模型，常用于一对一的转换
 * 
 * @author 叶中奇
 * 
 */
public class FormConvertor_FormToModel extends BaseFormConvertor implements
		IFormToModelConvertor {
	private static final Log logger = LogFactory
			.getLog(FormConvertor_FormToModel.class);

	/**
	 * @param tPropertyName
	 *            目标属性名
	 */
	public FormConvertor_FormToModel(String tPropertyName) {
		this.tPropertyName = tPropertyName;
	}

	public void excute(ConvertorContext ctx) throws Exception {
		IExtendForm sForm;
		try {
			sForm = (IExtendForm) PropertyUtils.getProperty(ctx.getSObject(),
					ctx.getSPropertyName());
		} catch (NestedNullException e) {
			if (logger.isDebugEnabled())
				logger.debug("获取属性" + ctx.getSPropertyName()
						+ "的值时中间出现null值，不转换该属性");
			return;
		}
		if (sForm == null) {
			if (logger.isDebugEnabled())
				logger.debug("属性" + ctx.getSPropertyName() + "的值为null，不转换该属性");
			return;
		}
		BeanUtils.copyProperty(ctx.getTObject(), getTPropertyName(), ctx
				.getBaseService().convertFormToModel(sForm, null, ctx));
	}

	public void validate(Object form, String sProperty, ActionErrors errors,
			ActionMapping mapping, HttpServletRequest request,
			ActionServlet servlet) {
		Object childForm = null;
		try {
			childForm = PropertyUtils.getProperty(form, sProperty);
		} catch (Exception e) {
			throw new KmssRuntimeException(e);
		}
		validateChild(childForm, errors, mapping, request, servlet);
	}

	public FormConvertor_FormToModel setTPropertyName(String propertyName) {
		tPropertyName = propertyName;
		return this;
	}

	public void examine(ExamineContext context, Class fromClass, Class toClass) {
		String sProperty = (String) context.getParameter("sProperty");
		Object form = context.getParameter("form");
		try {
			Object value = PropertyUtils.getProperty(form, sProperty);
			if (value == null) {
				context.addError(fromClass, sProperty, 1, "属性" + sProperty
						+ "必须有初值");
			} else if (!(value instanceof IExtendForm)) {
				context.addError(fromClass, sProperty, 1, "属性" + sProperty
						+ "必须初始化为一个Form的实体");
			} else {
				IExtendForm sPropertyObj = (IExtendForm) value;
				if (sPropertyObj.getModelClass() == null)
					context.addError(fromClass, sProperty, 1, "属性" + sProperty
							+ "对应的Form的getModelClass不能返回null");
			}
		} catch (Exception e) {
			context.addError(fromClass, sProperty, 1, "属性" + sProperty
					+ "的值无法获取");
		}

		PropertyDescriptor descriptor = ObjectUtil.getPropertyDescriptor(
				toClass, tPropertyName);
		if (descriptor == null || descriptor.getWriteMethod() == null)
			context.addError(fromClass, "getToModelPropertyMap", 1, "目标属性"
					+ tPropertyName + "无setter方法");
		else if (!IBaseModel.class.isAssignableFrom(descriptor
				.getPropertyType()))
			context.addError(fromClass, "getToModelPropertyMap", 1, "目标属性"
					+ tPropertyName + "必须是一个Model");
	}
}
