package com.landray.kmss.tib.sys.soap.connector.util.header.licence;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.landray.kmss.framework.plugin.core.config.IExtension;
import com.landray.kmss.framework.plugin.core.config.IExtensionPoint;
import com.landray.kmss.framework.service.plugin.Plugin;

/**
 * webservice 权限扩展点
 * 
 * @author
 */
public class LicenceHeaderPlugin {

	private static final Log logger = LogFactory.getLog(LicenceHeaderPlugin.class);
	private static final String EXTENSION_POINT_ID = "com.landray.kmss.tib.sys.soap.connector.util.header.licence";
	
	public static final String ITEM = "licenceHeader";
	public static final String handlerKey = "handlerKey";
	
	public static final String displayName = "displayName";
	public static final String handlerClassName = "handlerClass";
	public static final String handlerSpringName = "handlerSpring";
	public static final String extendJspPath = "extendJspPath";
	public static final String paramsParser = "paramsParser";
	public static final String isExtSelf = "isExtSelf";
	private static List<Map<String, String>> configs = new ArrayList<Map<String, String>>();
	
	/**
	 * 获取所有可用的权限扩展点的配置项
	 * 
	 * @return 扩展点集合
	 */
	public static List<Map<String, String>> getConfigs() {
		if (configs.isEmpty()) {
			synchronized (configs) {
				IExtensionPoint point = Plugin.getExtensionPoint(EXTENSION_POINT_ID);
				IExtension[] extensions = point.getExtensions();
				for (IExtension extension : extensions) {
					if (ITEM.equals(extension.getAttribute("name"))) {
						Map<String, String> params = new HashMap<String, String>();
						params.put(handlerKey, Plugin.getParamValueString(
								extension, handlerKey));
						params.put(displayName, Plugin.getParamValueString(
								extension, displayName));
						params.put(handlerClassName, Plugin.getParamValueString(
								extension, handlerClassName));
						params.put(handlerSpringName, Plugin.getParamValueString(
								extension, handlerSpringName));
						params.put(isExtSelf, Plugin.getParamValueString(
								extension, isExtSelf));
						params.put(extendJspPath, Plugin.getParamValueString(
								extension, extendJspPath));
						params.put(paramsParser, Plugin.getParamValueString(
								extension, paramsParser));
						
						configs.add(params);
					}
				}
			}
			logger.debug("加载SOAP消息验证配置项扩展点项" + configs.size() + "个");
		}
		return configs;
	}
	
	public static Map<String,String> getConfigByKey(String curHandler){
		getConfigs();
		for (Map<String, String> config : configs) {

			String handle = config.get(handlerKey);
			if (curHandler.equals(handle)) {
				return config;
			}
		}
		return null;
	}
	
}
