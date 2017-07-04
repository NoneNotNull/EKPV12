<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/kms/integral/kms_integral_person_role/kmsIntegralPersonRole.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/kms/integral/kms_integral_person_role/kmsIntegralPersonRole.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/kms/integral/kms_integral_person_role/kmsIntegralPersonRole.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/kms/integral/kms_integral_person_role/kmsIntegralPersonRole.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.kmsIntegralPersonRoleForm, 'deleteall');">
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
				<td width="5pt">
					<input type="checkbox" name="List_Tongle">
				</td>
				<td width="40pt">
					<bean:message key="page.serial"/>
				</td>
				<sunbor:column property="kmsIntegralPersonRole.fdName">
					<bean:message bundle="kms-integral" key="kmsIntegralPersonRole.fdName"/>
				</sunbor:column>
				<sunbor:column property="kmsIntegralPersonRole.fdBalance">
					<bean:message bundle="kms-integral" key="kmsIntegralPersonRole.fdBalance"/>
				</sunbor:column>
				<td>
					<bean:message bundle="kms-integral" key="kmsIntegralPersonRole.fdPerson"/>
				</td>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="kmsIntegralPersonRole" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/kms/integral/kms_integral_person_role/kmsIntegralPersonRole.do" />?method=view&fdId=${kmsIntegralPersonRole.fdId}">
				<td width="5%">
					<input type="checkbox" name="List_Selected" value="${kmsIntegralPersonRole.fdId}">
				</td>
				<td width="5%">
					${vstatus.index+1}
				</td>
				<td width="30%">
					<c:out value="${kmsIntegralPersonRole.fdName}" />
				</td>
				<td width="10%">
					<c:out value="${kmsIntegralPersonRole.fdBalance}" />
				</td>
				<td width="40%">
					<c:forEach var="sysOrgElemets" items="${kmsIntegralPersonRole.allPersons}"> 
						${sysOrgElemets.fdName }&nbsp;&nbsp;
					</c:forEach>
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>