<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<script>
	function confirmDelete(msg){
	var del = confirm("<bean:message key="page.comfirmDelete"/>");
	return del;
}
</script>
<div id="optBarDiv">
	<kmss:auth requestURL="/kms/integral/kms_integral_team_rank/kmsIntegralTeamRank.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.edit"/>"
			onclick="Com_OpenWindow('kmsIntegralTeamRank.do?method=edit&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<kmss:auth requestURL="/kms/integral/kms_integral_team_rank/kmsIntegralTeamRank.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.delete"/>"
			onclick="if(!confirmDelete())return;Com_OpenWindow('kmsIntegralTeamRank.do?method=delete&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="kms-integral" key="table.kmsIntegralTeamRank"/></p>

<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-integral" key="kmsIntegralTeamRank.fdLastTime"/>
		</td><td width="35%">
			<xform:datetime property="fdLastTime" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-integral" key="kmsIntegralTeamRank.fdWeek"/>
		</td><td width="35%">
			<c:out value="${kmsIntegralTeamRankForm.fdWeekName}" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-integral" key="kmsIntegralTeamRank.fdMonth"/>
		</td><td width="35%">
			<c:out value="${kmsIntegralTeamRankForm.fdMonthName}" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-integral" key="kmsIntegralTeamRank.fdYear"/>
		</td><td width="35%">
			<c:out value="${kmsIntegralTeamRankForm.fdYearName}" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-integral" key="kmsIntegralTeamRank.fdTotal"/>
		</td><td width="35%">
			<c:out value="${kmsIntegralTeamRankForm.fdTotalName}" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-integral" key="kmsIntegralTeamRank.fdTeam"/>
		</td><td width="35%">
			<c:out value="${kmsIntegralTeamRankForm.fdTeamName}" />
		</td>
	</tr>
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>