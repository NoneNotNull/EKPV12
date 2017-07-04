package com.landray.kmss.common.convertor;

import java.beans.PropertyDescriptor;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.beanutils.NestedNullException;
import org.apache.commons.beanutils.PropertyUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.landray.kmss.code.examine.ExamineContext;
import com.landray.kmss.common.model.IBaseModel;
import com.landray.kmss.util.ObjectUtil;

/**
 * 将ID转换为域模型，常用于多对一的关系
 * 
 * @author 叶中奇
 */
public class FormConvertor_IDToModel extends BaseFormConvertor implements
		IFormToModelConvertor {
	private static final Log logger = LogFactory
			.getLog(FormConvertor_IDToModel.class);

	private Class modelClass;

	/**
	 * @param tPropertyName
	 *            目标属性名
	 * @param modelClass
	 *            目标域模型的类
	 */
	public FormConvertor_IDToModel(String tPropertyName, Class modelClass) {
		this.tPropertyName = tPropertyName;
		this.modelClass = modelClass;
	}

	public void excute(ConvertorContext ctx) throws Exception {
		String id;
		try {
			id = (String) PropertyUtils.getProperty(ctx.getSObject(), ctx
					.getSPropertyName());
		} catch (NestedNullException e) {
			id = null;
			if (logger.isDebugEnabled())
				logger.debug("获取属性值" + ctx.getSPropertyName() + "时中间出现null值");
		}
		if (id == null)
			return;
		if (id.trim().length() == 0)
			BeanUtils.copyProperty(ctx.getTObject(), getTPropertyName(), null);
		else
			BeanUtils.copyProperty(ctx.getTObject(), getTPropertyName(), ctx
					.getBaseService().findByPrimaryKey(id, getModelClass(),
							false));
	}

	public Class getModelClass() {
		return modelClass;
	}

	public FormConvertor_IDToModel setModelClass(Class modelClass) {
		this.modelClass = modelClass;
		return this;
	}

	public FormConvertor_IDToModel setTPropertyName(String propertyName) {
		tPropertyName = propertyName;
		return this;
	}

	public void examine(ExamineContext context, Class fromClass, Class toClass) {
		String sProperty = (String) context.getParameter("sProperty");
		PropertyDescriptor descriptor = ObjectUtil.getPropertyDescriptor(
				fromClass, sProperty);
		if (descriptor == null || descriptor.getReadMethod() == null)
			context.addError(fromClass, "getToModelPropertyMap", 1, "源属性"
					+ sProperty + "无getter方法");
		else if (!String.class.isAssignableFrom(descriptor.getPropertyType()))
			context.addError(fromClass, "getToModelPropertyMap", 1, "源属性"
					+ sProperty + "应该是String类型");

		descriptor = ObjectUtil.getPropertyDescriptor(toClass, tPropertyName);
		if (descriptor == null || descriptor.getWriteMethod() == null)
			context.addError(fromClass, "getToModelPropertyMap", 1, "目标属性"
					+ tPropertyName + "无setter方法");
		if (!IBaseModel.class.isAssignableFrom(modelClass)) {
			context.addError(fromClass, "getToModelPropertyMap", 1, "目标属性"
					+ tPropertyName + "对应的类必须是Model");
		} else {
			if (descriptor != null && descriptor.getWriteMethod() != null) {
				if (!descriptor.getPropertyType().isAssignableFrom(modelClass))
					context.addError(fromClass, "getToModelPropertyMap", 1,
							"目标属性" + tPropertyName + "的setter方法参数与给定的类不匹配");
			}
		}
	}
}
