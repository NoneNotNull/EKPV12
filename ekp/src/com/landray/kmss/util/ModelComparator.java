package com.landray.kmss.util;

import java.util.Comparator;

import org.apache.commons.beanutils.PropertyUtils;

import com.landray.kmss.common.exception.KmssRuntimeException;

/**
 * 域模型顺序比较器，适用于在域模型中有一个index（Integer或int）属性标识域模型排列顺序的域模型列表
 * 
 * @author 叶中奇
 * 
 */
public class ModelComparator implements Comparator {
	private String indexProperty;

	private boolean inverse = false;

	/**
	 * @param indexProperty
	 *            域模型中的Index属性名
	 */
	public ModelComparator(String indexProperty) {
		this.indexProperty = indexProperty;
	}

	/**
	 * @param indexProperty
	 *            域模型中的Index属性名
	 * @param inverse
	 *            是否以逆序排列
	 */
	public ModelComparator(String indexProperty, boolean inverse) {
		this.indexProperty = indexProperty;
		this.inverse = inverse;
	}

	public int compare(Object o1, Object o2) {
		Integer i1, i2;
		try {
			i1 = (Integer) PropertyUtils.getProperty(o1, indexProperty);
			i2 = (Integer) PropertyUtils.getProperty(o2, indexProperty);
		} catch (Exception e) {
			throw new KmssRuntimeException(e);
		}
		if (i1 == null || i2 == null) {
			if (i1 == null && i2 == null)
				return 0;
			return i1 == null ? 1 : -1;
		}
		return (i1.intValue() - i2.intValue()) * (inverse ? -1 : 1);
	}
}
