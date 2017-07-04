<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@page import="java.util.List"%>
<%@page import="com.landray.kmss.util.ResourceUtil"%>
<template:include ref="default.view" sidebar="auto">
<template:replace name="toolbar">
		<ui:toolbar id="toolbar" layout="sys.ui.toolbar.float" var-navwidth="90%">
		    <ui:button text="${ lfn:message('button.close') }" order="5" onclick="Com_CloseWindow();">
			</ui:button>
		</ui:toolbar>
</template:replace>
<template:replace name="content">
<script>
	function confirmDelete(msg){
	var del = confirm("<bean:message key="page.comfirmDelete"/>");
	return del;
}
</script>
<p class="txttitle"><bean:message bundle="km-review"
	key="table.kmReviewFeedbackInfo" /></p>
<table class="tb_normal" width=70%>
	<!-- 反馈人 -->
	<tr>
		<td class="td_normal_title" width=10%><bean:message
			bundle="km-review" key="kmReviewFeedbackInfo.docCreatorId" /></td>
		<td><bean:write name="kmReviewFeedbackInfoForm"
			property="docCreatorName" /></td>
	</tr>
	<!-- 反馈时间 -->
	<tr>
		<td class="td_normal_title" width=10%><bean:message
			bundle="km-review" key="kmReviewFeedbackInfo.docCreatorTime" /></td>
		<td><bean:write name="kmReviewFeedbackInfoForm"
			property="docCreatorTime" /></td>
	</tr>
	<!-- 提要 -->
	<tr>
		<td class="td_normal_title" width=10%><bean:message
			bundle="km-review" key="kmReviewFeedbackInfo.fdSummary" /></td>
		<td><bean:write name="kmReviewFeedbackInfoForm"
			property="fdSummary" /></td>
	</tr>
	<!-- 反馈内容 -->
	<tr>
		<td class="td_normal_title" width=10%><bean:message
			bundle="km-review" key="kmReviewFeedbackInfo.docContent" /></td>
		<td><bean:write name="kmReviewFeedbackInfoForm"
			property="docContent" /></td>
	</tr>
	<!-- 通知人员 -->
	<tr>
		<td class="td_normal_title" width=10%><bean:message
			bundle="km-review" key="notify.people" /></td>
		<td><bean:write name="kmReviewFeedbackInfoForm"
			property="fdNotifyPeople" /></td>
	</tr>
	<!-- 通知方式 -->
	<tr>
		<td class="td_normal_title" width=10%><bean:message
			bundle="km-review" key="notify.type" /></td>
		<td>
			<kmss:showNotifyType value="${kmReviewFeedbackInfoForm.fdNotifyType}"/>
		</td>
	</tr>
</table>
</template:replace>
</template:include>
