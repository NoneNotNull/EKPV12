<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/kms/knowledge/kms_knowledge_wiki_template/kmsKnowledgeWikiTemplate.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/kms/knowledge/kms_knowledge_wiki_template/kmsKnowledgeWikiTemplate.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/kms/knowledge/kms_knowledge_wiki_template/kmsKnowledgeWikiTemplate.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/kms/knowledge/kms_knowledge_wiki_template/kmsKnowledgeWikiTemplate.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.kmsKnowledgeWikiTemplateForm, 'deleteall');">
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
				<sunbor:column property="kmsKnowledgeWikiTemplate.fdName">
					<bean:message bundle="kms-knowledge" key="kmsKnowledgeWikiTemplate.fdName"/>
				</sunbor:column>
				<sunbor:column property="kmsKnowledgeWikiTemplate.fdOrder">
					<bean:message bundle="kms-knowledge" key="kmsKnowledgeWikiTemplate.fdOrder"/>
				</sunbor:column>
				<sunbor:column property="kmsKnowledgeWikiTemplate.docCreator.fdName">
					<bean:message bundle="kms-knowledge" key="kmsKnowledgeWikiTemplate.docCreator"/>
				</sunbor:column>
				<sunbor:column property="kmsKnowledgeWikiTemplate.docCreateTime">
					<bean:message bundle="kms-knowledge" key="kmsKnowledgeWikiTemplate.docCreateTime"/>
				</sunbor:column>
				<sunbor:column property="kmsKnowledgeWikiTemplate.docAlteror.fdName">
					<bean:message bundle="kms-knowledge" key="kmsKnowledgeWikiTemplate.docAlteror"/>
				</sunbor:column>
				<sunbor:column property="kmsKnowledgeWikiTemplate.docAlterTime">
					<bean:message bundle="kms-knowledge" key="kmsKnowledgeWikiTemplate.docAlterTime"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="kmsWikiTemplate" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/kms/knowledge/kms_knowledge_wiki_template/kmsKnowledgeWikiTemplate.do" />?method=view&fdId=${kmsWikiTemplate.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${kmsWikiTemplate.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${kmsWikiTemplate.fdName}" />
				</td>
				<td>
					<c:out value="${kmsWikiTemplate.fdOrder}" />
				</td>
				<td>
					<c:out value="${kmsWikiTemplate.docCreator.fdName}" />
				</td>
				<td>
					<kmss:showDate value="${kmsWikiTemplate.docCreateTime}" />
				</td>
				<td>
					<c:out value="${kmsWikiTemplate.docAlteror.fdName}" />
				</td>
				<td>
					<kmss:showDate value="${kmsWikiTemplate.docAlterTime}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>