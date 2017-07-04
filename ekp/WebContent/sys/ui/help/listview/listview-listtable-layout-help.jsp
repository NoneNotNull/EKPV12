<%@page import="net.sf.json.JSONArray"%>
<%@page import="java.util.*"%>
<%@page import="com.landray.kmss.sys.ui.plugin.SysUiPluginUtil"%>
<%@page import="com.landray.kmss.sys.ui.xml.model.*"%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include file="/sys/ui/help/listview/listview-layout-help.jsp">
	<template:replace name="example">
		<list:listview>
			<ui:source type="AjaxJson">
				{"url":"/sys/ui/help/listview/listdata-example.jsp"}
			</ui:source>
			<list:colTable layout="sys.ui.listview.listtable" name="listtable">
				<list:col-checkbox name="List_Selected" style="width:5%"></list:col-checkbox>
				<list:col-serial title="${ lfn:message('page.serial') }" headerStyle="width:5%"></list:col-serial>
				<list:col-auto props="docSubject;docAuthor.fdName;docDept.fdName;docReadCount;docScore;docPublishTime"></list:col-auto>
			</list:colTable>
		</list:listview>
		<list:paging></list:paging>
	</template:replace>
</template:include> 
