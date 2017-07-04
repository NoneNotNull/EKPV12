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
	String formIds=StringUtil.isNull((String)request.getParameter("formIds"))?fieldIds:(String)request.getParameter("formIds");
	SysFieldsParamsParse parse = new SysFieldsParamsParse(request)
			.parse();
	//type
	String dateTimeType = parse.getParamValue("dateTimeType",
			"datetime");
	
%>
<xform:datetime property="<%=formIds%>" dateTimeType="<%=dateTimeType%>"/>