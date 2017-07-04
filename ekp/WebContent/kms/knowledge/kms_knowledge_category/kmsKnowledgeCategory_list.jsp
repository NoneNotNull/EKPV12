<%@ page
	language="java"
	contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<c:import
	url="/sys/right/tmp_right_batch_change_button.jsp"
	charEncoding="UTF-8">
	<c:param
		name="modelName"
		value="com.landray.kmss.kms.knowledge.model.KmsKnowledgeCategory" />
</c:import>
<html:form action="/kms/knowledge/kms_knowledge_category/kmsKnowledgeCategory.do">
	<div id="optBarDiv"><kmss:auth
		requestURL="/kms/knowledge/kms_knowledge_category/kmsKnowledgeCategory.do?method=add"
		requestMethod="GET">
		<input
			type="button"
			value="<bean:message key="button.add"/>"
			onclick="Com_OpenWindow('<c:url value="/kms/knowledge/kms_knowledge_category/kmsKnowledgeCategory.do?method=add&modelName=com.landray.kmss.kms.knowledge.model.KmsKnowledgeCategory&parentId=${param.parentId}" />');">
	</kmss:auth> <kmss:auth
		requestURL="/kms/multidoc/kms_multidoc_template/kmsKnowledgeCategory.do?method=deleteall&parentId=${param.parentId}"
		requestMethod="GET">
		<input
			type="button"
			value="<bean:message key="button.delete"/>"
			onclick="if(!List_ConfirmDel())return;Com_Submit(document.kmsMultidocTemplateForm, 'deleteall');">
	</kmss:auth></div>
	<%
	if (((Page) request.getAttribute("queryPage")).getTotalrows() == 0) {
	%>
	<%@ include file="/resource/jsp/list_norecord.jsp"%>
	<%
	} else {
	%>
	<%@ include file="/resource/jsp/list_pagenav_top.jsp"%>
	<table id="List_ViewTable">
		<tr>
			<sunbor:columnHead htmlTag="td">
				<td width="10pt"><input
					type="checkbox"
					name="List_Tongle"></td>
				<td width="40pt"><bean:message key="page.serial" /></td>
				<sunbor:column property="kmsKnowledgeCategory.fdName">
					<bean:message
						bundle="kms-knowledge"
						key="kmsKnowledgeCategory.fdName" />
				</sunbor:column>
				<sunbor:column property="kmsKnowledgeCategory.docCategory.fdName">
					<bean:message
						bundle="kms-knowledge"
						key="kmsKnowledgeCategory.docCategoryName" />
				</sunbor:column>
				<sunbor:column property="kmsKnowledgeCategory.fdOrder">
					<bean:message
						bundle="kms-knowledge"
						key="kmsKnowledgeCategory.fdOrder" />
				</sunbor:column>
				<sunbor:column property="kmsKnowledgeCategory.docCreator.fdName">
					<bean:message
						bundle="kms-knowledge"
						key="kmsKnowledgeCategory.docCreatorName" />
				</sunbor:column>
				<sunbor:column property="kmsKnowledgeCategory.docCreateTime">
					<bean:message
						bundle="kms-knowledge"
						key="kmsKnowledgeCategory.docCreateTime" />
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach
			items="${queryPage.list}"
			var="kmsKnowledgeCategory"
			varStatus="vstatus">
			<tr kmss_href="<c:url value="/kms/knowledge/kms_knowledge_category/kmsKnowledgeCategory.do" />?method=view&fdId=${kmsKnowledgeCategory.fdId}">
				<td><input
					type="checkbox"
					name="List_Selected"
					value="${kmsKnowledgeCategory.fdId}"></td>
				<td>${vstatus.index+1}</td>
				<td><c:out value="${kmsKnowledgeCategory.fdName}" /></td>
				<td><c:out value="${kmsKnowledgeCategory.docCategory.fdName}" /></td>
				<td><c:out value="${kmsKnowledgeCategory.fdOrder}" /></td>
				<td><c:out value="${kmsKnowledgeCategory.docCreator.fdName}" /></td>
				<td><kmss:showDate
					value="${kmsKnowledgeCategory.docCreateTime}"
					type="datetime" /></td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp"%>
	<%
	}
	%>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>
