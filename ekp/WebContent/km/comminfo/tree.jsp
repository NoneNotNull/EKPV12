<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/tree_top.jsp" %>
//Com_Parameter.XMLDebug = true;
function generateTree()
{
	LKSTree = new TreeView("LKSTree", "<bean:message  bundle="km-comminfo" key="table.kmComminfoMain"/>", document.getElementById("treeDiv"));
	var n1, n2, n3, n4, n5, n6, n7, n8, n9, n10;
	n1 = LKSTree.treeRoot;	
	
	<%-- 所有文档 --%>	
	n2 = n1.AppendURLChild(
		"<bean:message  bundle="km-comminfo" key="kmComminfo.allFiles"/>",
		"<c:url value="/km/comminfo/km_comminfo_main/kmComminfoMain.do?method=list&orderby=fdOrder asc,docCreateTime desc"/>"
	);
	n2.isExpanded=true;
	<%-- 所有的类别的集合 --%>
	n3=n2.AppendBeanData(
		 "kmCategoryTreeService&parentId=!{value}",
		 "<c:url value="/km/comminfo/km_comminfo_main/kmComminfoMain.do?method=list&docCategoryId=!{value}&orderby=fdOrder asc,docCreateTime desc" />"
	);
	<%-- 类别 --%>	
	n2 = n1.AppendURLChild(
		"<bean:message  bundle="km-comminfo" key="kmComminfoCategory.fdId"/>",
		"<c:url value="/km/comminfo/km_comminfo_category/kmComminfoCategory.do?method=list" />"
	);
	LKSTree.EnableRightMenu();
	LKSTree.Show();
}
<%@ include file="/resource/jsp/tree_down.jsp" %>
