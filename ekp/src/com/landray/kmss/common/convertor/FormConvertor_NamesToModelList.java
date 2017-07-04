package com.landray.kmss.common.convertor;

import java.beans.PropertyDescriptor;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.beanutils.NestedNullException;
import org.apache.commons.beanutils.PropertyUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.landray.kmss.code.examine.ExamineContext;
import com.landray.kmss.common.model.IBaseModel;
import com.landray.kmss.util.ObjectUtil;
import com.landray.kmss.util.StringUtil;

import edu.emory.mathcs.backport.java.util.Arrays;

/**
 * 将多个Name组成的字符串转换为有序的域模型列表，常用于多对一的关系
 * 
 * @author 舒斌
 * 
 */
@SuppressWarnings("unchecked")
public class FormConvertor_NamesToModelList extends BaseFormConvertor implements
		IFormToModelConvertor {
	private static final Log logger = LogFactory
			.getLog(FormConvertor_NamesToModelList.class);

	private Class modelClass;

	private String splitStr;

	private String foreignKeyProperty;

	private String subClassProperty;

	/**
	 * @param tPropertyName
	 *            目标属性名
	 * @param foreignKeyProperty
	 *            目标列表中每个域模型类中的外键属性字段名
	 * @param foreignKeyClass
	 *            目标列表中每个域模型类中的外键属性字段的类型
	 * @param subClassProperty
	 *            要转换到目标列表中每个域模型中的类中的属性名
	 * @param modelClass
	 *            目标列表中每个域模型的类
	 */
	public FormConvertor_NamesToModelList(String tPropertyName,
			String foreignKeyProperty, Class foreignKeyClass,
			String subClassProperty, Class modelClass) {
		this.tPropertyName = tPropertyName;
		this.modelClass = modelClass;
		this.subClassProperty = subClassProperty;
		this.foreignKeyProperty = foreignKeyProperty;
	}

	public void excute(ConvertorContext ctx) throws Exception {
		// 获取form中的目标值
		String names;
		try {
			names = (String) PropertyUtils.getProperty(ctx.getSObject(), ctx
					.getSPropertyName());
		} catch (NestedNullException e) {
			if (logger.isDebugEnabled())
				logger.debug("获取属性" + ctx.getSPropertyName()
						+ "的值时中间出现null值，不转换该属性");
			return;
		}
		if (names == null) {
			if (logger.isDebugEnabled())
				logger.debug("属性" + ctx.getSPropertyName() + "的值为null，不转换该属性");
			return;
		}
		// 获取model的原值
		List tList = (List) PropertyUtils.getProperty(ctx.getTObject(),
				tPropertyName);
		if (tList == null) {
			tList = new ArrayList();
		}
		// 处理空值
		if (names.trim().equals("")) {
			tList.clear();
			BeanUtils.copyProperty(ctx.getTObject(), tPropertyName, tList);
			return;
		}
		// 处理非空值
		List<String> namesList = Arrays.asList(names.split("\\s*["
				+ getSplitStr() + "]\\s*"));
		List<String> addedNames = new ArrayList<String>();
		// 移除原有无用的model
		for (int i = tList.size() - 1; i >= 0; i--) {
			Object bean = tList.get(i);
			// 由于很多地方直接把模板的关键字直接设置了进来，所以这里需要校验一下model是否合法
			if (!isLegitimate(bean, ctx.getTObject())) {
				tList.remove(i);
				continue;
			}
			String name = (String) PropertyUtils.getProperty(bean,
					subClassProperty);
			if (StringUtil.isNull(name) || addedNames.contains(name)
					|| !namesList.contains(name)) {
				// 该名称已经添加过，或不在目标列表中，则移除
				tList.remove(i);
				continue;
			}
			addedNames.add(name);
		}
		// 添加新列表
		for (String name : namesList) {
			if (StringUtil.isNull(name) || addedNames.contains(name)) {
				continue;
			}
			name = name.trim();
			Object bean = modelClass.newInstance();
			BeanUtils.copyProperty(bean, subClassProperty, name);
			BeanUtils.copyProperty(bean, foreignKeyProperty, ctx.getTObject());
			tList.add(bean);
			addedNames.add(name);
		}
		BeanUtils.copyProperty(ctx.getTObject(), tPropertyName, tList);
	}

	/**
	 * 合法性校验
	 * 
	 * @param bean
	 * @param mainModel
	 * @return
	 */
	private boolean isLegitimate(Object bean, Object mainModel) {
		if (bean == null)
			return false;
		if (!modelClass.isAssignableFrom(bean.getClass()))
			return false;
		try {
			if (!mainModel.equals(PropertyUtils.getProperty(bean,
					foreignKeyProperty))) {
				return false;
			}
		} catch (Exception e) {
			return false;
		}
		return true;
	}

	public Class getModelClass() {
		return modelClass;
	}

	public String getSplitStr() {
		if (splitStr == null)
			return ";";
		return splitStr;
	}

	public FormConvertor_NamesToModelList setModelClass(Class modelClass) {
		this.modelClass = modelClass;
		return this;
	}

	/**
	 * 设置ID字符串的分隔符号，默认为;
	 * 
	 * @param splitStr
	 * @return
	 */
	public FormConvertor_NamesToModelList setSplitStr(String splitStr) {
		this.splitStr = splitStr;
		return this;
	}

	public FormConvertor_NamesToModelList setTPropertyName(String propertyName) {
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
		else if (!List.class.isAssignableFrom(descriptor.getPropertyType()))
			context.addError(fromClass, "getToModelPropertyMap", 1, "目标属性"
					+ tPropertyName + "必须是List类型");
		if (!IBaseModel.class.isAssignableFrom(modelClass))
			context.addError(fromClass, "getToModelPropertyMap", 1, "目标属性"
					+ tPropertyName + "对应的类必须是Model");
	}

	public String getSubClassProperty() {
		return subClassProperty;
	}

	public void setSubClassProperty(String subClassProperty) {
		this.subClassProperty = subClassProperty;
	}
}
