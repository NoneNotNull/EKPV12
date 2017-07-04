package com.landray.kmss.tib.sys.soap.connector.util.executor.vo;


import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import com.eviware.soapui.model.iface.Response;
import com.landray.kmss.tib.sys.core.util.DOMHelper;
import com.landray.kmss.util.StringUtil;

public class TibSysSoapEasRtn implements ITibSysSoapRtn  {
	
	private String rtnContent;
	private Response response;
	private String rtnType;
	private String sessionId;
	private Document rtnDocument;
	
	public TibSysSoapEasRtn(String rtnContent, Response response,Document doc) {
		this.rtnContent = rtnContent;
		this.response = response;
		this.rtnDocument=doc;
		sessionId=findSessionId(rtnContent);
		if(StringUtil.isNull(sessionId)){
			rtnType=ERP_SOAPUI_EAR_TYPE_ERROR;
		}
		else{
			rtnType=ERP_SOAPUI_EAR_TYPE_SUCCESS;
		}
	}
	
	private String findSessionId(String rtnContent){
		try{
		Document doc= DOMHelper.parseXmlString(rtnContent);
		
		NodeList nodeList= doc.getElementsByTagName("sessionId");
		Node node=DOMHelper.getElementNode(nodeList, 0);
		String rtn=node.getTextContent();
		return rtn ;
		}catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
			return null;
		}
	}
	

	public String getRtnContent() {
		return rtnContent;
	}
	
	public void setRtnContent(String rtnContent) {
		this.rtnContent = rtnContent;
	}
	public Response getResponse() {
		return response;
	}
	public void setResponse(Response response) {
		this.response = response;
	}

	public String getSessionId() {
		return sessionId;
	}
	public void setSessionId(String sessionId) {
		this.sessionId = sessionId;
	}

	public String getRtnType() {
		return rtnType;
	}

	public void setRtnType(String rtnType) {
		this.rtnType = rtnType;
	}

	public Document getRtnDocument() {
		return rtnDocument;
	}

	public void setRtnDocument(Document rtnDocument) {
		this.rtnDocument = rtnDocument;
	}
	public Document resetRtnDocument(Document document) {
		// TODO 自动生成的方法存根
		setRtnDocument(document);
		return document;
	}
	
	
	

}
