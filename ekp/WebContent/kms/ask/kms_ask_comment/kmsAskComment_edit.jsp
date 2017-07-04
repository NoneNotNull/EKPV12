<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<html:form action="/kms/ask/kms_ask_comment/kmsAskComment.do">
<div id="optBarDiv">
	<c:if test="${kmsAskCommentForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit(document.kmsAskCommentForm, 'update');">
	</c:if>
	<c:if test="${kmsAskCommentForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="Com_Submit(document.kmsAskCommentForm, 'save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="Com_Submit(document.kmsAskCommentForm, 'saveadd');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="kms-ask" key="table.kmsAskComment"/></p>

<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-ask" key="kmsAskComment.docContent"/>
		</td><td width="35%">
			<xform:rtf property="docContent" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-ask" key="kmsAskComment.fdCommentTime"/>
		</td><td width="35%">
			<xform:datetime property="fdCommentTime" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-ask" key="kmsAskComment.fdPoster"/>
		</td><td width="35%">
			<xform:address propertyId="fdPosterId" propertyName="fdPosterName" orgType="ORG_TYPE_ALL" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-ask" key="kmsAskComment.fdKmsAskPost"/>
		</td><td width="35%">
			<xform:select property="fdKmsAskPostId">
				<xform:beanDataSource serviceBean="kmsAskPostService" selectBlock="fdId,docSubject" orderBy="" />
			</xform:select>
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