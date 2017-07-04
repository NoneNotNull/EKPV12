<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/kms/evaluate/kms_evaluate_ask_dept_filter/kmsEvaluateAskDeptFilter.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/kms/evaluate/kms_evaluate_ask_dept_filter/kmsEvaluateAskDeptFilter.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/kms/evaluate/kms_evaluate_ask_dept_filter/kmsEvaluateAskDeptFilter.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/kms/evaluate/kms_evaluate_ask_dept_filter/kmsEvaluateAskDeptFilter.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.kmsEvaluateAskDeptFilterForm, 'deleteall');">
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
				<sunbor:column property="kmsEvaluateAskDeptFilter.docSubject">
					<bean:message bundle="kms-evaluate" key="kmsEvaluateCommon.docSubject"/>
				</sunbor:column>
				<sunbor:column property="kmsEvaluateAskDeptFilter.fdCreator.fdName">
					<bean:message key="model.fdCreator"/>
				</sunbor:column>
				<sunbor:column property="kmsEvaluateAskDeptFilter.fdCreateTime">
					<bean:message key="model.fdCreateTime"/>
				</sunbor:column>
				<sunbor:column property="kmsEvaluateAskDeptFilter.fdAlterTime">
					<bean:message key="model.fdAlterTime"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="kmsEvaluateAskDeptFilter" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/kms/evaluate/kms_evaluate_ask_dept_filter/kmsEvaluateAskDeptFilter.do" />?method=view&fdId=${kmsEvaluateAskDeptFilter.fdId}">
				<td width="5%">
					<input type="checkbox" name="List_Selected" value="${kmsEvaluateAskDeptFilter.fdId}">
				</td>
				<td width="5%">
					${vstatus.index+1}
				</td>
				<td width="35%">
					<c:out value="${kmsEvaluateAskDeptFilter.docSubject}" />
				</td> 
				<td width="10%">
					<c:out value="${kmsEvaluateAskDeptFilter.fdCreator.fdName}" />
				</td>
				<td width="13%">
					<kmss:showDate value="${kmsEvaluateAskDeptFilter.fdCreateTime}" />
				</td>
				<td width="13%">
					<kmss:showDate value="${kmsEvaluateAskDeptFilter.fdAlterTime}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>