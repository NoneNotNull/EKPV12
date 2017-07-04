<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/tree_top.jsp" %>
//Com_Parameter.XMLDebug = true;
function generateTree()
{
	LKSTree = new TreeView(
		"LKSTree",
		"<bean:message key="module.tib.sys.sap.connector" bundle="tib-sys-sap-connector"/>",
		document.getElementById("treeDiv")
	);
	var n1, n2, n3, n4, n5,n_sync;
	n1 = LKSTree.treeRoot;
	
	<%-- sap连接配置 --%>
	n2 = n1.AppendURLChild(
		"<bean:message key="tibSysSapConnectingSetting" bundle="tib-sys-sap-connector" />",
		""
	);
	<%-- sap服务器配置 --%>
	n3 = n2.AppendURLChild(
		"<bean:message key="table.tibSysSapServerSetting" bundle="tib-sys-sap-connector" />",
		"<c:url value="/tib/sys/sap/connector/tib_sys_sap_server_setting/tibSysSapServerSetting.do?method=list" />"
	);
	
	<%-- jco配置 --%>
	n3 = n2.AppendURLChild(
		"<bean:message key="table.tibSysSapJcoSetting" bundle="tib-sys-sap-connector" />",
		"<c:url value="/tib/sys/sap/connector/tib_sys_sap_jco_setting/tibSysSapJcoSetting.do?method=list" />"
	);
	<%-- jco监控--%>
	n3 = n2.AppendURLChild(
		"<bean:message key="tibSysSapJcoCheck" bundle="tib-sys-sap-connector" />",
		"<c:url value="/tib/sys/sap/connector/tib_sys_sap_jco_monitor.jsp" />"
	);
	
		<%-- RFC管理 --%>
	n2 = n1.AppendURLChild(
		"<bean:message key="RfcSetting" bundle="tib-sys-sap-connector" />",
		""
	);
	<%-- RFC函数配置 --%>
	n3 = n2.AppendURLChild(
		"<bean:message key="table.tibSysSapRfcSetting" bundle="tib-sys-sap-connector" />",
		""
	);
	n4=n3.AppendBeanData("tibSysSapRfcCategoryTreeService&parentId=!{value}","<c:url value="/tib/sys/sap/connector/tib_sys_sap_rfc_setting/tibSysSapRfcSetting.do?method=list&categoryId=!{value}" />");
	<%-- 配置/分类信息 --%>
	n3 = n2.AppendURLChild(
		"<bean:message key="table.tibSysSapRfcCategory" bundle="tib-sys-sap-connector" />",
		//"<c:url value="/tib/sys/sap/connector/tib_sys_sap_rfc_category/tibSysSapRfcCategory_tree.jsp" />"
		"<c:url value="/sys/simplecategory/sys_simple_category/sysCategoryMain_tree.jsp?modelName=com.landray.kmss.tib.sys.sap.connector.model.TibSysSapRfcCategory&actionUrl=/tib/sys/sap/connector/tib_sys_sap_rfc_category/tibSysSapRfcCategory.do&formName=tibSysSapRfcCategoryForm&mainModelName=com.landray.kmss.tib.sys.sap.connector.model.TibSysSapRfcSetting&docFkName=docCategory" />"
	);
		<%-- RDB数据源 --%>
	n2 = n1.AppendURLChild(
		"<bean:message key="RDBDatasource" bundle="tib-sys-sap-connector" />",
		"<c:url value="/component/dbop/compDbcp.do?method=list" />"
	);
	
	n_sync= n1.AppendURLChild(
		"<bean:message key="module.tib.sap.sync" bundle="tib-sap-sync"/>",
		""
	);
				//按类别
	n_sync2 = n_sync.AppendURLChild(
		"<bean:message bundle="tib-sap-sync" key="module.erp.sapquartz.category.tree"/>",
		"<c:url value="/tib/sap/sync/tib_sap_sync_job/tibSapSyncJob.do?method=list&categoryId=!{value}" />"
	);
	n_sync2.AppendBeanData("tibSapSyncCategoryTreeService&parentId=!{value}");
	
		<%-- 配置/分类信息 --%>
	n_sync2 = n_sync.AppendURLChild(
		"<bean:message key="table.tibSapSyncCategory" bundle="tib-sap-sync" />",
		"<c:url value="/tib/sap/sync/tib_sap_sync_category/tibSapSyncCategory_tree.jsp" />"
	);
	
	
	
	
	LKSTree.EnableRightMenu();
	LKSTree.Show();
}
<%@ include file="/resource/jsp/tree_down.jsp" %>
