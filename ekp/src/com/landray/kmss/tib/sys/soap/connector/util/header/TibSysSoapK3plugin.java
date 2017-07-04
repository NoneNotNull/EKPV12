package com.landray.kmss.tib.sys.soap.connector.util.header;

import java.util.Map;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;

import com.landray.kmss.tib.sys.soap.connector.model.TibSysSoapSetting;
import com.landray.sso.client.util.StringUtil;

public class TibSysSoapK3plugin extends ISoapHeaderType {

	
	@Override
	public void buildDocTemplate(Document doc, TibSysSoapSetting soapuiSet)
			throws Exception {
		HeaderOperation.nodeToString(doc);
		Element ele = doc.getDocumentElement();
		Node iAisIDNode = HeaderOperation.selectNode("/Envelope/Body/*/iAisID", ele);
		Node strUserNode = HeaderOperation.selectNode("/Envelope/Body/*/strUser", ele);
		Node strPasswordNode = HeaderOperation.selectNode("/Envelope/Body/*/strPassword", ele);
		// 若用户没有填写验证信息，则调用k3登录方式进行填写验证信息
		if (iAisIDNode != null && StringUtil.isNull(iAisIDNode.getTextContent()) 
				&& StringUtil.isNull(strUserNode.getTextContent()) 
				&& StringUtil.isNull(strPasswordNode.getTextContent())) {
			Map<String, Object> map = soapuiSet.getExtendInfoMap();
			iAisIDNode.setTextContent(map.get("k3IAisID").toString());
			strUserNode.setTextContent(map.get("k3UserName").toString());
			strPasswordNode.setTextContent(map.get("k3Password").toString());
		}
		
	}
	
}
