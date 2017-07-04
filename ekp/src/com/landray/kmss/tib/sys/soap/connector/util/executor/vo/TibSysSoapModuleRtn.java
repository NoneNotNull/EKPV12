package com.landray.kmss.tib.sys.soap.connector.util.executor.vo;


import org.w3c.dom.Document;

import com.eviware.soapui.model.iface.Response;
import com.landray.kmss.tib.sys.soap.connector.util.xml.ParseSoapXmlUtil;
import com.landray.kmss.util.StringUtil;

public class TibSysSoapModuleRtn implements ITibSysSoapRtn  {
	
	private String rtnContent;
	private Response response;
	private String rtnType;
	private Document rtnDocument;
	
	public TibSysSoapModuleRtn(String rtnContent, Response response,Document doc) {
		this.rtnContent = rtnContent;
		this.response = response;
		this.rtnDocument=doc;
		if(StringUtil.isNull(rtnContent)){
			rtnType=ERP_SOAPUI_EAR_TYPE_ERROR;
		}
		else{
			try {
				//判断返回的数据是否为正常数据
				boolean isFault = ParseSoapXmlUtil.isFault(rtnContent);
				if(isFault){
					rtnType=ERP_SOAPUI_EAR_TYPE_ERROR;
				}
				else{
					rtnType=ERP_SOAPUI_EAR_TYPE_SUCCESS;
				}
			} catch (Exception e) {
				rtnType=ERP_SOAPUI_EAR_TYPE_ERROR;
			}
			
			
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
