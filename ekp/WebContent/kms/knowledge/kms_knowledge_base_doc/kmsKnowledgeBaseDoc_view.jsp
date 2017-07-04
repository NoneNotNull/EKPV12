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
	<kmss:auth requestURL="/kms/knowledge/kms_knowledge_base_doc/kmsKnowledgeBaseDoc.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.edit"/>"
			onclick="Com_OpenWindow('kmsKnowledgeBaseDoc.do?method=edit&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<kmss:auth requestURL="/kms/knowledge/kms_knowledge_base_doc/kmsKnowledgeBaseDoc.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.delete"/>"
			onclick="if(!confirmDelete())return;Com_OpenWindow('kmsKnowledgeBaseDoc.do?method=delete&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="kms-knowledge" key="table.kmsKnowledgeBaseDoc"/></p>

<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-knowledge" key="kmsKnowledgeBaseDoc.docSubject"/>
		</td><td width="35%">
			<xform:text property="docSubject" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-knowledge" key="kmsKnowledgeBaseDoc.docStatus"/>
		</td><td width="35%">
			<xform:text property="docStatus" style="width:85%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-knowledge" key="kmsKnowledgeBaseDoc.docType"/>
		</td><td width="35%">
			<xform:text property="docType" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-knowledge" key="kmsKnowledgeBaseDoc.docCreateTime"/>
		</td><td width="35%">
			<xform:datetime property="docCreateTime" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-knowledge" key="kmsKnowledgeBaseDoc.docAuthorId"/>
		</td><td width="35%">
			<xform:text property="docAuthorId" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-knowledge" key="kmsKnowledgeBaseDoc.docPosts"/>
		</td><td width="35%">
			<xform:text property="docPosts" style="width:85%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-knowledge" key="kmsKnowledgeBaseDoc.docDeptId"/>
		</td><td width="35%">
			<xform:text property="docDeptId" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-knowledge" key="kmsKnowledgeBaseDoc.docIntrCount"/>
		</td><td width="35%">
			<xform:text property="docIntrCount" style="width:85%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-knowledge" key="kmsKnowledgeBaseDoc.docEvalCount"/>
		</td><td width="35%">
			<xform:text property="docEvalCount" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-knowledge" key="kmsKnowledgeBaseDoc.docReadCount"/>
		</td><td width="35%">
			<xform:text property="docReadCount" style="width:85%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-knowledge" key="kmsKnowledgeBaseDoc.docIsNewVersion"/>
		</td><td width="35%">
			<xform:radio property="docIsNewVersion">
				<xform:enumsDataSource enumsType="common_yesno" />
			</xform:radio>
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-knowledge" key="kmsKnowledgeBaseDoc.authAreaId"/>
		</td><td width="35%">
			<xform:text property="authAreaId" style="width:85%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-knowledge" key="kmsKnowledgeBaseDoc.docCategory"/>
		</td><td width="35%">
			<c:out value="${kmsKnowledgeBaseDocForm.docCategoryName}" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-knowledge" key="kmsKnowledgeBaseDoc.authReaders"/>
		</td><td width="35%">
			<c:out value="${kmsKnowledgeBaseDocForm.authReaderNames}" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-knowledge" key="kmsKnowledgeBaseDoc.authEditors"/>
		</td><td width="35%">
			<c:out value="${kmsKnowledgeBaseDocForm.authEditorNames}" />
		</td>
		<td class="td_normal_title" width=15%>&nbsp;</td><td width=35%>&nbsp;</td>
	</tr>
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>