<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/tree_top.jsp" %>
//Com_Parameter.XMLDebug = true;
function generateTree()
{
	LKSTree = new TreeView(
		"LKSTree",
		"<bean:message key="sysTask.moduleName" bundle="sys-task"/>",
		document.getElementById("treeDiv")
	);
	var n1, n2, n3, n4, n5,n6,n7,n8,n9;
	n1 = LKSTree.treeRoot;
	 
<kmss:authShow roles="ROLE_SYSTASK_CONFIG">		
	<!-- 模块配置 -->
	n9 = n1.AppendURLChild(
		"<bean:message key="tree.module.set" bundle="sys-task"/>"
	);
	n9.isExpanded = true;
    n4 = n9.AppendURLChild(
		"<bean:message key="tree.task.category.set" bundle="sys-task"/>",
		"<c:url value="/sys/task/sys_task_category/sysTaskCategory.do?method=list"/>"
	);
	 n5 = n9.AppendURLChild(
		"<bean:message key="tree.task.degree.set" bundle="sys-task"/>",
		"<c:url value="/sys/task/sys_task_approve/sysTaskApprove.do?method=list"/>"
	);
</kmss:authShow>
LKSTree.EnableRightMenu();	
 LKSTree.Show();
 }
<%@ include file="/resource/jsp/tree_down.jsp" %>