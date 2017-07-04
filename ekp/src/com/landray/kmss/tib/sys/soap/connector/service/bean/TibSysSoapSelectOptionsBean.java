package com.landray.kmss.tib.sys.soap.connector.service.bean;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.eviware.soapui.model.iface.Operation;
import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.service.IXMLDataBean;
import com.landray.kmss.tib.sys.soap.connector.interfaces.ITibSysSoap;
import com.landray.kmss.tib.sys.soap.connector.model.TibSysSoapSetting;
import com.landray.kmss.tib.sys.soap.connector.service.ITibSysSoapSettingService;
import com.landray.kmss.util.SpringBeanUtil;

public class TibSysSoapSelectOptionsBean implements IXMLDataBean {

	public List getDataList(RequestContext requestInfo) throws Exception {
		List<Map<String, String>> rtnList = new ArrayList<Map<String, String>>(1);
		try {
			String serviceId = requestInfo.getParameter("serviceId");
			String soapversion = requestInfo.getParameter("soapversion");
			ITibSysSoapSettingService TibSysSoapSettingService = (ITibSysSoapSettingService) SpringBeanUtil
					.getBean("tibSysSoapSettingService");
			ITibSysSoap TibSysSoap = (ITibSysSoap) SpringBeanUtil.getBean("tibSysSoap");
			TibSysSoapSetting soapuiSetting = (TibSysSoapSetting) TibSysSoapSettingService
					.findByPrimaryKey(serviceId);
			if (soapuiSetting == null) {
				return rtnList;
			}
			Map<String, Operation> operationMap = new HashMap<String, Operation>(1);
			operationMap = TibSysSoap.getAllOperation(soapuiSetting, soapversion);

			for (String methodName : operationMap.keySet()) {
				Map<String, String> map = new HashMap<String, String>(1);
				map.put("key", methodName);
				map.put("name", methodName);
				rtnList.add(map);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return rtnList;
	}

}
