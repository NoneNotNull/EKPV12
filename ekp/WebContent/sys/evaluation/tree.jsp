<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/tree_top.jsp" %>
//Com_Parameter.XMLDebug = true;
function generateTree()
{
	LKSTree = new TreeView(
		"LKSTree",
		"<bean:message key="sysEvaluationMain.manager" bundle="sys-evaluation"/>",
		document.getElementById("treeDiv")
	);
	var n1, n2, n3;
	n1 = LKSTree.treeRoot;
	
	<%-- 点评总览 --%>
	n2 = n1.AppendURLChild(
		"<bean:message key="sysEvaluationMain.overView" bundle="sys-evaluation" />",
		"<c:url value="/sys/evaluation/import/sysEvaluationMain_over_view.jsp" />"
	);
	
	//段落点评 
	n3 = n1.AppendURLChild(
		"<bean:message bundle="sys-evaluation" key="table.sysEvaluationNotes"/>",
		"<c:url value="/sys/evaluation/sys_evaluation_notes/sysEvaluationNotesConfig.do?method=edit" />"); 
	
	LKSTree.EnableRightMenu();
	LKSTree.Show();
}
<%@ include file="/resource/jsp/tree_down.jsp" %>