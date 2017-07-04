﻿<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/tree_top.jsp" %>
//Com_Parameter.XMLDebug = true;
function generateTree()
{
	LKSTree = new TreeView(
		"LKSTree",
		"<bean:message key="module.kms.evaluate" bundle="kms-evaluate"/>",
		document.getElementById("treeDiv")
	);
	var n1, n2, n3, n4, n5;
	n1 = LKSTree.treeRoot;
	
	<%-- 知识应用排行--%>
	n2 = n1.AppendURLChild(
		"<bean:message key="table.kmsEvaluateDocRank" bundle="kms-evaluate" />",
		"<c:url value="/kms/evaluate/kms_evaluate_doc_detail/kmsEvaluateDocDetail.do?method=list" />"
	); 
	<%-- 个人知识应用
	n2 = n1.AppendURLChild(
		"<bean:message key="table.kmsEvaluatePersonal" bundle="kms-evaluate" />",
		"<c:url value="/kms/evaluate/kms_evaluate_personal/kmsEvaluatePersonal.do?method=list" />"
	); --%>
	<%-- 文档统计明细
	n2 = n1.AppendURLChild(
		"<bean:message key="table.kmsEvaluateKnowledge" bundle="kms-evaluate" />",
		"<c:url value="/kms/evaluate/kms_evaluate_knowledge/kmsEvaluateKnowledge.do?method=list" />"
	); --%>
	<%-- 个人知识应用--%>
	n2 = n1.AppendURLChild(
		"<bean:message key="table.kmsEvaluatePersonalDetail" bundle="kms-evaluate" />",
		"<c:url value="/kms/evaluate/kms_evaluate_personal_detail/kmsEvaluatePersonalDetail.do?method=list" />"
	);
	<%-- 统计报表--%>
	n2 = n1.AppendURLChild(
		"<bean:message key="table.reportCount" bundle="kms-evaluate" />"
	);
	n3 = n2.AppendURLChild(
		"<bean:message key="table.reportCount.personalKnowledgeCount" bundle="kms-evaluate" />",
		"<c:url value="/kms/evaluate/kms_evaluate_personal_filter/kmsEvaluatePersonalFilter.do?method=list" />"
	);
	n3 = n2.AppendURLChild(
		"<bean:message key="table.kmsEvaluateDeptFilter" bundle="kms-evaluate" />",
		"<c:url value="/kms/evaluate/kms_evaluate_dept_filter/kmsEvaluateDeptFilter.do?method=list" />"
	);
	n3 = n2.AppendURLChild(
		"<bean:message key="table.kmsEvaluateModuleCateFilter" bundle="kms-evaluate" />",
		"<c:url value="/kms/evaluate/kms_evaluate_module_cate_filter/kmsEvaluateModuleCateFilter.do?method=list" />"
	);
	
	<%-- 文档应用统计条件 --%>
	n3 = n2.AppendURLChild(
		"<bean:message key="table.kmsEvaluateDocFilter" bundle="kms-evaluate" />",
		"<c:url value="/kms/evaluate/kms_evaluate_doc_filter/kmsEvaluateDocFilter.do?method=list" />"
	);
	
	<%-- 爱问分类统计条件 --%>
	n3 = n2.AppendURLChild(
		"<bean:message key="table.kmsEvaluateAskCFilter" bundle="kms-evaluate" />",
		"<c:url value="/kms/evaluate/kms_evaluate_ask_c_filter/kmsEvaluateAskCFilter.do?method=list&ordertype=down&orderby=fdCreateTime" />"
	);
	
	<%-- 爱问部门统计条件 --%>
	n3 = n2.AppendURLChild(
		"<bean:message key="table.kmsEvaluateAskDeptFilter" bundle="kms-evaluate" />",
		"<c:url value="/kms/evaluate/kms_evaluate_ask_dept_filter/kmsEvaluateAskDeptFilter.do?method=list" />"
	);
	
	<%-- 知识搜索统计条件 --%>
	n3 = n2.AppendURLChild(
		"<bean:message key="table.kmsEvaluateDocSearchFilter" bundle="kms-evaluate" />",
		"<c:url value="/kms/evaluate/kms_evaluate_doc_search_filter/kmsEvaluateDocSearchFilter.do?method=list" />"
	);
	
	LKSTree.EnableRightMenu();
	LKSTree.Show();
}
<%@ include file="/resource/jsp/tree_down.jsp" %>