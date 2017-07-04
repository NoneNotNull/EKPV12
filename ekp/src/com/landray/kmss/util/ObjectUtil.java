package com.landray.kmss.util;

import java.beans.PropertyDescriptor;

import org.apache.commons.beanutils.PropertyUtils;

import com.landray.kmss.common.model.IBaseTreeModel;

public class ObjectUtil {
	/**
	 * 比较两个对象是否相等（同时处理null的情况），当两个对象都为空时返回true
	 * 
	 * @param obj1
	 * @param obj2
	 * @return
	 */
	public static boolean equals(Object obj1, Object obj2) {
		return equals(obj1, obj2, true);
	}

	/**
	 * 比较两个对象是否相等（同时处理null的情况），当两个对象都为空时返回指定值bothNullReturn
	 * 
	 * @param obj1
	 * @param obj2
	 * @param bothNullReturn
	 * @return
	 */
	public static boolean equals(Object obj1, Object obj2,
			boolean bothNullReturn) {
		if (obj1 == null && obj2 == null)
			return bothNullReturn;
		if (obj1 == obj2)
			return true;
		if (obj1 == null || obj2 == null)
			return false;
		return obj1.equals(obj2);
	}

	/**
	 * 将一个对象转换为Long类型
	 * 
	 * @param value
	 * @return
	 */
	public static Long parseLong(Object value) {
		if (value instanceof Long)
			return (Long) value;
		if (value instanceof String)
			return new Long((String) value);
		if (value instanceof Number)
			return new Long(((Number) value).longValue());
		return null;
	}

	/**
	 * 将一个对象转换为Double类型
	 * 
	 * @param value
	 * @return
	 */
	public static Double parseDouble(Object value) {
		if (value != null) {
			try {
				if (value instanceof Double)
					return (Double) value;
				if (value instanceof String)
					return new Double((String) value);
				if (value instanceof Number)
					return new Double(((Number) value).doubleValue());
			} catch (Exception e) {
				return null;
			}
		}
		return null;
	}

	/**
	 * 校验某个类的某个属性是否能够执行get或set方法
	 * 
	 * @param c
	 * @param property
	 * @return
	 */
	public static PropertyDescriptor getPropertyDescriptor(Class c,
			String property) {
		if (StringUtil.isNull(property))
			return null;
		// 按层级校验形如a.b.c的属性
		String[] properties = property.split("\\.");
		outloop: for (int i = 0; i < properties.length; i++) {
			if (StringUtil.isNull(properties[i]))
				return null;
			// 遍历类里面的每个属性，查找等于properties[i]的进行校验
			PropertyDescriptor[] propertyDescriptors = PropertyUtils
					.getPropertyDescriptors(c);
			for (int j = 0; j < propertyDescriptors.length; j++) {
				if (propertyDescriptors[j].getName().equals(properties[i])) {
					// 注意：校验setter方法的时候，仅在最后一级校验setter，前面的都校验getter
					if (i == properties.length - 1)
						return propertyDescriptors[j];
					else if (propertyDescriptors[j].getReadMethod() == null)
						return null;
					Class childClass = propertyDescriptors[j].getPropertyType();
					if (!childClass.isAssignableFrom(IBaseTreeModel.class))
						c = childClass;
					continue outloop;
				}
			}
			// 没有找到，校验失败
			return null;
		}
		return null;
	}
}
