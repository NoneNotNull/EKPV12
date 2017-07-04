package com.landray.kmss.tib.common.mapping.service.bean;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.service.IXMLDataBean;
import com.landray.kmss.tib.common.mapping.plugins.IBaseTibCommonMappingIntegration;
import com.landray.kmss.tib.common.mapping.plugins.TibCommonMappingIntegrationPlugins;
import com.landray.kmss.tib.common.mapping.service.ITibCommonMappingFuncService;
import com.landray.kmss.util.SpringBeanUtil;
import com.landray.kmss.util.StringUtil;

public class TibCommonMappingFuncListService implements IXMLDataBean {
	private ITibCommonMappingFuncService tibCommonMappingFuncService;

	public void setTibCommonMappingFuncService(
			ITibCommonMappingFuncService tibCommonMappingFuncService) {
		this.tibCommonMappingFuncService = tibCommonMappingFuncService;
	}

	public List getDataList(RequestContext requestInfo) throws Exception {
		List<Map<String, String>> rtnList = new ArrayList<Map<String, String>>();
		String fdTemplateId = requestInfo.getParameter("fdTemplateId");
		String fdType = requestInfo.getParameter("fdType");
		// 映射类型，机器人节点、表单事件、流程驳回等。
		String fdInvokeType = requestInfo.getParameter("fdInvokeType");
		if (StringUtil.isNull(fdTemplateId))
			return rtnList;
		Map<String, String>  pluginInfo= TibCommonMappingIntegrationPlugins.getConfigByType(fdType);
		if(pluginInfo==null||pluginInfo.isEmpty()){
			return rtnList;
		}
		// 代码拆解,使用目标扩展点的
		String beanName=pluginInfo.get(TibCommonMappingIntegrationPlugins.ekpIntegrationBean);
		Object bean=SpringBeanUtil.getBean(beanName);
		if(bean instanceof IBaseTibCommonMappingIntegration){
			rtnList= ((IBaseTibCommonMappingIntegration)bean).getSettingNameInfo(fdTemplateId, fdInvokeType);
		}
		
		return rtnList;
	}

}
