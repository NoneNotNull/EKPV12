<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<%@ page
	import="org.springframework.web.context.support.WebApplicationContextUtils"%>
<%@ page import="org.springframework.context.ApplicationContext"%>
<%@ page
	import="com.landray.kmss.sys.attachment.service.*,com.landray.kmss.km.review.service.IKmReviewTemplateService,com.landray.kmss.km.review.model.KmReviewTemplate,com.landray.kmss.km.review.forms.*,com.landray.kmss.common.actions.RequestContext"%>
<script type="text/javascript">
Com_IncludeFile("dialog.js|doclist.js");
</script>
<script language="JavaScript">
		Com_NewFile('com.landray.kmss.km.review.model.KmReviewTemplate','<c:url value="/km/review/km_review_main/kmReviewMain.do" />?method=add&fdTemplateId=!{id}&fdTemplateName=!{name}&fdWorkId=${param.fdWorkId}&fdPhaseId=${param.fdPhaseId}&fdModelId=${param.fdModelId}&fdModelName=${param.fdModelName}');		
		function locateCursor() {
			var rows = document.getElementById("TABLE_DocList").rows;
			var input_element = document.getElementsByName("fdRelationDoc["+(rows.length-2)+"].fdName");
			if(input_element[0]) {
				input_element[0].focus();
			}
		}
</script>
<kmss:windowTitle 
	moduleKey="km-review:table.kmReviewMain" 
	subjectKey="km-review:table.kmReviewMain" 
	subject="${kmReviewMainForm.docSubject}" />
<html:form action="/km/review/km_review_main/kmReviewMain.do" >
	<%
		String templateId = request.getParameter("fdTemplateId");
		KmReviewMainForm mainForm = (KmReviewMainForm) request
				.getAttribute("kmReviewMainForm");
		if (templateId == null && null != mainForm)
			templateId = mainForm.getFdTemplateId();
		ApplicationContext ctx = WebApplicationContextUtils
				.getRequiredWebApplicationContext(request.getSession()
				.getServletContext());
		IKmReviewTemplateService templateService = (IKmReviewTemplateService) ctx
				.getBean("kmReviewTemplateService");
		if (templateId != null) {
			KmReviewTemplate template = (KmReviewTemplate) templateService
			.findByPrimaryKey(templateId);
			KmReviewTemplateForm form = new KmReviewTemplateForm();
			templateService.convertModelToForm(form, template,
			new RequestContext(request));
			request.setAttribute("kmReviewTemplateForm", form);
		}
	%>
	<div id="optBarDiv">
	<c:if
		test="${kmReviewMainForm.method_GET=='edit'&&kmReviewMainForm.docStatus=='10'}">
		<input type=button value="<bean:message key="button.savedraft"/>"
			onclick="Com_Submit(document.kmReviewMainForm, 'update');">
	</c:if> 
	<c:if
		test="${kmReviewMainForm.method_GET=='edit'&&(kmReviewMainForm.docStatus=='10'||kmReviewMainForm.docStatus=='11'||kmReviewMainForm.docStatus=='20')}">
		<input type=button value="<bean:message key="button.submit"/>"
			onclick="Com_Submit(document.kmReviewMainForm, 'publishDraft');">
	</c:if> 
	<c:if test="${kmReviewMainForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.savedraft"/>"
			onclick="Com_Submit(document.kmReviewMainForm, 'saveDraft');">
		<input type=button value="<bean:message key="button.submit"/>"
			onclick="Com_Submit(document.kmReviewMainForm, 'save');">
	</c:if> <input type="button" value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();"></div>

<p class="txttitle">
	<c:if test="${empty kmReviewMainForm.docSubject}"><bean:message bundle="km-review" key="table.kmReviewMain" /></c:if>
	<c:if test="${not empty kmReviewMainForm.docSubject}"><c:out value="${kmReviewMainForm.docSubject}" /></c:if>
