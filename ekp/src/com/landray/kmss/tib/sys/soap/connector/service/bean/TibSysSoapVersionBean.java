/**
 * 
 */
package com.landray.kmss.tib.sys.soap.connector.service.bean;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.service.IXMLDataBean;
import com.landray.kmss.tib.sys.soap.connector.model.TibSysSoapSetting;
import com.landray.kmss.tib.sys.soap.connector.service.ITibSysSoapSettingService;
import com.landray.kmss.util.SpringBeanUtil;
import com.landray.kmss.util.StringUtil;

/**
 * 从WebService中获取Soap版本
 * 
 * @author 邱建华
 * @version 1.0 2012-12-5
 */
public class TibSysSoapVersionBean implements IXMLDataBean {

	public List getDataList(RequestContext requestInfo) throws Exception {
		List<Map<String, String>> rtnList = new ArrayList<Map<String, String>>(
				1);
		String serviceId = requestInfo.getParameter("serviceId");
		if (StringUtil.isNotNull(serviceId)) {
			ITibSysSoapSettingService TibSysSoapSettingService = (ITibSysSoapSettingService) SpringBeanUtil
					.getBean("tibSysSoapSettingService");
			TibSysSoapSetting soapuiSetting = (TibSysSoapSetting) TibSysSoapSettingService
					.findByPrimaryKey(serviceId);
			String soapVersions = soapuiSetting.getFdSoapVerson();

			// 修正这个参数名称,因为跟TibSysSoapFindSettingService使用的是同一个js脚本
			// 返回参数需要一致
			// modify by zhang
			if (StringUtil.isNull(soapVersions)) {
				return rtnList;
			}
			Map<String, String> map = new HashMap<String, String>(1);
			map.put("soap", soapVersions);
			rtnList.add(map);
		}
		return rtnList;
	}

}
