package com.landray.kmss.tib.sap.mapping.plugins.controls.common;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.service.IXMLDataBean;
import com.landray.kmss.tib.sap.mapping.service.spring.TibSapMappingFuncXmlService;
import com.landray.kmss.tib.sys.sap.connector.interfaces.ITibSysSapJcoFunctionUtil;
import com.landray.kmss.util.ResourceUtil;
import com.landray.kmss.util.SpringBeanUtil;
import com.landray.kmss.util.StringUtil;

public class TibSapMappingXmlTemplateBean implements IXMLDataBean {

	private static final Log logger = LogFactory.getLog(TibSapMappingFuncXmlService.class);
	
	private TibSapMappingFuncXmlService tibSapMappingFuncXmlService;

	public void setTibSapMappingFuncXmlService(
			TibSapMappingFuncXmlService tibSapMappingFuncXmlService) {
		this.tibSapMappingFuncXmlService = tibSapMappingFuncXmlService;
	}

	public List getDataList(RequestContext requestInfo) throws Exception {
		ITibSysSapJcoFunctionUtil tibSysSapJcoFunctionUtil = (ITibSysSapJcoFunctionUtil) SpringBeanUtil
				.getBean("tibSysSapJcoFunctionUtil");
		String fdRfcSettingId = requestInfo.getParameter("rfcId");
		if (StringUtil.isNull(fdRfcSettingId))
			return null;
		List<Map<String, String>> rtnList = new ArrayList<Map<String, String>>();
		try {
			String funcXml = (String) tibSysSapJcoFunctionUtil
					.getFunctionToXmlById(fdRfcSettingId);
			if (logger.isDebugEnabled()) {
				logger.debug("函数的xml为：\n" + funcXml);
			}
			Map<String, String> map = new HashMap<String, String>();
			map.put("funcXml", funcXml);
			Map<String, String> map2 = new HashMap<String, String>();
			map2.put("MSG", "SUCCESS");
			rtnList.add(map);
			rtnList.add(map2);
			return rtnList;
		} catch (Exception e) {
			e.printStackTrace();
			logger.debug(e.getMessage());
			Map<String, String> map = new HashMap<String, String>();
			map.put("funcXml", "");
			Map<String, String> map2 = new HashMap<String, String>();
			map2.put("MSG", ResourceUtil.getString("tibSapMapping.checkBapi", "tib-sap"));
			rtnList.add(map);
			rtnList.add(map2);
		}
		return rtnList;
	}

}
