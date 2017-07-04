<%@ page
	language="java"
	contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<script>
function confirmDelete(msg){
	var del = confirm("<bean:message key="page.comfirmDelete"/>");
	return del;
}
Com_IncludeFile("dialog.js");
</script>
<kmss:windowTitle
	subject="${kmDocKnowledgeForm.docSubject}"
	moduleKey="km-doc:table.kmdoc" />
<c:set
	var="sysDocBaseInfoForm"
	value="${kmDocKnowledgeForm}"
	scope="request" />
<%@ include file="kmDocKnowledge_script.jsp"%>
<div id="optBarDiv">
     <input type="button" value="<bean:message key="kmDoc.button.copyLink" bundle="km-doc"/>"
			onclick="copyLink();">
	 <c:if test="${kmDocKnowledgeForm.docStatusFirstDigit > '0' }">
		<kmss:auth
		requestURL="/km/doc/km_doc_knowledge/kmDocKnowledge.do?method=edit&fdId=${param.fdId}"
		requestMethod="GET">
		<input
			type="button"
			value="<bean:message key="button.edit"/>"
			onclick="Com_OpenWindow('kmDocKnowledge.do?method=edit&fdId=${param.fdId}','_self');">
	</kmss:auth> 
</c:if>
<kmss:auth
	requestURL="/km/doc/km_doc_knowledge/kmDocKnowledge.do?method=delete&fdId=${param.fdId}"
	requestMethod="GET">
	<input
		type="button"
		value="<bean:message key="button.delete"/>"
		onclick="if(!confirmDelete())return;Com_OpenWindow('kmDocKnowledge.do?method=delete&fdId=${param.fdId}','_self');">
</kmss:auth>
<c:if test="${kmDocKnowledgeForm.docStatusFirstDigit >= '3' }">
	<input type="button"
		value="<bean:message key="button.back" bundle="km-doc"/>"
		onclick="Com_OpenWindow('kmDocKnowledge.do?method=view&fdId=${param.fdId}','_self');" />
</c:if>
<input
	type="button"
	value="<bean:message key="button.close"/>"
	onclick="Com_CloseWindow();"></div>
	<p class="txttitle"><bean:write	name="sysDocBaseInfoForm" property="docSubject" /></p>
<center>
<c:if test="${isHasNewVersion=='true'}">
		<div style="color:red"><bean:message bundle="km-doc" key="kmDoc.kmDocKnowledge.has" /><bean:message bundle="km-doc" key="kmDoc.kmDocKnowledge.NewVersion" /></div>
	</c:if>
<table
	id="Label_Tabel"
	width=95%>
	<tr LKS_LabelName="<bean:message bundle="km-doc" key="kmDoc.form.tab.main.label" />">
		<td>
		<table
			class="tb_normal"
			width=100%>
			<%@ include file="/sys/doc/sys_doc_base_info/sysDocBaseInfo_view_top.jsp"%>
			<tr>
				<td
					class="td_normal_title"
					width="15%"><bean:message
					key="kmDocKnowledge.fdTemplateName"
					bundle="km-doc" /></td>
				<td width="39%"><bean:write
					name="kmDocKnowledgeForm"
					property="fdDocTemplateName" /></td>
				<td
						class="td_normal_title"
						width="15%"><bean:message
						key="kmDocKnowledge.docPublishTime"
						bundle="km-doc" /></td>
						
					<td width="39%"><bean:write
						name="kmDocKnowledgeForm"
						property="docPublishTime" /></td>
			</tr>
            <%-- 所属场所 --%>
            <c:import url="/sys/authorization/sys_auth_area/sysAuthArea_field.jsp" charEncoding="UTF-8">
                <c:param name="id" value="${kmDocKnowledgeForm.authAreaId}"/>
            </c:import>  	
			<tr>
				<td
					class="td_normal_title"
					width="15%"><bean:message
					bundle="km-doc"
					key="table.kmDocMainProperty" /></td>
				<td colspan="3"><bean:write
					name="kmDocKnowledgeForm"
					property="docPropertiesNames" /></td>
			</tr>
<%--
			<tr>
                <td class="td_normal_title" width="15%">
                    <bean:message key="sysAuthArea.authArea"
				    bundle="sys-authorization" />
			    </td>
				<td width="39%">
                    <xform:text property="authAreaName" />					
				</td>			
				<td
					class="td_normal_title"
					width="15%"><bean:message
					bundle="km-doc"
					key="table.kmDocMainProperty" /></td>
				<td colspan="3"><bean:write
					name="kmDocKnowledgeForm"
					property="docPropertiesNames" /></td>
			</tr>
