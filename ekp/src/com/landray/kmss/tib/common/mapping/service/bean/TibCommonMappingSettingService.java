package com.landray.kmss.tib.common.mapping.service.bean;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.service.IXMLDataBean;
import com.landray.kmss.tib.common.mapping.plugins.TibCommonMappingIntegrationPlugins;
import com.landray.kmss.tib.common.mapping.service.ITibCommonMappingModuleService;
import com.landray.kmss.util.SpringBeanUtil;
import com.landray.kmss.util.StringUtil;

/**
 * 根据注册id 获取注册信息
 * @author zhangtian
 * date :2012-9-27 上午05:10:40
 */
public class TibCommonMappingSettingService implements IXMLDataBean {

	private Log logger = LogFactory.getLog(this.getClass());
	
	public List getDataList(RequestContext requestInfo) throws Exception {
		List<Map<String,String>> rtnList =new ArrayList<Map<String, String>>();
		Map<String, String> settingMap=new HashMap<String, String>();
		String settingId=requestInfo.getParameter("settingId");
		if(StringUtil.isNull(settingId)){
			settingMap.put("errMsg", "没有传入注册ID~!");
			rtnList.add(settingMap);
			return rtnList;
		}
		ITibCommonMappingModuleService eSettingService=(ITibCommonMappingModuleService)SpringBeanUtil.getBean("tibCommonMappingModuleService");
		HQLInfo hqlInfo = new HQLInfo();
		hqlInfo.setSelectBlock("fdType");
		hqlInfo.setWhereBlock("fdId=:fdId");
		hqlInfo.setParameter("fdId", settingId.trim());
		hqlInfo.setOrderBy(" fdId desc");
		List<String> types=(List<String>)eSettingService.findValue(hqlInfo);
		if(types.isEmpty()){
			settingMap.put("errMsg", "没有找到对应注册ID的注册信息~!");
			rtnList.add(settingMap);
			return rtnList;
		}
		else{
			if(types.size()>1){
				logger.debug("存在2个相同fdId一用注册模块~!只取第一个使用");
				settingMap.put("warnMsg", "存在2个相同fdId一用注册模块~!只取第一个使用");
			}
			String type=(String)types.get(0);
			String[] i_type=type.split(";");
			if(i_type==null){
				logger.debug("注册类型为空");
				settingMap.put("errMsg", "没有对应模块注册类型");
			}
			JSONArray array=new JSONArray();
			for(String str: i_type){
				Map<String,String> infoMap= TibCommonMappingIntegrationPlugins.getConfigByType(str);
				if(infoMap==null){
					continue;
				}
				JSONObject json=new JSONObject();
				json.accumulate("itype", infoMap.get(TibCommonMappingIntegrationPlugins.fdIntegrationType));
				json.accumulate("iname", infoMap.get(TibCommonMappingIntegrationPlugins.displayName));
				json.accumulate("ikey",infoMap.get(TibCommonMappingIntegrationPlugins.integrationKey));
				json.accumulate("idialogLink", infoMap.get(TibCommonMappingIntegrationPlugins.fdMapperJsp));
				array.add(json);
			}
			settingMap.put("iJson", array.toString());
			rtnList.add(settingMap);
		}
		return rtnList;
	}

}
