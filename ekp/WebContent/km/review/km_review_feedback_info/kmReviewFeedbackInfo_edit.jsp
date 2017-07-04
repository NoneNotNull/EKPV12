<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.simple" sidebar="no">
	<template:replace name="body">
<script>
    seajs.use(['theme!form']);
	Com_IncludeFile("validation.jsp|validation.js|plugin.js|eventbus.js|xform.js", null, "js");
</script>
	<html:form action="/km/review/km_review_feedback_info/kmReviewFeedbackInfo.do">
	<div style="text-align: right;padding-right: 20px;">
		<c:if test="${kmReviewFeedbackInfoForm.method_GET=='edit'}">
		    <ui:button text="${ lfn:message('button.update') }" order="2"  onclick="Com_Submit(document.kmReviewFeedbackInfoForm, 'update');">
			</ui:button>
		</c:if> 
		<c:if test="${kmReviewFeedbackInfoForm.method_GET=='add'}">
		    <ui:button text="${ lfn:message('button.submit') }" order="2"  onclick="Com_Submit(document.kmReviewFeedbackInfoForm, 'save');">
			</ui:button>
		</c:if> 
		<ui:button text="${ lfn:message('button.close') }" order="5"  onclick="Com_CloseWindow()">
		</ui:button>
	</div>

	<p class="txttitle"><bean:message bundle="km-review"
		key="table.kmReviewFeedbackInfo" /></p>

	<center>
	<table class="tb_normal" width=95%>
		<!-- 反馈人 -->
		<tr>
			<td class="td_normal_title" width=30%>
				<html:hidden property="fdMainId" /> 
				<html:hidden property="docCreatorId"/>
				<bean:message bundle="km-review" key="kmReviewFeedbackInfo.docCreatorId" />
			</td>
			<td>
				<html:text property="docCreatorName" readonly="true" style="width:50%" />
			</td>
		</tr>
		<!-- 反馈时间 -->
		<tr>
			<td class="td_normal_title" width=30%>
				<bean:message bundle="km-review" key="kmReviewFeedbackInfo.docCreatorTime" />
			</td>
			<td>
				<html:text property="docCreatorTime" readonly="true" style="width:50%" />
			</td>
		</tr>
		<!-- 提要 -->
		<tr>
			<td class="td_normal_title" width=30%>
				<bean:message bundle="km-review" key="kmReviewFeedbackInfo.fdSummary" />
			</td>
			<td>
				<xform:text property="fdSummary" style="width:97%" />
			</td>
		</tr>
		<!-- 反馈内容 -->
		<tr>
			<td class="td_normal_title" width=30%><bean:message
				bundle="km-review" key="kmReviewFeedbackInfo.docContent" /></td>
			<td><html:textarea property="docContent" style="width:97%" /></td>
		</tr>
		<!-- 通知人员 -->
		<tr>
			<td class="td_normal_title" width=30%><bean:message
				bundle="km-review" key="notify.people" /></td>
			<td>
			<xform:address propertyId="fdNotifyId" propertyName="fdNotifyPeople" mulSelect="true" orgType="ORG_TYPE_ALL" style="width:97%"></xform:address>
			<br>
			<!-- 
			<font color=0000FF>
			<bean:message key="message.feedback.tip" bundle="km-review"/>
			<bean:write name="kmReviewFeedbackInfoForm" property="fdReaderNames"/>
			</font>
			 -->
			</td>
		</tr>
		<!-- 通知方式 -->
		<tr>
			<td class="td_normal_title" width=10%><bean:message
				bundle="km-review" key="notify.type" /></td>
			<td>
				<kmss:editNotifyType property="fdNotifyType"/>
			</td>
		</tr>
	</table>
	</center>
	<html:hidden property="method_GET" />
</html:form>
<script language="JavaScript">
			$KMSSValidation(document.forms['kmReviewFeedbackInfoForm']);
</script>
	</template:replace>
</template:include>
