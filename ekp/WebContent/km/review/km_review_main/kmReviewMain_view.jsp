<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<%@page import="java.util.List"%>
<%@page import="com.landray.kmss.km.review.forms.KmReviewMainForm"%>
<%--bookmark--%>
<c:import url="/sys/bookmark/include/bookmark_bar.jsp"
	charEncoding="UTF-8">
	<c:param name="fdSubject" value="${kmReviewMainForm.docSubject}" />
	<c:param name="fdModelId" value="${kmReviewMainForm.fdId}" />
	<c:param name="fdModelName"
		value="com.landray.kmss.km.review.model.KmReviewMain" />
</c:import>
<script>
Com_IncludeFile("docutil.js|optbar.js|validator.jsp|validation.js|plugin.js|validation.jsp|xform.js", null, "js");
Com_IncludeFile("calendar.js|dialog.js|doclist.js");
Com_IncludeFile("label_doc.js", "${KMSS_Parameter_ContextPath}km/review/resource/style/doc/","js",true);

function confirmDelete(msg){
	var del = confirm('<bean:message key="page.comfirmDelete"/>');
	return del;
}

function feedBack_LoadIframe(){
	Doc_LoadFrame('feedbackList','<c:url value="/km/review/km_review_feedback_info/kmReviewFeedbackInfo.do" />?method=list&fdModelName=com.landray.kmss.km.review.model.KmReviewMain&fdModelId=${kmReviewMainForm.fdId}&currentVer=${sysEditionForm.mainVersion}.${sysEditionForm.auxiVersion}');
}
</script>

<kmss:windowTitle moduleKey="km-review:table.kmReviewMain" subjectKey="km-review:table.kmReviewMain" subject="${kmReviewMainForm.docSubject}" />

<html:form action="/km/review/km_review_main/kmReviewMain.do">
<div id="optBarDiv">
	<logic:equal name="kmReviewMainForm"
		property="method_GET" value="view">
		<c:if test="${kmReviewMainForm.docStatus=='10' || kmReviewMainForm.docStatus=='11'|| kmReviewMainForm.docStatus=='20'}">
			<kmss:auth
				requestURL="/km/review/km_review_main/kmReviewMain.do?method=edit&fdId=${param.fdId}"
				requestMethod="GET">
				<input type="button" value="<bean:message key="button.edit"/>"
					onclick="Com_OpenWindow('kmReviewMain.do?method=edit&fdId=${param.fdId}','_self');"/>
			</kmss:auth>
		</c:if>
	</logic:equal> <!-- 发布或已反馈 --> 
	<logic:equal name="kmReviewMainForm" property="method_GET" value="view">
		<c:if test="${kmReviewMainForm.docStatus=='30' || kmReviewMainForm.docStatus=='31'}">
			<!-- 实施反馈 -->
			<kmss:auth
				requestURL="/km/review/km_review_feedback_info/kmReviewFeedbackInfo.do?method=add&fdMainId=${param.fdId}&fdCreatorId=${kmReviewMainForm.docCreatorId}"
				requestMethod="GET">
				<input type=button
					value="<bean:message key="button.feedback.info" bundle="km-review"/>"
					onclick="Com_OpenWindow('<c:url value="/km/review/km_review_feedback_info/kmReviewFeedbackInfo.do" />?method=add&fdMainId=${param.fdId}&fdCreatorId=${kmReviewMainForm.docCreatorId}');"/>
			</kmss:auth>
			<c:if test="${kmReviewMainForm.fdFeedbackExecuted!='1' && kmReviewMainForm.fdFeedbackModify=='1'}">
				<kmss:auth requestURL="/km/review/km_review_main/kmReviewChangeFeedback.jsp?fdId=${param.fdId}"	requestMethod="GET">
					<!-- 指定反馈人 -->
					<input type=button
						value="<bean:message key="button.feedback.people" bundle="km-review"/>"
						onclick="Com_OpenWindow('<c:url value="/km/review/km_review_main/kmReviewChangeFeedback.jsp"/>?fdId=${param.fdId}');"/>
				</kmss:auth>
			</c:if>
			<!-- 修改权限 -->
			<kmss:auth requestURL="/km/review/km_review_main/kmReviewMain.do?method=editRight&fdId=${param.fdId}" requestMethod="GET">
				<input type=button
					value="<bean:message key="button.modify.permission" bundle="km-review"/>"
					onclick="Com_OpenWindow('<c:url value="/km/review/km_review_main/kmReviewMain.do"/>?method=editRight&fdId=${param.fdId }');"/>
			</kmss:auth>
		</c:if>
	</logic:equal> 
	<kmss:auth requestURL="/km/review/km_review_main/kmReviewMain.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
		<input type="button" value="<bean:message key="button.delete"/>"
			onclick="if(!confirmDelete())return;Com_OpenWindow('kmReviewMain.do?method=delete&fdId=${param.fdId}','_self');"/>
	</kmss:auth> 
	<!-- 打印 --> 
	<kmss:auth requestURL="/km/review/km_review_main/kmReviewMain.do?method=print&fdId=${param.fdId}" requestMethod="GET">
		<input type=button
			value="<bean:message key="button.print" bundle="km-review"/>"
			onclick="Com_OpenWindow('<c:url value="/km/review/km_review_main/kmReviewMain.do"/>?method=print&fdId=${param.fdId}');"/>
	</kmss:auth> 
	<input type="button" value="<bean:message key="button.close"/>"	onclick="Com_CloseWindow();"/>
