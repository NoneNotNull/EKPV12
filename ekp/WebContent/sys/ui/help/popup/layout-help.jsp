<%@page import="net.sf.json.JSONArray"%>
<%@page import="java.util.*"%>
<%@page import="com.landray.kmss.sys.ui.plugin.SysUiPluginUtil"%>
<%@page import="com.landray.kmss.sys.ui.xml.model.*"%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include file="/sys/ui/help/layout-help.jsp">
	<template:replace name="example">
		
		<table>
		<tr><td height="50px"></td><td></td></tr>
		<tr><td width="50px" height="250px"></td><td valign="top">
		<ui:popup align="down-right" borderWidth="1" triggerEvent="click" triggerObject="all">
			<ui:text>我是弹出层点击我试试效果</ui:text>
			<ui:container>
				 aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa<br>
				 我是弹出层内容aaaaaa<br>
				 我是弹出层内容aaaaaa<br>
			</ui:container>
		</ui:popup>
		</td></tr>
		</table> 
	</template:replace>
</template:include> 
