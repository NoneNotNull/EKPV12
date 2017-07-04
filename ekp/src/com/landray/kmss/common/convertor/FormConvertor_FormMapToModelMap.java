package com.landray.kmss.common.convertor;

import java.beans.PropertyDescriptor;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

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
import com.landray.kmss.util.AutoHashMap;
import com.landray.kmss.util.ObjectUtil;

/**
 * 将Form模型Map转换为域模型Map，常用于一对多的转换
 * 
 * @author 叶中奇
 * 
 */
public class FormConvertor_FormMapToModelMap extends BaseFormConvertor
		implements IFormToModelConvertor {
	private static final Log logger = LogFactory
			.getLog(FormConvertor_FormMapToModelMap.class);

	private String tChildToParentProperty;

	/**
	 * @param tPropertyName
	 *            目标属性名
	 * @param tChildToParentProperty
	 *            子域模型到父域模型的属性名
	 */
	public FormConvertor_FormMapToModelMap(String tPropertyName,
			String tChildToParentProperty) {
		this.tPropertyName = tPropertyName;
		this.tChildToParentProperty = tChildToParentProperty;
	}

	public void excute(ConvertorContext ctx) throws Exception {
		Map sMap;
		try {
			sMap = (Map) PropertyUtils.getProperty(ctx.getSObject(), ctx
					.getSPropertyName());
		} catch (NestedNullException e) {
			if (logger.isDebugEnabled())
				logger.debug("获取属性" + ctx.getSPropertyName()
						+ "的值时中间出现null值，不转换该属性");
			return;
		}
		if (sMap == null) {
			if (logger.isDebugEnabled())
				logger.debug("属性" + ctx.getSPropertyName() + "的值为null，不转换该属性");
			return;
		}
		Map tMap = (Map) PropertyUtils.getProperty(ctx.getTObject(),
				getTPropertyName());
		if (tMap == null)
			tMap = new HashMap();
		else
			tMap.clear();

		Iterator keys = sMap.keySet().iterator();
		while (keys.hasNext()) {
			Object key = keys.next();
			IExtendForm sForm = (IExtendForm) sMap.get(key);
			if (sForm != null) {
				IBaseModel tModel = ctx.getBaseService().convertFormToModel(
						sForm, null, ctx);
				BeanUtils.copyProperty(tModel, getTChildToParentProperty(), ctx
						.getTObject());
				tMap.put(key, tModel);
			}
		}
		BeanUtils.copyProperty(ctx.getTObject(), getTPropertyName(), tMap);
	}

	public void validate(Object form, String sProperty, ActionErrors errors,
			ActionMapping mapping, HttpServletRequest request,
			ActionServlet servlet) {
		Map formMap = null;
		try {
			formMap = (Map) PropertyUtils.getProperty(form, sProperty);
		} catch (Exception e) {
			throw new KmssRuntimeException(e);
		}
		for (Iterator iter = formMap.values().iterator(); iter.hasNext();)
			validateChild(iter.next(), errors, mapping, request, servlet);
	}

	public String getTChildToParentProperty() {
		return tChildToParentProperty;
	}

	public FormConvertor_FormMapToModelMap setTChildToParentProperty(
			String childToParentProperty) {
		tChildToParentProperty = childToParentProperty;
		return this;
	}

	public FormConvertor_FormMapToModelMap setTPropertyName(String propertyName) {
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
		else if (!Map.class.isAssignableFrom(descriptor.getPropertyType()))
			context.addError(formClass, "getToModelPropertyMap", 1, "目标属性"
					+ tPropertyName + "必须是Map类型");

		Object form = context.getParameter("form");
		String sProperty = (String) context.getParameter("sProperty");
		Map sPropertyMap = null;
		try {
			Object value = PropertyUtils.getProperty(form, sProperty);
			if (value == null) {
				context.addError(formClass, sProperty, 1, "属性" + sProperty
						+ "必须有初值");
			} else if (!(value instanceof AutoHashMap)) {
				context.addError(formClass, sProperty, 1, "属性" + sProperty
						+ "初始化为一个AutoHashMap的实体");
			} else {
				sPropertyMap = (Map) value;
			}
		} catch (Exception e) {
			context.addError(formClass, sProperty, 1, "属性" + sProperty
					+ "的值无法读取");
		}
		if (sPropertyMap != null) {
			Object child = null;
			try {
				child = sPropertyMap.get("key");
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
							+ "的元素必须为Form");
				}
			}
		}
	}
}
