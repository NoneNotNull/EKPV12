package com.landray.kmss.tib.sys.sap.connector.service.bean;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.service.IXMLDataBean;
import com.landray.kmss.tib.sys.sap.connector.model.TibSysSapRfcSearchInfo;
import com.landray.kmss.tib.sys.sap.connector.service.ITibSysSapRfcSearchInfoService;

public class TibSysSapRfcSettingFunctionHistoryDataRecordService implements
		IXMLDataBean {
	private ITibSysSapRfcSearchInfoService tibSysSapRfcSearchInfoService;

	public List<TibSysSapRfcSearchInfo> getDataList(RequestContext requestInfo)
			throws Exception {
		String fdSettingId = requestInfo.getParameter("fdId");
		List<TibSysSapRfcSearchInfo> histroyData = new ArrayList<TibSysSapRfcSearchInfo>();
		HQLInfo hqlInfo = new HQLInfo();
		hqlInfo.setWhereBlock("tibSysSapRfcSearchInfo.fdRfc.fdId=:fdSettingId");
		hqlInfo.setParameter("fdSettingId", fdSettingId);
		histroyData = tibSysSapRfcSearchInfoService.findList(hqlInfo);
		List rntList = new ArrayList();
		Map map = new HashMap();
		if(histroyData!=null && histroyData.size()>0){
		   map.put("xml", histroyData.size());
		   rntList.add(map);
		}
		return rntList;
	}

	public ITibSysSapRfcSearchInfoService getTibSysSapRfcSearchInfoService() {
		return tibSysSapRfcSearchInfoService;
	}

	public void setTibSysSapRfcSearchInfoService(
			ITibSysSapRfcSearchInfoService tibSysSapRfcSearchInfoService) {
		this.tibSysSapRfcSearchInfoService = tibSysSapRfcSearchInfoService;
	}

}
