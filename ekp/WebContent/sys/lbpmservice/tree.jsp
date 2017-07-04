<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="com.landray.kmss.sys.lbpmservice.util.TreeBuilder"%>
<%@ include file="/resource/jsp/tree_top.jsp" %>
//Com_Parameter.XMLDebug = true;
function generateTree()
{
	LKSTree = new TreeView(
		"LKSTree",
		"<bean:message bundle="sys-lbpmservice" key="module.sys.lbpmservice"/>",
		document.getElementById("treeDiv")
	);
	var root, node, nodes = [];
	root = LKSTree.treeRoot;
	nodes[0] = root;
	<%= TreeBuilder.getTreeNodesJS(request)%>
	node = root.firstChild;
	do {
		node.isExpanded = true;
		node = node.nextSibling;
	} while(node != null)
	
	LKSTree.EnableRightMenu();
	LKSTree.Show();
}
<%@ include file="/resource/jsp/tree_down.jsp" %>