<%@page import="com.landray.kmss.util.StringUtil"%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@page import="java.util.Map"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="java.util.Iterator"%>
<%@page import="net.sf.json.JSONArray"%>
<%
	
%>

		<ui:menu layout="sys.ui.menu.nav" id="sysnotifycateid">
			<ui:menu-item text="${ lfn:message('home.home') }" icon="lui_icon_s_home" href="/" target="_self">
			</ui:menu-item>
			<ui:menu-item text="${lfn:message('sys-notify:module.sys.notify') }" href="/sys/notify" target="_self">
			</ui:menu-item>
			<ui:menu-source autoFetch="true" 
					target="_self" 
					href="/sys/notify?fdCateId=!{value}">
				<ui:source type="AjaxJson">
					{"url":"/sys/notify/sys_notify_todo/sysNotifyMainIndex.do?method=path&fdCateId=${param.fdCateId }&currId=!{value}"} 
				</ui:source>
			</ui:menu-source>
		</ui:menu>

