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
	<kmss:auth requestURL="/km/signature/km_signature_document_signature/kmSignatureDocumentSignature.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.edit"/>"
			onclick="Com_OpenWindow('kmSignatureDocumentSignature.do?method=edit&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<kmss:auth requestURL="/km/signature/km_signature_document_signature/kmSignatureDocumentSignature.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.delete"/>"
			onclick="if(!confirmDelete())return;Com_OpenWindow('kmSignatureDocumentSignature.do?method=delete&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
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
	<tr height="200">
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-signature" key="documentSignature.hostname"/>
		</td><td width="35%">
			<xform:text property="fdHostName" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
		</td><td width=35%>
			<OBJECT name="SendOut" classid="clsid:2294689C-9EDF-40BC-86AE-0438112CA439" codebase="iWebRevision.cab#version=6,0,0,0" width=100% height=100%>
	        	<param name="Enabled" value="0">  <!-- Enabled:是否允许修改，0:不允许 1:允许  默认值:1  -->           
	        	<param name="BorderStyle" value="0">    <!-- BorderStyle:边框，0:无边框 1:有边框  默认值:1  -->
	        	<param name="value" value="${kmSignatureDocumentSignatureForm.fdFieldValue}">
	        </OBJECT>
		</td>
	</tr>
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>