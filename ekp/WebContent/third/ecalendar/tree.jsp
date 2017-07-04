<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/tree_top.jsp" %>
//Com_Parameter.XMLDebug = true;
function generateTree()
{
	LKSTree = new TreeView(
		"LKSTree",
		"<bean:message key="module.third.ecalendar" bundle="third-ecalendar"/>",
		document.getElementById("treeDiv")
	);
	var n1, n2, n3, n4, n5;
	n1 = LKSTree.treeRoot;
	
	<%-- 主文档 --%>
	n2 = n1.AppendURLChild(
		"<bean:message key="table.ecalendarBindDada" bundle="third-ecalendar" />",
		"<c:url value="/third/ecalendar/third_ecalendar_bind_dada/ecalendarBindDada.do?method=list" />"
	);
	
	LKSTree.EnableRightMenu();
	LKSTree.Show();
}
<%@ include file="/resource/jsp/tree_down.jsp" %>