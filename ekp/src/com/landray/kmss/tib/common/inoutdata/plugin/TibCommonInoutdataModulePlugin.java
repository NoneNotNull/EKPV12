/**
 * 
 */
package com.landray.kmss.tib.common.inoutdata.plugin;

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
 * @author 邱建华
 * @version 1.0 2013-1-28
 * 导入导出扩展点
 */
public class TibCommonInoutdataModulePlugin {
	private static final Log logger = LogFactory.getLog(TibCommonInoutdataModulePlugin.class);
	private static final String EXTENSION_POINT_ID = "com.landray.kmss.tib.common.inoutdata.service";
	
	public static final String ITEM = "inoutModule";
	public static final String moduleKey = "moduleKey";
	public static final String moduleType = "moduleType";
	public static final String messageKey = "messageKey";
	public static final String springName = "springName";
	public static final String showName = "showName";
	public static final String parentRelation = "parentRelation";
	public static final String parentShowName = "parentShowName";
	private static List<Map<String, String>> configs = new ArrayList<Map<String, String>>();
	
	/**
	 * 获取所有可用的扩展点的配置项
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
						params.put(moduleKey, Plugin.getParamValueString(
								extension, moduleKey));
						params.put(moduleType, Plugin.getParamValueString(
								extension, moduleType));
						params.put(messageKey, Plugin.getParamValueString(
								extension, messageKey));
						params.put(springName, Plugin.getParamValueString(
								extension, springName));
						params.put(showName, Plugin.getParamValueString(
								extension, showName));
						params.put(parentRelation, Plugin.getParamValueString(
								extension, parentRelation));
						params.put(parentShowName, Plugin.getParamValueString(
								extension, parentShowName));
						
						configs.add(params);
					}
				}
			}
			logger.debug("加载导入导出扩展点项" + configs.size() + "个");
		}
		return configs;
	}
	
	public static Map<String,String> getConfigByKey(String curHandler){
		getConfigs();
		for (Map<String, String> config : configs) {

			String handle = config.get(moduleKey);
			if (curHandler.equals(handle)) {
				return config;
			}
		}
		return null;
	}
}
