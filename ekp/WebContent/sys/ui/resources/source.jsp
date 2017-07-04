
<%@ page language="java" contentType="text/plain; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="com.landray.kmss.sys.ui.xml.model.SysUiSource"%>
<%@ page import="com.landray.kmss.sys.ui.plugin.SysUiPluginUtil"%>
<%
	SysUiSource render = SysUiPluginUtil.getSourceById(request
			.getParameter("code"));
	out.append(render.getFdBody().getBody());
%>