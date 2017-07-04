<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/tree_top.jsp" %>
//Com_Parameter.XMLDebug = true;
function generateTree()
{
	LKSTree = new TreeView(
		"LKSTree",
		"<bean:message bundle="sys-lbpmext-authorize" key="lbpmAuthorize.moduleName"/>",
		document.getElementById("treeDiv")
	);
	var n1, n2, n3, n4, n5;
	n1 = LKSTree.treeRoot;
	//========== 参数配置 ==========
	n2 = n1.AppendURLChild(
		"<bean:message bundle="sys-lbpmext-authorize" key="lbpmAuthorize.tree.part1"/>",
		"<c:url value="/sys/lbpmext/authorize/lbpm_authorize/lbpmAuthorize.do?method=list"/>"
	);
		
	LKSTree.EnableRightMenu();
	LKSTree.Show();
}
<%@ include file="/resource/jsp/tree_down.jsp" %>