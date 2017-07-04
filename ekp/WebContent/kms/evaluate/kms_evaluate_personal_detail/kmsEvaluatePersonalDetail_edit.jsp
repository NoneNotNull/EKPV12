<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<html:form action="/kms/evaluate/kms_evaluate_personal_detail/kmsEvaluatePersonalDetail.do">
<div id="optBarDiv">
	<c:if test="${kmsEvaluatePersonalDetailForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit(document.kmsEvaluatePersonalDetailForm, 'update');">
	</c:if>
	<c:if test="${kmsEvaluatePersonalDetailForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="Com_Submit(document.kmsEvaluatePersonalDetailForm, 'save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="Com_Submit(document.kmsEvaluatePersonalDetailForm, 'saveadd');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="kms-evaluate" key="table.kmsEvaluatePersonalDetail"/></p>

<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-evaluate" key="kmsEvaluatePersonalDetail.docAlterTime"/>
		</td><td width="35%">
			<xform:datetime property="docAlterTime" showStatus="readOnly" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-evaluate" key="kmsEvaluatePersonalDetail.docWeekCount"/>
		</td><td width="35%">
			<xform:select property="docWeekCountId">
				<xform:beanDataSource serviceBean="kmsEvaluatePersonalRankService" selectBlock="fdId,docReadCount" orderBy="" />
			</xform:select>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-evaluate" key="kmsEvaluatePersonalDetail.docMonthCount"/>
		</td><td width="35%">
			<xform:select property="docMonthCountId">
				<xform:beanDataSource serviceBean="kmsEvaluatePersonalRankService" selectBlock="fdId,docReadCount" orderBy="" />
			</xform:select>
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-evaluate" key="kmsEvaluatePersonalDetail.docYearCount"/>
		</td><td width="35%">
			<xform:select property="docYearCountId">
				<xform:beanDataSource serviceBean="kmsEvaluatePersonalRankService" selectBlock="fdId,docReadCount" orderBy="" />
			</xform:select>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-evaluate" key="kmsEvaluatePersonalDetail.docCumulativeCount"/>
		</td><td width="35%">
			<xform:select property="docCumulativeCountId">
				<xform:beanDataSource serviceBean="kmsEvaluatePersonalRankService" selectBlock="fdId,docReadCount" orderBy="" />
			</xform:select>
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-evaluate" key="kmsEvaluatePersonalDetail.fdCreator"/>
		</td><td width="35%">
			<xform:address propertyId="fdCreatorId" propertyName="fdCreatorName" orgType="ORG_TYPE_ALL" style="width:85%" />
		</td>
	</tr>
</table>
</center>
<html:hidden property="fdId" />
<html:hidden property="method_GET" />
<script>
	Com_IncludeFile("dialog.js");
	$KMSSValidation();
</script>
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>