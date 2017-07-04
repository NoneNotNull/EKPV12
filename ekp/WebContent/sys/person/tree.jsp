<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/tree_top.jsp" %>
//Com_Parameter.XMLDebug = true;
function generateTree()
{
	LKSTree = new TreeView(
		"LKSTree",
		"${lfn:escapeJs(lfn:message('sys-person:person.setting')) }",
		document.getElementById("treeDiv")
	);
	var n1, n2, n3, n4, n5;
	n1 = LKSTree.treeRoot;
	
	//设置
	<kmss:auth requestURL="/sys/person/sys_person_cfg_link/sysPersonCfgLink.do?method=edit">
	n2 = n1.AppendURLChild(
		"${lfn:escapeJs(lfn:message('sys-person:person.setting.nav')) }",
		"<c:url value="/sys/person/sys_person_cfg_link/sysPersonCfgLink.do?method=edit" />"
	);
	n2.isExpanded = true;
	</kmss:auth>
	
	LKSTree.EnableRightMenu();
	LKSTree.Show();
}
<%@ include file="/resource/jsp/tree_down.jsp" %>