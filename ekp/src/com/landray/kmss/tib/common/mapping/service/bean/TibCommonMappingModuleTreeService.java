package com.landray.kmss.tib.common.mapping.service.bean;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.service.IXMLDataBean;
import com.landray.kmss.tib.common.mapping.model.TibCommonMappingModule;
import com.landray.kmss.tib.common.mapping.plugins.TibCommonMappingIntegrationPlugins;
import com.landray.kmss.tib.common.mapping.service.ITibCommonMappingModuleService;
import com.landray.kmss.util.StringUtil;

/**
 * @author zhangwt 构造服务器或模块树的service
 */
public class TibCommonMappingModuleTreeService implements IXMLDataBean {
	private ITibCommonMappingModuleService tibCommonMappingModuleService;

	public void setTibCommonMappingModuleService(
			ITibCommonMappingModuleService tibCommonMappingModuleService) {
		this.tibCommonMappingModuleService = tibCommonMappingModuleService;
	}

	public List getDataList(RequestContext requestInfo) throws Exception {
		HQLInfo hqlInfo = new HQLInfo();
		String id = requestInfo.getParameter("id");
		String whereBlock = "tibCommonMappingModule.fdUse=1 ";
		if (StringUtil.isNotNull(id)) {
			whereBlock += " and fdId=:fdId";
			hqlInfo.setParameter("fdId", id);
		}
		List<Map<String, Object>> rtnList = new ArrayList<Map<String, Object>>();
		List<TibCommonMappingModule> TibCommonMappingModuleList = tibCommonMappingModuleService
				.findList(hqlInfo);
		for (TibCommonMappingModule tibCommonMappingModule : TibCommonMappingModuleList) {
			Map<String, Object> map = new HashMap<String, Object>();
			
			String type=tibCommonMappingModule.getFdType();
			String str="("+type2SimpleName(type)+")";
			
			map.put("value", tibCommonMappingModule.getFdId());
			map.put("text", tibCommonMappingModule.getFdModuleName()+str);
			map.put("isAutoFetch", "0");
			map.put("target", 2);
			String path=requestInfo.getContextPath()+"/tib/common/mapping/tib_common_mapping_main/tibCommonMappingMain.do";
			map
					.put(
							"href",
							""+path+"?method=forwardModuleCate&moduleName="
									+ tibCommonMappingModule.getFdModuleName()// 模块名字
									+ "&cateType="
									+ tibCommonMappingModule.getFdCate()
									+ "&templateName="
									+ tibCommonMappingModule.getFdTemplateName()
									+ "&mainModelName="
									+ tibCommonMappingModule.getFdMainModelName()
									+"&settingId="
					                +tibCommonMappingModule.getFdId()				
					);

			rtnList.add(map);
		}
		return rtnList;

	}
	
	private String type2SimpleName(String type){
		if(StringUtil.isNull(type)){
			return "";
		}
		String[] typeArray=type.split(";");
		StringBuffer buf=new StringBuffer();
		for(String str:typeArray){
			Map<String, String>  mapInfo=TibCommonMappingIntegrationPlugins.getConfigByType(str);
			if(mapInfo==null){
				continue;
			}
			String preKey=mapInfo.get(TibCommonMappingIntegrationPlugins.integrationKey);
			if(StringUtil.isNotNull(preKey)){
				if(buf.length()>0){
					buf.append(",");
				}
				buf.append(preKey);
			}
		}
		return buf.toString();
	}
	
	
}
