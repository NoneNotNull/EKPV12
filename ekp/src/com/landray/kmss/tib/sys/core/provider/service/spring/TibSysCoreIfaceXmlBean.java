package com.landray.kmss.tib.sys.core.provider.service.spring;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.service.IXMLDataBean;
import com.landray.kmss.tib.sys.core.provider.model.TibSysCoreIface;
import com.landray.kmss.tib.sys.core.provider.service.ITibSysCoreIfaceService;

public class TibSysCoreIfaceXmlBean implements IXMLDataBean {

	private ITibSysCoreIfaceService tibSysCoreIfaceService;

	public void setTibSysCoreIfaceService(
			ITibSysCoreIfaceService tibSysCoreIfaceService) {
		this.tibSysCoreIfaceService = tibSysCoreIfaceService;
	}

	public List getDataList(RequestContext requestInfo) throws Exception {
		String ifaceId = requestInfo.getParameter("ifaceId");
		TibSysCoreIface tibSysCoreIface = (TibSysCoreIface) tibSysCoreIfaceService.findByPrimaryKey(ifaceId);
		String ifaceXml = tibSysCoreIface.getFdIfaceXml();
		List<Map<String, String>> rtnList = new ArrayList<Map<String, String>>();
		Map<String, String> map = new HashMap<String, String>();
		map.put("ifaceXml", ifaceXml);
		rtnList.add(map);
		return rtnList;
	}

}
