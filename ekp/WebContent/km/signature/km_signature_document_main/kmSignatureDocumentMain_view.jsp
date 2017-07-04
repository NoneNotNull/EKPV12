<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<%@ page import="java.util.List" %>
<%@ page import="com.landray.kmss.common.actions.ExtendAction" %>
<%@ page import="com.landray.kmss.common.dao.HQLInfo" %>
<%@ page import="com.landray.kmss.km.signature.model.KmSignatureDocumentMain" %>
<%@ page import="com.landray.kmss.km.signature.model.KmSignatureDocumentSignature" %>
<%@ page import="com.landray.kmss.km.signature.model.KmSignatureMain" %>
<%@ page import="com.landray.kmss.km.signature.service.IKmSignatureDocumentMainService" %>
<%@ page import="com.landray.kmss.km.signature.service.IKmSignatureDocumentSignatureService" %>
<%@ page import="com.landray.kmss.km.signature.service.IKmSignatureMainService" %>
<%
String id = request.getParameter("fdId");
IKmSignatureDocumentMainService imp = (IKmSignatureDocumentMainService) SpringBeanUtil
		.getBean("kmSignatureDocumentMainService");
KmSignatureDocumentMain document = (KmSignatureDocumentMain) imp.findByPrimaryKey(id);
IKmSignatureDocumentSignatureService imp2 = (IKmSignatureDocumentSignatureService) SpringBeanUtil
		.getBean("kmSignatureDocumentSignatureService");
HQLInfo hqlInfo = new HQLInfo();
hqlInfo.setWhereBlock("fdRecordId='" + document.getFdRecordId() + "'");
List<KmSignatureDocumentSignature> lists = imp2.findList(hqlInfo);
String value = lists.get(0).getFieldvalue();
%>
<script>
	function confirmDelete(msg) {
		var del = confirm("<bean:message key="page.comfirmDelete"/>");
		return del;
	}
</script>
<div id="optBarDiv">
	<kmss:auth
		requestURL="/km/signature/km_signature_document_main/kmSignatureDocumentMain.do?method=edit&fdId=${param.fdId}"
		requestMethod="GET">
		<input type="button" value="<bean:message key="button.edit"/>"
			onclick="Com_OpenWindow('kmSignatureDocumentMain.do?method=edit&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<kmss:auth
		requestURL="/km/signature/km_signature_document_main/kmSignatureDocumentMain.do?method=delete&fdId=${param.fdId}"
		requestMethod="GET">
		<input type="button" value="<bean:message key="button.delete"/>"
			onclick="if(!confirmDelete())return;Com_OpenWindow('kmSignatureDocumentMain.do?method=delete&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<input type="button" value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>

<p class="txttitle">
	<bean:message bundle="km-signature" key="table.document" />
</p>

<center>
	<table class="tb_normal" width=95%>
		<tr>
			<td class="td_normal_title" width=15%>
				<bean:message bundle="km-signature" key="document.documentid" />
			</td>
			<td width="35%">
				<xform:text property="fdDocumentId" style="width:85%" />
			</td>
			<td class="td_normal_title" width=15%>
				<bean:message bundle="km-signature" key="document.recordid" />
			</td>
			<td width="35%">
				<xform:text property="fdRecordId" style="width:85%" />
			</td>
		</tr>
		<tr>
			<td class="td_normal_title" width=15%>
				<bean:message bundle="km-signature" key="document.docno" />
			</td>
			<td width="35%">
				<xform:text property="fdDocNo" style="width:85%" />
			</td>
			<td class="td_normal_title" width=15%>
				<bean:message bundle="km-signature" key="document.username" />
			</td>
			<td width="35%">
				<xform:text property="fdUserName" style="width:85%" />
			</td>
		</tr>
		<tr>
			<td class="td_normal_title" width=15%>
				<bean:message bundle="km-signature" key="document.security" />
			</td>
			<td width="35%">
				<xform:text property="fdSecurity" style="width:85%" />
			</td>
			<td class="td_normal_title" width=15%>
				<bean:message bundle="km-signature" key="document.draft" />
			</td>
			<td width="35%">
				<xform:text property="fdDraft" style="width:85%" />
			</td>
		</tr>
		<tr>
			<td class="td_normal_title" width=15%>
				<bean:message bundle="km-signature" key="document.check1" />
			</td>
			<td width="35%">
				<xform:text property="fdAuditor" style="width:85%" />
			</td>
			<td class="td_normal_title" width=15%>
				<bean:message bundle="km-signature" key="document.title" />
			</td>
			<td width="35%">
				<xform:text property="fdTitle" style="width:85%" />
			</td>
		</tr>
		<tr>
			<td class="td_normal_title" width=15%>
				<bean:message bundle="km-signature" key="document.copyto" />
			</td>
			<td width="35%">
				<xform:text property="fdCopyTo" style="width:85%" />
			</td>
			<td class="td_normal_title" width=15%>
				<bean:message bundle="km-signature" key="document.subject" />
			</td>
			<td width="35%">
				<xform:text property="docSubject" style="width:85%" />
			</td>
		</tr>
		<tr>
			<td class="td_normal_title" width=15%>
				<bean:message bundle="km-signature" key="document.copies" />
			</td>
			<td width="35%">
				<xform:text property="fdCopies" style="width:85%" />
			</td>
			<td class="td_normal_title" width=15%>
				<bean:message bundle="km-signature" key="document.datetime" />
			</td>
			<td width="35%">
				<xform:text property="fdDateTime" style="width:85%" /> 		 
				<img src="${KMSS_Parameter_ContextPath}/km/signature/km_signature_main/showImg.do?fdId=${kmSignatureDocumentMainForm.fdId}&flag=doc">
			</td>
		</tr>
		<tr>
		<td colspan="4" height="200">
			<OBJECT name="SendOut" classid="clsid:2294689C-9EDF-40BC-86AE-0438112CA439" codebase="iWebRevision.cab#version=6,0,0,0" width=100% height=100%>
				<param name="Enabled" value="0">  <!-- Enabled:是否允许修改，0:不允许 1:允许  默认值:1  -->           
				<param name="BorderStyle" value="0">    <!-- BorderStyle:边框，0:无边框 1:有边框  默认值:1  -->
				<param name="value" value="<%=value%>">
			</OBJECT>
		</td>
		</tr>
	</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>