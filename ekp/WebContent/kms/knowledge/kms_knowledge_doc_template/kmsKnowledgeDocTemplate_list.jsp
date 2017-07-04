<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/kms/knowledge/kms_knowledge_doc_template/kmsKnowledgeDocTemplate.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/kms/knowledge/kms_knowledge_doc_template/kmsKnowledgeDocTemplate.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/kms/knowledge/kms_knowledge_doc_template/kmsKnowledgeDocTemplate.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/kms/knowledge/kms_knowledge_doc_template/kmsKnowledgeDocTemplate.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.kmsKnowledgeDocTemplateForm, 'deleteall');">
		</kmss:auth>
	</div>
<c:if test="${queryPage.totalrows==0}">
	<%@ include file="/resource/jsp/list_norecord.jsp"%>
</c:if>
<c:if test="${queryPage.totalrows>0}">
	<%@ include file="/resource/jsp/list_pagenav_top.jsp"%>
	<table id="List_ViewTable">
		<tr>
			<sunbor:columnHead htmlTag="td">
				<td width="10pt">
					<input type="checkbox" name="List_Tongle">
				</td>
				<td width="40pt">
					<bean:message key="page.serial"/>
				</td>
				<sunbor:column property="kmsKnowledgeDocTemplate.fdName">
					<bean:message bundle="kms-knowledge" key="kmsKnowledgeDocTemplate.fdName"/>
				</sunbor:column>
				<sunbor:column property="kmsKnowledgeDocTemplate.docCreateTime">
					<bean:message bundle="kms-knowledge" key="kmsKnowledgeDocTemplate.docCreateTime"/>
				</sunbor:column>
				<sunbor:column property="kmsKnowledgeDocTemplate.docCreator.fdName">
					<bean:message bundle="kms-knowledge" key="kmsKnowledgeDocTemplate.docCreator"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="kmsKnowledgeDocTemplate" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/kms/knowledge/kms_knowledge_doc_template/kmsKnowledgeDocTemplate.do" />?method=view&fdId=${kmsKnowledgeDocTemplate.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${kmsKnowledgeDocTemplate.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${kmsKnowledgeDocTemplate.fdName}" />
				</td>
				<td>
					<kmss:showDate value="${kmsKnowledgeDocTemplate.docCreateTime}" />
				</td>
				<td>
					<c:out value="${kmsKnowledgeDocTemplate.docCreator.fdName}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>