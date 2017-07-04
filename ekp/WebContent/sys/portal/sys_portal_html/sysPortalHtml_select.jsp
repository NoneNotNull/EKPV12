<%@page import="net.sf.json.JSONArray"%>
<%@page import="com.landray.kmss.util.ResourceUtil"%>
<%@ page language="java" contentType="text/json; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.landray.kmss.sys.ui.plugin.SysUiPluginUtil"%>
<%@ page import="org.apache.commons.beanutils.PropertyUtils"%>
<%@ page import="com.landray.kmss.sys.ui.xml.model.*"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<list:data>
	<list:data-columns var="sysPortalHtml" list="${queryPage.list}">
		<list:data-column property="fdId">
		</list:data-column>
		<list:data-column property="fdName" title="名称">
		</list:data-column>
	</list:data-columns>
	<list:data-paging page="${ queryPage }">
	</list:data-paging>
</list:data>