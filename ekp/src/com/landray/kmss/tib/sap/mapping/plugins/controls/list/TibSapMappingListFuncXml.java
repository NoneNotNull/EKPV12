package com.landray.kmss.tib.sap.mapping.plugins.controls.list;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.service.IXMLDataBean;
import com.landray.kmss.tib.common.mapping.service.ITibCommonMappingFuncService;

public class TibSapMappingListFuncXml implements IXMLDataBean {
	private ITibCommonMappingFuncService tibCommonMappingFuncService;
	
	public void setTibCommonMappingFuncService(
			ITibCommonMappingFuncService tibCommonMappingFuncService) {
		this.tibCommonMappingFuncService = tibCommonMappingFuncService;
	}
	
	public List getDataList(RequestContext requestInfo) throws Exception {
		List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();
		Map<String, Object> map = new HashMap<String, Object>();
		String mappingFuncId = requestInfo.getParameter("funcId");
		HQLInfo hqlInfo = new HQLInfo();
		hqlInfo.setSelectBlock("tibCommonMappingFunc.fdRfcParamXml, tibCommonMappingFunc.fdRefName");
		hqlInfo.setWhereBlock("tibCommonMappingFunc.fdId = :fdId");
		hqlInfo.setParameter("fdId", mappingFuncId);
		List<Object[]> xmlList = tibCommonMappingFuncService.findValue(hqlInfo);
		if (xmlList == null || xmlList.isEmpty()) {
			return result;
		}
		Object funcXml = xmlList.get(0)[0];
		Object rfcName = xmlList.get(0)[1];
		map.put("funcXml", funcXml);
		map.put("rfcName", rfcName);
		result.add(map);
		return result;
	}
	
}
