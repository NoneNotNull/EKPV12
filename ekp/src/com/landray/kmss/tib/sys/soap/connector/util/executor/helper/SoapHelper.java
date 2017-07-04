package com.landray.kmss.tib.sys.soap.connector.util.executor.helper;

import java.util.HashMap;
import java.util.Map;

import org.apache.commons.lang.StringUtils;

import com.eviware.soapui.impl.WsdlInterfaceFactory;
import com.eviware.soapui.impl.wsdl.WsdlInterface;
import com.eviware.soapui.impl.wsdl.WsdlOperation;
import com.landray.kmss.tib.sys.soap.connector.impl.TibSysSoapProjectFactory;
import com.landray.kmss.tib.sys.soap.connector.impl.TibSysSoapWsdlLoader;
import com.landray.kmss.tib.sys.soap.connector.model.TibSysSoapSetting;
import com.landray.kmss.util.StringUtil;


public class SoapHelper {
	
	
	public static WsdlInterface[] getWsdlInterfacesNoCache(String url,String soapVersion,String requestUser,String passwrod) throws Exception{
		if(StringUtil.isNotNull(requestUser)&&StringUtil.isNotNull(passwrod)){
			TibSysSoapWsdlLoader wsdlLoader = new TibSysSoapWsdlLoader(url, requestUser, passwrod, "10000", 
					"10000");
			return WsdlInterfaceFactory.importWsdl(TibSysSoapProjectFactory.getWsdlProjectInstance(),
					url, false, wsdlLoader);
		}
		else{
			return WsdlInterfaceFactory.importWsdl(TibSysSoapProjectFactory.getWsdlProjectInstance(), url, false);
		}
	}
	
	public static WsdlInterface getWsdlInterfaceNoCache(String url,String soapVersion,String opernateName,String requestUser,String passwrod) throws Exception{
		WsdlInterface[]  ifaces=getWsdlInterfacesNoCache(url, soapVersion, requestUser, passwrod);
		WsdlInterface iface = null;
		if (ifaces.length > 0) {
			Map<String, WsdlInterface> ifaceMap = new HashMap<String, WsdlInterface>(1);
			// 把WsdlInterface全部存入大Map
			for (WsdlInterface face : ifaces) {
				String displaySoapVersionName = face.getSoapVersion().getName();
				displaySoapVersionName = StringUtils.deleteWhitespace(displaySoapVersionName);
				ifaceMap.put(displaySoapVersionName, face);
				if (soapVersion != null
						&& displaySoapVersionName.equals(soapVersion)){
					iface = face;
					return iface;
				}
			}
		}
		return iface;
	} 
	
	public static WsdlInterface getWsdlInterfaceInstanceCache(TibSysSoapSetting soapuiSett,String soapVersion) throws Exception{
		WsdlInterface  wsdlInterface = TibSysSoapProjectFactory.getWsdlInterfaceInstance(soapuiSett, soapVersion);
	    return wsdlInterface;
	}
	
	public  WsdlOperation getWsdlOperation(WsdlInterface face,String operationName){
		WsdlOperation wsdlOperation=null;
		if(face!=null){
			wsdlOperation = face.getOperationByName(operationName);
		}
		return wsdlOperation;
	}
	
	
	
	
	
	
	

}
