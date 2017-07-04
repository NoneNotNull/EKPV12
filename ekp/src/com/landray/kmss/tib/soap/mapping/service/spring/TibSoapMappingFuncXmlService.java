package com.landray.kmss.tib.soap.mapping.service.spring;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.service.IXMLDataBean;
import com.landray.kmss.tib.sys.soap.connector.model.TibSysSoapMain;
import com.landray.kmss.tib.sys.soap.connector.service.ITibSysSoapMainService;
import com.landray.kmss.tib.sys.soap.connector.util.xml.ParseSoapXmlUtil;
import com.landray.kmss.util.ResourceUtil;
import com.landray.kmss.util.StringUtil;

public class TibSoapMappingFuncXmlService implements IXMLDataBean {
	private static final Log logger = LogFactory
			.getLog(TibSoapMappingFuncXmlService.class);
	
	private ITibSysSoapMainService tibSysSoapMainService;

	public List getDataList(RequestContext requestInfo) throws Exception {
		List<Map<String,String>> rtnList = new ArrayList<Map<String,String>>();
		String fdSoapMainId = requestInfo.getParameter("fdSoapMainId");
		if (StringUtil.isNull(fdSoapMainId))
			{return rtnList;}
		try {
			TibSysSoapMain tibSysSoapMain=(TibSysSoapMain)tibSysSoapMainService.findByPrimaryKey(fdSoapMainId);
			String funcXml=tibSysSoapMain.getWsMapperTemplate();
			// 移除禁用的节点
			funcXml = ParseSoapXmlUtil.disableFilter(funcXml);
			Map<String,String> map = new HashMap<String,String>(1);
			map.put("funcXml", funcXml);
			Map<String,String> map2 = new HashMap<String,String>(1);
			map2.put("MSG", "SUCCESS");
			rtnList.add(map);
			rtnList.add(map2);
			return rtnList;
		} catch (Exception e) {
			e.printStackTrace();
			logger.debug(e.getMessage());
			Map<String,String> map = new HashMap<String,String>(1);
			map.put("funcXml", "");
			Map<String,String> map2 = new HashMap<String,String>(1);
			map2.put("MSG", ResourceUtil.getString("erpSoapuiMain.dataException", "tib-soap"));
			rtnList.add(map);
			rtnList.add(map2);
		}
		return rtnList;

	}
	public ITibSysSoapMainService gettibSysSoapMainService() {
		return tibSysSoapMainService;
	}

	public void settibSysSoapMainService(ITibSysSoapMainService tibSysSoapMainService) {
		this.tibSysSoapMainService = tibSysSoapMainService;
	}
	
	
}
