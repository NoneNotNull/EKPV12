<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<html:form action="/km/signature/km_signature_document_signature/kmSignatureDocumentSignature.do">
<div id="optBarDiv">
	<c:if test="${kmSignatureDocumentSignatureForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit(document.kmSignatureDocumentSignatureForm, 'update');">
	</c:if>
	<c:if test="${kmSignatureDocumentSignatureForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="Com_Submit(document.kmSignatureDocumentSignatureForm, 'save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="Com_Submit(document.kmSignatureDocumentSignatureForm, 'saveadd');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="km-signature" key="table.documentSignature"/></p>

<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-signature" key="documentSignature.id"/>
		</td><td width="35%">
			<xform:text property="fdDocumentSignatureId" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-signature" key="documentSignature.recordid"/>
		</td><td width="35%">
			<xform:text property="fdRecordId" style="width:85%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-signature" key="documentSignature.fieldname"/>
		</td><td width="35%">
			<xform:text property="fdFieldName" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-signature" key="documentSignature.fieldvalue"/>
		</td><td width="35%">
			<xform:text property="fdFieldValue" style="width:85%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-signature" key="documentSignature.username"/>
		</td><td width="35%">
			<xform:text property="fdUserName" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-signature" key="documentSignature.datetime"/>
		</td><td width="35%">
			<xform:datetime property="fdDateTime" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-signature" key="documentSignature.hostname"/>
		</td><td width="35%">
			<xform:text property="fdHostName" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>&nbsp;</td>
		<td width=35%>&nbsp;</td>
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