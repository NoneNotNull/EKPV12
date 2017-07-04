<%@page import="com.landray.kmss.sys.xform.base.service.controls.fieldlayout.SysFieldsParamsParse"%>
<%@page import="com.landray.kmss.util.StringUtil"%>
<%@page import="java.util.Map"%>
<%@page import="net.sf.json.JSONObject"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>

<%
	//字段ID
	String fieldIds=request.getParameter("fieldIds");
	String formIds=StringUtil.isNull((String)request.getParameter("formIds"))?fieldIds:(String)request.getParameter("formIds");
	SysFieldsParamsParse parse=new SysFieldsParamsParse(request).parse();
	
	//是否必填,只针对数据字典中非必填的字段生效
	boolean required=Boolean.parseBoolean(parse.getParamValue("control_required","edit"));
	
	//只读
	String readOnly=parse.getReadOnly(parse.getParamValue("control_readOnly", "false"));
	//type
	String dateTimeType=parse.getParamValue("dateTimeType","datetime");
	//样式字符串
	parse.addStyle("width", "control_width", "120px");
	parse.addStyle("_readOnly", "control_readOnly", "false");
	
%>
<script>Com_IncludeFile('calendar.js');</script>
<xform:datetime property="<%=formIds%>" required="<%=required%>" showStatus="<%=readOnly%>" dateTimeType="<%=dateTimeType%>" style="<%=parse.getStyle()%>" />	