<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<html:form action="/kms/evaluate/kms_evaluate_doc_detail/kmsEvaluateDocDetail.do">
<div id="optBarDiv">
	<c:if test="${kmsEvaluateDocDetailForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit(document.kmsEvaluateDocDetailForm, 'update');">
	</c:if>
	<c:if test="${kmsEvaluateDocDetailForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="Com_Submit(document.kmsEvaluateDocDetailForm, 'save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="Com_Submit(document.kmsEvaluateDocDetailForm, 'saveadd');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="kms-evaluate" key="table.kmsEvaluateDocDetail"/></p>

<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-evaluate" key="kmsEvaluateDocDetail.countId"/>
		</td><td width="35%">
			<xform:text property="countId" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-evaluate" key="kmsEvaluateDocDetail.docReadCount"/>
		</td><td width="35%">
			<xform:text property="docReadCount" style="width:85%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-evaluate" key="kmsEvaluateDocDetail.docEvaluationCount"/>
		</td><td width="35%">
			<xform:text property="docEvaluationCount" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-evaluate" key="kmsEvaluateDocDetail.docIntroduceCount"/>
		</td><td width="35%">
			<xform:text property="docIntroduceCount" style="width:85%" />
		</td>
	</tr>
</table>
</center>
<html:hidden property="fdId" />
<html:hidden property="method_GET" />
<script>
	$KMSSValidation();
</script>
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>