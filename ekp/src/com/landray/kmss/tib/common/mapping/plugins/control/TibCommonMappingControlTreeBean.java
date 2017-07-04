package com.landray.kmss.tib.common.mapping.plugins.control;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.service.IXMLDataBean;
import com.landray.kmss.tib.common.mapping.plugins.TibCommonMappingIntegrationPlugins;
import com.landray.kmss.util.SpringBeanUtil;

public class TibCommonMappingControlTreeBean implements IXMLDataBean {
	private Log logger = LogFactory.getLog(this.getClass());

	public List getDataList(RequestContext requestInfo) throws Exception {
		List<Map<String, String>> rtnList = new ArrayList<Map<String, String>>(1);
		String type = requestInfo.getParameter("type");
		if ("cate".equals(type)) {
			rtnList = executeCate(requestInfo);
		} else if ("func".equals(type)) {
			rtnList = executeFunc(requestInfo);
		} else if ("search".equals(type)) {
			rtnList = executeSearch(requestInfo);
		}
		return rtnList;
	}
	
	public List<Map<String, String>> executeCate(RequestContext requestInfo)
			throws Exception {
		List<Map<String, String>> rtnList = new ArrayList<Map<String, String>>(1);
		String serviceBean = requestInfo.getParameter("serviceBean");
		String selectId = requestInfo.getParameter("selectId");
		ITibCommonMappingControlDispatcher tibControlDispatcher = (ITibCommonMappingControlDispatcher) SpringBeanUtil.getBean(serviceBean);
		List<TibCommonMappingControlTreeVo> cateVos = tibControlDispatcher.getCateInfo(selectId, null);
		if (cateVos != null) {
			for (TibCommonMappingControlTreeVo cate : cateVos) {
				Map<String, String> rtnMap = new HashMap<String, String>();
				rtnMap.put("value", cate.getSelectId());
				rtnMap.put("text", cate.getDisplayName());
				rtnList.add(rtnMap);
			}
		}
		return rtnList;
	}
		
	public List<Map<String, String>> executeFunc(RequestContext requestInfo)
		throws Exception {
		List<Map<String, String>> rtnList = new ArrayList<Map<String, String>>(1);
		String serviceBean = requestInfo.getParameter("serviceBean");
		String selectId = requestInfo.getParameter("selectId");
		ITibCommonMappingControlDispatcher tibControlDispatcher = (ITibCommonMappingControlDispatcher) SpringBeanUtil.getBean(serviceBean);
		// 获取函数信息
		List<TibCommonMappingControlTreeVo> funcVos = tibControlDispatcher.getFuncDataList(selectId, null);
		if (funcVos != null) {
			for (TibCommonMappingControlTreeVo funcVo : funcVos) {
				Map<String, String> rtnMap = new HashMap<String, String>();
				rtnMap.put("id", funcVo.getSelectId());
				rtnMap.put("name", funcVo.getDisplayName());
				rtnList.add(rtnMap);
			}
		} 
		return rtnList;
	}
	
	public List<Map<String, String>> executeSearch(RequestContext requestInfo)
		throws Exception {
		List<Map<String, String>> rtnList = new ArrayList<Map<String, String>>(1);
		return rtnList;
	}
	
	public List<Map<String, String>> excuteTemplate(RequestContext requestInfo) throws Exception {
		List<Map<String, String>> rtnList = new ArrayList<Map<String, String>>();
		Map<String, String> map = new HashMap<String, String>();
		try {
			String moduleKey = requestInfo.getParameter("moduleKey");
			String funcId = requestInfo.getParameter("funcId");
			Map<String, String> pluginMap = TibCommonMappingIntegrationPlugins.getConfigByKey(moduleKey);
			String beanName = pluginMap.get("infoClass");
			ITibCommonMappingControlDispatcher tibControlDispatcher = (ITibCommonMappingControlDispatcher) SpringBeanUtil.getBean(beanName);
			String templateXml = tibControlDispatcher.getTemplateXml(funcId);
			map.put("templateXml", templateXml);
		} catch (Exception e) {
			map.put("error", "获取数据模版错误！");
			e.printStackTrace();
		}
		rtnList.add(map);
		return rtnList;
	}

}
