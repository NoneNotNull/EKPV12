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
import com.landray.kmss.util.ResourceUtil;
import com.landray.kmss.util.SpringBeanUtil;
import com.landray.kmss.util.StringUtil;

public class TibSapMappingFuncXmlService implements IXMLDataBean {
	private static final Log logger = LogFactory
			.getLog(TibSapMappingFuncXmlService.class);

	public List getDataList(RequestContext requestInfo) throws Exception {
		ITibSysSapJcoFunctionUtil tibSysSapJcoFunctionUtil = (ITibSysSapJcoFunctionUtil) SpringBeanUtil
				.getBean("tibSysSapJcoFunctionUtil");
		String fdRfcSettingId = requestInfo.getParameter("fdRfcSettingId");
		if (StringUtil.isNull(fdRfcSettingId))
			return null;
		List rtnList = new ArrayList();
		try {
			String funcXml = (String) tibSysSapJcoFunctionUtil
					.getFunctionToXmlById(fdRfcSettingId);
			if (logger.isDebugEnabled()) {
				logger.debug("函数的xml为：\n" + funcXml);
			}
			Map map = new HashMap();
			map.put("funcXml", funcXml);
			Map map2 = new HashMap();
			map2.put("MSG", "SUCCESS");
			rtnList.add(map);
			rtnList.add(map2);
			return rtnList;
		} catch (Exception e) {
			e.printStackTrace();
			logger.debug(e.getMessage());
			Map map = new HashMap();
			map.put("funcXml", "");
			Map map2 = new HashMap();
			map2.put("MSG", ResourceUtil.getString("tibSapMapping.checkBapi", "tib-sap"));
			rtnList.add(map);
			rtnList.add(map2);
		}
		return rtnList;

	}
}
