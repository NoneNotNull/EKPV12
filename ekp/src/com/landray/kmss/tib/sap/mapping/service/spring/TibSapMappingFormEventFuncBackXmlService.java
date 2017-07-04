package com.landray.kmss.tib.sap.mapping.service.spring;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.service.IXMLDataBean;
import com.landray.kmss.tib.sys.sap.connector.interfaces.ITibSysSapJcoFunctionUtil;

public class TibSapMappingFormEventFuncBackXmlService implements IXMLDataBean {

	private static final Log log = LogFactory
			.getLog(TibSapMappingFormEventFuncBackXmlService.class);
	private ITibSysSapJcoFunctionUtil tibSysSapJcoFunctionUtil;
	

	public void settibSysSapJcoFunctionUtil(ITibSysSapJcoFunctionUtil tibSysSapJcoFunctionUtil) {
		this.tibSysSapJcoFunctionUtil = tibSysSapJcoFunctionUtil;
	}

	// 执行函数返回xml
	public List getDataList(RequestContext requestInfo) throws Exception {
		String xml = requestInfo.getParameter("xml");
		List rtnList = new ArrayList();
		Map map = new HashMap();
		String backXml = "";
		try {
			backXml = (String) tibSysSapJcoFunctionUtil.getXMltoFunction(xml)
			 .getResult();
			map.put("funcBackXml", backXml);
		} catch (Exception e) {
			e.printStackTrace();
//			map.put("message", e.getMessage());
			map.put("message", "服务器出现异常");
		}
		rtnList.add(map);
		return rtnList;
	}

}
