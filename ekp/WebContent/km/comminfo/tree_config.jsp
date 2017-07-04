<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/tree_top.jsp" %>
//Com_Parameter.XMLDebug = true;
function generateTree()
{
	LKSTree = new TreeView("LKSTree", "<bean:message  bundle="km-comminfo" key="table.kmComminfoMain"/>", document.getElementById("treeDiv"));
	var n1, n2;
	n1 = LKSTree.treeRoot;	
	<%-- 类别 --%>	
	n2 = n1.AppendURLChild(
		"<bean:message  bundle="km-comminfo" key="kmComminfoCategory.fdId"/>",
		"<c:url value="/km/comminfo/km_comminfo_category/kmComminfoCategory.do?method=list" />"
	);
	LKSTree.EnableRightMenu();
	LKSTree.Show();
}
<%@ include file="/resource/jsp/tree_down.jsp" %>
