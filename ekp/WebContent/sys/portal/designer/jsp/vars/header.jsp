<%@page import="net.sf.json.JSONArray"%>
<%@page import="com.landray.kmss.sys.portal.util.PortalUtil"%>
<%@page import="com.landray.kmss.sys.portal.xml.model.SysPortalHeader"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	SysPortalHeader header = PortalUtil.getPortalHeaders().get(request.getParameter("fdId"));
	request.setAttribute("vars",JSONArray.fromObject(header.getFdVars()));
	request.getRequestDispatcher("/sys/ui/jsp/vars/variable.jsp").forward(request, response);
%>