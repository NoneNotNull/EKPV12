<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<html:form action="/km/signature/km_signature_document_history/kmSignatureDocumentHistory.do">
<div id="optBarDiv">
	<c:if test="${kmSignatureDocumentHistoryForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit(document.kmSignatureDocumentHistoryForm, 'update');">
	</c:if>
	<c:if test="${kmSignatureDocumentHistoryForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="Com_Submit(document.kmSignatureDocumentHistoryForm, 'save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="Com_Submit(document.kmSignatureDocumentHistoryForm, 'saveadd');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="km-signature" key="table.documentHistory"/></p>

<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-signature" key="documentHistory.id"/>
		</td><td width="35%">
			<xform:text property="fdHistoryId" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-signature" key="documentHistory.recordid"/>
		</td><td width="35%">
			<xform:text property="fdRecordId" style="width:85%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-signature" key="documentHistory.fieldname"/>
		</td><td width="35%">
			<xform:text property="fdFieldName" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-signature" key="documentHistory.markname"/>
		</td><td width="35%">
			<xform:text property="fdMarkName" style="width:85%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-signature" key="documentHistory.username"/>
		</td><td width="35%">
			<xform:text property="fdUserName" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-signature" key="documentHistory.datetime"/>
		</td><td width="35%">
			<xform:datetime property="fdDateTime" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-signature" key="documentHistory.hostname"/>
		</td><td width="35%">
			<xform:text property="fdHostName" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-signature" key="documentHistory.markguid"/>
		</td><td width="35%">
			<xform:text property="fdMarkGuid" style="width:85%" />
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