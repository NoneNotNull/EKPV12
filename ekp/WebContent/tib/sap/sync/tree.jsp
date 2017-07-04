<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/tree_top.jsp" %>
//Com_Parameter.XMLDebug = true;
function generateTree()
{
	LKSTree = new TreeView(
		"LKSTree",
		"<bean:message key="module.erp.sapquartz" bundle="tib-sap-sync"/>",
		document.getElementById("treeDiv")
	);
	var n1, n2, n3, n4, n5;
	n1 = LKSTree.treeRoot;
	
	<%-- 定时任务对应函数表 
	n2 = n1.AppendURLChild(
		"<bean:message key="table.tibSapSyncTempFunc" bundle="tib-sap-sync" />",
		"<c:url value="/tib/sap/sync/tib_sap_sync_temp_func/tibSapSyncTempFunc.do?method=list" />"
	);--%>
	<%-- 定时任务 --%>
<%-- 	n2 = n1.AppendURLChild(
		"<bean:message key="table.tibSapSyncJob" bundle="tib-sap-sync" />",
		"<c:url value="/tib/sap/sync/tib_sap_sync_job/tibSapSyncJob.do?method=list" />"
	); --%>
	
			//按类别
	n2 = n1.AppendURLChild(
		"<bean:message bundle="tib-sap-sync" key="module.erp.sapquartz.category.tree"/>",
		"<c:url value="/tib/sap/sync/tib_sap_sync_job/tibSapSyncJob.do?method=list&categoryId=!{value}" />"
	);
		n2.AppendBeanData("tibSapSyncCategoryTreeService&parentId=!{value}");
	n2.isExpanded = true;
		<%-- 配置/分类信息 --%>
	n2 = n1.AppendURLChild(
		"<bean:message key="table.tibSapSyncCategory" bundle="tib-sap-sync" />",
		"<c:url value="/tib/sap/sync/tib_sap_sync_category/tibSapSyncCategory_tree.jsp" />"
	);

	

	
	LKSTree.EnableRightMenu();
	

	

	LKSTree.Show();
}
<%@ include file="/resource/jsp/tree_down.jsp" %>
