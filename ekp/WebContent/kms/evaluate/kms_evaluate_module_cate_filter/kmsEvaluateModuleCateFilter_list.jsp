<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/kms/evaluate/kms_evaluate_module_cate_filter/kmsEvaluateModuleCateFilter.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/kms/evaluate/kms_evaluate_module_cate_filter/kmsEvaluateModuleCateFilter.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/kms/evaluate/kms_evaluate_module_cate_filter/kmsEvaluateModuleCateFilter.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/kms/evaluate/kms_evaluate_module_cate_filter/kmsEvaluateModuleCateFilter.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.kmsEvaluateModuleCateFilterForm, 'deleteall');">
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
				<td>
					<input type="checkbox" name="List_Tongle">
				</td>
				<td>
					<bean:message key="page.serial"/>
				</td>
				<sunbor:column property="kmsEvaluateModuleCateFilter.docSubject"> 
					<bean:message bundle="kms-evaluate" key="kmsEvaluateCommon.docSubject"/>
				</sunbor:column>
				<sunbor:column property="kmsEvaluateModuleCateFilter.fdCreator.fdName">
					<bean:message key="model.fdCreator"/>
				</sunbor:column>
				<sunbor:column property="kmsEvaluateModuleCateFilter.fdCreateTime">
					<bean:message key="model.fdCreateTime"/>
				</sunbor:column>
				<sunbor:column property="kmsEvaluateModuleCateFilter.fdAlterTime">
					<bean:message key="model.fdAlterTime"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="kmsEvaluateModuleCateFilter" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/kms/evaluate/kms_evaluate_module_cate_filter/kmsEvaluateModuleCateFilter.do" />?method=view&fdId=${kmsEvaluateModuleCateFilter.fdId}">
				<td width="5%">
					<input type="checkbox" name="List_Selected" value="${kmsEvaluateModuleCateFilter.fdId}">
				</td>
				<td width="5%">
					${vstatus.index+1}
				</td>
				<td width="35%">
					<c:out value="${kmsEvaluateModuleCateFilter.docSubject}" />
				</td>
				<td width="10%">
					<c:out value="${kmsEvaluateModuleCateFilter.fdCreator.fdName}" />
				</td>
				<td width="13%">
					<kmss:showDate value="${kmsEvaluateModuleCateFilter.fdCreateTime}" />
				</td>
				<td width="13%">
					<kmss:showDate value="${kmsEvaluateModuleCateFilter.fdAlterTime}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>