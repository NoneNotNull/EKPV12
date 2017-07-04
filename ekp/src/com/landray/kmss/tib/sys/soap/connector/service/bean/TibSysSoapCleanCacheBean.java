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
import com.landray.kmss.tib.sys.soap.connector.impl.TibSysSoapProjectFactory;

/**
 * 清除某个Wsdl缓存
 * @author 邱建华
 * @version 1.0 2012-12-19
 */
public class TibSysSoapCleanCacheBean implements IXMLDataBean {

	public List getDataList(RequestContext requestInfo) {
		List<Map<String, String>> rtnList = new ArrayList<Map<String, String>>();
		Map<String, String> map = new HashMap<String, String>();
		try {
			String serviceId = requestInfo.getParameter("serviceId");
			TibSysSoapProjectFactory.cleanCacheByServiceId(serviceId);
		} catch (Exception e) {
			map.put("error", "exception");
			rtnList.add(map);
			e.printStackTrace();
		}
		return rtnList;
	}

}
