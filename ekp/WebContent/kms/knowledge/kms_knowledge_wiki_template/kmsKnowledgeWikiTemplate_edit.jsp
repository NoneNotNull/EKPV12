<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<%@ include file="/kms/knowledge/kms_knowledge_wiki_template/kmsKnowledgeWikiTemplate_edit_js.jsp" %>
<%@page import="com.landray.kmss.sys.authorization.constant.ISysAuthConstant"%>
<%@ page import="com.landray.kmss.util.UserUtil" %>
<%@ page import="java.util.Set" %>
<%@ page import="com.landray.kmss.sys.config.dict.SysDataDict" %>
<%
   String fdAuthAreaId= UserUtil.getKMSSUser().getAuthAreaId();
   String fdAuthAreaName= UserUtil.getKMSSUser().getAuthAreaName();
   request.setAttribute("fdAuthAreaName", fdAuthAreaName);
   request.setAttribute("fdAuthAreaId", fdAuthAreaId);
%>

<html:form action="/kms/knowledge/kms_knowledge_wiki_template/kmsKnowledgeWikiTemplate.do">
<div id="optBarDiv">
	<c:if test="${kmsKnowledgeWikiTemplateForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit_kmsWikiTemplateForm(document.kmsKnowledgeWikiTemplateForm, 'update');">
	</c:if>
	<c:if test="${kmsKnowledgeWikiTemplateForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="Com_Submit_kmsWikiTemplateForm(document.kmsKnowledgeWikiTemplateForm, 'save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="Com_Submit_kmsWikiTemplateForm(document.kmsKnowledgeWikiTemplateForm, 'saveadd');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="kms-knowledge" key="table.kmsKnowledgeWikiTemplate"/></p>

<center>
<table id="Label_Tabel" class="tb_normal" width=95%>
	<html:hidden property="fdId"/>
	<input type="hidden" name="fdType" value="1" />
	<input type="hidden" name="fdContentType" id="fdContentType" value="html" />
	<html:hidden property="fdHtmlContent" />
	<tr LKS_LabelName="${lfn:message('kms-knowledge:kmsKnowledgeWikiTemplate.templateInfo')}">
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
						<xform:text property="fdOrder" style="width:35%" />
					</td>
				</tr>
				<%-- 所属场所 --%>
				<% if(ISysAuthConstant.IS_AREA_ENABLED) { %> 
				<c:if test="${kmsKnowledgeWikiTemplateForm.method_GET=='add' }">
					<tr>	
				    <td>
				        <bean:message key="sysAuthArea.authArea" bundle="sys-authorization" />：
					</td>
					<td colspan="3">
						<input type="hidden" name="authAreaId" value="${fdAuthAreaId}"> 
						<xform:text property="authAreaName" showStatus="view" value="${fdAuthAreaName}"/>	
					</td>	
				</tr >
				</c:if>
				<c:if test="${kmsKnowledgeWikiTemplateForm.method_GET=='edit' }">
					<tr class="multidoctr">	
				    <th>
				        <bean:message key="sysAuthArea.authArea" bundle="sys-authorization" />：
					</th>
					<td colspan="3">
						<input type="hidden" name="authAreaId" value="${kmsKnowledgeWikiTemplateForm.authAreaId}"> 
						<xform:text property="authAreaName" showStatus="view" />	
					</td>	
				</tr >
				</c:if>
			
				<% } %>
				<tr>
					<td colspan="4">
						<%@ include file="/kms/knowledge/kms_knowledge_wiki_template/kmsKnowledgeWikiTemplate_edit_catelog.jsp" %>
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
							<xform:address propertyId="docCreatorId" propertyName="docCreatorName" orgType="ORG_TYPE_PERSON" showStatus="view" />
						</td>
						<td class="td_normal_title" width=15%>
							<bean:message bundle="kms-knowledge" key="kmsKnowledgeWikiTemplate.docCreateTime"/>
						</td><td width="35%">
							<xform:datetime property="docCreateTime" showStatus="view" />
						</td>
					</tr>
				</c:if>
				<c:if test="${not empty kmsKnowledgeWikiTemplateForm.docAlterorId }">
					<tr>
						<td class="td_normal_title" width=15%>
							<bean:message bundle="kms-knowledge" key="kmsKnowledgeWikiTemplate.docAlteror"/>
						</td><td width="35%">
							<xform:address propertyId="docAlterorId" propertyName="docAlterorName" orgType="ORG_TYPE_PERSON" showStatus="view" />
						</td>
						<td class="td_normal_title" width=15%>
							<bean:message bundle="kms-knowledge" key="kmsKnowledgeWikiTemplate.docAlterTime"/>
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