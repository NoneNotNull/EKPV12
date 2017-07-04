<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/kms/integral/kms_integral_person_filter/kmsIntegralPersonFilter.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/kms/integral/kms_integral_person_filter/kmsIntegralPersonFilter.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/kms/integral/kms_integral_person_filter/kmsIntegralPersonFilter.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/kms/integral/kms_integral_person_filter/kmsIntegralPersonFilter.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.kmsIntegralPersonFilterForm, 'deleteall');">
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
				<sunbor:column property="kmsIntegralPersonFilter.docSubject">
					<bean:message bundle="kms-integral" key="kmsIntegralCommon.docSubject"/>
				</sunbor:column>
				<sunbor:column property="kmsIntegralPersonFilter.fdCreator.fdName">
					<bean:message key="model.fdCreator"/>
				</sunbor:column>
				<sunbor:column property="kmsIntegralPersonFilter.docCreateTime">
					<bean:message key="model.fdCreateTime"/>
				</sunbor:column>
				<sunbor:column property="kmsIntegralPersonFilter.docAlterTime">
					<bean:message key="model.fdAlterTime"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="kmsIntegralPersonFilter" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/kms/integral/kms_integral_person_filter/kmsIntegralPersonFilter.do" />?method=view&fdId=${kmsIntegralPersonFilter.fdId}">
				<td width="5%">
					<input type="checkbox" name="List_Selected" value="${kmsIntegralPersonFilter.fdId}">
				</td>
				<td width="5%">
					${vstatus.index+1}
				</td>
				<td width="35%">
					<c:out value="${kmsIntegralPersonFilter.docSubject}" />
				</td>
				<td width="10%">
					<c:out value="${kmsIntegralPersonFilter.fdCreator.fdName}" />
				</td>
				<td width="13%">
					<kmss:showDate value="${kmsIntegralPersonFilter.docCreateTime}" />
				</td>
				<td width="13%">
					<kmss:showDate value="${kmsIntegralPersonFilter.docAlterTime}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>