/**
 * 
 */
package com.landray.kmss.tib.common.inoutdata.service.spring;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.service.IBaseService;
import com.landray.kmss.common.service.IXMLDataBean;
import com.landray.kmss.sys.config.dict.SysDataDict;
import com.landray.kmss.sys.config.dict.SysDictCommonProperty;
import com.landray.kmss.sys.config.dict.SysDictModel;
import com.landray.kmss.tib.common.inoutdata.plugin.TibCommonInoutdataModulePlugin;
import com.landray.kmss.tib.common.inoutdata.service.ITibCommonInoutdataCategoryService;
import com.landray.kmss.tib.common.inoutdata.util.TibCommonInoutdataConstant;
import com.landray.kmss.tib.common.mapping.model.TibCommonMappingModule;
import com.landray.kmss.tib.common.mapping.plugins.TibCommonMappingIntegrationPlugins;
import com.landray.kmss.tib.common.mapping.service.ITibCommonMappingModuleService;
import com.landray.kmss.util.ModelUtil;
import com.landray.kmss.util.ResourceUtil;
import com.landray.kmss.util.SpringBeanUtil;
import com.landray.kmss.util.StringUtil;

/**
 * 用于显示导出列表
 * @author 邱建华
 * @version 1.0 2013-1-5
 */
