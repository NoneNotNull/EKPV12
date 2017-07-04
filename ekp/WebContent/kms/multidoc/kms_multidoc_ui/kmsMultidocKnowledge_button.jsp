<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/lfn.tld" prefix="lfn"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/ui.tld" prefix="ui"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/kmss.tld" prefix="kmss"%>
<%@ include file="/kms/knowledge/kms_knowledge_ui/kmsKnowledge_common_js.jsp"%>
<%@ include file="/kms/multidoc/kms_multidoc_ui/kmsMultidocKnowledge_button_js.jsp"%>

<kmss:auth requestURL="/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=add" requestMethod="GET">
	<ui:button text="${lfn:message('button.add')}" onclick="addDoc()" order="2"></ui:button>
</kmss:auth>
<kmss:auth requestURL="/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=deleteall&status=${param.status}&categoryId=${param.categoryId}&nodeType=${param.nodeType}" requestMethod="GET">
	<ui:button text="${lfn:message('kms-knowledge:kmsKnowledge.button.delete')}" 
			   onclick="delDoc()" 
			   id="deleteall"
			   order="5"></ui:button>
</kmss:auth>
<kmss:auth requestURL="/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=recycleall&categoryId=${param.categoryId}" requestMethod="GET">
	<ui:button text="${lfn:message('kms-knowledge:kmsKnowledge.button.recycle')}" 
			   onclick="recycleDoc()" 
			   id="recycleall"
			   order="4"></ui:button>
</kmss:auth>

<kmss:auth
		requestURL="/kms/knowledge/kms_knowledge_base_doc/kmsKnowledgeBaseDoc.do?method=editPropertys&templateId=${param.categoryId}"
		requestMethod="GET">
	<ui:button text="${lfn:message('kms-multidoc:button.chengeProperty')}" onclick="editProperty()"></ui:button>
</kmss:auth>

 
<%--置顶---%>
<kmss:auth
		requestURL="/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=setTop&local=index&categoryId=${param.categoryId}"
		requestMethod="GET">
	<ui:button id="setTop" text="${lfn:message('kms-multidoc:kmsMultidoc.setTop')}" onclick="setTopSelection();"></ui:button>
</kmss:auth>
