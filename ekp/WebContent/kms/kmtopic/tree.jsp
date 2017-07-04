<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/tree_top.jsp" %>
//Com_Parameter.XMLDebug = true;
function generateTree()
{
	LKSTree = new TreeView(
		"LKSTree",
		"<bean:message key="module.kms.kmtopic" bundle="kms-kmtopic"/>",
		document.getElementById("treeDiv")
	);
	var nodes = new Array();
	//var n1, n2, n3, n4, n5;
	nodes[0] = LKSTree.treeRoot;
	
	<%-- 知识专辑分类 --%>
	nodes[1] = nodes[0].AppendURLChild(
		"<bean:message key="menu.kmtopic.categoryconfig" bundle="kms-kmtopic" />",
		"<c:url value="/sys/simplecategory/sys_simple_category/sysCategoryMain_tree.jsp?modelName=com.landray.kmss.kms.kmtopic.model.KmsKmtopicCategory&actionUrl=/kms/kmtopic/kms_kmtopic_category/kmsKmtopicCategory.do&formName=kmsKmtopicCategoryForm&mainModelName=com.landray.kmss.kms.kmtopic.model.KmsKmtopicMain&docFkName=docCategory" />"
	);
	//流程模板设置
	<kmss:authShow roles="ROLE_KMSKMTOPIC_COMMONWORKFLOW">
		nodes[0].AppendURLChild(
			"<bean:message key="tree.workflowTemplate" bundle="kms-kmtopic" />",
			"<c:url value="/sys/workflow/sys_wf_common_template/sysWfCommonTemplate.do?method=list&fdModelName=com.landray.kmss.kms.kmtopic.model.KmsKmtopicCategory&fdKey=kmtopic" />"
		); 
	</kmss:authShow>
	//推荐精华库流程模板设置
	<kmss:authShow roles="ROLE_KMSKMTOPIC_COMMONWORKFLOW">
	nodes[0].AppendURLChild(
		"<bean:message key="tree.introworkflowTemplate" bundle="kms-kmtopic" />",
		"<c:url value="/sys/workflow/sys_wf_common_template/sysWfCommonTemplate.do?method=list&fdModelName=com.landray.kmss.kms.kmtopic.model.KmsKmtopicCategory&fdKey=introDoc" />"
	); 
	</kmss:authShow>
	
	nodes[1] = nodes[0].AppendURLChild("<bean:message bundle="kms-kmtopic" key="kmsKmtopicMain.maintain"/>");
	nodes[1].authType="01";
	<kmss:authShow roles="ROLE_KMSKMTOPIC_CATEGORY_MAINTAINER_EXTENSION">
	nodes[1].authRole="optAll";
	</kmss:authShow>
	nodes[1].AppendSimpleCategoryDataWithAdmin("com.landray.kmss.kms.kmtopic.model.KmsKmtopicCategory",
		"<c:url value="/kms/kmtopic/kms_kmtopic_main/kmsKmtopicMain.do?method=manageList&categoryId=!{value}&status=all" />",
		"<c:url value="/kms/kmtopic/kms_kmtopic_main/kmsKmtopicMain.do?method=listChildren&categoryId=!{value}&orderby=docPublishTime&ordertype=down" />");
	
	LKSTree.EnableRightMenu();
	LKSTree.Show();
}
<%@ include file="/resource/jsp/tree_down.jsp" %>