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
	<kmss:auth requestURL="/kms/knowledge/kms_knowledge_category/kmsKnowledgeCategory.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.edit"/>"
			onclick="Com_OpenWindow('kmsKnowledgeCategory.do?method=edit&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<kmss:auth requestURL="/kms/knowledge/kms_knowledge_category/kmsKnowledgeCategory.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.delete"/>"
			onclick="if(!confirmDelete())return;Com_OpenWindow('kmsKnowledgeCategory.do?method=delete&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="kms-knowledge" key="table.kmsKnowledgeCategory"/></p>

<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-knowledge" key="kmsKnowledgeCategory.fdName"/>
		</td><td width="35%">
			<xform:text property="fdName" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-knowledge" key="kmsKnowledgeCategory.fdOrder"/>
		</td><td width="35%">
			<xform:text property="fdOrder" style="width:85%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-knowledge" key="kmsKnowledgeCategory.docCreatorId"/>
		</td><td width="35%">
			<xform:text property="docCreatorId" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-knowledge" key="kmsKnowledgeCategory.docCreateTime"/>
		</td><td width="35%">
			<xform:datetime property="docCreateTime" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-knowledge" key="kmsKnowledgeCategory.docAlterorId"/>
		</td><td width="35%">
			<xform:text property="docAlterorId" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-knowledge" key="kmsKnowledgeCategory.docAlterTime"/>
		</td><td width="35%">
			<xform:datetime property="docAlterTime" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-knowledge" key="kmsKnowledgeCategory.fdParentId"/>
		</td><td width="35%">
			<xform:text property="fdParentId" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-knowledge" key="kmsKnowledgeCategory.fdHierarchyId"/>
		</td><td width="35%">
			<xform:text property="fdHierarchyId" style="width:85%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-knowledge" key="kmsKnowledgeCategory.fdDescription"/>
		</td><td width="35%">
			<xform:textarea property="fdDescription" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-knowledge" key="kmsKnowledgeCategory.fdIsinheritMaintainer"/>
		</td><td width="35%">
			<xform:radio property="fdIsinheritMaintainer">
				<xform:enumsDataSource enumsType="common_yesno" />
			</xform:radio>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-knowledge" key="kmsKnowledgeCategory.fdIsinheritUser"/>
		</td><td width="35%">
			<xform:radio property="fdIsinheritUser">
				<xform:enumsDataSource enumsType="common_yesno" />
			</xform:radio>
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-knowledge" key="kmsKnowledgeCategory.authReaderFlag"/>
		</td><td width="35%">
			<xform:radio property="authReaderFlag">
				<xform:enumsDataSource enumsType="common_yesno" />
			</xform:radio>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-knowledge" key="kmsKnowledgeCategory.authNotReaderFlag"/>
		</td><td width="35%">
			<xform:radio property="authNotReaderFlag">
				<xform:enumsDataSource enumsType="common_yesno" />
			</xform:radio>
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-knowledge" key="kmsKnowledgeCategory.authAreaId"/>
		</td><td width="35%">
			<xform:text property="authAreaId" style="width:85%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-knowledge" key="kmsKnowledgeCategory.fdNumberPrefix"/>
		</td><td width="35%">
			<xform:text property="fdNumberPrefix" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-knowledge" key="kmsKnowledgeCategory.authTmpAttNodownload"/>
		</td><td width="35%">
			<xform:radio property="authTmpAttNodownload">
				<xform:enumsDataSource enumsType="common_yesno" />
			</xform:radio>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-knowledge" key="kmsKnowledgeCategory.authTmpAttNocopy"/>
		</td><td width="35%">
			<xform:radio property="authTmpAttNocopy">
				<xform:enumsDataSource enumsType="common_yesno" />
			</xform:radio>
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-knowledge" key="kmsKnowledgeCategory.authTmpAttNoprint"/>
		</td><td width="35%">
			<xform:radio property="authTmpAttNoprint">
				<xform:enumsDataSource enumsType="common_yesno" />
			</xform:radio>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-knowledge" key="kmsKnowledgeCategory.fdPropertyTemplate"/>
		</td><td width="35%">
			<c:out value="${kmsKnowledgeCategoryForm.fdPropertyTemplateName}" />
		</td>
		<td class="td_normal_title" width=15%>&nbsp;</td><td width=35%>&nbsp;</td>
	</tr>
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>