<%@page import="com.landray.kmss.util.StringUtil"%>
<%@page import="com.landray.kmss.sys.portal.util.SysPortalInfo"%>
<%@page import="com.landray.kmss.sys.portal.util.PortalUtil"%>
<%@page language="java" pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<%@page errorPage="/resource/jsp/jsperror.jsp"%>
<%	
	SysPortalInfo xpage = PortalUtil.viewDefaultPortalInfo(request);
	if (xpage.getPageType().equals("2")) {
		response.sendRedirect(xpage.getPageUrl());
	} else {
		String path = PortalUtil.getPortalPageJspPath(xpage);
		request.getRequestDispatcher(path).forward(request, response);
	}
%>