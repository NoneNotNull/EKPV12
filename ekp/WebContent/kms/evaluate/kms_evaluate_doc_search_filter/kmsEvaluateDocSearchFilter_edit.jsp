<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<html:form action="/kms/evaluate/kms_evaluate_doc_search_filter/kmsEvaluateDocSearchFilter.do">
<div id="optBarDiv">
	<c:if test="${kmsEvaluateDocSearchFilterForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="if(submited())Com_Submit(document.kmsEvaluateDocSearchFilterForm, 'update');">
	</c:if>
	<c:if test="${kmsEvaluateDocSearchFilterForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="if(submited())Com_Submit(document.kmsEvaluateDocSearchFilterForm, 'save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="if(submited())Com_Submit(document.kmsEvaluateDocSearchFilterForm, 'saveadd');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="kms-evaluate" key="table.kmsEvaluateDocSearchFilter"/></p>

<center>
<table class="tb_normal" width=60%>
	<%@ include file="/kms/evaluate/resource/jsp/kmsEvaluatePublic.jsp"%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-evaluate" key="kmsEvaluateCommon.fdDept"/>
		</td><td width="80%">
			<input type="hidden" name="fdDeptIds" value="${kmsEvaluateDocSearchFilterForm.fdDeptIds}">
			<xform:textarea property="fdDeptNames" required="true" style="width:90%;height:90px"></xform:textarea>
			<a href="#" onclick="Dialog_Address(true, 'fdDeptIds','fdDeptNames', ';', ORG_TYPE_DEPT);">
				<bean:message key="dialog.selectOrg" /></a>
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