<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/kms/evaluate/kms_evaluate_doc_search_filter/kmsEvaluateDocSearchFilter.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/kms/evaluate/kms_evaluate_doc_search_filter/kmsEvaluateDocSearchFilter.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/kms/evaluate/kms_evaluate_doc_search_filter/kmsEvaluateDocSearchFilter.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/kms/evaluate/kms_evaluate_doc_search_filter/kmsEvaluateDocSearchFilter.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.kmsEvaluateDocSearchFilterForm, 'deleteall');">
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
				<sunbor:column property="kmsEvaluateDocSearchFilter.docSubject">
					<bean:message bundle="kms-evaluate" key="kmsEvaluateCommon.docSubject"/>
				</sunbor:column>
				<sunbor:column property="kmsEvaluateDocSearchFilter.fdCreator">
					<bean:message key="model.fdCreator"/>
				</sunbor:column>
				<sunbor:column property="kmsEvaluateDocSearchFilter.fdCreateTime">
					<bean:message key="model.fdCreateTime"/>
				</sunbor:column>
				<sunbor:column property="kmsEvaluateDocSearchFilter.fdAlterTime">
					<bean:message key="model.fdAlterTime"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="kmsEvaluateDocSearchFilter" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/kms/evaluate/kms_evaluate_doc_search_filter/kmsEvaluateDocSearchFilter.do" />?method=view&fdId=${kmsEvaluateDocSearchFilter.fdId}">
				<td width="5%">
					<input type="checkbox" name="List_Selected" value="${kmsEvaluateDocSearchFilter.fdId}">
				</td>
				<td width="5%">
					${vstatus.index+1}
				</td>
				<td  width="35%">
					<c:out value="${kmsEvaluateDocSearchFilter.docSubject}" />
				</td>
				<td width="10%">
					<c:out value="${kmsEvaluateDocSearchFilter.fdCreator.fdName}" /> 
				</td>
				<td width="15%">
					<kmss:showDate value="${kmsEvaluateDocSearchFilter.fdCreateTime}" />
				</td>
				<td width="15%">
					<kmss:showDate value="${kmsEvaluateDocSearchFilter.fdAlterTime}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>