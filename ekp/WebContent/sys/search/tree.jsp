<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/tree_top.jsp" %>
//Com_Parameter.XMLDebug = true;
function generateTree()
{
	LKSTree = new TreeView(
		"LKSTree",
		"<bean:message bundle="sys-search" key="table.sysSearchMain"/>",
		document.getElementById("treeDiv")
	);
	var n1;
	n1 = LKSTree.treeRoot;
	var modelName = Com_GetUrlParameter(location.href, "fdModelName");
	var url = "<c:url value="/sys/search/search.do?method=condition" />&searchId=!{value}&fdModelName="+modelName;
	n1.AppendBeanData("sysSearchConfigTree&fdModelName="+modelName, url, null, false);
	LKSTree.EnableRightMenu();
	LKSTree.Show();
}
<%@ include file="/resource/jsp/tree_down.jsp" %>