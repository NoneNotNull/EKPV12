package com.landray.kmss.tib.common.log.service.bean;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.service.IXMLDataBean;
import com.landray.kmss.tib.common.log.constant.TibCommonLogConstant;
import com.landray.kmss.tib.common.mapping.plugins.TibCommonMappingIntegrationPlugins;
import com.landray.kmss.util.StringUtil;

public class TibCommonLogTypeTreeServiceImp implements IXMLDataBean {

	public List<?> getDataList(RequestContext requestInfo) throws Exception {
		
//		集成类型
		String type=requestInfo.getParameter("id");
		
		List<Map<String,String>> rtnList=new ArrayList<Map<String,String>>();
//		如果不为空 ，获取这个扩展的信息
		if(StringUtil.isNotNull(type)){
			Map<String, String>  singleInfo=TibCommonMappingIntegrationPlugins.getConfigByType(type);
			if(singleInfo==null){
				return rtnList;
			}
			else{                           
				String path=requestInfo.getContextPath()+"/tib/common/log/tib_common_log_main/tibCommonLogMain.do?method=searchView&isError=!{error}&fdType=!{logType}";
//				正常日志
				Map<String,String> normalMap=new HashMap<String, String>();
				String logType=singleInfo.get(TibCommonMappingIntegrationPlugins.fdIntegrationType);
				normalMap.put("value", "normal");
				normalMap.put("text", "正常日志");
				String n_path=path.replace("!{error}", TibCommonLogConstant.TIB_COMMON_LOG_TYPE_SUCCESS).replace("!{logType}", logType);
				normalMap.put("href", n_path);
				
				
//				异常日志
				Map<String,String> errorMap=new HashMap<String, String>();
				errorMap.put("value", "error");
				errorMap.put("text", "异常日志");
				String e_path =path.replace("!{error}", TibCommonLogConstant.TIB_COMMON_LOG_TYPE_ERROR).replace("!{logType}", logType);
				errorMap.put("href", e_path);
				
//				业务日志
				Map<String,String> bierrorMap=new HashMap<String, String>();
				bierrorMap.put("value", "berror");
				bierrorMap.put("text", "业务异常日志");
				String b_path =path.replace("!{error}", TibCommonLogConstant.TIB_COMMON_LOG_TYPE_BIERROR).replace("!{logType}", logType);
				bierrorMap.put("href", b_path);
				
				rtnList.add(normalMap);
				rtnList.add(errorMap);
				rtnList.add(bierrorMap);
			}
			
		}
//		如果type不为空则获取集成类型
		else{
			List<Map<String, String>>  configs=TibCommonMappingIntegrationPlugins.getConfigs();
			for(Map<String, String> map :configs){
				String fdIntegrationType=map.get(TibCommonMappingIntegrationPlugins.fdIntegrationType);
				String displayName=map.get(TibCommonMappingIntegrationPlugins.displayName);
				map.put("value", fdIntegrationType);
				map.put("text", displayName);
				rtnList.add(map);
//				String path=requestInfo.getContextPath()+"/third/tibCommon/common/log/tib_common_log_main/tibCommonLogMain.do?method=list&isError=0&fd";
//				map.put("href", "");
			}
		}
		
		// TODO 自动生成的方法存根
		
		return rtnList;
	}

}
