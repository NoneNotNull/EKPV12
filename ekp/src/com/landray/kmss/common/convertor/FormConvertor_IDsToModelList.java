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

/**
 * 将多个ID组成的字符串转换为有序的域模型列表，常用于多对多的关系
 * 
 * @author 叶中奇
 * 
 */
public class FormConvertor_IDsToModelList extends BaseFormConvertor implements
		IFormToModelConvertor {
	private static final Log logger = LogFactory
			.getLog(FormConvertor_IDsToModelList.class);

	private Class modelClass;

	private String splitStr;

	/**
	 * @param tPropertyName
	 *            目标属性名
	 * @param modelClass
	 *            目标列表中每个域模型的类
	 */
	public FormConvertor_IDsToModelList(String tPropertyName, Class modelClass) {
		this.tPropertyName = tPropertyName;
		this.modelClass = modelClass;
	}

	public void excute(ConvertorContext ctx) throws Exception {
		String ids;
		try {
			ids = (String) PropertyUtils.getProperty(ctx.getSObject(), ctx
					.getSPropertyName());
		} catch (NestedNullException e) {
			if (logger.isDebugEnabled())
				logger.debug("获取属性" + ctx.getSPropertyName()
						+ "的值时中间出现null值，不转换该属性");
			return;
		}
		if (ids == null) {
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
		if (!ids.trim().equals("")) {
			String[] idArr = ids.split("\\s*[" + getSplitStr() + "]\\s*");
			for (int i = 0; i < idArr.length; i++) {
				IBaseModel tModel = ctx.getBaseService().findByPrimaryKey(
						idArr[i], getModelClass(), false);
				if (tModel != null)
					tList.add(tModel);
			}
		}
		BeanUtils.copyProperty(ctx.getTObject(), getTPropertyName(), tList);
	}

	public Class getModelClass() {
		return modelClass;
	}

	public String getSplitStr() {
		if (splitStr == null)
			return ";";
		return splitStr;
	}

	public FormConvertor_IDsToModelList setModelClass(Class modelClass) {
		this.modelClass = modelClass;
		return this;
	}

	/**
	 * 设置ID字符串的分隔符号，默认为;
	 * 
	 * @param splitStr
	 * @return
	 */
	public FormConvertor_IDsToModelList setSplitStr(String splitStr) {
		this.splitStr = splitStr;
		return this;
	}

	public FormConvertor_IDsToModelList setTPropertyName(String propertyName) {
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
}
