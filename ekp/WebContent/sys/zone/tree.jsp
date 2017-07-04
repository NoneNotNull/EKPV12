<%@page import="java.util.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/tree_top.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
//Com_Parameter.XMLDebug = true;
function generateTree()
{
	LKSTree = new TreeView(
		"LKSTree",
		"${lfn:escapeJs(lfn:message('sys-zone:module.name')) }",
		document.getElementById("treeDiv")
	);
	var n1, n2, n3, n4, n5;
	n1 = LKSTree.treeRoot;
	
	n2 = n1.AppendURLChild(
		"${lfn:escapeJs(lfn:message('sys-zone:path.nav.setting')) }",
		"<c:url value="/sys/zone/sys_zone_navigation/sysZoneNavigation.do?method=list" />"
	);
	LKSTree.ExpandNode(n2);
	n2 = n1.AppendURLChild(
		"${lfn:escapeJs(lfn:message('sys-zone:path.page.setting')) }",
		"<c:url value="/sys/zone/sys_zone_page_template/sysZonePageTemplate.do?method=edit" />"
	);
	
	n2 = n1.AppendURLChild(
		"${lfn:escapeJs(lfn:message('sys-zone:table.sysZonePerDataTempl')) }",
		"<c:url value="/sys/zone/sys_zone_person_data_cate/sysZonePersonDataCate.do?method=list" />"
	);
	LKSTree.ExpandNode(n2);
	LKSTree.EnableRightMenu();
	LKSTree.Show();
}
<%@ include file="/resource/jsp/tree_down.jsp" %>