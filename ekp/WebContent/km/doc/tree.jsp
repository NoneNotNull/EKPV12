<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/tree_top.jsp" %>
//Com_Parameter.XMLDebug = true;
function generateTree()
{
	LKSTree = new TreeView(
		"LKSTree",
		"<bean:message key="module.km.doc" bundle="km-doc"/>",
		document.getElementById("treeDiv")
	);
	var n1, n2, n3;
	n1 = LKSTree.treeRoot;

	//类别设置
	n2 = n1.AppendURLChild(
		"<bean:message bundle="km-doc" key="menu.kmdoc.categoryconfig"/>",
		"<c:url value="/sys/simplecategory/sys_simple_category/sysCategoryMain_tree.jsp?modelName=com.landray.kmss.km.doc.model.KmDocTemplate&actionUrl=/km/doc/km_doc_template/kmDocTemplate.do&formName=kmDocTemplateForm&mainModelName=com.landray.kmss.km.doc.model.KmDocKnowledge&docFkName=kmDocTemplate" />"
	);

	//流程模板设置
	<kmss:authShow roles="ROLE_KMDOC_COMMONWORKFLOW">
	n2 = n1.AppendURLChild(
		"<bean:message key="tree.workflowTemplate" bundle="km-doc" />",
		"<c:url value="/sys/workflow/sys_wf_common_template/sysWfCommonTemplate.do?method=list&fdModelName=com.landray.kmss.km.doc.model.KmDocTemplate&fdKey=mainDoc" />"
	); 
	</kmss:authShow>
	//文档维护
	n2 = n1.AppendURLChild("<bean:message key="tree.sysCategory.maintains" bundle="sys-category" />")
	n2.authType="01";
	<kmss:authShow roles="ROLE_KMDOC_OPTALL">
	n2.authRole="optAll";
	</kmss:authShow>
	n2.AppendSimpleCategoryDataWithAdmin ("com.landray.kmss.km.doc.model.KmDocTemplate","<c:url value="/km/doc/km_doc_knowledge/kmDocKnowledge.do?method=manageList&categoryId=!{value}&status=all"/>","<c:url value="/km/doc/km_doc_knowledge/kmDocKnowledge.do?method=listChildren&categoryId=!{value}&orderby=docPublishTime&ordertype=down" />");	
	LKSTree.EnableRightMenu();
	LKSTree.Show();
}
<%@ include file="/resource/jsp/tree_down.jsp" %>