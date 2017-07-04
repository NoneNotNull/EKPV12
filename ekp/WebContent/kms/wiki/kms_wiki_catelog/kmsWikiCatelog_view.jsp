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
	<kmss:auth requestURL="/kms/wiki/kms_wiki_catelog/kmsWikiCatelog.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.edit"/>"
			onclick="Com_OpenWindow('kmsWikiCatelog.do?method=edit&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<kmss:auth requestURL="/kms/wiki/kms_wiki_catelog/kmsWikiCatelog.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.delete"/>"
			onclick="if(!confirmDelete())return;Com_OpenWindow('kmsWikiCatelog.do?method=delete&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
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
			<c:out value="${kmsWikiCatelogForm.fdMainName}" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-wiki" key="kmsWikiCatelog.authEditors"/>
		</td><td width="35%">
			<c:out value="${kmsWikiCatelogForm.authEditorNames}" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-wiki" key="kmsWikiCatelog.authOtherEditors"/>
		</td><td width="35%">
			<c:out value="${kmsWikiCatelogForm.authOtherEditorNames}" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-wiki" key="kmsWikiCatelog.authAllEditors"/>
		</td><td width="35%">
			<c:out value="${kmsWikiCatelogForm.authAllEditorNames}" />
		</td>
		<td class="td_normal_title" width=15%>&nbsp;</td><td width=35%>&nbsp;</td>
	</tr>
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>