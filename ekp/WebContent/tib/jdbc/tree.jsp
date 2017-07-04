<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/tree_top.jsp" %>
//Com_Parameter.XMLDebug = true;
function generateTree()
{
	LKSTree = new TreeView(
		"LKSTree",
		"<bean:message key="module.tib.jdbc" bundle="tib-jdbc"/>",
		document.getElementById("treeDiv")
	);
	var n1, n2, n3, n4, n5;
	n1 = LKSTree.treeRoot;
	
	
	<%-- 映射管理 --%>
	n2 = n1.AppendURLChild(
		"<bean:message key="table.tibJdbcMappManage" bundle="tib-jdbc" />",
		""
	);
	n3 = n2.AppendURLChild(
		"<bean:message key="tibJdbcMappManage.title" bundle="tib-jdbc" />",
		"<c:url value="/tib/jdbc/tib_jdbc_mapp_manage/tibJdbcMappManage.do?method=list" />"
	);
	
	n3.AppendBeanData("tibJdbcMappCategoryTreeService&parentId=!{value}","<c:url value="/tib/jdbc/tib_jdbc_mapp_manage/tibJdbcMappManage.do?method=list&categoryId=!{value}" />");
	
	<%-- 映射分类 --%>
	n3 = n2.AppendURLChild(
		"<bean:message key="tibJdbcMappCategory.title" bundle="tib-jdbc" />",
		"<c:url value="/tib/jdbc/tib_jdbc_mapp_category/tibJdbcMappCategory_tree.jsp" />"
	);
	
	
	<%-- 任务管理 --%>
	n2 = n1.AppendURLChild(
		"<bean:message key="table.tibJdbcTaskManage" bundle="tib-jdbc" />",
		""
	);
	n3 = n2.AppendURLChild(
		"<bean:message key="tibJdbcTaskManage.title" bundle="tib-jdbc" />",
		"<c:url value="/tib/jdbc/tib_jdbc_task_manage/tibJdbcTaskManage.do?method=list"/>"
	);
	
	n3.AppendBeanData("tibJdbcTaskCategoryTreeService&parentId=!{value}","<c:url value="/tib/jdbc/tib_jdbc_task_manage/tibJdbcTaskManage.do?method=list&categoryId=!{value}" />");
	
	<%-- 任务分类 --%>
	n3 = n2.AppendURLChild(
		"<bean:message key="tibJdbcTaskCategory.title" bundle="tib-jdbc" />",
		"<c:url value="/tib/jdbc/tib_jdbc_task_category/tibJdbcTaskCategory_tree.jsp" />"
	);
	
	<%-- 数据集管理 --%>
	n2 = n1.AppendURLChild(
		"<bean:message key="table.tibJdbcDataSet" bundle="tib-jdbc" />",
		"<c:url value="/tib/jdbc/tib_jdbc_data_set/tibJdbcDataSet.do?method=list" />"
	);
	
	
	
	LKSTree.EnableRightMenu();
	LKSTree.Show();
}
<%@ include file="/resource/jsp/tree_down.jsp" %>