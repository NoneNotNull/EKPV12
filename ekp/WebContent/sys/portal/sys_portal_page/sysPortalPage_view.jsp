<%@page import="com.landray.kmss.sys.portal.util.SysPortalInfo"%>
<%@page import="com.landray.kmss.sys.portal.util.PortalUtil"%>
<%@page import="com.landray.kmss.sys.portal.forms.SysPortalPageForm"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@page errorPage="/resource/jsp/jsperror.jsp" %>
<%
	SysPortalPageForm pageForm = (SysPortalPageForm)request.getAttribute("sysPortalPageForm");	
	SysPortalInfo info = new SysPortalInfo();
	PortalUtil.getSysPortalPageInfo(info,pageForm.getFdId());
	info.setUsePortal("false");
	request.setAttribute("sys_portal_page_preview",info);
	if (info.getPageType().equals("2")) {
		response.sendRedirect(info.getPageUrl());
	}else{
		String path = PortalUtil.getPortalPageJspPath(info);
		request.getRequestDispatcher(path).forward(request, response);
	}
%>