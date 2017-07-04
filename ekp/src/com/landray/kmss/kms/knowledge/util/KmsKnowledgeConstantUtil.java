package com.landray.kmss.kms.knowledge.util;

import java.util.HashMap;
import java.util.Map;

import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.framework.plugin.core.config.IExtension;
import com.landray.kmss.framework.plugin.core.config.IExtensionPoint;
import com.landray.kmss.framework.service.plugin.Plugin;
import com.landray.kmss.util.HQLUtil;
import com.landray.kmss.util.StringUtil;

public class KmsKnowledgeConstantUtil implements KmsKnowledgeConstant {

	/**
	 * 扩展点
	 */
	private static final String BASE_EXTENSION_POINT_ID = "com.landray.kmss.kms.knowledge.type";

	private static final String KNOWLEDGE_TYPE = "knowledgeType";

	static Map<String, String> knowledgeType = new HashMap<String, String>();

	static Map<String, String> knowledgeModelNames = new HashMap<String, String>();

	public static final String ITEM_TEXT = "messageText";

	public static final String ITEM_MODELNAME = "methodName";

	public static final String ITEM_TYPE_VALUE = "knowledgeTypeValue";

	/**
	 * 获取所有知识类型
	 * 
	 * @return
	 */
	public static Map<String, String> getKnowledgeTypeMap() {
		if (knowledgeType.isEmpty()) {
			synchronized (knowledgeType) {
				if (knowledgeType.isEmpty()) {
					IExtensionPoint point = Plugin
							.getExtensionPoint(BASE_EXTENSION_POINT_ID);
					IExtension[] extensions = point.getExtensions();
					for (IExtension extension : extensions) {
						if (KNOWLEDGE_TYPE.equals(extension
								.getAttribute("name"))) {
							knowledgeType.put(Plugin.getParamValueString(
									extension, ITEM_TYPE_VALUE), Plugin
									.getParamValueString(extension, ITEM_TEXT));
						}
					}
				}
			}
		}
		return knowledgeType;
	}

	/**
	 * 获取所有知识类型modelName
	 * 
	 * @return
	 */
	public static Map<String, String> getKnowledgeModelNames() {
		if (knowledgeModelNames.isEmpty()) {
			synchronized (knowledgeModelNames) {
				if (knowledgeModelNames.isEmpty()) {
					IExtensionPoint point = Plugin
							.getExtensionPoint(BASE_EXTENSION_POINT_ID);
					IExtension[] extensions = point.getExtensions();
					for (IExtension extension : extensions) {
						if (KNOWLEDGE_TYPE.equals(extension
								.getAttribute("name"))) {
							knowledgeModelNames.put(Plugin.getParamValueString(
									extension, ITEM_TYPE_VALUE), Plugin
									.getParamValueString(extension,
											ITEM_MODELNAME));
						}
					}
				}
			}
		}
		return knowledgeModelNames;
	}

	/**
	 * 根据值获取模版列表
	 * 
	 * @param value
	 * @return
	 */
	public static Map<String, String> getTemplateMap(String value) {
		Map<String, String> rtnMap = new HashMap<String, String>();
		if (StringUtil.isNull(value)) {
			return rtnMap;
		}
		Map<String, String> knowledgeType = getKnowledgeTypeMap();
		if (KNOWLEDGE_TYPE_MUORWIKI == Integer.valueOf(value)) {
			return knowledgeType;
		}
		String strValue = String.valueOf(value);
		if (knowledgeType.get(strValue) != null) {
			rtnMap.put(strValue, knowledgeType.get(strValue));
		}
		return rtnMap;
	}

	/**
	 * 计算模版类型值 如：“1;2”计算结果：3 “1;2;4”计算结果为：7
	 */
	public static int getTemplateTypeValue(String strValue) {
		if (StringUtil.isNull(strValue)) {
			return 0;
		}
		String[] vals = strValue.split(";");
		int PATCH = 0;
		for (String val : vals) {
			int iVal = Integer.valueOf(val);
			PATCH = PATCH | iVal;
		}
		return PATCH;
	}

	/**
	 * 根据类型值获取具体类型 如：类型3：结果为1;2
	 * 
	 * @return
	 */
	public static String getTemplateType(String fdTemplateType) {
		if (String.valueOf(KmsKnowledgeConstant.KNOWLEDGE_TYPE_MUORWIKI)
				.equals(fdTemplateType)) {
			return "1;2";
		}
		return fdTemplateType;
	}

	/**
	 * 获取知识类型所对应的modelName
	 * 
	 * @param key
	 * @return
	 */
	public static String getTemplateModelName(String key) {
		return getKnowledgeModelNames().get(key);
	}

	/**
	 * 根据模板类型构建类别查询hql对象
	 * 
	 * @param fdTemplateType
	 * @param hqlInfo
	 */
	public static void buildHqlByTemplateType(String fdTemplateType,
			HQLInfo hqlInfo, String tableName) {
		if (StringUtil.isNotNull(fdTemplateType)) {
			String[] types = fdTemplateType.split("[，,;；]");
			String __whereBlock = "";
			for (String type : types) {
				String param = "kmss_ext_props_" + HQLUtil.getFieldIndex();
				__whereBlock = StringUtil.linkString(__whereBlock, " or ",
						tableName + ".fdTemplateType =:" + param);
				hqlInfo.setParameter(param, type);
			}
			hqlInfo
					.setWhereBlock(StringUtil
							.linkString(hqlInfo.getWhereBlock(), " and ", "("
									+ __whereBlock + ")"));
		}
	}

}
