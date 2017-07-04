<%@ page import="com.landray.kmss.sys.ui.plugin.SysUiPluginUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%
request.setAttribute("datas", SysUiPluginUtil.getVarKinds().values());
%>
<ui:json var="columns">
	[
		{id:"fdId", name:"ID"},
		{id:"fdName", name:"名称"},
		{id:"fdFile", name:"路径"}
	]
</ui:json>
<template:include file="/sys/ui/help/common/list.jsp">
</template:include>

