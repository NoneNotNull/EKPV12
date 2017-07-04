package com.landray.kmss.common.convertor;

import java.beans.PropertyDescriptor;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.beanutils.NestedNullException;
import org.apache.commons.beanutils.PropertyUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.landray.kmss.code.examine.ExamineContext;
import com.landray.kmss.common.model.IBaseModel;
import com.landray.kmss.util.AutoArrayList;
import com.landray.kmss.util.ModelComparator;
import com.landray.kmss.util.ObjectUtil;

/**
 * 将域模型列表转换为Form模型列表，常用于一对多的关系
 * 
 * @author 叶中奇
 * 
 */
public class ModelConvertor_ModelListToFormList extends BaseModelConvertor
		implements IModelToFormConvertor {
	private static final Log logger = LogFactory
			.getLog(ModelConvertor_ModelListToFormList.class);

	private Comparator comparator;

	/**
	 * @param tPropertyName
	 *            目标属性名
	 */
	public ModelConvertor_ModelListToFormList(String tPropertyName) {
		this.tPropertyName = tPropertyName;
	}

	public void excute(ConvertorContext ctx) throws Exception {
		List sList;
		try {
			sList = (List) PropertyUtils.getProperty(ctx.getSObject(), ctx
					.getSPropertyName());
		} catch (NestedNullException e) {
			sList = null;
			if (logger.isDebugEnabled())
				logger.debug("获取属性" + ctx.getSPropertyName() + "的值时中间出现null值");
		}
		List tList = (List) PropertyUtils.getProperty(ctx.getTObject(),
				getTPropertyName());
		if (tList == null)
			tList = new ArrayList();
		else
			tList.clear();
		if (sList != null) {
			if (getComparator() != null) {
				if (logger.isDebugEnabled())
					logger.debug("对" + ctx.getSPropertyName() + "的对应的列表进行排序");
				List tmpList = new ArrayList();
				tmpList.addAll(sList);
				sList = tmpList;
				Collections.sort(sList, getComparator());
			}
			for (int i = 0; i < sList.size(); i++) {
				IBaseModel sModel = (IBaseModel) sList.get(i);
				if (sModel != null)
					tList.add(ctx.getBaseService().convertModelToForm(null,
							sModel, ctx));
			}
		}
		BeanUtils.copyProperty(ctx.getTObject(), getTPropertyName(), tList);
	}

	/**
	 * 若域模型列表是有序的，该方法可以设置域模型中用于排序的属性，该属性必须是Integer或int类型的
	 * 
	 * @param indexProperty
	 * @return
	 */
	public ModelConvertor_ModelListToFormList setIndexProperty(
			String indexProperty) {
		setComparator(new ModelComparator(indexProperty));
		return this;
	}

	/**
	 * 若域模型列表是有序的，但域模型的排序并不是简单的int类型的排序，该方法可以让您设置排序使用的比较器
	 * 
	 * @param indexProperty
	 * @return
	 */
	public Comparator getComparator() {
		return comparator;
	}

	public ModelConvertor_ModelListToFormList setComparator(
			Comparator comparator) {
		this.comparator = comparator;
		return this;
	}

	public void examine(ExamineContext context, Class fromClass, Class toClass) {
		String sProperty = (String) context.getParameter("sProperty");
		PropertyDescriptor descriptor = ObjectUtil.getPropertyDescriptor(
				fromClass, sProperty);
		if (descriptor == null || descriptor.getReadMethod() == null)
			context.addError(fromClass, "getToModelPropertyMap", 1, "源属性"
					+ sProperty + "无getter方法");
		else if (!List.class.isAssignableFrom(descriptor.getPropertyType()))
			context.addError(fromClass, "getToModelPropertyMap", 1, "源属性"
					+ sProperty + "必须是List类型");

		descriptor = ObjectUtil.getPropertyDescriptor(toClass, tPropertyName);
		if (descriptor == null || descriptor.getWriteMethod() == null)
			context.addError(fromClass, "getToFormPropertyMap", 1, "目标属性"
					+ tPropertyName + "无setter方法");
		else {
			if (!List.class.isAssignableFrom(descriptor.getPropertyType()))
				context.addError(fromClass, "getToModelPropertyMap", 1, "目标属性"
						+ tPropertyName + "必须是List类型");
			try {
				Object obj = PropertyUtils.getProperty(context
						.getParameter("form"), tPropertyName);
				if (obj == null)
					context.addError(fromClass, "getToModelPropertyMap", 1,
							"目标属性" + tPropertyName + "在Form中必须有初值");
				if (!(obj instanceof AutoArrayList))
					context.addError(fromClass, "getToModelPropertyMap", 1,
							"目标属性" + tPropertyName
									+ "在Form中必须初始化为一个AutoArrayList的实体");
			} catch (Exception e) {
				context.addError(fromClass, "getToModelPropertyMap", 1, "目标属性"
						+ tPropertyName + "无法获取");
			}
		}
	}
}
