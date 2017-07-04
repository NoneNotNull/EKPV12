<%@page import="net.sf.json.JSONArray"%>
<%@page import="com.landray.kmss.util.ResourceUtil"%>
<%@ page language="java" contentType="text/json; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.landray.kmss.sys.ui.plugin.SysUiPluginUtil"%>
<%@ page import="org.apache.commons.beanutils.PropertyUtils"%>
<%@ page import="com.landray.kmss.sys.ui.xml.model.*"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<list:data>
	<list:data-columns var="sysUiRender" list="${queryList}">
		<list:data-column property="fdId" title="ID">
		</list:data-column>
		<list:data-column property="fdName" title="${ lfn:message('sys-portal:sysPortalPage.fdName') }">
		</list:data-column>
		<list:data-column property="fdThumb">
		</list:data-column>
	</list:data-columns>
</list:data>