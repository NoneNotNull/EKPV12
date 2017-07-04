<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/tree_top.jsp" %>
//Com_Parameter.XMLDebug = true;
function generateTree()
{
	LKSTree = new TreeView(
		"LKSTree",
		"<bean:message key="componentLocker.moduleName" bundle="component-locker"/>",
		document.getElementById("treeDiv")
	);
	var n1, n2, n3, n4, n5;
	n1 = LKSTree.treeRoot;
	
	n2 = n1.AppendURLChild(
		"<bean:message key="tree.componentLockerMain.all" bundle="component-locker" />",
		"<c:url value="/component/locker/component_locker_main/componentLockerMain.do?method=listAllLockers" />"
	);
	n2 = n1.AppendURLChild(
		"<bean:message key="tree.componentLockerMain.timeout" bundle="component-locker" />",
		"<c:url value="/component/locker/component_locker_main/componentLockerMain.do?method=listTimeoutLockers" />"
	);
	
	LKSTree.EnableRightMenu();
	LKSTree.Show();
}
<%@ include file="/resource/jsp/tree_down.jsp" %>