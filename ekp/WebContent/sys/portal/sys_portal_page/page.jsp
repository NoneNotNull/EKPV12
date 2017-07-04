<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@page import="com.landray.kmss.sys.portal.util.SysPortalConfig"%>
<%
	if(SysPortalConfig.BEHAVIOR_ENABLE){
%>
<c:import url="/dbcenter/behavior/hotspot/portal.jsp" />
<% } %>