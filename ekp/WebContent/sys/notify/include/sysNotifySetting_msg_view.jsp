<%@ include file="/resource/jsp/common.jsp" %>
<c:set var="notifySettingForm" value="${requestScope[param.formName].notifySettingForms[param.fdKey]}" />
<tr>
	<td class="td_normal_title" width="15%">
		<bean:message bundle="sys-notify" key="sysNotifySetting.fdNotifyType" />
	</td>
	<td colspan="3">
		<kmss:showNotifyType value="${notifySettingForm.fdNotifyType}" />
	</td>
</tr>
<c:if test="${param.showTarget!='false'}">
	<tr>
		<td class="td_normal_title">
			<bean:message bundle="sys-notify" key="sysNotifySetting.notifyTarget" />
		</td>
		<td colspan="3">
			<c:out value="${notifySettingForm.fdNotifyTargetNames}"/>
		</td>
	</tr>
</c:if>
<tr>
	<td class="td_normal_title">
		<bean:message bundle="sys-notify" key="sysNotifySetting.fdSubject" />
	</td>
	<td colspan="3">
		<c:out value="${notifySettingForm.fdSubject}"/>
	</td>
</tr>
<tr>
	<td class="td_normal_title">
		<bean:message bundle="sys-notify" key="sysNotifySetting.fdContent" />
	</td>
	<td colspan="3">
		${notifySettingForm.fdContent}
	</td>
</tr>