package com.landray.kmss.tib.sys.core.provider.service.spring;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.service.IXMLDataBean;
import com.landray.kmss.tib.sys.core.provider.plugins.TibSysCoreProviderPlugins;

public class TibSysCoreIfacePluginsBean implements IXMLDataBean {

	public List getDataList(RequestContext requestInfo) throws Exception {
		List<Map<String, String>> rtnList = new ArrayList<Map<String, String>>();
		Map<String, String> rtnMap = new HashMap<String, String>();
		List<Map<String, String>> pluginList = TibSysCoreProviderPlugins.getConfigs();
		StringBuffer handInfo = new StringBuffer("[");
		for (Map<String, String> map : pluginList) {
			handInfo.append("{");
			for (String key : map.keySet()) {
				String value = map.get(key);
				if ("convertXmlJsPath".equals(key)) {
					String jsPath = value.substring(0, value.lastIndexOf("/") + 1);
					String jsName = value.substring(value.lastIndexOf("/") + 1);
					handInfo.append("jsPath").append(":'").append(jsPath).append("',");
					handInfo.append("jsName").append(":'").append(jsName).append("',");
				} else {
					handInfo.append(key).append(":'").append(value).append("',");
				}
			}
			handInfo.deleteCharAt(handInfo.length() - 1);
			handInfo.append("}");
		}
		handInfo.append("]");
		rtnMap.put("handInfo", handInfo.toString());
		rtnList.add(rtnMap);
		return rtnList;
	}
	
}
