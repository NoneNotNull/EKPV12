<%@ page
	language="java"
	contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<script>
	Com_IncludeFile("dialog.js");
</script>
<script language="JavaScript">
   var fdModelId='${param.fdModelId}';
   var fdModelName='${param.fdModelName}';
   var fdWorkId='${param.fdWorkId}';
   var fdPhaseId='${param.fdPhaseId}';
   var url='<c:url value="/km/doc/km_doc_knowledge/kmDocKnowledge.do" />?method=add&fdTemplateId=!{id}&fdTemplateName=!{name}';
   if(fdModelId!=null&&fdModelId!=''){
		url+="&fdModelId="+fdModelId+"&fdModelName="+fdModelName+"&fdWorkId="+fdWorkId+"&fdPhaseId="+fdPhaseId;
	}   
	Com_NewFileFromSimpleCateory('com.landray.kmss.km.doc.model.KmDocTemplate',url);

</script>
<c:if test="${kmDocKnowledgeForm.method_GET=='add' }">
	<%@page import="com.landray.kmss.km.doc.model.KmDocTemplate"%>
	<%@page import="com.landray.kmss.km.doc.service.IKmDocTemplateService"%>
	<%@page import="org.springframework.context.ApplicationContext"%>
	<%@page import="org.springframework.web.context.support.WebApplicationContextUtils"%>
	<%@page import="com.landray.kmss.km.doc.forms.KmDocTemplateForm"%>
	<%@page import="com.landray.kmss.common.actions.RequestContext"%>
	<%
		String templateId = request.getParameter("fdTemplateId");
		ApplicationContext ctx = WebApplicationContextUtils
				.getRequiredWebApplicationContext(request.getSession()
				.getServletContext());
		IKmDocTemplateService templateService = (IKmDocTemplateService) ctx
				.getBean("kmDocTemplateService");
		if (templateId != null&&StringUtil.isNotNull(templateId)) {
			KmDocTemplate template = (KmDocTemplate) templateService
			.findByPrimaryKey(templateId);
			KmDocTemplateForm form = new KmDocTemplateForm();
			templateService.convertModelToForm(form, template,
			new RequestContext(request));
			request.setAttribute("kmDocTemplateForm", form);
		}
	%>
</c:if>
<c:set
	var="sysDocBaseInfoForm"
	value="${kmDocKnowledgeForm}"
	scope="request" />
