<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/kms/integral/kms_integral_team/kmsIntegralTeam.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/kms/integral/kms_integral_team/kmsIntegralTeam.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/kms/integral/kms_integral_team/kmsIntegralTeam.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/kms/integral/kms_integral_team/kmsIntegralTeam.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.kmsIntegralTeamForm, 'deleteall');">
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
				<td width="5%">
					<input type="checkbox" name="List_Tongle">
				</td>
				<td  width="6%">
					<bean:message key="page.serial"/>
				</td>
				<td width="30%">
					<bean:message bundle="kms-integral" key="kmsIntegralTeam.fdName"/>
				</td>
				<td width="50%">
					<bean:message bundle="kms-integral" key="kmsIntegralTeam.fdPersons"/>
				</td>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="kmsIntegralTeam" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/kms/integral/kms_integral_team/kmsIntegralTeam.do" />?method=view&fdId=${kmsIntegralTeam.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${kmsIntegralTeam.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${kmsIntegralTeam.fdName}" />
				</td>
				<td>
					<c:forEach var="sysOrgElemets" items="${kmsIntegralTeam.allPersons}"> 
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