package com.landray.kmss.util;

import java.util.HashMap;

/**
 * 该类为一个动态哈希表对象，当哈希表中某个key不存在的时自动构建一个新的实例。
 * 
 * @author 叶中奇
 * @version 1.0 2006-4-3
 */
public class AutoHashMap extends HashMap {
	private Class itemClass;

	/**
	 * 构造函数。
	 * 
	 * @param itemClass
	 *            数组中每个元素对应的类
	 */
	public AutoHashMap(Class itemClass) {
		this.itemClass = itemClass;
	}

	/**
	 * 重载get方法，当key不存在时自动构造新的类返回。
	 * 
	 * @see java.util.HashMap#get(Object)
	 */
	public Object get(Object key) {
		if (!containsKey(key))
			try {
				put(key, itemClass.newInstance());
			} catch (Exception e) {
				e.printStackTrace();
			}
		return super.get(key);
	}
}
