<%@ page import="com.landray.kmss.sys.ui.plugin.SysUiPluginUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%
request.setAttribute("datas", SysUiPluginUtil.getTemplates().values());
%>
<ui:json var="columns">
	[
		{id:"fdId", name:"ID"},
		{id:"fdName", name:"名称"},
		{id:"fdFile", name:"文件路径"},
		{id:"fdFor", name:"使用场景"}
	]
</ui:json>
<template:include file="/sys/ui/help/common/list.jsp">
</template:include>
