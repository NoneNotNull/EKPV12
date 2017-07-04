<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/tree_top.jsp" %>
//Com_Parameter.XMLDebug = true;
function generateTree()
{
	LKSTree = new TreeView(
		"LKSTree",
		"<bean:message key="module.tib.soap.sync" bundle="tib-soap-sync"/>",
		document.getElementById("treeDiv")
	);
	var n1, n2, n3, n4, n5;
	n1 = LKSTree.treeRoot;
	
	<%-- 定时任务对应函数表 --%>
	n2 = n1.AppendURLChild(
		"<bean:message key="table.tibSoapSyncTempFunc" bundle="tib-soap-sync" />",
		"<c:url value="/tib/soap/sync/tib_soap_sync_temp_func/tibSoapSyncTempFunc.do?method=list" />"
	);
	<%-- 配置/分类信息 --%>
	n2 = n1.AppendURLChild(
		"<bean:message key="table.tibSoapSyncCategory" bundle="tib-soap-sync" />",
		"<c:url value="/tib/soap/sync/tib_soap_sync_category/tibSoapSyncCategory.do?method=list" />"
	);
	<%-- 定时任务 --%>
	n2 = n1.AppendURLChild(
		"<bean:message key="table.tibSoapSyncJob" bundle="tib-soap-sync" />",
		"<c:url value="/tib/soap/sync/tib_soap_sync_job/tibSoapSyncJob.do?method=list" />"
	);
	
	LKSTree.EnableRightMenu();
	LKSTree.Show();
}
<%@ include file="/resource/jsp/tree_down.jsp" %>