public class TibCommonInoutdataBean implements 
		IXMLDataBean {

	private static final String DOC_ISNEWVERSION = "docIsNewVersion";
	
	ITibCommonInoutdataCategoryService tibCommonInoutdataCategoryService;

	public void setTibCommonInoutdataCategoryService(
			ITibCommonInoutdataCategoryService tibCommonInoutdataCategoryService) {
		this.tibCommonInoutdataCategoryService = tibCommonInoutdataCategoryService;
	}

	@SuppressWarnings("unchecked")
	public List getDataList(RequestContext requestInfo) throws Exception {
		// parentId代表节点value值，其中拼串了父类Id,模块名称等等的一些数据
		String parentId = requestInfo.getParameter("parentId");
		// 区分sap还是soap
		String moduleType = requestInfo.getParameter("moduleType");
		List<Map<String, Object>> rtnList = new ArrayList<Map<String, Object>>();
		// 获取扩展点中存放的Map信息
		List<Map<String, String>> mapListPlugin = TibCommonInoutdataModulePlugin.getConfigs();
		// 标题
		if (StringUtil.isNull(parentId)) {
			if (TibCommonInoutdataConstant.SAP_MODULE.equals(moduleType)
					|| TibCommonInoutdataConstant.SOAP_MODULE.equals(moduleType)) {
				// 添加表单流程映射标题
				Map<String, Object> formMap = new HashMap<String, Object>();
				formMap.put("text", ResourceUtil.getString("imExport.formFlowMapping", "tib-common-inoutdata"));
				formMap.put("value", TibCommonInoutdataConstant.FormFlowMapping);
				formMap.put("nodeType", "CATEGORY");
				rtnList.add(formMap);
			}
			// 添加其他组件标题
			for (Map<String, String> pluginMap : mapListPlugin) {
				if (moduleType.equals(pluginMap.get(TibCommonInoutdataModulePlugin.moduleType))) {
					Map<String, Object> map = new HashMap<String, Object>();
					map.put("text", pluginMap.get(TibCommonInoutdataModulePlugin.messageKey));
					map.put("value", pluginMap.get(TibCommonInoutdataModulePlugin.moduleKey));
					map.put("nodeType", "CATEGORY");
					rtnList.add(map);
				}
			}
			return rtnList;
		}
		// 扩展点的类型(key)
		String checkType = requestInfo.getParameter("type");
		if (StringUtil.isNull(checkType)) {
			if (parentId.indexOf(";") != -1) {
				checkType = parentId.split(";")[2];
			} else {
				checkType = parentId;
			}
		}
		
		if (TibCommonInoutdataConstant.FormFlowMapping.equals(checkType)) {
			// 表单流程映射中的所有模块
			List<Map<String, String>> mapList = getValueByJson();
			for (Map<String, String> map : mapList) {
				String moduleName = map.get("moduleName");
				String cateType = map.get("cateType");
				String templateName = map.get("templateName");
				Map<String, Object> rtnMap = new HashMap<String, Object>(); 
				rtnMap.put("text", moduleName);
				rtnMap.put("value", "notExport;"+ templateName +";"+ TibCommonInoutdataConstant.FormFlowMappingChild +";"+ cateType);
				rtnMap.put("nodeType", "CATEGORY");
				rtnList.add(rtnMap);
			}
			return rtnList;
		} else if (TibCommonInoutdataConstant.FormFlowMappingChild.equals(checkType)) {
			/***********************************************
			功能：cateUrl添加类别展开树
			参数：
				cateType:必填，0为简单分类，1为全局分类
				modelName:必填，当前的域模型名称
				authType:对节点的验证权限,0显示所有(00可以选中所有,01只能选中有维护权限的,
							02只能选中有使用权限的),1 只显示有维护权限的 2 只显示有使用权限的
				parentId:必填，包含当前类别id，通常为!{value}(这里进行了用;分号隔开的拼串)
				isGetTemplate: 可选，是否显示模板，0不显示，1 显示模板，类别不可选择，2 显示模板并且类别可选择，默认是2
				showType:可选,显示方式,0显示父机构分类和子机构分类,只1显示父机构分类,2只显示子机构分类
			***********************************************/
			String authType = "00";
			String isGetTemplate = "2";
			String showType = "0";
			String[] parentIdaArr = parentId.split(";");
			String cateType = parentIdaArr[3];
			String modelName = parentIdaArr[1];
			// 保持当前域模型名称不变
			if (parentIdaArr.length > 4) {
				modelName = parentIdaArr[4];
			}
			// 表单流程映射
			if ("0".equals(cateType)) {
				List<Map<String, Object>> simpleList = tibCommonInoutdataCategoryService
						.getSimpleCategoryList(parentId, modelName, authType);
				rtnList.addAll(simpleList);
			} else {
				List<Map<String, Object>> globalList = tibCommonInoutdataCategoryService
						.getGlobalCategoryList(parentId, modelName, authType, isGetTemplate, showType);
				rtnList.addAll(globalList);
			}
			return rtnList;
		}
		
		// 搭建HQLInfo
		HQLInfo parentHqlInfo = new HQLInfo();
		HQLInfo hqlInfo = new HQLInfo();
		String whereBlockCate = "";
		String whereBlock = "";
		Map<String, String> pluginMap = TibCommonInoutdataModulePlugin.getConfigByKey(checkType);
		// 子类service
		IBaseService baseService = (IBaseService) SpringBeanUtil
				.getBean(pluginMap.get(TibCommonInoutdataModulePlugin.springName));
		String className = baseService.getModelName();
		SysDataDict dataDict = SysDataDict.getInstance();
		SysDictModel dictModel = dataDict.getModel(className);
		Map<String, SysDictCommonProperty> proMap = dictModel.getPropertyMap();
		// 获取新版本字段，没有则是Null
		SysDictCommonProperty newVersionPro = proMap.get(DOC_ISNEWVERSION);
		// 父子关联字段
		String parentRelation = pluginMap.get(TibCommonInoutdataModulePlugin.parentRelation);
		// 父类的自关联
		String selfRelation = "";
		String parentTableName = "";
		String parentSpringName = "";
		String parentClassName = "";
		if (StringUtil.isNotNull(parentRelation)) {
			// 根据关联字段获取父类的信息
			SysDictCommonProperty dictPro = proMap.get(parentRelation);
			parentClassName = dictPro.getType();
			SysDictModel parentDictModel = dataDict.getModel(parentClassName);
			// 获取父类service
			parentSpringName = parentDictModel.getServiceBean();
			List<SysDictCommonProperty> ProList = parentDictModel.getPropertyList();
			for (SysDictCommonProperty pro : ProList) {
				String varType = pro.getType();
				// 找出父类是否有自关联
				if (varType.equals(parentClassName)) {
					selfRelation = pro.getName();
				}
			}
			if (StringUtil.isNotNull(parentClassName)) {
				parentTableName = ModelUtil.getModelTableName(parentClassName);
			}
		}
		
		String tableName = ModelUtil.getModelTableName(className);
		
		String showName = pluginMap.get(TibCommonInoutdataModulePlugin.showName);
		String parentShowName = pluginMap.get(TibCommonInoutdataModulePlugin.parentShowName);
		
		if (String.valueOf(checkType).equals(parentId)) {
			// 存在自关联则自关联查询
			if (StringUtil.isNotNull(selfRelation)) {
				whereBlockCate = parentTableName +"."+ selfRelation +" is null";
			}
			// 存在父子关联则父子关联查询
			if (StringUtil.isNotNull(parentRelation)) {
				whereBlock = tableName +"."+ parentRelation +" is null ";
				// 是否存在版本机制
				if (newVersionPro != null) {
					StringUtil.linkString(whereBlock, " and ", tableName +"."+ DOC_ISNEWVERSION +" = 1");
				}
			}

		} else {
			// 获取父类id
			parentId = parentId.split(";")[0];
			if (StringUtil.isNotNull(selfRelation)) {
				whereBlockCate = parentTableName +"."+ selfRelation +".fdId = :parentId";
				parentHqlInfo.setParameter("parentId", parentId);
			}
			if (StringUtil.isNotNull(parentRelation)) {
				whereBlock = tableName +"."+ parentRelation +".fdId = :parentId ";
				hqlInfo.setParameter("parentId", parentId);
				// 是否存在版本机制
				if (newVersionPro != null) {
					StringUtil.linkString(whereBlock, " and ", tableName +"."+ DOC_ISNEWVERSION +" = 1");
				}
			}
		}
		
		// 分类的遍历
		if (StringUtil.isNotNull(parentSpringName)) {
			IBaseService parentBaseService = (IBaseService) SpringBeanUtil.getBean(parentSpringName);
			parentHqlInfo.setWhereBlock(whereBlockCate);
			// 设置查询值，fdId和name
			parentHqlInfo.setSelectBlock(parentTableName +".fdId,"+ 
					parentTableName +"."+ parentShowName);
			List<Object[]> parentObjList = parentBaseService.findValue(parentHqlInfo);
			if (String.valueOf(checkType).equals(parentId) || StringUtil.isNotNull(selfRelation)) {
				for (Object[] objs : parentObjList) {
					Map<String, Object> map = new HashMap<String, Object>();
					map.put("text", objs[1]);
					map.put("value", objs[0] +";"+ parentClassName +";"+ checkType);
					map.put("nodeType", "CATEGORY");
					rtnList.add(map);
				}
			}
		}
		// 主文档的遍历
		hqlInfo.setWhereBlock(whereBlock);
		hqlInfo.setSelectBlock(tableName +".fdId,"+ tableName +"."+ showName);
		List<Object[]> objList = baseService.findValue(hqlInfo);
		for (Object[] objs : objList) {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("text", objs[1]);
			map.put("value", objs[0] +";"+ className +";"+ checkType);
			map.put("isAutoFetch", "0");
			rtnList.add(map);
		}
		return rtnList;
	}

	@SuppressWarnings("unchecked")
	private List<Map<String, String>> getValueByJson() throws Exception {
		List<Map<String, String>> list = new ArrayList<Map<String, String>>();
		ITibCommonMappingModuleService tibCommonMappingModuleService = (ITibCommonMappingModuleService) 
				SpringBeanUtil.getBean("tibCommonMappingModuleService");
		List<TibCommonMappingModule> mappingModuleList = tibCommonMappingModuleService
				.findList("tibCommonMappingModule.fdUse=1 ", null);
		for (TibCommonMappingModule mappingModule : mappingModuleList) {
			String type = mappingModule.getFdType();
			String str = "(" + type2SimpleName(type) + ")";
			// 显示表单流程映射需要的数据
			Map<String, String> map = new HashMap<String, String>();
			map.put("moduleName", mappingModule.getFdModuleName() + str);
			map.put("cateType", String.valueOf(mappingModule.getFdCate()));
			map.put("templateName", mappingModule.getFdTemplateName());
			list.add(map);
		}
		return list;
	}
	
	/**
	 * 获取表单流程映射开启的功能
	 * @param type
	 * @return
	 */
	private String type2SimpleName(String type) {
		if (StringUtil.isNull(type)) {
			return "";
		}
		String[] typeArray = type.split(";");
		StringBuffer buf = new StringBuffer();
		for (String str : typeArray) {
			Map<String, String> mapInfo = TibCommonMappingIntegrationPlugins
					.getConfigByType(str);
			if (mapInfo == null) {
				continue;
			}
			String preKey = mapInfo.get(TibCommonMappingIntegrationPlugins.integrationKey);
			if (StringUtil.isNotNull(preKey)) {
				if (buf.length() > 0) {
					buf.append(",");
				}
				buf.append(preKey);
			}
		}
		return buf.toString();
	}
	
}
