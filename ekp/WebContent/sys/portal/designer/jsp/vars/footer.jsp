<%@page import="com.landray.kmss.sys.portal.xml.model.SysPortalFooter"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="com.landray.kmss.sys.portal.util.PortalUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	SysPortalFooter footer = PortalUtil.getPortalFooters().get(request.getParameter("fdId"));
	request.setAttribute("vars",JSONArray.fromObject(footer.getFdVars()));
	request.getRequestDispatcher("/sys/ui/jsp/vars/variable.jsp").forward(request, response);
%>