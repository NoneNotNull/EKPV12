<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/tree_top.jsp" %>
<%@page import="com.landray.kmss.web.SysTreeWriter"%>
//Com_Parameter.XMLDebug = true;
function generateTree()
{
	LKSTree = new TreeView(
		"LKSTree",
		"<bean:message key="module.kms.knowledge" bundle="kms-knowledge"/>",
		document.getElementById("treeDiv")
	);
	var nodes = new Array();
	//var n1, n2, n3, n4, n5;
	nodes[0] = LKSTree.treeRoot;
			
	<%-- 文档基本信息
	n2 = n1.AppendURLChild(
		"<bean:message key="table.kmsKnowledgeBaseDoc" bundle="kms-knowledge" />",
		"<c:url value="/kms/knowledge/kms_knowledge_base_doc/kmsKnowledgeBaseDoc.do?method=list" />"
	); --%>
	<%-- 知识分类 --%>
	nodes[1] = nodes[0].AppendURLChild(
		"<bean:message key="menu.kmdoc.categoryconfig" bundle="kms-knowledge" />",
		"<c:url value="/sys/simplecategory/sys_simple_category/sysCategoryMain_tree.jsp?modelName=com.landray.kmss.kms.knowledge.model.KmsKnowledgeCategory&actionUrl=/kms/knowledge/kms_knowledge_category/kmsKnowledgeCategory.do&formName=kmsKnowledgeCategoryForm&mainModelName=com.landray.kmss.kms.knowledge.model.KmsKnowledgeBaseDoc&docFkName=docCategory" />"
	);
		//流程模板设置
	<kmss:authShow roles="ROLE_KMSKNOWLEDGE_COMMONWORKFLOW">
	nodes[0].AppendURLChild(
		"<bean:message key="tree.workflowTemplate" bundle="kms-knowledge" />",
		"<c:url value="/sys/workflow/sys_wf_common_template/sysWfCommonTemplate.do?method=list&fdModelName=com.landray.kmss.kms.knowledge.model.KmsKnowledgeCategory&fdKey=mainDoc" />"
	); 
	</kmss:authShow>
	//推荐精华库流程模板设置
	<kmss:authShow roles="ROLE_KMSKNOWLEDGE_COMMONWORKFLOW">
	nodes[0].AppendURLChild(
		"<bean:message key="tree.introworkflowTemplate" bundle="kms-knowledge" />",
		"<c:url value="/sys/workflow/sys_wf_common_template/sysWfCommonTemplate.do?method=list&fdModelName=com.landray.kmss.kms.knowledge.model.KmsKnowledgeCategory&fdKey=introDoc" />"
	); 
	</kmss:authShow>
	<kmss:authShow roles="ROLE_KMSKNOWLEDGE_EXCEL_IMPORT">
	nodes[0].AppendURLChild(
		"<bean:message key="templateImport.config" bundle="kms-knowledge" />",
		"<c:url value="/sys/transport/sys_transport_import/SysTransportImport.do?method=list&fdModelName=com.landray.kmss.kms.knowledge.model.KmsKnowledgeCategory" />"
	); 
	</kmss:authShow>
	
	nodes[0].AppendURLChild(
		"<bean:message key="kmsCommonDocErrorCorrection.workflowTemplate" bundle="kms-common" />",
		"<c:url value="/sys/workflow/sys_wf_common_template/sysWfCommonTemplate.do?method=list&fdModelName=com.landray.kmss.kms.knowledge.model.KmsKnowledgeCategory&fdKey=knowledgeErrorCorrectionFlow" />"
	);  
	
	
	<%= SysTreeWriter.getTreeNodesJS("knowledge", request) %>

	nodes[2] = nodes[0].AppendURLChild("<bean:message key="kmsKnowledgeBaseDoc.doc.maintain" bundle="kms-knowledge" />");
	nodes[2].authType="01";
	<kmss:authShow roles="ROLE_KMSKNOWLEDGE_CATEGORY_MAINTAINER_EXTENSION">
	nodes[2].authRole="optAll";
	</kmss:authShow>
	nodes[2].AppendSimpleCategoryDataWithAdmin("com.landray.kmss.kms.knowledge.model.KmsKnowledgeCategory",
		"<c:url value="/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=manageList&categoryId=!{value}&orderby=docPublishTime&ordertype=down&status=all" />",
		"<c:url value="/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=listChildren&categoryId=!{value}&orderby=docPublishTime&ordertype=down" />",null,null,null,null,
		"fdTemplateType:1;fdTemplateType:3");
	
	nodes[2] = nodes[0].AppendURLChild("<bean:message key="kmsKnowledgeBaseDoc.wiki.maintain" bundle="kms-knowledge" />");
	nodes[2].authType="01";
	<kmss:authShow roles="ROLE_KMSKNOWLEDGE_CATEGORY_MAINTAINER_EXTENSION">
	nodes[2].authRole="optAll";
	</kmss:authShow>
	nodes[2].AppendSimpleCategoryDataWithAdmin("com.landray.kmss.kms.knowledge.model.KmsKnowledgeCategory",
		"<c:url value="/kms/wiki/kms_wiki_main/kmsWikiMain.do?method=manageList&categoryId=!{value}&orderby=docPublishTime&ordertype=down&status=all" />",
		"<c:url value="/kms/wiki/kms_wiki_main/kmsWikiMain.do?method=listChildren&categoryId=!{value}&orderby=docPublishTime&ordertype=down" />",null,null,null,null,
		"fdTemplateType:2;fdTemplateType:3");
	
	
		//回收站
	nodes[2] = nodes[0].AppendURLChild("<bean:message key="kmsCommon.RecycleBin" bundle="kms-common"/>");
		//回收站按类别
		nodes[3] = nodes[2].AppendURLChild(
			"<bean:message bundle="kms-knowledge" key="kmsKnowledge.qByCategory"/>"
		);
	<%-- 	nodes[3].AppendSimpleCategoryData(
			"com.landray.kmss.kms.knowledge.model.KmsKnowledgeCategory",
			""
	    ); --%>
	    nodes[3].authType="01";
	    <kmss:authShow roles="ROLE_KMSKNOWLEDGE_CATEGORY_MAINTAINER_EXTENSION">
			nodes[3].authRole="optAll";
		</kmss:authShow>
		nodes[3].AppendSimpleCategoryDataWithAdmin ("com.landray.kmss.kms.knowledge.model.KmsKnowledgeCategory",
			"<c:url value="/kms/knowledge/kms_knowledge_base_doc/kmsKnowledgeBaseDoc.do?method=manageList&categoryId=!{value}&orderby=docPublishTime&ordertype=down&status=50&isAllDoc=false" />",
			"<c:url value="/kms/knowledge/kms_knowledge_base_doc/kmsKnowledgeBaseDoc.do?method=listChildren&categoryId=!{value}&orderby=docPublishTime&ordertype=down&status=50&isAllDoc=false" />");
	    
	 
		//回收站所有文档
		nodes[3] = nodes[2].AppendURLChild(
			"<bean:message bundle="kms-knowledge" key="kmsKnowledge.recycleDoc"/>",
			"<c:url value="/kms/knowledge/kms_knowledge_base_doc/kmsKnowledgeBaseDoc.do?method=list&status=50&isAllDoc=false" />"
		);
		<kmss:authShow roles="SYSROLE_ADMIN">
		//回收站日志
		nodes[3] = nodes[2].AppendURLChild(
			"<bean:message bundle="kms-common" key="kmsCommonRecycleLog.log"/>",
			"<c:url value="/kms/common/kms_common_recycle_log/kmsCommonRecycleLog.do?method=list&orderby=fdOperateTime&ordertype=down&fdModelName=com.landray.kmss.kms.wiki.model.KmsWikiMain;com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge;com.landray.kmss.kms.knowledge.model.KmsKnowledgeBaseDoc" />"
		);
		</kmss:authShow>
	LKSTree.EnableRightMenu();
	LKSTree.Show();
}
<%@ include file="/resource/jsp/tree_down.jsp" %>