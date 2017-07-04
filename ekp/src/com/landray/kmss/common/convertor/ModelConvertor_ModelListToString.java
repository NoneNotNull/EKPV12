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
import com.landray.kmss.util.ArrayUtil;
import com.landray.kmss.util.ModelComparator;
import com.landray.kmss.util.ObjectUtil;

/**
 * 将域模型列表转换为字符串，常用于多对多的关系
 * 
 * @author 叶中奇
 */
public class ModelConvertor_ModelListToString extends BaseModelConvertor
		implements IModelToFormConvertor {
	private static final Log logger = LogFactory
			.getLog(ModelConvertor_ModelListToString.class);

	private Comparator comparator;

	private String sPropertyName;

	private String splitStr;

	/**
	 * @param tPropertyName
	 *            目标域模型中的属性，需要转换多个属性用:分隔多值，如：fpostids:fpostsnames
	 * @param sPropertyName
	 *            源域模型中的属性，需要转换多个属性用:分隔多值，如：fdId:fname
	 */
	public ModelConvertor_ModelListToString(String tPropertyName,
			String sPropertyName) {
		this.tPropertyName = tPropertyName;
		this.sPropertyName = sPropertyName;
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
		if (sList != null) {
			if (getComparator() != null) {
				if (logger.isDebugEnabled())
					logger.debug("对" + ctx.getSPropertyName() + "的对应的列表进行排序");
				List tmpList = new ArrayList();
				tmpList.addAll(sList);
				sList = tmpList;
				Collections.sort(sList, getComparator());
			}
			String[] values = ArrayUtil.joinProperty(sList, getSPropertyName(),
					getSplitStr());
			String[] properties = getTPropertyName().split(":");
			for (int i = 0; i < values.length; i++)
				BeanUtils.copyProperty(ctx.getTObject(), properties[i],
						values[i]);
		} else
			BeanUtils.copyProperty(ctx.getTObject(), getTPropertyName(), null);
	}

	public Comparator getComparator() {
		return comparator;
	}

	public String getSPropertyName() {
		return sPropertyName;
	}

	public String getSplitStr() {
		if (splitStr == null)
			return ";";
		return splitStr;
	}

	/**
	 * 若域模型列表是有序的，该方法可以设置域模型中用于排序的属性，该属性必须是Integer或int类型的
	 * 
	 * @param indexProperty
	 * @return
	 */
	public ModelConvertor_ModelListToString setIndexProperty(
			String indexProperty) {
		setComparator(new ModelComparator(indexProperty));
		return this;
	}

	/**
	 * 若域模型列表是有序的，该方法可以让您设置排序使用的比较器
	 * 
	 * @param indexProperty
	 * @return
	 */
	public ModelConvertor_ModelListToString setComparator(Comparator comparator) {
		this.comparator = comparator;
		return this;
	}

	public ModelConvertor_ModelListToString setSPropertyName(String joinProperty) {
		this.sPropertyName = joinProperty;
		return this;
	}

	/**
	 * 分隔多值时候使用的分隔符，默认为;
	 * 
	 * @param splitStr
	 * @return
	 */
	public ModelConvertor_ModelListToString setSplitStr(String splitStr) {
		this.splitStr = splitStr;
		return this;
	}

	public ModelConvertor_ModelListToString setTPropertyName(String propertyName) {
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
		else if (!List.class.isAssignableFrom(descriptor.getPropertyType()))
			context.addError(fromClass, "getToModelPropertyMap", 1, "源属性"
					+ sProperty + "必须是List类型");

		String[] tPropertyNames = tPropertyName.split(":");
		String[] sPropertyNames = sPropertyName.split(":");
		if (tPropertyNames.length != sPropertyNames.length)
			context.addError(fromClass, "getToModelPropertyMap", 1,
					"目标属性的两个参数列表的个数必须一致");
		for (int i = 0; i < tPropertyNames.length; i++) {
			descriptor = ObjectUtil.getPropertyDescriptor(toClass,
					tPropertyNames[i]);
			if (descriptor == null || descriptor.getWriteMethod() == null)
				context.addError(fromClass, "getToFormPropertyMap", 1, "目标属性"
						+ tPropertyNames[i] + "无setter方法");
		}
	}
}
