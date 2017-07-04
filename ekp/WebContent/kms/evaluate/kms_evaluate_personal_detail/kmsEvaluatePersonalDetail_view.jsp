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
	<kmss:auth requestURL="/kms/evaluate/kms_evaluate_personal_detail/kmsEvaluatePersonalDetail.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.edit"/>"
			onclick="Com_OpenWindow('kmsEvaluatePersonalDetail.do?method=edit&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<kmss:auth requestURL="/kms/evaluate/kms_evaluate_personal_detail/kmsEvaluatePersonalDetail.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.delete"/>"
			onclick="Com_OpenWindow('kmsEvaluatePersonalDetail.do?method=delete&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="kms-evaluate" key="table.kmsEvaluatePersonalDetail"/></p>

<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-evaluate" key="kmsEvaluatePersonalDetail.docAlterTime"/>
		</td><td width="35%">
			<xform:datetime property="docAlterTime" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-evaluate" key="kmsEvaluatePersonalDetail.docWeekCount"/>
		</td><td width="35%">
			<c:out value="${kmsEvaluatePersonalDetailForm.docWeekCountName}" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-evaluate" key="kmsEvaluatePersonalDetail.docMonthCount"/>
		</td><td width="35%">
			<c:out value="${kmsEvaluatePersonalDetailForm.docMonthCountName}" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-evaluate" key="kmsEvaluatePersonalDetail.docYearCount"/>
		</td><td width="35%">
			<c:out value="${kmsEvaluatePersonalDetailForm.docYearCountName}" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-evaluate" key="kmsEvaluatePersonalDetail.docCumulativeCount"/>
		</td><td width="35%">
			<c:out value="${kmsEvaluatePersonalDetailForm.docCumulativeCountName}" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-evaluate" key="kmsEvaluatePersonalDetail.fdCreator"/>
		</td><td width="35%">
			<c:out value="${kmsEvaluatePersonalDetailForm.fdCreatorName}" />
		</td>
	</tr>
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>