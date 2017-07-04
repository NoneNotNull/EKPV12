<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/kms/evaluate/kms_evaluate_personal_filter/kmsEvaluatePersonalFilter.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/kms/evaluate/kms_evaluate_personal_filter/kmsEvaluatePersonalFilter.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/kms/evaluate/kms_evaluate_personal_filter/kmsEvaluatePersonalFilter.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/kms/evaluate/kms_evaluate_personal_filter/kmsEvaluatePersonalFilter.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.kmsEvaluatePersonalFilterForm, 'deleteall');">
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
				<sunbor:column property="kmsEvaluatePersonalFilter.docSubject">
					<bean:message bundle="kms-evaluate" key="kmsEvaluateCommon.docSubject"/>
				</sunbor:column>
				<sunbor:column property="kmsEvaluatePersonalFilter.fdCreator.fdName">
					<bean:message key="model.fdCreator"/>
				</sunbor:column>
				<sunbor:column property="kmsEvaluatePersonalFilter.fdCreateTime">
					<bean:message key="model.fdCreateTime"/>
				</sunbor:column>
				<sunbor:column property="kmsEvaluatePersonalFilter.fdAlterTime">
					<bean:message key="model.fdAlterTime"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="kmsEvaluatePersonalFilter" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/kms/evaluate/kms_evaluate_personal_filter/kmsEvaluatePersonalFilter.do" />?method=view&fdId=${kmsEvaluatePersonalFilter.fdId}">
				<td width="5%">
					<input type="checkbox" name="List_Selected" value="${kmsEvaluatePersonalFilter.fdId}">
				</td>
				<td width="5%">
					${vstatus.index+1}
				</td>
				<td width="35%">
					<c:out value="${kmsEvaluatePersonalFilter.docSubject}" />
				</td>
				<td width="10%">
					<c:out value="${kmsEvaluatePersonalFilter.fdCreator.fdName}" />
				</td>
				<td width="13%">
					<kmss:showDate value="${kmsEvaluatePersonalFilter.fdCreateTime}" />
				</td>
				<td width="13%">
					<kmss:showDate value="${kmsEvaluatePersonalFilter.fdAlterTime}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>