<html:form
	action="/km/doc/km_doc_knowledge/kmDocKnowledge.do"
	onsubmit="return validateKmDocKnowledgeForm(this);">
	<html:hidden property="fdImportInfo" />
	<%@ include file="kmDocKnowledge_script.jsp"%>
	<div id="optBarDiv"><logic:equal
		name="kmDocKnowledgeForm"
		property="method_GET"
		value="add">
		<kmss:windowTitle
			subjectKey="km-doc:kmDoc.create.title"
			moduleKey="km-doc:table.kmdoc" />
		<input
			type=button
			value="<bean:message key="kmDoc.button.savedraft" bundle="km-doc"/>"
			onclick="commitMethod('save','true');">
		<input
			type=button
			value="<bean:message key="button.submit"/>"
			onclick="commitMethod('save','false');">
	</logic:equal> <logic:equal
		name="kmDocKnowledgeForm"
		property="method_GET"
		value="edit">
		<kmss:windowTitle
			subject="${kmDocKnowledgeForm.docSubject}"
			moduleKey="km-doc:table.kmdoc" />
		<c:if test="${kmDocKnowledgeForm.docStatusFirstDigit=='1'}">
			<input
				type=button
				value="<bean:message key="kmDoc.button.savedraft" bundle="km-doc"/>"
				onclick="commitMethod('update','true');">
		</c:if>
		<c:if test="${kmDocKnowledgeForm.docStatusFirstDigit<'3'}">
			<input
				type=button
				value="<bean:message key="button.submit"/>"
				onclick="commitMethod('update','false');">
		</c:if>
		<c:if test="${kmDocKnowledgeForm.docStatusFirstDigit>='3'}">
			<input
				type=button
				value="<bean:message key="button.submit"/>"
				onclick="Com_Submit(document.kmDocKnowledgeForm, 'update');">
		</c:if>
	</logic:equal> <input
		type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();"></div>
	<c:if test="${empty kmDocKnowledgeForm.docSubject}">
		<p class="txttitle"><bean:message bundle="km-doc" key="kmDoc.form.title" /></p>
	</c:if>
	<c:if test="${!empty kmDocKnowledgeForm.docSubject}">
		<p class="txttitle">${kmDocKnowledgeForm.docSubject }</p>
	</c:if>
	<center>
	<table
		id="Label_Tabel"
		width=95%>
		<html:hidden property="fdId" />
		<tr LKS_LabelName="<bean:message bundle="km-doc" key="kmDoc.form.tab.main.label" />">
			<td>
			<table
				class="tb_normal"
				width=100%>
				<%@ include file="/sys/doc/sys_doc_base_info/sysDocBaseInfo_edit_top.jsp"%>
				<html:hidden property="fdId" />
				<html:hidden property="fdModelId" />
				<html:hidden property="fdModelName" />
				<html:hidden property="fdWorkId" />
				<html:hidden property="fdPhaseId" />
				<tr>
					<td
						class="td_normal_title"
						width="15%"><bean:message
						key="kmDocKnowledge.fdTemplateName"
						bundle="km-doc" /></td>
					<td width="39%"><html:hidden property="fdDocTemplateId" /> <bean:write
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
					<td colspan="3">
					<html:hidden property="docPropertiesIds" />
					<%-----辅类别--原来为不可选  现按照规章制度的 改为 可选或多选--modify by zhouchao 20090520--%>					
					<%--<bean:write
						name="kmDocKnowledgeForm"
						property="docPropertiesNames" />					
					--%>
						<html:text
						property="docPropertiesNames"
						readonly="true"
						styleClass="inputsgl"
						style="width:90%;"  />
					 <a
				href="#"
				onclick="Dialog_property(true, 'docPropertiesIds','docPropertiesNames', ';', ORG_TYPE_PERSON);">
				<bean:message key="dialog.selectOrg" /> 
				</a>
					
					</td> 
				</tr>				    				
<%--				<tr>	

                    <td class="td_normal_title" width="15%">
                        <bean:message key="sysAuthArea.authArea" bundle="sys-authorization" />
					</td>
					<td width="39%">
					    <html:hidden property="authAreaId" /> 
					    <xform:text property="authAreaName" showStatus="view" />	
					</td>				
					<td
						class="td_normal_title"
						width="15%"><bean:message
						bundle="km-doc"
						key="table.kmDocMainProperty" /></td>
					<td width="39%">
					<html:hidden property="docPropertiesIds" />
						<html:text
						property="docPropertiesNames"
						readonly="true"
						styleClass="inputsgl"
						style="width:90%;"  />
					 <a
				href="#"
				onclick="Dialog_property(true, 'docPropertiesIds','docPropertiesNames', ';', ORG_TYPE_PERSON);">
				<bean:message key="dialog.selectOrg" /> 
				</a>
					
					</td>	 
				</tr>
