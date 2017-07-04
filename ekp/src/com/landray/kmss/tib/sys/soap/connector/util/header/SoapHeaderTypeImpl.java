/**
 * 
 */
package com.landray.kmss.tib.sys.soap.connector.util.header;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;

import com.landray.kmss.tib.sys.soap.connector.model.TibSysSoapSetting;

/**
 * SOAPHeader方式
 * @author 邱建华
 * @version 1.0 2012-12-20
 */
public class SoapHeaderTypeImpl extends ISoapHeaderType {
	
	/**
	 * doc是整个请求xml的节点
	 * 创建自己的Header，下面是自己的模版格式
	 * <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" 
	 			xmlns:ws="http://ws.com/">
	 	   <!-- 从以下开始 -->
	 	 <soapenv:Header>
			<auth:authentication xmlns:auth="http://gd.chinamobile.com//authentication">
				<auth:systemID>1</auth:systemID>
				<auth:userID>test</auth:userID>
				<auth:password>test</auth:password>
			</auth:authentication>
		 </soapenv:Header>
	 */
	@Override
	public void buildDocTemplate(Document doc, TibSysSoapSetting soapuiSet) throws Exception {
		Element ele = doc.getDocumentElement();
		// 获取头部节点
		Node headerNode = HeaderOperation.selectNode("//Envelope/Header", ele);
		// 创建authentication节点信息
		Element authEle = doc.createElement("auth:authentication");
		authEle.setAttribute("xmlns:auth", "http://gd.chinamobile.com//authentication");
		headerNode.appendChild(authEle);
		// 创建systemID,userID,password节点信息
		Node systemIDNode = doc.createElement("auth:systemID");
		systemIDNode.setTextContent("1");
		Node userIDNode = doc.createElement("auth:userID");
		userIDNode.setTextContent(soapuiSet.getFdUserName());
		Node passwordNode = doc.createElement("auth:password");
		passwordNode.setTextContent(soapuiSet.getFdPassword());
		// authEle加入验证的节点
		authEle.appendChild(systemIDNode);
		authEle.appendChild(userIDNode);
		authEle.appendChild(passwordNode);
		
	}
	
	public void buildHeaderNode(Document doc, String username, String password,Object obj)
			throws Exception{
		
		
	}
	
	
	
}
