<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/lfn.tld" prefix="lfn"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/ui.tld" prefix="ui"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/kmss.tld" prefix="kmss"%>
<%@ include file="/kms/knowledge/kms_knowledge_ui/kmsKnowledge_button_js.jsp" %>
<%@ include file="/kms/knowledge/kms_knowledge_ui/kmsKnowledge_common_js.jsp"%>

<kmss:auth requestURL="/kms/knowledge/kms_knowledge_base_doc/kmsKnowledgeBaseDoc.do?method=add" requestMethod="GET">
	<ui:button text="${lfn:message('button.add')}" onclick="addDoc()" order="2"></ui:button>
</kmss:auth>
<%--回收--%>
<kmss:auth requestURL="/kms/knowledge/kms_knowledge_base_doc/kmsKnowledgeBaseDoc.do?method=recycleall&categoryId=${param.categoryId}" 
		   requestMethod="GET">
	<ui:button text="${lfn:message('kms-knowledge:kmsKnowledge.button.recycle')}" 
			   onclick="recycleDoc()"
			   id="recycleall" order="4"></ui:button>
</kmss:auth>
<kmss:auth requestURL="/kms/knowledge/kms_knowledge_base_doc/kmsKnowledgeBaseDoc.do?method=deleteall&categoryId=${param.categoryId}" 
           requestMethod="GET">
	<ui:button text="${lfn:message('kms-knowledge:kmsKnowledge.button.delete')}" 
			   onclick="delDoc()"
			   id="deleteall" order="5"></ui:button>
</kmss:auth>
<kmss:auth
		requestURL="/kms/knowledge/kms_knowledge_base_doc/kmsKnowledgeBaseDoc.do?method=editPropertys&templateId=${param.categoryId}"
		requestMethod="GET">
	<ui:button text="${lfn:message('kms-knowledge:button.changeProperty')}" onclick="editProperty()"></ui:button>
</kmss:auth>

<kmss:auth
		requestURL="/kms/knowledge/kms_knowledge_base_doc/kmsKnowledgeBaseDoc.do?method=setTop&local=index&categoryId=${param.categoryId}"
		requestMethod="GET">
	<ui:button id="setTop" text="${lfn:message('kms-multidoc:kmsMultidoc.setTop')}" onclick="setTopSelection();"></ui:button>
</kmss:auth>
<script>
	//搜索本模块变量
 	var SYS_SEARCH_MODEL_NAME = "com.landray.kmss.kms.wiki.model.KmsWikiMain;com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge";
</script>