--%>				<%--适用岗位 不要--modify by zhouchao 20090520--%>	
				<%--			
				<tr>
					<td
						class="td_normal_title"
						width="15%"><bean:message
						bundle="km-doc"
						key="table.kmDocMainPost" /></td>
					<td colspan="3"><html:hidden property="docPostsIds" /> <html:textarea
						property="docPostsNames"
						style="width:80%"
						readonly="true" /><a
						href="#"
						onclick="Dialog_Address(true, 'docPostsIds','docPostsNames', ';',ORG_TYPE_POST);"> <bean:message key="dialog.selectOrg" /> </a></td>
				</tr>
				--%>
				<!-- 标签机制 -->
				<c:import url="/sys/tag/include/sysTagMain_edit.jsp"
					charEncoding="UTF-8">
					<c:param name="formName" value="kmDocKnowledgeForm" />
					<c:param name="fdKey" value="mainDoc" /> 
					<c:param name="modelName" value="com.landray.kmss.km.doc.model.KmDocKnowledge" />
					<c:param name="fdQueryCondition" value="fdDocTemplateId;docDeptId" /> 
				</c:import>
				<!-- 标签机制 -->	
				<tr>
					<td
						class="td_normal_title"
						width=15%><bean:message
						bundle="km-doc"
						key="kmDocTemplate.fdStoretime" /></td>
					<td colspan="3"><html:text property="docExpire" />
						<bean:message key="message.storetime" bundle="km-doc" />
						<bean:message key="message.storetime.tip" bundle="km-doc" />
						</td>
				</tr>
				<%@ include file="/sys/doc/sys_doc_base_info/sysDocBaseInfo_edit_bottom.jsp"%>
				<c:if test="${kmDocKnowledgeForm.method_GET=='add' }">
					<tr>
						<td
							class="td_normal_title"
							width=15%><bean:message
							bundle="km-doc"
							key="kmDoc.rattachement" /></td>
						<td colspan="3">
						<c:import
							url="/sys/attachment/sys_att_main/sysAttMain_view.jsp"
							charEncoding="UTF-8">
							<c:param
								name="fdKey"
								value="rattachment" />
							<c:param
								name="formBeanName"
								value="kmDocTemplateForm" />
						</c:import></td>
					</tr>
				</c:if>
			</table>
			</td>
		</tr>
		<c:import
			url="/sys/evaluation/include/sysEvaluationMain_edit.jsp"
			charEncoding="UTF-8">
			<c:param
				name="formName"
				value="kmDocKnowledgeForm" />
		</c:import>
		<c:import
			url="/sys/introduce/include/sysIntroduceMain_edit.jsp"
			charEncoding="UTF-8">
			<c:param
				name="formName"
				value="kmDocKnowledgeForm" />
		</c:import>
		<c:import
			url="/sys/readlog/include/sysReadLog_edit.jsp"
			charEncoding="UTF-8">
			<c:param
				name="formName"
				value="kmDocKnowledgeForm" />
		</c:import>
		<!-- 流程 -->
		<c:import url="/sys/workflow/include/sysWfProcess_edit.jsp"
			charEncoding="UTF-8">
			<c:param name="formName" value="kmDocKnowledgeForm" />
			<c:param name="fdKey" value="mainDoc" />
		</c:import>
		<c:import
			url="/sys/edition/include/sysEditionMain_edit.jsp"
			charEncoding="UTF-8">
			<c:param
				name="formName"
				value="kmDocKnowledgeForm" />
		</c:import>
		<%---发布机制 开始---%>
		<c:import
			url="/sys/news/include/sysNewsPublishMain_edit.jsp"
			charEncoding="UTF-8">
			<c:param
				name="formName"
				value="kmDocKnowledgeForm" />
			<c:param name="fdKey" value="mainDocPublish" />	 
			<c:param name="isShow" value="true" /><%--是否显示--%>
		</c:import> 	
		<%---发布机制 结束---%>
		<%---关联机制 开始----%>
		<tr LKS_LabelName="<bean:message bundle="sys-relation" key="sysRelationMain.tab.label" />">
			<c:set
				var="mainModelForm"
				value="${kmDocKnowledgeForm}"
				scope="request" />
			<c:set
				var="currModelName"
				value="com.landray.kmss.km.doc.model.KmDocKnowledge"
				scope="request" />
			<td><%@ include file="/sys/relation/include/sysRelationMain_edit.jsp"%></td>
		</tr>
		<%---关联机制 结束----%>
		<tr LKS_LabelName="<bean:message bundle="sys-right" key="right.moduleName" />">
			<td>
			<table
				class="tb_normal"
				width=100%>
				<c:import
					url="/sys/right/right_edit.jsp"
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
	</table>
	</center>
	<html:hidden property="method_GET" />
</html:form>
<!-- 校验代码生成语句-->
<html:javascript
	formName="kmDocKnowledgeForm"
	cdata="false"
	dynamicJavascript="true"
	staticJavascript="false" />
<%@ include file="/resource/jsp/edit_down.jsp"%>
