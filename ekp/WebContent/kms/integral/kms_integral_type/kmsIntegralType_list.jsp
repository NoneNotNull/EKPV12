<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/kms/integral/kms_integral_type/kmsIntegralType.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/kms/integral/kms_integral_type/kmsIntegralType.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/kms/integral/kms_integral_type/kmsIntegralType.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/kms/integral/kms_integral_type/kmsIntegralType.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.kmsIntegralTypeForm, 'deleteall');">
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
				<sunbor:column property="kmsIntegralType.fdName">
					<bean:message bundle="kms-integral" key="kmsIntegralType.fdName"/>
				</sunbor:column>
				<sunbor:column property="kmsIntegralType.fdOrder">
					<bean:message bundle="kms-integral" key="kmsIntegralType.fdOrder"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="kmsIntegralType" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/kms/integral/kms_integral_type/kmsIntegralType.do" />?method=view&fdId=${kmsIntegralType.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${kmsIntegralType.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${kmsIntegralType.fdName}" />
				</td>
				<td>
					<c:out value="${kmsIntegralType.fdOrder}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>