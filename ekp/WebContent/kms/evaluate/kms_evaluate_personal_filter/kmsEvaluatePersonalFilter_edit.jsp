<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<html:form action="/kms/evaluate/kms_evaluate_personal_filter/kmsEvaluatePersonalFilter.do">
<div id="optBarDiv">
	<c:if test="${kmsEvaluatePersonalFilterForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="if(submited())Com_Submit(document.kmsEvaluatePersonalFilterForm, 'update');">
	</c:if>
	<c:if test="${kmsEvaluatePersonalFilterForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="if(submited())Com_Submit(document.kmsEvaluatePersonalFilterForm, 'save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="if(submited())Com_Submit(document.kmsEvaluatePersonalFilterForm, 'saveadd');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="kms-evaluate" key="table.reportCount.personalKnowledgeCount"/></p>

<center>
<table class="tb_normal" width=60%>
	<%@ include file="/kms/evaluate/resource/jsp/kmsEvaluatePublic.jsp"%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-evaluate" key="kmsEvaluateCommon.personal"/>
		</td><td width="80%">
			<input type="hidden" name="fdDeptIds" value="${kmsEvaluatePersonalFilterForm.fdDeptIds }">
			<xform:textarea property="fdDeptNames" required="true" style="width:90%;height:90px"></xform:textarea>
			<a href="#" onclick="Dialog_Address(true, 'fdDeptIds','fdDeptNames', ';', null);">
				<bean:message key="dialog.selectOrg" /></a>	
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=20%>
			<bean:message bundle="kms-evaluate" key="kmsEvaluateCommon.count"/> 
		</td><td width="80%">
			<xform:checkbox property="docAddCount" subject="<bean:message bundle='kms-evaluate' key='kmsEvaluateCommon.docAddCount'/>" >
				<xform:simpleDataSource value="true"><bean:message bundle='kms-evaluate' key='kmsEvaluateCommon.docAddCount'/></xform:simpleDataSource>
			</xform:checkbox>
			<xform:checkbox property="docUpdateCount" subject="<bean:message bundle='kms-evaluate' key='kmsEvaluateCommon.docUpdateCount'/>" >
				<xform:simpleDataSource value="true"><bean:message bundle='kms-evaluate' key='kmsEvaluateCommon.docUpdateCount'/></xform:simpleDataSource>
			</xform:checkbox>
			<xform:checkbox property="docDeleteCount" subject="<bean:message bundle='kms-evaluate' key='kmsEvaluateCommon.docDeleteCount'/>" >
				<xform:simpleDataSource value="true"><bean:message bundle='kms-evaluate' key='kmsEvaluateCommon.docDeleteCount'/></xform:simpleDataSource>
			</xform:checkbox>
			<xform:checkbox property="docReadCount" subject="<bean:message bundle='kms-evaluate' key='kmsEvaluateCommon.docReadCount'/>" >
				<xform:simpleDataSource value="true"><bean:message bundle='kms-evaluate' key='kmsEvaluateCommon.docReadCount'/></xform:simpleDataSource>
			</xform:checkbox>
			<xform:checkbox property="docEvaluationCount" subject="<bean:message bundle='kms-evaluate' key='kmsEvaluateCommon.docEvaluationCount'/>" >
				<xform:simpleDataSource value="true"><bean:message bundle='kms-evaluate' key='kmsEvaluateCommon.docEvaluationCount'/></xform:simpleDataSource>
			</xform:checkbox>
			<xform:checkbox property="docIntroduceCount" subject="<bean:message bundle='kms-evaluate' key='kmsEvaluateCommon.docIntroduceCount'/>" >
				<xform:simpleDataSource value="true"><bean:message bundle='kms-evaluate' key='kmsEvaluateCommon.docIntroduceCount'/></xform:simpleDataSource>
			</xform:checkbox>
		</td>
	</tr>
</table>
</center>
<html:hidden property="fdId" />
<html:hidden property="method_GET" />
<script>
	Com_IncludeFile("calendar.js");
	Com_IncludeFile("dialog.js");
	$KMSSValidation();
</script>
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>