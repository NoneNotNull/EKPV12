package com.landray.kmss.tib.sys.soap.connector.util.init;

import java.util.Map;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import com.landray.kmss.tib.sys.core.util.DOMHelper;
import com.landray.kmss.tib.sys.soap.connector.interfaces.ITibSysSoap;
import com.landray.kmss.tib.sys.soap.connector.model.TibSysSoapMain;
import com.landray.kmss.tib.sys.soap.connector.model.TibSysSoapSetting;
import com.landray.kmss.tib.sys.soap.connector.util.executor.vo.ITibSysSoapRtn;
import com.landray.kmss.tib.sys.soap.connector.util.header.HeaderOperation;
import com.landray.kmss.tib.sys.soap.connector.util.header.SoapInfo;
import com.landray.kmss.tib.sys.soap.connector.util.xml.ParseSoapXmlUtil;
import com.landray.kmss.util.SpringBeanUtil;

public class TibSysSoapInitExecuteUtil {
	
	public static Document getResponseDocByInit(TibSysSoapSetting soapuiSett, 
			String bindFunc, String soapVersion, Map<String, String> authMap) throws Exception {
		ITibSysSoap tibSysSoap = (ITibSysSoap) SpringBeanUtil.getBean("tibSysSoap");
		String templateXml = tibSysSoap.toAllXmlTemplate(soapuiSett, bindFunc, soapVersion);
		Document requestDoc = ParseSoapXmlUtil.parseXmlString("<web>"+ templateXml +"</web>");
		Element ele = ParseSoapXmlUtil.selectElement("//Input/Envelope/Body", requestDoc).get(0);
		// 组装请求参数
		for (String key : authMap.keySet()) {
			NodeList nodeList = ele.getElementsByTagName(key);
			Node node = DOMHelper.getElementNode(nodeList, 0);
			if (node != null) {
				node.setTextContent(authMap.get(key));
			}
		}
		String requestXml = ParseSoapXmlUtil.nodeToString(requestDoc);
		// 设置传入信息VO
		SoapInfo soapInfo = new SoapInfo();
		soapInfo.setRequestXml(requestXml);
		soapInfo.setRequestDocument(requestDoc);
		// 设置主文档信息
		TibSysSoapMain soapMain = new TibSysSoapMain();
		soapMain.setWsSoapVersion(soapVersion);
		soapMain.setWsBindFunc(bindFunc);
		soapMain.setTibSysSoapSetting(soapuiSett);
		soapInfo.setTibSysSoapMain(soapMain);
		ITibSysSoapRtn soapRtn = tibSysSoap.inputToOutputRtn(soapInfo);
		String responseXml = soapRtn.getRtnContent();
		Document responseDoc = HeaderOperation.stringToDoc(responseXml);
		return responseDoc;
	}
	
}
