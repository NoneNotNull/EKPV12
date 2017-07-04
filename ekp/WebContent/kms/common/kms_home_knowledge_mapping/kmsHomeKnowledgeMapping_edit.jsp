<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<html:form action="/kms/common/kms_home_knowledge_mapping/kmsHomeKnowledgeMapping.do">
<div id="optBarDiv">
	<c:if test="${kmsHomeKnowledgeMappingForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit(document.kmsHomeKnowledgeMappingForm, 'update');">
	</c:if>
	<c:if test="${kmsHomeKnowledgeMappingForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="Com_Submit(document.kmsHomeKnowledgeMappingForm, 'save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="Com_Submit(document.kmsHomeKnowledgeMappingForm, 'saveadd');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="kms-common" key="table.kmsHomeKnowledgeMapping"/></p>

<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-common" key="kmsHomeKnowledgeMapping.docSubject"/>
		</td><td width="35%">
			<xform:text property="docSubject" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-common" key="kmsHomeKnowledgeMapping.fdUrl"/>
		</td><td width="35%">
			<xform:text property="fdUrl" style="width:85%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-common" key="kmsHomeKnowledgeMapping.fdMainContent"/>
		</td><td width="35%">
			<xform:text property="fdMainContent" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-common" key="kmsHomeKnowledgeMapping.fdIsFirst"/>
		</td><td width="35%">
			<xform:radio property="fdIsFirst">
				<xform:enumsDataSource enumsType="common_yesno" />
			</xform:radio>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-common" key="kmsHomeKnowledgeMapping.fdMapping"/>
		</td><td width="35%">
			<xform:select property="fdMappingId">
				<xform:beanDataSource serviceBean="kmsHomeKnowledgeIntroService" selectBlock="fdId,fdName" orderBy="" />
			</xform:select>
		</td>
		<td class="td_normal_title" width=15%>&nbsp;</td><td width=35%>&nbsp;</td>
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