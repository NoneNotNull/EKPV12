<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/tree_top.jsp" %>
//Com_Parameter.XMLDebug = true;
function generateTree()
{
	LKSTree = new TreeView(
		"LKSTree",
		"<bean:message key="attachment.mechanism" bundle="sys-attachment"/>",
		document.getElementById("treeDiv")
	);
	var n1, n2;
	n1 = LKSTree.treeRoot;
	
	<%-- 按分类 --%>
	<kmss:auth
		requestURL="/sys/attachment/sys_att_catalog/sysAttCatalog.do?method=list"
		requestMethod="GET">
		n2 = n1.AppendURLChild(
			"<bean:message key="table.sysAttCatalog" bundle="sys-attachment" />",
			"<c:url value="/sys/attachment/sys_att_catalog/sysAttCatalog.do?method=list" />"
		);
	</kmss:auth>
	
	LKSTree.EnableRightMenu();	
	LKSTree.Show();
}
<%@ include file="/resource/jsp/tree_down.jsp" %>
