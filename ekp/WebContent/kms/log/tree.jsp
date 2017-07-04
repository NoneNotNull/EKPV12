﻿<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/tree_top.jsp" %>
//Com_Parameter.XMLDebug = true;
function generateTree()
{
	LKSTree = new TreeView(
		"LKSTree",
		"<bean:message key="module.kms.log" bundle="kms-log"/>",
		document.getElementById("treeDiv")
	);
	var n1, n2, n3, n4, n5;
	n1 = LKSTree.treeRoot;
	
	<%-- 日志基础配置 --%>
	n2 = n1.AppendURLChild(
		"<bean:message key="table.kmsLogConfig" bundle="kms-log" />",
		"<c:url value="/kms/log/kms_log_config/kmsLogConfig.do?method=edit" />"
	);
	
	<%-- 应用日志表 --%>
	n2 = n1.AppendURLChild(
		"<bean:message key="table.kmsLogApp" bundle="kms-log" />",
		"<c:url value="/kms/log/kms_log_app/kmsLogApp.do?method=list" />"
	);
	
	<%-- 历史应用日志表 --%>
	<% if(Boolean.valueOf(ResourceUtil.getKmssConfigString("kmss.log.detachment"))){
	%>
		n2 = n1.AppendURLChild(
			"<bean:message key="kmsLogApp.kmsLogAppHistory" bundle="kms-log" />",
			"<c:url value="/kms/log/kms_log_app/kmsLogApp.do?method=list&history=true" />"
		);
		
	<%} %>
	
	<%-- 搜索日志表 --%>
	n2 = n1.AppendURLChild(
		"<bean:message key="table.kmsLogSearch" bundle="kms-log" />",
		"<c:url value="/kms/log/kms_log_search/kmsLogSearch.do?method=list" />"
	);
	
	LKSTree.EnableRightMenu();
	LKSTree.Show();
}
<%@ include file="/resource/jsp/tree_down.jsp" %>