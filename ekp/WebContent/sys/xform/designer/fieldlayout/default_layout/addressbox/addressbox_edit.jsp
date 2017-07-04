<%@page import="com.landray.kmss.util.StringUtil"%>
<%@page import="com.landray.kmss.sys.xform.base.service.controls.fieldlayout.SysFieldsParamsParse"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>

<%
	//字段ID
	String fieldIds=request.getParameter("fieldIds");

	SysFieldsParamsParse parse=new SysFieldsParamsParse(request).parse();
	//type
	String dateTimeType=parse.getParamValue("dateTimeType","datetime");
	String formIds=StringUtil.isNull((String)request.getParameter("formIds"))?fieldIds+"Ids"+":"+fieldIds+"Names":(String)request.getParameter("formIds");



	//样式字符串
	parse.addStyle("width", "control_width", "120px");
	parse.addStyle("_readOnly", "control_readOnly", "false");
	//只读
	String readOnly=parse.getReadOnly(parse.getParamValue("control_readOnly", "false"));
	boolean required=Boolean.parseBoolean(parse.getParamValue("control_required","false"));
	String propertyId=formIds.split(":")[0];
	String propertyName=formIds.split(":")[1];
	boolean mulSelect=Boolean.parseBoolean(parse.getParamValue("mulSelect","false"));
	String orgType=parse.getParamValue("orgType","ORG_TYPE_ALL");
%>
<xform:address propertyId="<%=propertyId%>" propertyName="<%=propertyName%>" showStatus="<%=readOnly%>"  required="<%=required%>" mulSelect="<%=mulSelect%>" orgType="<%=orgType%>" style="<%=parse.getStyle()%>" onValueChange="__xformDispatch" isLoadDataDict="false"/>
