package com.landray.kmss.util.xml;

import java.util.Map;

/**
 * 操纵XML属性文件的工具类的接口
 * 
 * @author 吴兵
 * @version 1.0 2006-09-04
 */

public interface XMLProperties {

	/**
	 * 返回指定属性的值
	 * 
	 * @param name
	 *            需要取得的属性的名称
	 * @return String 需要取得的属性的值
	 */
	public abstract String getProperty(String name);

	/**
	 * 以Map形式返回一个父属性下所有的子属性 如果没有子属性，则返回一个Null 例如：当前属性有<tt>X.Y.A</tt>,
	 * <tt>X.Y.B</tt>, and <tt>X.Y.C</tt> 那么属性<tt>X.Y</tt>的子属性就有<tt>A</tt>,
	 * <tt>B</tt>, and
	 * 
	 * @param parent
	 *            父属性的名称
	 * @return Map 所有的子属性，以子属性的名称为键值
	 */
	public abstract Map getChildrenProperties(String parent);

	/**
	 * 以数组形式返回一个父属性下所有的子属性的<b>值</b> 如果没有子属性，则返回一个空数组 例如：当前属性有<tt>X.Y.A</tt>,
	 * <tt>X.Y.B</tt>, and <tt>X.Y.C</tt> 那么属性<tt>X.Y</tt>的子属性就有<tt>A</tt>,
	 * <tt>B</tt>, and
	 * 
	 * @param parent
	 *            父属性的名称
	 * @return String[] 所有的子属性的值
	 */
	public abstract String[] getChildrenPropertiesValue(String parent);

	/**
	 * 设置一个属性的值 如果这个值不存在就自动创建它
	 * 
	 * @param name
	 *            需要设置的属性的名称
	 * @param value
	 *            需要设置的属性的值
	 */
	public abstract void setProperty(String name, String value);

	/**
	 * 删除指定属性
	 * 
	 * @param name
	 *            需要删除的属性的名称
	 */
	public abstract void deleteProperty(String name);

	/**
	 * 设置配置文件名称路径
	 * 
	 * @param fileName
	 *            文件名称路径
	 */
	public abstract void setFilename(String fileName);

	/**
	 * 重新读取配置文件
	 */
	public abstract void reload();
}