--%>			<%--适用岗位 不要--modify by zhouchao 20090520--%>	
			<%--
			<tr>
				<td
					class="td_normal_title"
					width="15%"><bean:message
					bundle="km-doc"
					key="table.kmDocMainPost" /></td>
				<td colspan="3"><bean:write
					name="kmDocKnowledgeForm"
					property="docPostsNames" /></td>
			</tr>
			--%>
			<!-- 标签机制 -->
			<c:import url="/sys/tag/include/sysTagMain_view.jsp"
				charEncoding="UTF-8">
				<c:param name="formName" value="kmDocKnowledgeForm" />
				<c:param name="fdKey" value="mainDoc" /> 
			</c:import>
			<!-- 标签机制 -->
			<tr>
				<td
					class="td_normal_title"
					width=15%><bean:message
					bundle="km-doc"
					key="kmDocTemplate.fdStoretime" /></td>
				<td colspan="3"><bean:write
					name="kmDocKnowledgeForm"
					property="docExpire" /><bean:message
					key="message.storetime"
					bundle="km-doc" /><bean:message
					key="message.storetime.tip"
					bundle="km-doc" /></td>
			</tr>
			<%@ include file="/sys/doc/sys_doc_base_info/sysDocBaseInfo_view_bottom.jsp"%>
		</table>
		</td>
	</tr>
	<c:import
		url="/sys/evaluation/include/sysEvaluationMain_view.jsp"
		charEncoding="UTF-8">
		<c:param
			name="formName"
			value="kmDocKnowledgeForm" />
	</c:import>
	<c:import
		url="/sys/introduce/include/sysIntroduceMain_view.jsp"
		charEncoding="UTF-8">
		<c:param name="formName" value="kmDocKnowledgeForm" />
		<c:param name="fdKey" value="mainDoc" />
		<c:param name="toEssence" value="true" />
		<c:param name="toNews" value="true" />
		<c:param name="docSubject" value="${kmDocKnowledgeForm.docSubject}" />
		<c:param name="docCreatorName" value="${kmDocKnowledgeForm.docCreatorName}" />
	</c:import>
	<%--发布机制开始--%>
	<c:import
		url="/sys/news/include/sysNewsPublishMain_view.jsp"
		charEncoding="UTF-8">
		<c:param
			name="formName"
			value="kmDocKnowledgeForm" />
	</c:import>
	<%--发布机制结束--%>
	<c:import
		url="/sys/readlog/include/sysReadLog_view.jsp"
		charEncoding="UTF-8">
		<c:param
			name="formName"
			value="kmDocKnowledgeForm" />
	</c:import>
		<c:import url="/sys/workflow/include/sysWfProcess_view.jsp"
			charEncoding="UTF-8">
			<c:param name="formName" value="kmDocKnowledgeForm" />
			<c:param name="fdKey" value="mainDoc" />
		</c:import>
	<c:import
		url="/sys/edition/include/sysEditionMain_view.jsp"
		charEncoding="UTF-8">
		<c:param
			name="formName"
			value="kmDocKnowledgeForm" />
	</c:import>
	
	<c:import
		url="/sys/relation/include/sysRelationMain_view.jsp"
		charEncoding="UTF-8">
		<c:param
			name="formName"
			value="kmDocKnowledgeForm" />
		<c:param
			name="useTab"
			value="true" />
	</c:import>
	
	<tr LKS_LabelName="<bean:message bundle="sys-right" key="right.moduleName" />">
		<td>
		<table
			class="tb_normal"
			width=100%>
			<c:import
				url="/sys/right/right_view.jsp"
				charEncoding="UTF-8">
				<c:param
					name="formName"
					value="kmDocKnowledgeForm" />
				<c:param
					name="moduleModelName"
					value="com.landray.kmss.km.doc.model.KmDocKnowledge" />
			</c:import>
		</table>
		</td>
	</tr>
	<%--bookmark--%>
	<c:import url="/sys/bookmark/include/bookmark_bar.jsp"
		charEncoding="UTF-8">
		<c:param name="fdSubject" value="${kmDocKnowledgeForm.docSubject}" />
		<c:param name="fdModelId" value="${kmDocKnowledgeForm.fdId}" />
		<c:param name="fdModelName"
			value="com.landray.kmss.km.doc.model.KmDocKnowledge" />
	</c:import>
	<!-- 旧数据查询 -->
	<kmss:ifModuleExist path="/tools/datatransfer/">
		<c:import
			url="/tools/datatransfer/include/toolsDatatransfer_old_data.jsp"
			charEncoding="UTF-8">
			<c:param
				name="fdModelId"
				value="${kmDocKnowledgeForm.fdId}" />
			<c:param name="fdModelName"
			    value="com.landray.kmss.km.doc.model.KmDocKnowledge" />	
		</c:import>
	</kmss:ifModuleExist>
</table>
<input type="hidden" name="docSubject" />
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>
