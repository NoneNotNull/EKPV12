package com.landray.kmss.common.convertor;

import java.beans.PropertyDescriptor;
import java.util.ArrayList;
import java.util.List;

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
import com.landray.kmss.util.AutoArrayList;
import com.landray.kmss.util.ObjectUtil;

/**
 * 将Form模型列表转换为域模型列表，常用于一对多的转换
 * 
 * @author 叶中奇
 * 
 */
public class FormConvertor_FormListToModelList extends BaseFormConvertor
		implements IFormToModelConvertor {
	private static final Log logger = LogFactory
			.getLog(FormConvertor_FormListToModelList.class);

	private String tChildToParentProperty;

	/**
	 * @param tPropertyName
	 *            目标属性名
	 * @param tChildToParentProperty
	 *            子域模型到父域模型的属性名
	 */
	public FormConvertor_FormListToModelList(String tPropertyName,
			String tChildToParentProperty) {
		this.tPropertyName = tPropertyName;
		this.tChildToParentProperty = tChildToParentProperty;
	}

	public void excute(ConvertorContext ctx) throws Exception {
		List sList;
		try {
			sList = (List) PropertyUtils.getProperty(ctx.getSObject(), ctx
					.getSPropertyName());
		} catch (NestedNullException e) {
			if (logger.isDebugEnabled())
				logger.debug("获取属性" + ctx.getSPropertyName()
						+ "的值时中间出现null值，不转换该属性");
			return;
		}
		if (sList == null) {
			if (logger.isDebugEnabled())
				logger.debug("属性" + ctx.getSPropertyName() + "的值为null，不转换该属性");
			return;
		}
		List tList = (List) PropertyUtils.getProperty(ctx.getTObject(),
				getTPropertyName());
		if (tList == null)
			tList = new ArrayList();
		else
			tList.clear();
		for (int i = 0; i < sList.size(); i++) {
			IExtendForm sForm = (IExtendForm) sList.get(i);
			if (sForm != null) {
				IBaseModel tModel = ctx.getBaseService().convertFormToModel(
						sForm, null, ctx);
				tList.add(tModel);
				BeanUtils.copyProperty(tModel, getTChildToParentProperty(), ctx
						.getTObject());
			}
		}
		BeanUtils.copyProperty(ctx.getTObject(), getTPropertyName(), tList);
	}

	public void validate(Object form, String sProperty, ActionErrors errors,
			ActionMapping mapping, HttpServletRequest request,
			ActionServlet servlet) {
		List formList = null;
		try {
			formList = (List) PropertyUtils.getProperty(form, sProperty);
		} catch (Exception e) {
			throw new KmssRuntimeException(e);
		}
		for (int i = 0; i < formList.size(); i++)
			validateChild(formList.get(i), errors, mapping, request, servlet);
	}

	public String getTChildToParentProperty() {
		return tChildToParentProperty;
	}

	public FormConvertor_FormListToModelList setTChildToParentProperty(
			String childToParentProperty) {
		tChildToParentProperty = childToParentProperty;
		return this;
	}

	public FormConvertor_FormListToModelList setTPropertyName(
			String propertyName) {
		tPropertyName = propertyName;
		return this;
	}

	public void examine(ExamineContext context, Class formClass,
			Class modelClass) {
		PropertyDescriptor descriptor = ObjectUtil.getPropertyDescriptor(
				modelClass, tPropertyName);
		if (descriptor == null || descriptor.getWriteMethod() == null)
			context.addError(formClass, "getToModelPropertyMap", 1, "目标属性"
					+ tPropertyName + "无setter方法");
		else if (!List.class.isAssignableFrom(descriptor.getPropertyType()))
			context.addError(formClass, "getToModelPropertyMap", 1, "目标属性"
					+ tPropertyName + "必须是List类型");

		Object form = context.getParameter("form");
		String sProperty = (String) context.getParameter("sProperty");
		List sPropertyList = null;
		try {
			Object value = PropertyUtils.getProperty(form, sProperty);
			if (value == null) {
				context.addError(formClass, sProperty, 1, "属性" + sProperty
						+ "必须有初值");
			} else if (!(value instanceof AutoArrayList)) {
				context.addError(formClass, sProperty, 1, "属性" + sProperty
						+ "初始化为一个AutoArrayList的实体");
			} else {
				sPropertyList = (List) value;
			}
		} catch (Exception e) {
			context.addError(formClass, sProperty, 1, "属性" + sProperty
					+ "的值无法获取");
		}
		if (sPropertyList != null) {
			Object child = null;
			try {
				child = sPropertyList.get(0);
			} catch (Exception e) {
				context.addError(formClass, sProperty, 1, "属性" + sProperty
						+ "的元素无法被实例化");
			}
			if (child != null) {
				if (child instanceof IExtendForm) {
					Class childModelClass = ((IExtendForm) child)
							.getModelClass();
					if (childModelClass == null) {
						context.addError(formClass, sProperty, 1, "属性"
								+ sProperty + "对应的Form中getModelClass不能返回null");
					} else {
						descriptor = ObjectUtil.getPropertyDescriptor(
								childModelClass, tChildToParentProperty);
						if (descriptor == null
								|| descriptor.getWriteMethod() == null)
							context.addError(formClass,
									"getToModelPropertyMap", 1, "属性"
											+ sProperty + "对应域模型中的属性"
											+ tChildToParentProperty
											+ "无setter方法");
					}
				} else {
					context.addError(formClass, sProperty, 1, "属性" + sProperty
							+ "的元素必须为Form对象");
				}
			}
		}
	}
}
