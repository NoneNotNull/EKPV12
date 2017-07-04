<%@page import="com.landray.kmss.util.StringUtil"%>
<%@page import="com.landray.kmss.sys.xform.base.service.controls.fieldlayout.SysFieldsParamsParse"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="java.util.Map"%>
<%@page import="net.sf.json.JSONObject"%>

<%@ include file="/resource/jsp/common.jsp"%>
<%
	//字段ID
	String fieldIds = request.getParameter("fieldIds");
	String formIds=StringUtil.isNull((String)request.getParameter("formIds"))?fieldIds+"Ids"+":"+fieldIds+"Names":(String)request.getParameter("formIds");
	String propertyId=formIds.split(":")[0];
	String propertyName=formIds.split(":")[1];
%>
<xform:address propertyId="<%=propertyId%>" propertyName="<%=propertyName%>"  onValueChange="__xformDispatch" isLoadDataDict="false"/>