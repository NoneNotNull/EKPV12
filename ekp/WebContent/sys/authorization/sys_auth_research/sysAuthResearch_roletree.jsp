<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/tree_top.jsp" %>
//Com_Parameter.XMLDebug = true;
function generateTree()
{
	LKSTree = new TreeView("LKSTree", "<bean:message bundle="sys-authorization" key="sysAuthRole.sysRole"/>", document.getElementById("treeDiv"));
	var n1 = LKSTree.treeRoot;
	n1.AppendBeanData(
		"sysAuthModuleTree&modulePath=!{value}"
	);

	LKSTree.Show();
}
<%@ include file="/resource/jsp/tree_down.jsp" %>