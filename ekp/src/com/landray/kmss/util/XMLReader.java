package com.landray.kmss.util;

import java.io.File;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.landray.kmss.util.xml.XMLProperties;
import com.landray.kmss.util.xml.XMLPropertiesFactory;

/**
 * 操纵XML属性文件的工具类
 * 
 * @author 吴兵
 * @version 1.0 2006-09-04
 */

public class XMLReader {

	private static final Log logger = LogFactory.getLog(XMLReader.class);

	/*
	 * XML properties用来取得或设置配置属性
	 */
	private XMLProperties properties = null;

	private String CONFIG_FILENAME = "configure.xml";

	private long lastmodify = 0;

	public XMLReader(String file) {
		CONFIG_FILENAME = file;

		if (logger.isDebugEnabled()) {
			logger.debug("configure file path is : " + CONFIG_FILENAME);
		}

		loadProperties();
	}

	/**
	 * 判断当前配置文件是否可读
	 * 
	 * @return boolean 可读否
	 */
	public boolean isConfigReadable() {
		return (new File(CONFIG_FILENAME)).canRead();
	}

	/**
	 * 判断当前配置文件是否可写
	 * 
	 * @return boolean 可写否
	 */
	public boolean isConfigWritable() {
		return (new File(CONFIG_FILENAME)).canWrite();
	}

	/**
	 * 获得一个配置属性的值
	 * 
	 * @param name
	 *            属性的名称
	 * @return String 属性的值
	 */
	public String getProperty(String name) {
		loadProperties();

		return properties.getProperty(name);
	}

	/**
	 * 获得一个配置属性其下所有子属性
	 * 
	 * @param parent
	 *            父属性的名称
	 * @return Map 子属性
	 */
	public Map getProperties(String parent) {
		loadProperties();

		return properties.getChildrenProperties(parent);
	}

	/**
	 * 设置一个配置属性的值，如果配置文件里没有这个属性，则创建它
	 * 
	 * @param name
	 *            the name of the property being set.
	 * @param value
	 *            the value of the property being set.
	 */
	public void setProperty(String name, String value) {
		loadProperties();
		properties.setProperty(name, value);
		lastmodify = System.currentTimeMillis();
	}

	/**
	 * 删除一个配置属性
	 * 
	 * @param name
	 *            the name of the property to delete.
	 */
	public void deleteProperty(String name) {
		loadProperties();
		properties.deleteProperty(name);
		lastmodify = System.currentTimeMillis();
	}

	/**
	 * 读取配置属性，如果文件修改，自动判别重新读取
	 */
	private boolean loadProperties() {
		try {
			if (properties == null) {
				if (logger.isDebugEnabled()) {
					logger.debug("configure file is null , need load");
				}

				properties = XMLPropertiesFactory.getInstance();
				properties.setFilename(CONFIG_FILENAME);
				lastmodify = FileUtil.getLastModify(CONFIG_FILENAME);
			}
		} catch (Exception e) {
			e.printStackTrace();

			return false;
		}

		return true;
	}
}
