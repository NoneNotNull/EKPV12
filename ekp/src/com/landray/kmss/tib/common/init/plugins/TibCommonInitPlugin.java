package com.landray.kmss.tib.common.init.plugins;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.landray.kmss.framework.plugin.core.config.IExtension;
import com.landray.kmss.framework.plugin.core.config.IExtensionPoint;
import com.landray.kmss.framework.service.plugin.Plugin;
import com.landray.kmss.util.ResourceUtil;

public class TibCommonInitPlugin {
	private static final Log logger = LogFactory
			.getLog(TibCommonInitPlugin.class);

	public static String KEY_ITEM = null;
	public static String EXTENSION_POINT_ID = null;
	public static String ITEM = null;
	public static Map<String, String> ITMEMAP = new HashMap<String, String>(1);
	public static List<Map<String, String>> configs = new ArrayList<Map<String, String>>(1);
	public static boolean FLAG_INIT = false;

	public static void init() {
		EXTENSION_POINT_ID = "com.landray.kmss.tib.common.init";
		ITEM = "init";
		ITMEMAP.put("moduleKey", "moduleKey");
		ITMEMAP.put("initTitle", "initTitle");
		ITMEMAP.put("springBean", "springBean");
		ITMEMAP.put("jspPath", "jspPath");
		KEY_ITEM = "moduleKey";
		FLAG_INIT = true;
	}

	/**
	 * 获取所有扩展点的配置项
	 * 
	 * @return 扩展点集合
	 */
	public static List<Map<String, String>> getConfigs() {
		if (!FLAG_INIT) {
			init();
		}
		if (configs.isEmpty()) {
			synchronized (configs) {
				IExtensionPoint point = Plugin
						.getExtensionPoint(EXTENSION_POINT_ID);
				IExtension[] extensions = point.getExtensions();
				if (extensions == null) {
					logger.debug(ResourceUtil.getString("init.onloadPlugin", "tib-common-init") + EXTENSION_POINT_ID + ResourceUtil.getString("init.notExist", "tib-common-init"));
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
					logger.debug(ResourceUtil.getString("init.onloadPlugin", "tib-common-init") + configs.size() + ResourceUtil.getString("init.ge", "tib-common-init"));
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
