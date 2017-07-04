<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<html:form action="/kms/wiki/kms_wiki_catelog/kmsWikiCatelog.do">
<div id="optBarDiv">
	<c:if test="${kmsWikiCatelogForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit(document.kmsWikiCatelogForm, 'update');">
	</c:if>
	<c:if test="${kmsWikiCatelogForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="Com_Submit(document.kmsWikiCatelogForm, 'save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="Com_Submit(document.kmsWikiCatelogForm, 'saveadd');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="kms-wiki" key="table.kmsWikiCatelog"/></p>

<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-wiki" key="kmsWikiCatelog.fdName"/>
		</td><td width="35%">
			<xform:text property="fdName" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-wiki" key="kmsWikiCatelog.fdKey"/>
		</td><td width="35%">
			<xform:text property="fdKey" style="width:85%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-wiki" key="kmsWikiCatelog.fdOrder"/>
		</td><td width="35%">
			<xform:text property="fdOrder" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-wiki" key="kmsWikiCatelog.fdParentId"/>
		</td><td width="35%">
			<xform:text property="fdParentId" style="width:85%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-wiki" key="kmsWikiCatelog.docContent"/>
		</td><td width="35%">
			<xform:rtf property="docContent" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-wiki" key="kmsWikiCatelog.fdMain"/>
		</td><td width="35%">
			<xform:select property="fdMainId">
				<xform:beanDataSource serviceBean="kmsWikiMainService" selectBlock="fdId,fdId" orderBy="" />
			</xform:select>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-wiki" key="kmsWikiCatelog.authEditors"/>
		</td><td width="35%">
			<xform:address propertyId="authEditorIds" propertyName="authEditorNames" mulSelect="true" orgType="ORG_TYPE_ALL" textarea="true" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-wiki" key="kmsWikiCatelog.authOtherEditors"/>
		</td><td width="35%">
			<xform:address propertyId="authOtherEditorIds" propertyName="authOtherEditorNames" mulSelect="true" orgType="ORG_TYPE_ALL" textarea="true" style="width:85%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-wiki" key="kmsWikiCatelog.authAllEditors"/>
		</td><td width="35%">
			<xform:address propertyId="authAllEditorIds" propertyName="authAllEditorNames" mulSelect="true" orgType="ORG_TYPE_ALL" textarea="true" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>&nbsp;</td><td width=35%>&nbsp;</td>
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