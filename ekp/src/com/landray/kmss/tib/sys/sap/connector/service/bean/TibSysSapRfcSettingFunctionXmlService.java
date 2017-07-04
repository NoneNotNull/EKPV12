package com.landray.kmss.tib.sys.sap.connector.service.bean;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.service.IXMLDataBean;
import com.landray.kmss.tib.sys.sap.connector.interfaces.ITibSysSapJcoFunctionUtil;

public class TibSysSapRfcSettingFunctionXmlService implements IXMLDataBean {
	private ITibSysSapJcoFunctionUtil tibSysSapJcoFunctionUtil;
	private String flag = null;

	public List getDataList(RequestContext requestInfo) throws Exception {
		String name = requestInfo.getParameter("name");
		String pool = requestInfo.getParameter("pool");

		Object xml;
		Map map = new HashMap();
		List rtnList = new ArrayList();
		try {
			xml = tibSysSapJcoFunctionUtil.getFunctionToXmlByName(name, pool);
			map.put("xml", xml.toString());
		} catch (Exception e) {
			e.printStackTrace();
			map.put("xml", "err");
		}

		rtnList.add(map);
		return rtnList;
	}

	public ITibSysSapJcoFunctionUtil getTibSysSapJcoFunctionUtil() {
		return tibSysSapJcoFunctionUtil;
	}

	public void setTibSysSapJcoFunctionUtil(ITibSysSapJcoFunctionUtil tibSysSapJcoFunctionUtil) {
		this.tibSysSapJcoFunctionUtil = tibSysSapJcoFunctionUtil;
	}

}
