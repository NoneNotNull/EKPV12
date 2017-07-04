package com.landray.kmss.util.xml;

/**
 * 用于生成具体操纵XML的实例的工厂对象
 * 
 * @author 吴兵
 * @version 1.0 2006-09-04
 */

public class XMLPropertiesFactory {

	private XMLPropertiesFactory() {
	}

	/**
	 * 获取默认的操纵XML的实例
	 * 
	 * @return XMLProperties 系统默认的操纵XML的实例
	 */
	public static XMLProperties getInstance() {
		return new XMLProperties4DOM4J();
	}

	/**
	 * 获取指定的操纵XML的实例
	 * 
	 * @param name
	 *            指定的实例的名称，需有完整包路径
	 * @return XMLProperties 指定的操纵XML的实例，如果没有找到指定实例则返回系统默认的操纵XML的实例
	 */
	public static XMLProperties getInstance(String name) {
		try {
			return (XMLProperties) Class.forName(name).newInstance();
		} catch (Exception e) {
			e.printStackTrace();

			return getInstance();
		}
	}
}
