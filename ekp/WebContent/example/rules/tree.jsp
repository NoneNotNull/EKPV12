<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="config.tree">
	<template:replace name="content">
//Com_Parameter.XMLDebug = true;
function generateTree()
{
	LKSTree = new TreeView(
		"LKSTree",
		"<bean:message key="module.example.rules" bundle="example-rules"/>",
		document.getElementById("treeDiv")
	);
	var n1, n2, n3, n4, n5;
	n1 = LKSTree.treeRoot;
	
	<%-- 分类信息 --%>
	
<%-- 	n2 = n1.AppendURLChild(
		"<bean:message key="table.exampleRulesCategory" bundle="example-rules" />",
		"<c:url value="/example/rules/example_rules_category/exampleRulesCategory.do?method=list" />"
	); --%>
	
	n2 = n1.AppendURLChild(
		"<bean:message key="table.exampleRulesCategory" bundle="example-rules" />",
		"<c:url value="/sys/simplecategory/sys_simple_category/sysCategoryMain_tree.jsp?modelName=com.landray.kmss.example.rules.model.ExampleRulesCategory&actionUrl=/example/rules/example_rules_category/exampleRulesCategory.do&formName=exampleRulesCategoryForm&mainModelName=com.landray.kmss.example.rules.model.ExampleRulesMain&docFkName=docCategory" />"
	);

	
	LKSTree.EnableRightMenu();
	LKSTree.Show();
}
	</template:replace>
</template:include>