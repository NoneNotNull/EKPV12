<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="com.landray.kmss.sys.xform.base.service.controls.fieldlayout.SysFieldsParamsParse"%>
<%
	SysFieldsParamsParse parse = new SysFieldsParamsParse(request).parse();
	boolean required = Boolean.parseBoolean(parse.getParamValue("control_required", "false"));
%>