<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/kms/wiki/kms_wiki_evaluation/kmsWikiEvaluation.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/kms/wiki/kms_wiki_evaluation/kmsWikiEvaluation.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/kms/wiki/kms_wiki_evaluation/kmsWikiEvaluation.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/kms/wiki/kms_wiki_evaluation/kmsWikiEvaluation.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.kmsWikiEvaluationForm, 'deleteall');">
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
				<sunbor:column property="kmsWikiEvaluation.fdEvaluationTime">
					<bean:message bundle="kms-wiki" key="kmsWikiEvaluation.fdEvaluationTime"/>
				</sunbor:column>
				<sunbor:column property="kmsWikiEvaluation.fdEvaluationContent">
					<bean:message bundle="kms-wiki" key="kmsWikiEvaluation.fdEvaluationContent"/>
				</sunbor:column>
				<sunbor:column property="kmsWikiEvaluation.fdModelId">
					<bean:message bundle="kms-wiki" key="kmsWikiEvaluation.fdModelId"/>
				</sunbor:column>
				<sunbor:column property="kmsWikiEvaluation.fdFirstModelId">
					<bean:message bundle="kms-wiki" key="kmsWikiEvaluation.fdFirstModelId"/>
				</sunbor:column>
				<sunbor:column property="kmsWikiEvaluation.fdModelName">
					<bean:message bundle="kms-wiki" key="kmsWikiEvaluation.fdModelName"/>
				</sunbor:column>
				<sunbor:column property="kmsWikiEvaluation.fdEvaluator.fdName">
					<bean:message bundle="kms-wiki" key="kmsWikiEvaluation.fdEvaluator"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="kmsWikiEvaluation" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/kms/wiki/kms_wiki_evaluation/kmsWikiEvaluation.do" />?method=view&fdId=${kmsWikiEvaluation.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${kmsWikiEvaluation.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<kmss:showDate value="${kmsWikiEvaluation.fdEvaluationTime}" />
				</td>
				<td>
					<c:out value="${kmsWikiEvaluation.fdEvaluationContent}" />
				</td>
				<td>
					<c:out value="${kmsWikiEvaluation.fdModelId}" />
				</td>
				<td>
					<c:out value="${kmsWikiEvaluation.fdFirstModelId}" />
				</td>
				<td>
					<c:out value="${kmsWikiEvaluation.fdModelName}" />
				</td>
				<td>
					<c:out value="${kmsWikiEvaluation.fdEvaluator.fdName}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>