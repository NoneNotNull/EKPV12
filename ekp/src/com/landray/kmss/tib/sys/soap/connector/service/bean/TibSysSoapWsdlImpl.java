/**
 * 
 */
package com.landray.kmss.tib.sys.soap.connector.service.bean;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.eviware.soapui.impl.wsdl.WsdlInterface;
import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.service.IXMLDataBean;
import com.landray.kmss.tib.sys.soap.connector.impl.TibSysSoapProjectFactory;
import com.landray.kmss.tib.sys.soap.connector.model.TibSysSoapSetting;

/**
 * @author 邱建华
 * todo soapui 需要做一个这样的功能===
 * @version 1.0
 * @2012-8-14
 */
public class TibSysSoapWsdlImpl implements IXMLDataBean {
	
	public List getDataList(RequestContext requestInfo) {
		List<Map<String, String>> rtnList = new ArrayList<Map<String, String>>();
		try {
			String fdWsdlUrl = requestInfo.getParameter("fdWsdlUrl");
			String fdloadUser = requestInfo.getParameter("user");
			String fdloadPwd = requestInfo.getParameter("pwd");
			TibSysSoapSetting soapuiSett = new TibSysSoapSetting();
			soapuiSett.setFdWsdlUrl(fdWsdlUrl);
			soapuiSett.setFdloadUser(fdloadUser);
			soapuiSett.setFdloadPwd(fdloadPwd);
			WsdlInterface[]  faces=TibSysSoapProjectFactory.importWsdl(soapuiSett);
			if(faces!=null){
				for(WsdlInterface wf:faces){
					Map<String, String> map=new HashMap<String, String>();
					String verison=wf.getSoapVersion().getName();
					map.put("version", verison);
					rtnList.add(map);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return rtnList;
	}
}
	
