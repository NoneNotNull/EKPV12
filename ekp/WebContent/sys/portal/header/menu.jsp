<%@page import="com.landray.kmss.sys.portal.util.PortalUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/ui.tld" prefix="ui"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/lfn.tld" prefix="lfn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<ui:dataview>
	<ui:source type="AjaxJson">
		{"url":"/sys/portal/sys_portal_main/sysPortalMain.do?method=pages&portalId=<%= PortalUtil.getPortalInfo(request).getPortalId() %>&pageId=<%= PortalUtil.getPortalPageId(request) %>"}
	</ui:source>
	<ui:render ref="sys.portal.menu"/>
</ui:dataview>