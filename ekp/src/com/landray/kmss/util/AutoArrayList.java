package com.landray.kmss.util;

import java.util.ArrayList;

import com.landray.kmss.common.exception.KmssRuntimeException;

/**
 * 该类为一个动态数组对象，当数组中某个元素不存在的时自动构建一个新的实例。
 * 
 * @author 叶中奇
 * @version 1.0 2006-4-3
 */
public class AutoArrayList extends ArrayList {
	private Class itemClass;

	/**
	 * 构造函数。
	 * 
	 * @param itemClass
	 *            数组中每个元素对应的类
	 */
	public AutoArrayList(Class itemClass) {
		super();
		this.itemClass = itemClass;
	}

	/**
	 * 重载get方法，当下标越界时自动构造新的类返回。
	 * 
	 * @see java.util.List#get(int)
	 */
	public Object get(int index) {
		try {
			while (index >= size()) {
				add(itemClass.newInstance());
			}
		} catch (Exception e) {
			throw new KmssRuntimeException(new KmssMessage("error.classCanNotNewInstance", itemClass
					.getClass().getName()), e);
		}
		return super.get(index);
	}

	/**
	 * 重载set方法，当下标越界时自动添加空对象至指定下标。
	 * 
	 * @see java.util.List#get(int)
	 */

	public Object set(int index, Object element) {
		int size = size();

		// Grow the list
		if (index >= size) {
			for (int i = size; i <= index; i++) {
				this.add(null);
			}
		}

		return super.set(index, element);
	}
}