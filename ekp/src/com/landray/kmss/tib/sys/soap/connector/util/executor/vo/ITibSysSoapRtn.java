package com.landray.kmss.tib.sys.soap.connector.util.executor.vo;

import org.w3c.dom.Document;

import com.eviware.soapui.model.iface.Response;

public interface ITibSysSoapRtn {

	// 程序错误
	public static final String ERP_SOAPUI_EAR_TYPE_ERROR = "fault";
	// 执行成功
	public static final String ERP_SOAPUI_EAR_TYPE_SUCCESS = "success";
	// 业务异常
	public static final String ERP_SOAPUI_EAR_TYPE_BIERROR = "bierror";

	public String getRtnContent();

	public Response getResponse();
	
	public Document resetRtnDocument(Document document);
	
	public Document getRtnDocument();

	public String getRtnType();

}
