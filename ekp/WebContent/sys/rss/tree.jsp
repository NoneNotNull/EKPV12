<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/tree_top.jsp" %>
//Com_Parameter.XMLDebug = true;
function generateTree()
{
	LKSTree = new TreeView(
		"LKSTree",
		"<bean:message key="menu.sysRssMain" bundle="sys-rss"/>",
		document.getElementById("treeDiv")
	);
	var n1, n2;
	n1 = LKSTree.treeRoot;
	//====分类设置===
	<kmss:authShow roles="ROLE_SYSRSS_CATEGORY;">
	n1.AppendURLChild(
		"<bean:message key="menu.rss.cateory" bundle="sys-rss" />",
		"<c:url value="/sys/rss/sys_rss_category/sysRssCategory_tree_edit.jsp" />"
	);
	</kmss:authShow>
	//====频道设置===
	n2 = n1.AppendURLChild(
		"<bean:message key="menu.rss.channel" bundle="sys-rss" />",
		"<c:url value="/sys/rss/sys_rss_main/sysRssMain.do?method=list" />"
	);
	n2.AppendBeanData("sysRssCategoryTreeService&href=true&selectdId=!{value}");
	
	LKSTree.EnableRightMenu();	
	LKSTree.Show();
}
<%@ include file="/resource/jsp/tree_down.jsp" %>
