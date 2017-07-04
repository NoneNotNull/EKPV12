<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/tree_top.jsp" %>
//Com_Parameter.XMLDebug = true;
function generateTree()
{
	LKSTree = new TreeView(
		"LKSTree",
		"<bean:message key="module.km.collaborate" bundle="km-collaborate"/>",
		document.getElementById("treeDiv")
	);
	var n1, n2, n3, n4, n5;
	n1 = LKSTree.treeRoot;
	
	<%--模块设置 --%>
	n2 = n1.AppendURLChild(
		"<bean:message key="kmCollaborateMain.moduleSetting" bundle="km-collaborate" />");
		<%-- 参数设置 --%>
		<kmss:authShow roles="ROLE_KMCOLLABORATE_PARAMETERP_SETTINGS">
		n3 = n2.AppendURLChild(
			"<bean:message key="table.kmCollaborateConfig" bundle="km-collaborate" />",
			"<c:url value="/km/collaborate/km_collaborate_config/kmCollaborateConfig.do?method=edit" />"
		);
		</kmss:authShow>
		<%-- 分类信息 --%>
		n3 = n2.AppendURLChild(
			"<bean:message key="table.kmCollaborateCategory" bundle="km-collaborate" />",
			"<c:url value="/km/collaborate/km_collaborate_category/kmCollaborateCategory.do?method=list" />"
		);

	
		
	LKSTree.EnableRightMenu();
	LKSTree.Show();
}
<%@ include file="/resource/jsp/tree_down.jsp" %>