package com.landray.kmss.common.convertor;

import java.beans.PropertyDescriptor;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.beanutils.NestedNullException;
import org.apache.commons.beanutils.PropertyUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.landray.kmss.code.examine.ExamineContext;
import com.landray.kmss.common.forms.IExtendForm;
import com.landray.kmss.common.model.IBaseModel;
import com.landray.kmss.util.ObjectUtil;

/**
 * 将Model模型转换为Form模型，常用于一对一的转换
 * 
 * @author 叶中奇
 * 
 */
public class ModelConvertor_ModelToForm extends BaseModelConvertor implements
		IModelToFormConvertor {
	private static final Log logger = LogFactory
			.getLog(ModelConvertor_ModelToForm.class);

	/**
	 * @param tPropertyName
	 *            目标属性名
	 */
	public ModelConvertor_ModelToForm(String tPropertyName) {
		this.tPropertyName = tPropertyName;
	}

	public void excute(ConvertorContext ctx) throws Exception {
		IBaseModel sModel;
		try {
			sModel = (IBaseModel) PropertyUtils.getProperty(ctx.getSObject(),
					ctx.getSPropertyName());
		} catch (NestedNullException e) {
			if (logger.isDebugEnabled())
				logger.debug("获取属性" + ctx.getSPropertyName()
						+ "的值时中间出现null值，不转换该属性");
			return;
		}
		if (sModel == null) {
			if (logger.isDebugEnabled())
				logger.debug("属性" + ctx.getSPropertyName() + "的值为null，不转换该属性");
			return;
		}
		BeanUtils.copyProperty(ctx.getTObject(), getTPropertyName(), ctx
				.getBaseService().convertModelToForm(null, sModel, ctx));
	}

	public ModelConvertor_ModelToForm setTPropertyName(String propertyName) {
		tPropertyName = propertyName;
		return this;
	}

	public void examine(ExamineContext context, Class modelClass,
			Class formClass) {
		String sProperty = (String) context.getParameter("sProperty");
		PropertyDescriptor descriptor = ObjectUtil.getPropertyDescriptor(
				modelClass, sProperty);
		if (descriptor == null || descriptor.getReadMethod() == null)
			context.addError(modelClass, "getToModelPropertyMap", 1, "源属性"
					+ sProperty + "无getter方法");
		else {
			Class childClass = descriptor.getPropertyType();
			IBaseModel childObj = null;
			try {
				childObj = (IBaseModel) childClass.newInstance();
			} catch (Exception e) {
				context.addError(modelClass, sProperty, 1, "源属性" + sProperty
						+ "的类型必须能实例化为一个Model对象");
			}
			if (childObj != null && childObj.getFormClass() == null)
				context.addError(modelClass, sProperty, 1, "源属性" + sProperty
						+ "对应的对象的getFormClass方法不能返回null");
		}

		descriptor = ObjectUtil.getPropertyDescriptor(formClass, tPropertyName);
		if (descriptor == null || descriptor.getWriteMethod() == null)
			context.addError(modelClass, "getToFormPropertyMap", 1, "目标属性"
					+ tPropertyName + "无setter方法");
		else if (!IExtendForm.class.isAssignableFrom(descriptor
				.getPropertyType()))
			context.addError(modelClass, "getToFormPropertyMap", 1, "目标属性"
					+ tPropertyName + "必须是一个Form");
	}
}
