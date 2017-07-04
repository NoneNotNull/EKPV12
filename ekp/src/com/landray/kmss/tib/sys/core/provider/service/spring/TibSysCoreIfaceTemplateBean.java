package com.landray.kmss.tib.sys.core.provider.service.spring;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.service.IXMLDataBean;
import com.landray.kmss.tib.sys.core.provider.plugins.TibSysCoreProviderPlugins;
import com.landray.kmss.tib.sys.core.provider.process.provider.interfaces.ITibSysCoreProvider;
import com.landray.kmss.util.SpringBeanUtil;

/**
 * 
 *	获取XML模版
 */
public class TibSysCoreIfaceTemplateBean implements IXMLDataBean {

	public List getDataList(RequestContext requestInfo) throws Exception {
		List<Map<String, String>> rtnList = new ArrayList<Map<String, String>>();
		Map<String, String> map = new HashMap<String, String>();
		try {
			String providerKey = requestInfo.getParameter("providerKey");
			String funcId = requestInfo.getParameter("funcId");
			Map<String, String> pluginMap = TibSysCoreProviderPlugins.getConfigByKey(providerKey);
			String springBean = pluginMap.get("executeClass");
			ITibSysCoreProvider tibSysCoreProvider = (ITibSysCoreProvider) 
					SpringBeanUtil.getBean(springBean);
			String templateXml = (String) tibSysCoreProvider.getTemplateXml(funcId, false);
			map.put("templateXml", templateXml);
		} catch (Exception e) {
			e.printStackTrace();
			return rtnList;
		}
		rtnList.add(map);
		return rtnList;
	}
	
}
