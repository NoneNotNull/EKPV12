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
	<kmss:auth requestURL="/kms/knowledge/kms_knowledge_wiki_template/kmsKnowledgeWikiTemplate.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.edit"/>"
			onclick="Com_OpenWindow('kmsKnowledgeWikiTemplate.do?method=edit&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="kms-knowledge" key="table.kmsKnowledgeWikiTemplate"/></p>

<center>
<table id="Label_Tabel" class="tb_normal" width=95%>
	<tr LKS_LabelName="模板信息">
 		<td>
			<table class="tb_normal" width="100%" >
				<tr>
					<td class="td_normal_title" width=15%>
						<bean:message bundle="kms-knowledge" key="kmsKnowledgeWikiTemplate.fdName"/>
					</td><td width="85%" colspan="3">
						<xform:text property="fdName" style="width:85%" />
					</td>
				</tr>
				<tr>
					<td class="td_normal_title" width=15%>
						<bean:message bundle="kms-knowledge" key="kmsKnowledgeWikiTemplate.fdOrder"/>
					</td><td width="85%" colspan="3">
						<xform:text property="fdOrder" style="width:85%" />
					</td>
				</tr>
				<tr>
					<td colspan="4">
						<%@ include file="/kms/knowledge/kms_knowledge_wiki_template/kmsKnowledgeWikiTemplate_view_catelog.jsp" %>
					</td>
				</tr>
				<tr>
					<td class="td_normal_title" width=15%>
						<bean:message bundle="kms-knowledge" key="kmsKnowledgeWikiTemplate.fdDescription"/>
					</td><td width="85%" colspan="3">
						<xform:textarea property="fdDescription" style="width:85%" />
					</td>
				</tr>
				<c:if test="${not empty kmsKnowledgeWikiTemplateForm.docCreatorId }">
					<tr>
						<td class="td_normal_title" width=15%>
							<bean:message bundle="kms-knowledge" key="kmsKnowledgeWikiTemplate.docCreator"/>
						</td><td width="35%">
							<c:out value="${kmsKnowledgeWikiTemplateForm.docCreatorName}" />
						</td>
						<td class="td_normal_title" width=15%>
							<bean:message bundle="kms-knowledge" key="kmsKnowledgeWikiTemplate.docCreateTime"/>
						</td><td width="35%">
							<xform:datetime property="docCreateTime" />
						</td>
					</tr>
				</c:if>
				<c:if test="${not empty kmsKnowledgeWikiTemplateForm.docAlterorId }">
					<tr>
						<td class="td_normal_title" width=15%>
							<bean:message bundle="kms-knowledge" key="kmsKnowledgeWikiTemplate.docAlteror"/>
						</td><td width="35%">
							<c:out value="${kmsKnowledgeWikiTemplateForm.docAlterorName}" />
						</td>
						<td class="td_normal_title" width=15%>
							<bean:message bundle="kms-knowledge" key="kmsKnowledgeWikiTemplate.docAlterTime"/>
						</td><td width="35%">
							<xform:datetime property="docAlterTime" />
						</td>
					</tr>
				</c:if>
			</table>
		</td>
	</tr>
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>