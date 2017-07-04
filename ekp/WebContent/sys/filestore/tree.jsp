<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/tree_top.jsp" %>
//Com_Parameter.XMLDebug = true;
function generateTree()
{
	LKSTree = new TreeView(
		"LKSTree",
		"<bean:message key="module.sys.filestore" bundle="sys-filestore"/>",
		document.getElementById("treeDiv")
	);
	var n1, n2
	n1 = LKSTree.treeRoot;
	
	n2 = n1.AppendURLChild(
		"<bean:message key="filestore.queueList" bundle="sys-filestore" />",
		"<c:url value="/sys/filestore/convertqueue/index.jsp" />"
	);
	
	n2 = n1.AppendURLChild(
		"<bean:message key="filestore.queueConfig" bundle="sys-filestore" />",
		"<c:url value="/sys/filestore/convertconfig/index.jsp" />"
	);
	
	LKSTree.EnableRightMenu();
	LKSTree.Show();
}
<%@ include file="/resource/jsp/tree_down.jsp" %>