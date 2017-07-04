package com.landray.kmss.tib.sys.core.provider.plugins;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.landray.kmss.framework.plugin.core.config.IExtension;
import com.landray.kmss.framework.plugin.core.config.IExtensionPoint;
import com.landray.kmss.framework.service.plugin.Plugin;

public class TibSysCoreProviderPlugins {

	private static final Log logger = LogFactory
			.getLog(TibSysCoreProviderPlugins.class);

	public static String KEY_ITEM = null;
	public static String EXTENSION_POINT_ID = null;

	public static String ITEM = null;

	public static Map<String, String> ITMEMAP = new HashMap<String, String>(1);

	public static List<Map<String, String>> configs = new ArrayList<Map<String, String>>(
			1);
	public static boolean FLAG_INIT = false;

	public static void init() {
		EXTENSION_POINT_ID = "com.landray.kmss.tib.sys.core.provider.plugins";
		ITEM = "provider";
		ITMEMAP.put("providerKey", "providerKey");
		ITMEMAP.put("providerName", "providerName");
		ITMEMAP.put("key", "key");
		ITMEMAP.put("orderBy", "orderBy");
		ITMEMAP.put("executeClass", "executeClass");
		ITMEMAP.put("infoClass", "infoClass");
		ITMEMAP.put("convertXmlJsPath", "convertXmlJsPath");
		ITMEMAP.put("convertXmlJsFunc", "convertXmlJsFunc");
		KEY_ITEM = "providerKey";
		FLAG_INIT=true;
	}

	/**
	 * 获取所有扩展点的配置项
	 * 
	 * @return 扩展点集合
	 */
	public static List<Map<String, String>> getConfigs() {
		if(!FLAG_INIT){
			init();
		}
		if (configs.isEmpty()) {
			synchronized (configs) {
				IExtensionPoint point = Plugin
						.getExtensionPoint(EXTENSION_POINT_ID);
				IExtension[] extensions = point.getExtensions();
				if (extensions == null) {
					logger.debug("加载配置项扩展点项 " + EXTENSION_POINT_ID + " 不存在~");
				}
				for (IExtension extension : extensions) {
					if (ITEM.equals(extension.getAttribute("name"))) {
						Map<String, String> params = new HashMap<String, String>();

						for (String itemKey : ITMEMAP.keySet()) {
							params.put(itemKey, Plugin.getParamValueString(
									extension, itemKey));
						}
						configs.add(params);
					}
					logger.debug("加载配置项扩展点项" + configs.size() + "个");
				}
			}
		}
		return configs;
	}

	public static Map<String, String> getConfigByKey(String curHandler) {
		getConfigs();
		for (Map<String, String> config : configs) {

			String handle = config.get(KEY_ITEM);
			if (handle.equals(curHandler)) {
				return config;
			}
		}
		return null;
	}
	
	public static Map<String, String> getContainConfigByKey(String curHandler) {
		getConfigs();
		for (Map<String, String> config : configs) {
			
			String handle = config.get(KEY_ITEM);
			if (handle.contains(curHandler)) {
				return config;
			}
		}
		return null;
	}
}
