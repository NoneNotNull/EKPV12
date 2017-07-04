<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.simple" sidebar="no">
	<template:replace name="body">
<script>
    seajs.use(['theme!form']);
	Com_IncludeFile("validation.jsp|validation.js|plugin.js|eventbus.js|xform.js", null, "js");
</script>
<script language="JavaScript">
		Com_IncludeFile("dialog.js");
		function submitForm() {
			var tform = document.forms[0].action="<c:url value="/km/review/km_review_main/kmReviewMain.do"/>?method=changeFeedback&fdId=${param.fdId}";
			Com_Submit(document.forms[0], 'changeFeedback');
			return;
		}
</script>
<html:form action="/km/review/km_review_main/kmReviewMain.do">
    <div style="text-align: right;padding-right: 20px;">
	    <ui:button text="${ lfn:message('button.submit') }" order="2"  onclick="submitForm();">
		</ui:button>
		<ui:button text="${ lfn:message('button.close') }" order="5"  onclick="Com_CloseWindow()">
		</ui:button>
	</div>

	<p class="txttitle"><bean:message bundle="km-review"
		key="review.title.set.feedback" /></p>

	<center>
	<table class="tb_normal" width=95%>
		<tr>
			<td class="td_normal_title" width=30%>
			<bean:message key="table.kmReviewFeedback" bundle="km-review"/></td>
			<td>
			<xform:address propertyId="fdFeedbackIds" propertyName="fdFeedbackNames" mulSelect="true" orgType="ORG_TYPE_PERSON" style="width:80%" showStatus="edit" required="true" subject="${ lfn:message('km-review:table.kmReviewFeedback')}"></xform:address>
			</td>
		</tr>
		<tr>
			<td class="td_normal_title" width=30%><bean:message
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
			$KMSSValidation(document.forms['kmReviewMainForm']);
</script>
    </template:replace>
</template:include>


