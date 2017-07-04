<%@ page language="java" contentType="text/plain; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="com.landray.kmss.sys.ui.xml.model.SysUiRender"%>
<%@ page import="com.landray.kmss.sys.ui.plugin.SysUiPluginUtil"%>
<%
	SysUiRender render = SysUiPluginUtil.getRenderById(request
			.getParameter("code"));
	out.append(render.getFdBody().getBody());
%>