</div>

<p class="txttitle">
	<c:if test="${empty kmReviewMainForm.docSubject}"><bean:message bundle="km-review" key="table.kmReviewMain" /></c:if>
	<c:if test="${not empty kmReviewMainForm.docSubject}"><c:out value="${kmReviewMainForm.docSubject}" /></c:if>
</p>
<br/>
<center>
<div class="label_doc_area" id="label_doc_area">
	<html:hidden name="kmReviewMainForm" property="fdId" />
	<%--内容 --%>
	<div class="label_doc" isExpand="1">
		<c:if test="${kmReviewMainForm.fdUseForm == 'false'}">
			<table class="tb_normal" width=100%>
				<tr>
					<td colspan="4">${kmReviewMainForm.docContent}</td>
				</tr>
				<!-- 相关附件 -->
				<tr KMSS_RowType="documentNews">
					<td class="td_normal_title" width=15%><bean:message
						bundle="km-review" key="kmReviewMain.attachment" /></td>
					<td colspan=3><c:import
						url="/sys/attachment/sys_att_main/sysAttMain_view.jsp"
						charEncoding="UTF-8">
						<c:param name="fdMulti" value="true" />
						<c:param name="formBeanName" value="kmReviewMainForm" />
						<c:param name="fdKey" value="fdAttachment" />
					</c:import></td>
				</tr>
			</table>
		</c:if>
		<c:if test="${kmReviewMainForm.fdUseForm == 'true' || empty kmReviewMainForm.fdUseForm}">
			<%-- 表单 --%>
			<c:import url="/sys/xform/include/sysForm_view.jsp"
				charEncoding="UTF-8">
				<c:param name="formName" value="kmReviewMainForm" />
				<c:param name="fdKey" value="reviewMainDoc" />
				<c:param name="messageKey" value="km-review:kmReviewDocumentLableName.reviewContent" />
				<c:param name="useTab" value="false"/>
			</c:import>
		</c:if>
	</div>
	
	<%-- 流程 --%>
	<div class="label_doc" isExpand="1" labelName='<bean:message bundle="km-review" key="kmReviewMain.flowDef" />' useLabel="true" labelType="flow">
		<table class="tb_normal" width=100%>
			<c:import url="/sys/workflow/include/sysWfProcess_view.jsp"
				charEncoding="UTF-8">
				<c:param name="formName" value="kmReviewMainForm" />
				<c:param name="fdKey" value="reviewMainDoc" />
				<c:param name="showHistoryOpers" value="true" />
				<c:param name="onClickSubmitButton" value="Com_Submit(document.kmReviewMainForm, 'publishDraft');" />
			</c:import>
		</table>
	</div>
	
	<%-- 基本信息 --%>
	<div class="label_doc" labelName="<bean:message bundle='km-review' key='kmReviewDocumentLableName.baseInfo'/>" labelType="base">
		<table class="tb_normal" width=100%>
			<!--主题-->
			<tr>
				<td class="td_normal_title" width=15%><bean:message
					bundle="km-review" key="kmReviewMain.docSubject" />
				</td>
				<td colspan=3><bean:write name="kmReviewMainForm"
					property="docSubject" /></td>
			</tr>
			<!--关键字-->
			<tr>
				<td class="td_normal_title" width=15%><bean:message
					bundle="km-review" key="kmReviewKeyword.fdKeyword" /></td>
				<td colspan=3><bean:write name="kmReviewMainForm"
					property="fdKeywordNames" /></td>
			</tr>
			<!--模板名称-->
			<tr>
				<td class="td_normal_title" width=15%><bean:message
					bundle="km-review" key="kmReviewTemplate.fdName" /></td>
				<td colspan=3><bean:write name="kmReviewMainForm"
					property="fdTemplateName" /></td>
			</tr>
			<!--申请人-->
			<tr>
				<td class="td_normal_title" width=15%><bean:message
					bundle="km-review" key="kmReviewMain.docCreatorName" /></td>
				<td width=35%><html:hidden name="kmReviewMainForm"
					property="docCreatorId" /> <bean:write name="kmReviewMainForm"
					property="docCreatorName" /></td>
				<td class="td_normal_title" width=15%><bean:message
					bundle="km-review" key="kmReviewMain.fdNumber" /></td>
				<td width=35%><bean:write name="kmReviewMainForm"
					property="fdNumber" /></td>
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
					property="docCreateTime" /></td>
			</tr>
			<!--状态-->
			<tr>
				<td class="td_normal_title" width=15%>
					<bean:message bundle="km-review" key="kmReviewMain.docStatus" />
				</td>
				<td>
					<c:if test="${kmReviewMainForm.docStatus=='00'}">
						<bean:message bundle="km-review" key="status.discard"/>
					</c:if>
					<c:if test="${kmReviewMainForm.docStatus=='10'}">
						<bean:message bundle="km-review" key="status.draft"/>
					</c:if>
					<c:if test="${kmReviewMainForm.docStatus=='11'}">
						<bean:message bundle="km-review" key="status.refuse"/>
					</c:if>
					<c:if test="${kmReviewMainForm.docStatus=='20'}">
						<bean:message bundle="km-review" key="status.append"/>
					</c:if>
					<c:if test="${kmReviewMainForm.docStatus=='30'}">
						<bean:message bundle="km-review" key="status.publish"/>
					</c:if>
					<c:if test="${kmReviewMainForm.docStatus=='31'}">
						<bean:message bundle="km-review" key="status.feedback" />
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
				<td colspan=3><bean:write name="kmReviewMainForm"
					property="fdFeedbackNames" /></td>

			</tr>
			<%-- 所属场所 --%>
			<c:import url="/sys/authorization/sys_auth_area/sysAuthArea_field.jsp" charEncoding="UTF-8">
                <c:param name="id" value="${kmReviewMainForm.authAreaId}"/>
            </c:import> 
			<!--其他属性-->
			<tr>
				<td class="td_normal_title" width=15%><bean:message
					bundle="km-review" key="table.sysCategoryProperty" /></td>
				<td colspan=3><bean:write name="kmReviewMainForm"
					property="docPropertyNames" /></td>
			</tr>
			<xform:isExistRelationProcesses relationType="parent">
			<tr>
				<td class="td_normal_title" width=15%><bean:message
					bundle="km-review" key="kmReviewMain.process.parent" />
				</td>
				<td colspan=3><xform:showParentProcesse /></td>
			</tr>
			</xform:isExistRelationProcesses>
			<xform:isExistRelationProcesses relationType="subs">
			<tr>
				<td class="td_normal_title" width=15%><bean:message
					bundle="km-review" key="kmReviewMain.process.subs" />
				</td>
				<td colspan=3><xform:showSubProcesses /></td>
			</tr>
			</xform:isExistRelationProcesses>
		</table>
	</div>
	
	<%-- 权限机制--%>
	<div class="label_doc" labelName='<bean:message	bundle="km-review" key="kmReviewMain.right" />' labelType="right">
		<table class="tb_normal" width=100%>
			<c:import
				url="/sys/right/right_view.jsp"
				charEncoding="UTF-8">
				<c:param
					name="formName"
					value="kmReviewMainForm" />
				<c:param
					name="moduleModelName"
					value="com.landray.kmss.km.review.model.KmReviewMain" />
			</c:import>
		</table>
	</div>
	<%-- 关联信息 --%>
	<div class="label_doc" labelType="relation" useLabel="true">
		<table class="tb_normal" width=100%>
			<c:import
					url="/sys/relation/include/sysRelationMain_view.jsp"
					charEncoding="UTF-8">
					<c:param name="formName" value="kmReviewMainForm" />
					<c:param name="useTab" value="true" />
				</c:import>
		</table>
	</div>	
	
	<%-- 督办沟通 --%>
	<c:if test="${kmReviewMainForm.docStatus!='10'}">
		<kmss:ifModuleExist  path = "/km/collaborate/">
			<%request.setAttribute("communicateTitle",ResourceUtil.getString("kmReviewMain.communicateTitle","km-review"));%>
			<div class="label_doc" labelName="${communicateTitle}" useLabel="true" labelType="communicate">
				<table class="tb_normal" width=100%>
					<c:import
						url="/km/collaborate/include/kmCollaborateMain_view.jsp"
						charEncoding="UTF-8">
						<c:param
							name="commuTitle"
							value="${communicateTitle}" />
						<c:param
							name="formName"
							value="kmReviewMainForm" />
						<c:param
							name="styleValue"
							value="height=350px" />
					</c:import>
				</table>
			</div>
	</kmss:ifModuleExist>
    </c:if>
	<%-- 反馈记录 --%>
	<c:if
		test="${kmReviewMainForm.docStatus=='30'||kmReviewMainForm.docStatus=='31'}">
		<div class="label_doc" labelName="<bean:message bundle='km-review' key='kmReviewDocumentLableName.feedbackInfo'/>" 
			labelType="feedback">
			<table class="tb_normal" width=100%>
				<tr>
					<td id="feedbackList" onresize="feedBack_LoadIframe();">
						<iframe	name="feedbackLog" src="" width=100% height=100% frameborder=0 scrolling=no>
					</iframe></td>
				</tr>
			</table>
		</div>
	</c:if>
	<%--传阅机制--%>
	<div class="label_doc" useLabel="true" labelType="circulation">
		<table class="tb_normal" width=100%>	
			<c:import
				url="/sys/circulation/include/sysCirculationMain_view.jsp"
				charEncoding="UTF-8">
				<c:param
					name="formName"
					value="kmReviewMainForm" />
			</c:import>
		</table>
	</div>
	<%-- 阅读记录 --%>
	<div class="label_doc" useLabel="true" labelType="read">
		<table class="tb_normal" width=100% >
			<c:import url="/sys/readlog/include/sysReadLog_view.jsp"
				charEncoding="UTF-8">
				<c:param name="formName" value="kmReviewMainForm" />
			</c:import>
		</table>
	</div>

	<%-- 数据迁移 --%>
	<kmss:ifModuleExist path="/tools/datatransfer/">
		<div class="label_doc" useLabel="true" labelType="olddata">
			<table class="tb_normal" width=100%>
				<c:import
					url="/tools/datatransfer/include/toolsDatatransfer_old_data.jsp"
					charEncoding="UTF-8">
					<c:param
						name="fdModelId"
						value="${kmReviewMainForm.fdId}" />
					<c:param
						name="fdModelName"
						value="com.landray.kmss.km.review.model.KmReviewMain" />
				</c:import>
			</table>
		</div>
	</kmss:ifModuleExist>
</div>
</center>
	<html:hidden property="docSubject" />
	<html:hidden property="docStatus" />
	<html:hidden property="fdNumber" />
	<html:hidden property="method_GET" />
</html:form>
<script language="JavaScript">
Com_IncludeFile("calendar.js");
xform_validation = $KMSSValidation(document.forms['kmReviewMainForm']);
</script>
<%@ include file="/resource/jsp/view_down.jsp"%>
