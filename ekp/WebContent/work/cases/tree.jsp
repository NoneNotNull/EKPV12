<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="config.tree">
	<template:replace name="content">
//Com_Parameter.XMLDebug = true;
function generateTree()
{
	LKSTree = new TreeView(
		"LKSTree",
		"<bean:message key="module.work.cases" bundle="work-cases"/>",
		document.getElementById("treeDiv")
	);
	var n1, n2, n3, n4, n5;
	n1 = LKSTree.treeRoot;
	
	n2 = n1.AppendURLChild(
		"<bean:message key="table.workCasesCategory" bundle="work-cases" />",
		"<c:url value="/sys/simplecategory/sys_simple_category/sysCategoryMain_tree.jsp?modelName=com.landray.kmss.work.cases.model.WorkCasesCategory&actionUrl=/work/cases/work_cases_category/workCasesCategory.do&formName=workCasesCategoryForm&mainModelName=com.landray.kmss.work.cases.model.WorkCasesMain&docFkName=docCategory" />"
	);
	
	
	<kmss:authShow
		roles="ROLE_SYS_LBPM_TEMPLATE_ADMIN,ROLE_WORKCASES_COMMONWORKFLOW">
		n1.AppendURLChild(
			"<bean:message key="tree.workflowTemplate" bundle="work-cases" />",
			"<c:url value="/sys/lbpmservice/support/lbpm_template/lbpmTemplate.do?method=list&fdModelName=com.landray.kmss.work.cases.model.WorkCasesCategory&fdKey=reviewMainDoc" />"
		);
	</kmss:authShow>

	
	
	LKSTree.EnableRightMenu();
	LKSTree.Show();
}
	</template:replace>
	
</template:include>