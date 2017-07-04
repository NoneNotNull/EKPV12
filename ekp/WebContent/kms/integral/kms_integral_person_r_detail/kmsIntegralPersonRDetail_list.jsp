<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/kms/integral/kms_integral_person_r_detail/kmsIntegralPersonRDetail.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/kms/integral/kms_integral_person_r_detail/kmsIntegralPersonRDetail.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/kms/integral/kms_integral_person_r_detail/kmsIntegralPersonRDetail.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/kms/integral/kms_integral_person_r_detail/kmsIntegralPersonRDetail.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.kmsIntegralPersonRDetailForm, 'deleteall');">
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
				<sunbor:column property="kmsIntegralPersonRDetail.fdScoreValue">
					<bean:message bundle="kms-integral" key="kmsIntegralPersonRDetail.fdScoreValue"/>
				</sunbor:column>
				<sunbor:column property="kmsIntegralPersonRDetail.fdRichesValue">
					<bean:message bundle="kms-integral" key="kmsIntegralPersonRDetail.fdRichesValue"/>
				</sunbor:column>
				<sunbor:column property="kmsIntegralPersonRDetail.fdBalanceValue">
					<bean:message bundle="kms-integral" key="kmsIntegralPersonRDetail.fdBalanceValue"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="kmsIntegralPersonRDetail" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/kms/integral/kms_integral_person_r_detail/kmsIntegralPersonRDetail.do" />?method=view&fdId=${kmsIntegralPersonRDetail.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${kmsIntegralPersonRDetail.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${kmsIntegralPersonRDetail.fdScoreValue}" />
				</td>
				<td>
					<c:out value="${kmsIntegralPersonRDetail.fdRichesValue}" />
				</td>
				<td>
					<c:out value="${kmsIntegralPersonRDetail.fdBalanceValue}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>