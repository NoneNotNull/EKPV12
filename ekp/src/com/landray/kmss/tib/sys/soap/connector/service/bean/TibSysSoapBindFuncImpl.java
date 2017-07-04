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
import com.landray.kmss.tib.sys.soap.connector.service.ITibSysSoapSettingService;
import com.landray.kmss.util.SpringBeanUtil;
import com.landray.kmss.util.StringUtil;

/**
 * @author 邱建华
 * @version 1.0
 * @2012-8-15
 */
public class TibSysSoapBindFuncImpl implements IXMLDataBean {
	private ITibSysSoapSettingService tibSysSoapSettingService;
	
	public void setTibSysSoapSettingService(
			ITibSysSoapSettingService tibSysSoapSettingService) {
		this.tibSysSoapSettingService = tibSysSoapSettingService;
	}
	
	public List getDataList(RequestContext requestInfo) throws Exception {
		List<Map<String, String>> rtnList = new ArrayList<Map<String, String>>();
		try {
			String serviceId = requestInfo.getParameter("serviceId");
			String localPart = requestInfo.getParameter("wsBindFunc");
			String soapversion = requestInfo.getParameter("soapversion");
			String curFdId=requestInfo.getParameter("curId");
			if (StringUtil.isNotNull(serviceId)) {
				TibSysSoapSetting TibSysSoapSetting = (TibSysSoapSetting) tibSysSoapSettingService
						.findByPrimaryKey(serviceId);
				ITibSysSoap TibSysSoap = (ITibSysSoap) SpringBeanUtil.getBean("tibSysSoap");
				String xml=null;
				if(TibSysSoapSetting.getFdProtectWsdl()){
					 xml = TibSysSoap.toAllXmlTemplate(TibSysSoapSetting, localPart, soapversion);
				}else{
					 xml = TibSysSoap.toAllXmlTemplate(TibSysSoapSetting, localPart, soapversion);
				}
				
				
				String[] mergeXml=new String[4];
				mergeXml[0]="<?xml version=\"1.0\" encoding=\"UTF-8\"?>";
				mergeXml[1]="<web ID=\"!{fdId}\">".replace("!{fdId}", curFdId);
				mergeXml[2]=xml;
				mergeXml[3]="</web>";
				String result=StringUtils.join(mergeXml);
				Map<String, String> map = new HashMap<String, String>();
				map.put("xml", result);
				rtnList.add(map);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return rtnList;
	}
	
}
