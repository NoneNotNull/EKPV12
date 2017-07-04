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
	<kmss:auth requestURL="/kms/wiki/kms_wiki_template/kmsWikiTemplate.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.edit"/>"
			onclick="Com_OpenWindow('kmsWikiTemplate.do?method=edit&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<kmss:auth requestURL="/kms/wiki/kms_wiki_template/kmsWikiTemplate.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.delete"/>"
			onclick="if(!confirmDelete())return;Com_OpenWindow('kmsWikiTemplate.do?method=delete&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="kms-wiki" key="table.kmsWikiTemplate"/></p>

<center>
<table id="Label_Tabel" class="tb_normal" width=95%>
	<tr LKS_LabelName="模板信息">
 		<td>
			<table class="tb_normal" width="100%" >
				<tr>
					<td class="td_normal_title" width=15%>
						<bean:message bundle="kms-wiki" key="kmsWikiTemplate.fdName"/>
					</td><td width="85%" colspan="3">
						<xform:text property="fdName" style="width:85%" />
					</td>
				</tr>
				<tr>
					<td class="td_normal_title" width=15%>
						<bean:message bundle="kms-wiki" key="kmsWikiTemplate.fdOrder"/>
					</td><td width="85%" colspan="3">
						<xform:text property="fdOrder" style="width:85%" />
					</td>
				</tr>
				<tr>
					<td colspan="4">
						<%@ include file="/kms/wiki/kms_wiki_template/kmsWikiTemplate_view_catelog.jsp" %>
					</td>
				</tr>
				<tr>
					<td class="td_normal_title" width=15%>
						<bean:message bundle="kms-wiki" key="kmsWikiTemplate.fdDescription"/>
					</td><td width="85%" colspan="3">
						<xform:textarea property="fdDescription" style="width:85%" />
					</td>
				</tr>
				<c:if test="${not empty kmsWikiTemplateForm.docCreatorId }">
					<tr>
						<td class="td_normal_title" width=15%>
							<bean:message bundle="kms-wiki" key="kmsWikiTemplate.docCreator"/>
						</td><td width="35%">
							<c:out value="${kmsWikiTemplateForm.docCreatorName}" />
						</td>
						<td class="td_normal_title" width=15%>
							<bean:message bundle="kms-wiki" key="kmsWikiTemplate.docCreateTime"/>
						</td><td width="35%">
							<xform:datetime property="docCreateTime" />
						</td>
					</tr>
				</c:if>
				<c:if test="${not empty kmsWikiTemplateForm.docAlterorId }">
					<tr>
						<td class="td_normal_title" width=15%>
							<bean:message bundle="kms-wiki" key="kmsWikiTemplate.docAlteror"/>
						</td><td width="35%">
							<c:out value="${kmsWikiTemplateForm.docAlterorName}" />
						</td>
						<td class="td_normal_title" width=15%>
							<bean:message bundle="kms-wiki" key="kmsWikiTemplate.docAlterTime"/>
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