</p>

	<center>
	<table id="Label_Tabel" width=95%>
		<!-- 基本信息 -->
		<tr
			LKS_LabelName="<bean:message bundle='km-review' key='kmReviewDocumentLableName.baseInfo'/>">
			<td>
			<html:hidden property="fdId" />
			<html:hidden property="fdWorkId" />
			<html:hidden property="fdPhaseId" />
			<html:hidden property="fdModelId" />
			<html:hidden property="fdModelName" />
			<html:hidden property="docStatus" />
			<table class="tb_normal" width=100%>
				<!--主题-->
				<tr>
					<td class="td_normal_title" width=15%><bean:message
						bundle="km-review" key="kmReviewMain.docSubject" /></td>
					<td colspan=3>
						<xform:text property="docSubject" style="width:80%" />
					</td>
				</tr>
				<!--关键字-->
				<tr>
					<td class="td_normal_title" width=15%><bean:message
						bundle="km-review" key="kmReviewKeyword.fdKeyword" /></td>
					<td colspan=3><html:text property="fdKeywordNames"
						style="width:80%;" /></td>
				</tr>
				<!--流程类别-->
				<tr>
					<td class="td_normal_title" width=15%><bean:message
						bundle="km-review" key="kmReviewTemplate.fdName" /></td>
					<td colspan=3><html:hidden property="fdTemplateId" /> <bean:write
						name="kmReviewMainForm" property="fdTemplateName" /></td>
				</tr>
				<!--申请人-->
				<tr>
					<td class="td_normal_title" width=15%><bean:message
						bundle="km-review" key="kmReviewMain.docCreatorName" /></td>
					<td width=35%><bean:write name="kmReviewMainForm"
						property="docCreatorName" /></td>
					<td class="td_normal_title" width=15%><bean:message
						bundle="km-review" key="kmReviewMain.fdNumber" /></td>
					<td width=35%>
						<c:if test="${kmReviewMainForm.fdNumber!=null}">
							<html:text property="fdNumber" readonly="true" />
						</c:if>
						<c:if test="${kmReviewMainForm.fdNumber==null}">
							<bean:message bundle="km-review" key="kmReviewMain.fdNumber.message" />
						</c:if>
					</td>
				</tr>
				<!--部门-->
				<tr>
					<td class="td_normal_title" width=15%><bean:message
						bundle="km-review" key="kmReviewMain.department" /></td>
					<td><bean:write name="kmReviewMainForm"
						property="fdDepartmentName" /></td>
					<td class="td_normal_title" width=15%><bean:message
						bundle="km-review" key="kmReviewMain.docCreateTime" /></td>
					<td width=35%><bean:write name="kmReviewMainForm"
						property="docCreateTime" /> <html:hidden property="docCreateTime" />
					</td>
				</tr>
				<!--状态-->
				<tr>
					<td class="td_normal_title" width=15%>
						<bean:message bundle="km-review" key="kmReviewMain.docStatus" />
					</td>
					<td>
						<c:if test="${kmReviewMainForm.docStatus=='00'}">
							<bean:message key="status.discard"/>
						</c:if>
						<c:if test="${kmReviewMainForm.docStatus=='10'}">
							<bean:message key="status.draft"/>
						</c:if>
						<c:if test="${kmReviewMainForm.docStatus=='11'}">
							<bean:message key="status.refuse"/>
						</c:if>
						<c:if test="${kmReviewMainForm.docStatus=='20'}">
							<bean:message key="status.examine"/>
						</c:if>
						<c:if test="${kmReviewMainForm.docStatus=='30'}">
							<bean:message key="status.publish"/>
						</c:if>
						<c:if test="${kmReviewMainForm.docStatus=='31'}">
							<bean:message key="status.feedback" bundle="km-review"/>
						</c:if>
					</td>
					<td class="td_normal_title" width=15%>
						<bean:message bundle="km-review" key="kmReviewMain.docPublishTime" />
					</td>
					<td width=35%>
						<bean:write name="kmReviewMainForm" property="docPublishTime" />
					</td>
				</tr>
				<!--实施反馈人-->
				<tr>
					<td class="td_normal_title" width=15%><bean:message
						bundle="km-review" key="table.kmReviewFeedback" /></td>
					<td colspan=3><html:hidden property="fdFeedbackIds" /> <html:hidden
						property="fdFeedbackModify" /> <html:text
						property="fdFeedbackNames" style="width:80%" readonly="true"
						styleClass="inputsgl" /> <c:if
						test="${kmReviewMainForm.fdFeedbackModify=='1'}">
						<a href="#"
							onclick="Dialog_Address(true, 'fdFeedbackIds','fdFeedbackNames', ';',null);"><bean:message
							key="dialog.selectOther" /></a>
					</c:if></td>

				</tr>
				<%-- 所属场所 --%>
				<c:import url="/sys/authorization/sys_auth_area/sysAuthArea_field.jsp" charEncoding="UTF-8">
                     <c:param name="id" value="${kmReviewMainForm.authAreaId}"/>
                </c:import> 
				
				<!--适用岗位-->
				<%--适用岗位不要了，modify by zhouchao--%>
				<%--<tr>
					<td class="td_normal_title" width=15%><bean:message
						bundle="km-review" key="table.kmReviewPost" /></td>
					<td colspan=3><html:hidden property="fdPostIds" /> <html:textarea
						property="fdPostNames" style="width:80%" readonly="true" /> <a
						href="#"
						onclick="Dialog_Address(true, 'fdPostIds','fdPostNames', ';',ORG_TYPE_POST);"><bean:message
						key="dialog.selectOther" /></a></td>
				</tr>
				--%>
				<!--其他属性-->
				
				<tr>
					<td class="td_normal_title" width=15%><bean:message
						bundle="km-review" key="table.sysCategoryProperty" /></td>
						
					<%-----辅类别--原来为不可选  现按照规章制度的 改为 可选或多选
					                   --modify by zhouchao 20090520--%>						
					<td colspan=3><html:hidden property="docPropertyIds" />
					<%-- <html:text
						property="docPropertyNames" style="width:80%" readonly="true" />
					</td>
				    --%>
				    <html:text property="docPropertyNames" readonly="true" 	styleClass="inputsgl"
						style="width:80%;"  />
					 <a href="#" onclick="Dialog_property(true, 'docPropertyIds','docPropertyNames', ';', ORG_TYPE_PERSON);">
					<bean:message key="dialog.selectOrg" /> 
					</a>				
				</tr>
			</table>
			</td>
		</tr>
		<!-- 审批内容 -->
		<%--
		<tr
			LKS_LabelName="">
			<td>
			<table class="tb_normal" width=100%>
				<!-- 内容 -->
				<tr>
					<td class="td_normal_title" width=17%><bean:message
						bundle="km-review" key="kmReviewMain.docContent" /></td>
					<td colspan=3><kmss:editor property="docContent"
						toolbarSet="Default" height="500" /></td>
				</tr>
				<!-- 相关附件 -->
				<tr KMSS_RowType="documentNews">
					<td class="td_normal_title" width=17%><bean:message
						bundle="km-review" key="kmReviewMain.attachment" /></td>
					<td colspan=3><c:import
						url="/sys/attachment/sys_att_main/sysAttMain_edit.jsp"
						charEncoding="UTF-8">
						<c:param name="fdAttType" value="byte" />
						<c:param name="fdMulti" value="true" />
						<c:param name="fdImgHtmlProperty" />
						<c:param name="fdKey" value="fdAttachment" />
						<c:param name="fdModelId" value="${param.fdId }" />
						<c:param name="fdModelName"
							value="com.landray.kmss.km.review.model.KmReviewMain" />
					</c:import></td>
				</tr>
				<!-- 参考附件 -->
				<c:if
					test="${kmReviewMainForm.method_GET=='add'||kmReviewMainForm.method_GET=='addsave'||kmReviewMainForm.method_GET=='edit'}">
					<tr KMSS_RowType="documentNews">
						<td class="td_normal_title" width=15%><bean:message
							bundle="km-review" key="kmReviewTemplate.fdAttachment" /></td>
						<td colspan=3><c:import
							url="/sys/attachment/sys_att_main/sysAttMain_view.jsp"
							charEncoding="UTF-8">
							<c:param name="fdMulti" value="true" />
							<c:param name="formBeanName" value="kmReviewTemplateForm" />
							<c:param name="fdKey" value="ConsultAttachment" />
						</c:import></td>
					</tr>
				</c:if>
			</table>
			</td>
		</tr>
		--%>
		<c:if test="${kmReviewMainForm.fdUseForm == 'false'}">
		<tr LKS_LabelName="<kmss:message key='km-review:kmReviewDocumentLableName.reviewContent'/>">
			<td>
				<table class="tb_normal" width=100%>
					<tr>
						<td colspan="2">
							<kmss:editor property="docContent" toolbarSet="Default" height="1000" needFilter="true"/>
						</td>
					</tr>
					<!-- 相关附件 -->
					<tr KMSS_RowType="documentNews">
						<td class="td_normal_title" width=17%><bean:message
							bundle="km-review" key="kmReviewMain.attachment" /></td>
						<td colspan=3><c:import
							url="/sys/attachment/sys_att_main/sysAttMain_edit.jsp"
							charEncoding="UTF-8">
							<c:param name="fdAttType" value="byte" />
							<c:param name="fdMulti" value="true" />
							<c:param name="fdImgHtmlProperty" />
							<c:param name="fdKey" value="fdAttachment" />
							<c:param name="fdModelId" value="${param.fdId }" />
							<c:param name="fdModelName"
								value="com.landray.kmss.km.review.model.KmReviewMain" />
						</c:import></td>
					</tr>
				</table>	
			</td>
		</tr>
		</c:if>
		<c:if test="${kmReviewMainForm.fdUseForm == 'true' || empty kmReviewMainForm.fdUseForm}">
		<%-- 表单 --%>
		<c:import url="/sys/xform/include/sysForm_edit.jsp"
			charEncoding="UTF-8">
			<c:param name="formName" value="kmReviewMainForm" />
			<c:param name="fdKey" value="reviewMainDoc" />
			<c:param name="messageKey" value="km-review:kmReviewDocumentLableName.reviewContent" />
		</c:import>
		</c:if>

		<!-- 流程 -->
		<c:import url="/sys/workflow/include/sysWfProcess_edit.jsp"
			charEncoding="UTF-8">
			<c:param name="formName" value="kmReviewMainForm" />
			<c:param name="fdKey" value="reviewMainDoc" />
			<c:param name="showHistoryOpers" value="true" />
		</c:import>

		<!-- 关联信息 -->
		<c:import url="/sys/relation/include/sysRelationMain_edit.jsp" charEncoding="UTF-8">
			<c:param name="formName" value="kmReviewMainForm" />
			<c:param name="useTab" value="true" />
		</c:import>
		
		<c:import url="/sys/readlog/include/sysReadLog_edit.jsp"
			charEncoding="UTF-8">
			<c:param name="formName" value="kmReviewMainForm" />
		</c:import>
		<!-- 权限机制-->
		<tr LKS_LabelName="<bean:message bundle="sys-right" key="right.moduleName" />" style="display:none">
			<td>
				<table class="tb_normal" width=100%>
					<c:import url="/sys/right/right_edit.jsp" charEncoding="UTF-8">
						<c:param
							name="formName"
							value="kmReviewMainForm" />
						<c:param
							name="moduleModelName"
							value="com.landray.kmss.km.review.model.KmReviewMain" />
					</c:import>
				</table>
			</td>
		</tr>
		<!-- 权限机制 -->
	</table>
	</center>
	<html:hidden property="method_GET" />
</html:form>
<script language="JavaScript">
Com_IncludeFile("calendar.js");
$KMSSValidation(document.forms['kmReviewMainForm']);
</script>
<%--html:javascript formName="kmReviewMainForm" cdata="false"
	dynamicJavascript="true" staticJavascript="false" /--%>
<%@ include file="/resource/jsp/edit_down.jsp"%>
