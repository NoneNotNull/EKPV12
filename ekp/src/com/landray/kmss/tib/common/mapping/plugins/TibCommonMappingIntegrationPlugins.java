package com.landray.kmss.tib.common.mapping.plugins;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.landray.kmss.framework.plugin.core.config.IExtension;
import com.landray.kmss.framework.plugin.core.config.IExtensionPoint;
import com.landray.kmss.framework.service.plugin.Plugin;

public class TibCommonMappingIntegrationPlugins {

	/**
	 * ERP 权限扩展点
	 * 
	 * @author
	 */

	private static final Log logger = LogFactory
			.getLog(TibCommonMappingIntegrationPlugins.class);
	private static final String EXTENSION_POINT_ID = "com.landray.kmss.tib.common.mapping.plugins.integration";

	public static final String ITEM = "tibCommonMappingIntegration";
	public static final String integrationKey = "integrationKey";

	public static final String displayName = "displayName";
	public static final String fdIntegrationType = "fdIntegrationType";
	public static final String fdMapperJsp="fdMapperConfigJsp";
	public static final String ekpIntegrationBean="ekpIntegrationBean";
	
	public static final String formEventJS="formEventJS";
	public static final String formEventPath="formEventPath";
	public static final String formEventFuncName="formEventFuncName";
	
	public static final String order="order";
	// 用于表单控件获取树
	public static final String infoClass="infoClass";
	public static final String formControlJS="formControlJS";
	
	private static List<Map<String, String>> configs = new ArrayList<Map<String, String>>();

	/**
	 * 获取所有可用的权限扩展点的配置项
	 * 
	 * @return 扩展点集合
	 */
	public static List<Map<String, String>> getConfigs() {
		if (configs.isEmpty()) {
			synchronized (configs) {
				IExtensionPoint point = Plugin
						.getExtensionPoint(EXTENSION_POINT_ID);
				IExtension[] extensions = point.getExtensions();
				if(extensions==null){
					logger.debug("加载ERP配置项扩展点项 " + EXTENSION_POINT_ID + " 不存在~");
				}
				for (IExtension extension : extensions) {
					if (ITEM.equals(extension.getAttribute("name"))) {
						Map<String, String> params = new HashMap<String, String>();
						params.put(integrationKey, Plugin.getParamValueString(
								extension, integrationKey));
						params.put(displayName, Plugin.getParamValueString(
								extension, displayName));
						params.put(fdIntegrationType, Plugin.getParamValueString(
								extension, fdIntegrationType));
						
						params.put(fdMapperJsp, Plugin.getParamValueString(
								extension, fdMapperJsp));
						params.put(ekpIntegrationBean, Plugin.getParamValueString(
								extension, ekpIntegrationBean));
						
						params.put(formEventJS, Plugin.getParamValueString(
								extension, formEventJS));
						params.put(formEventPath, Plugin.getParamValueString(
								extension, formEventPath));
						params.put(formEventFuncName, Plugin.getParamValueString(
								extension, formEventFuncName));
						params.put(order, Plugin.getParamValueString(
								extension, order));
						params.put(infoClass, Plugin.getParamValueString(
								extension, infoClass));
						params.put(formControlJS, Plugin.getParamValueString(
								extension, formControlJS));
						configs.add(params);
					}
				}
//				用来排序,order 越大排到越后
				Collections.sort(configs,new Comparator<Map<String, String>>(){
					public int compare(Map<String, String> o1,
							Map<String, String> o2) {
						Integer f_o1=Integer.valueOf(o1.get(order));
						Integer f_o2=Integer.valueOf(o2.get(order));
						return f_o1-f_o2;
					}
				});
			}
			logger.debug("加载ERP配置项扩展点项" + configs.size() + "个");
		}
		return configs;
	}

	public static Map<String, String> getConfigByType(String curType) {
		getConfigs();
		for (Map<String, String> config : configs) {
			String handle = config.get(fdIntegrationType);
			if (curType.equals(handle)) {
				return config;
			}
		}
		return null;
	}
	
	public static Map<String, String> getConfigByKey(String curKey) {
		getConfigs();
		for (Map<String, String> config : configs) {
			String handle = config.get(integrationKey);
			if (curKey.equals(handle)) {
				return config;
			}
		}
		return null;
	}
	
	public static Map<String, String> getRegisterdConfigs(String fdTemplateId, 
			String fdType) throws Exception {
//		ITibCommonMappingModuleService moduleService = (ITibCommonMappingModuleService) 
//				SpringBeanUtil.getBean("tibCommonMappingModuleService");
//		ITibCommonMappingMainService mainService = (ITibCommonMappingMainService) 
//		SpringBeanUtil.getBean("tibCommonMappingMainService");
//		HQLInfo hqlInfo = new HQLInfo();
//		hqlInfo.setSelectBlock("tibCommonMappingMain.fdMainModelName");
//		hqlInfo.setWhereBlock("tibCommonMappingMain.fdTemplateId=:fdTemplateId");
//		hqlInfo.setParameter("fdTemplateId", fdTemplateId);
//		List list = mainService.findValue(hqlInfo);
//		getConfigs();
//		List<Map<String, String>> regConfigs = new ArrayList<Map<String, String>>();
//		regConfigs.addAll(configs);
//		for (Map<String, String> config : regConfigs) {
//			String pluginIntegrationType = config.get(fdIntegrationType);
//			if (fdType.equals(pluginIntegrationType)) {
//				// 判断是否注册
//				if (list != null && !list.isEmpty()) {
//					String fdTemplateName = (String) list.get(0);
//					String fdDisplayName = config.get(displayName);
//					fdDisplayName = fdDisplayName.replaceAll("\\(未启用\\)", "");
//					if (!moduleService.ifRegister(fdTemplateName, fdType)) {
//						config.put(displayName, fdDisplayName+"(未启用)");
//					} else {
//						config.put(displayName, fdDisplayName);
//					}
//				}
//				return config;
//			}
//		}
//		return null;
		return getConfigByType(fdType);
	}

}
