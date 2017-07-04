<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/tree_top.jsp"%>
	//Com_Parameter.XMLDebug = true;
function generateTree()
{
	LKSTree = new TreeView(
		"LKSTree",
		"<bean:message bundle="kms-expert" key="kmsExpert.personalInfo"/>",
		document.getElementById("treeDiv")
	);
	var n1;
	n1 = LKSTree.treeRoot;
	<%-- 专家体系 --%>
	n2 = n1.AppendBeanData("kmsExpertTypeTreeService&expertTypeId=!{value}",
		"<c:url value="/kms/expert/kms_expert_info/kmsExpertInfo.do?method=list&fdCategoryId=!{value}&fdCategoryName=!{text}" />"
	);
	LKSTree.EnableRightMenu();
	LKSTree.Show();
}
<%@ include file="/resource/jsp/tree_down.jsp" %>
	