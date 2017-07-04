<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<%@ include file="/kms/wiki/kms_wiki_template/kmsWikiTemplate_edit_js.jsp" %>
<html:form action="/kms/wiki/kms_wiki_template/kmsWikiTemplate.do">
<div id="optBarDiv">
	<c:if test="${kmsWikiTemplateForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit_kmsWikiTemplateForm(document.kmsWikiTemplateForm, 'update');">
	</c:if>
	<c:if test="${kmsWikiTemplateForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="Com_Submit_kmsWikiTemplateForm(document.kmsWikiTemplateForm, 'save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="Com_Submit_kmsWikiTemplateForm(document.kmsWikiTemplateForm, 'saveadd');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="kms-wiki" key="table.kmsWikiTemplate"/></p>

<center>
<table id="Label_Tabel" class="tb_normal" width=95%>
	<html:hidden property="fdId"/>
	<input type="hidden" name="fdType" value="1" />
	<input type="hidden" name="fdContentType" id="fdContentType" value="html" />
	<html:hidden property="fdHtmlContent" />
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
						<xform:text property="fdOrder" style="width:35%" />
					</td>
				</tr>
				<tr>
					<td colspan="4">
						<%@ include file="/kms/wiki/kms_wiki_template/kmsWikiTemplate_edit_catelog.jsp" %>
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
							<xform:address propertyId="docCreatorId" propertyName="docCreatorName" orgType="ORG_TYPE_PERSON" showStatus="view" />
						</td>
						<td class="td_normal_title" width=15%>
							<bean:message bundle="kms-wiki" key="kmsWikiTemplate.docCreateTime"/>
						</td><td width="35%">
							<xform:datetime property="docCreateTime" showStatus="view" />
						</td>
					</tr>
				</c:if>
				<c:if test="${not empty kmsWikiTemplateForm.docAlterorId }">
					<tr>
						<td class="td_normal_title" width=15%>
							<bean:message bundle="kms-wiki" key="kmsWikiTemplate.docAlteror"/>
						</td><td width="35%">
							<xform:address propertyId="docAlterorId" propertyName="docAlterorName" orgType="ORG_TYPE_PERSON" showStatus="view" />
						</td>
						<td class="td_normal_title" width=15%>
							<bean:message bundle="kms-wiki" key="kmsWikiTemplate.docAlterTime"/>
						</td><td width="35%">
							<xform:datetime property="docAlterTime" showStatus="view" />
						</td>
					</tr>
				</c:if>
			</table>
		</td>
	</tr>
</table>
</center>
<html:hidden property="fdId" />
<html:hidden property="method_GET" />
<script>
	$KMSSValidation();
</script>
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>