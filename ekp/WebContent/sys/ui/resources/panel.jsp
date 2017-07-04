<%@ page language="java" contentType="text/plain; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="com.landray.kmss.sys.ui.model.SysUiPanel"%>
<%@ page import="com.landray.kmss.sys.ui.plugin.SysUiPluginUtil"%>
<%
	SysUiPanel panel = SysUiPluginUtil.getPanelById(request
			.getParameter("code"));
	out.append(panel.getFdBody().getBody());
%>