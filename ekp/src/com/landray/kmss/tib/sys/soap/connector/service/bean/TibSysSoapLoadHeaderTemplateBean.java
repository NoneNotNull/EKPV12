/**
 * 
 */
package com.landray.kmss.tib.sys.soap.connector.service.bean;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.service.IXMLDataBean;
import com.landray.kmss.tib.sys.soap.connector.interfaces.ITibSysSoap;
import com.landray.kmss.tib.sys.soap.connector.model.TibSysSoapSetting;
import com.landray.kmss.util.ResourceUtil;
import com.landray.kmss.util.SpringBeanUtil;

/**
 * @author 邱建华
 * @version 1.0 2012-12-22
 */
public class TibSysSoapLoadHeaderTemplateBean implements IXMLDataBean {
	
	public List getDataList(RequestContext requestInfo) throws Exception {
		List<Map<String, String>> rtnList = new ArrayList<Map<String, String>>();
		Map<String, String> map = new HashMap<String, String>();
		try {
			String wsdlUrl = requestInfo.getParameter("wsdlUrl");
			String fdLoadUser = requestInfo.getParameter("fdLoadUser");
			String fdLoadPwd = requestInfo.getParameter("fdLoadPwd");
			String fdSoapVersion = requestInfo.getParameter("fdSoapVerson");
			ITibSysSoap soapui = (ITibSysSoap) SpringBeanUtil.getBean("tibSysSoap");
			// 把soapuiSett设置为VO
			TibSysSoapSetting soapuiSett = new TibSysSoapSetting();
			soapuiSett.setFdWsdlUrl(wsdlUrl);
			soapuiSett.setFdloadUser(fdLoadUser);
			soapuiSett.setFdloadPwd(fdLoadPwd);
			soapuiSett.setFdSoapVerson(fdSoapVersion);
			String versionMsg = ResourceUtil							
					.getString("tibSysSoapSetting.soapHeaderTemplate", "tib-sys-soap-connector");
			if (fdSoapVersion.indexOf(";") != -1) {
				String[] soapVersions = fdSoapVersion.split(";");
				for (String soapVersion : soapVersions) {
					String soapVersionRemark = "<!-- "+ soapVersion + versionMsg +" -->";
					String headTemplate = soapui.toDefaultInputXml(soapuiSett, soapVersion);
					map.put(StringUtils.deleteWhitespace(soapVersion), soapVersionRemark + headTemplate +"\n");
				}
			} else {
				String soapVersionRemark = "<!-- "+ fdSoapVersion + versionMsg +" -->";
				String headTemplate = soapui.toDefaultInputXml(soapuiSett, fdSoapVersion);
				map.put(StringUtils.deleteWhitespace(fdSoapVersion), soapVersionRemark + headTemplate +"\n");
			}
			rtnList.add(map);
		} catch (Exception e) {
			map.put("error", "exception");
			rtnList.add(map);
			e.printStackTrace();
		}
		return rtnList;
	}
	
}
