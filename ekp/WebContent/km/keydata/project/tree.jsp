<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/tree_top.jsp" %>
//Com_Parameter.XMLDebug = true;
function generateTree()
{
	LKSTree = new TreeView(
		"LKSTree",
		"<bean:message key="module.km.keydata.project" bundle="km-keydata-project"/>",
		document.getElementById("treeDiv")
	);
	var n1, n2, n3, n4, n5;
	n1 = LKSTree.treeRoot;
	
	<%-- 项目 --%>
	n2 = n1.AppendURLChild(
		"<bean:message key="table.kmProjectMain" bundle="km-keydata-project" />",
		"<c:url value="/km/keydata/project/km_project_main/kmProjectMain.do?method=list" />"
	);
	
	LKSTree.EnableRightMenu();
	LKSTree.Show();
}
<%@ include file="/resource/jsp/tree_down.jsp" %>