<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<html:form action="/kms/integral/kms_integral_team_rank/kmsIntegralTeamRank.do">
<div id="optBarDiv">
	<c:if test="${kmsIntegralTeamRankForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit(document.kmsIntegralTeamRankForm, 'update');">
	</c:if>
	<c:if test="${kmsIntegralTeamRankForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="Com_Submit(document.kmsIntegralTeamRankForm, 'save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="Com_Submit(document.kmsIntegralTeamRankForm, 'saveadd');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
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
			<xform:select property="fdWeekId">
				<xform:beanDataSource serviceBean="kmsIntegralPersonRDetailService" selectBlock="fdId,fdId" orderBy="" />
			</xform:select>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-integral" key="kmsIntegralTeamRank.fdMonth"/>
		</td><td width="35%">
			<xform:select property="fdMonthId">
				<xform:beanDataSource serviceBean="kmsIntegralPersonRDetailService" selectBlock="fdId,fdId" orderBy="" />
			</xform:select>
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-integral" key="kmsIntegralTeamRank.fdYear"/>
		</td><td width="35%">
			<xform:select property="fdYearId">
				<xform:beanDataSource serviceBean="kmsIntegralPersonRDetailService" selectBlock="fdId,fdId" orderBy="" />
			</xform:select>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-integral" key="kmsIntegralTeamRank.fdTotal"/>
		</td><td width="35%">
			<xform:select property="fdTotalId">
				<xform:beanDataSource serviceBean="kmsIntegralPersonRDetailService" selectBlock="fdId,fdId" orderBy="" />
			</xform:select>
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-integral" key="kmsIntegralTeamRank.fdTeam"/>
		</td><td width="35%">
			<xform:select property="fdTeamId">
				<xform:beanDataSource serviceBean="kmsIntegralTeamService" selectBlock="fdId,fdName" orderBy="" />
			</xform:select>
		</td>
	</tr>
</table>
</center>
<html:hidden property="fdId" />
<html:hidden property="method_GET" />
<script>
	Com_IncludeFile("calendar.js");
	$KMSSValidation();
</script>
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>