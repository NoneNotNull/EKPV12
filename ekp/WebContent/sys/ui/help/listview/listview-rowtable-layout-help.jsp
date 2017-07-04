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
			<list:rowTable
				name="rowtable" onRowClick="" 
				style="" target="_blank"> 
				<list:row-template ref="sys.ui.listview.rowtable">
				</list:row-template>
			</list:rowTable>
		</list:listview>
		<list:paging></list:paging>
	</template:replace>
</template:include> 
