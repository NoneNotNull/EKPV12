<%@ include file="/resource/jsp/common.jsp" %>
<%@ page import="com.landray.kmss.util.ResourceUtil" %>
<script>Com_IncludeFile("notify.js");</script>
<script>
<c:if test="${param.messageKey==null}">
	Notify_SubjectRequired["${param.fdKey}"] = "<bean:message key="sysNotifySetting.error.subjectRequired" bundle="sys-notify"/>";
</c:if>
<c:if test="${param.messageKey!=null}">
	<%
	pageContext.setAttribute("messageKey", ResourceUtil.getString((String)request.getParameter("messageKey"), request.getLocale()));
	%>
	Notify_SubjectRequired["${param.fdKey}"] = "<bean:message key="sysNotifySetting.error.para.subjectRequired" arg0="${messageKey}" bundle="sys-notify"/>";
</c:if>
	Notify_KeyList[Notify_KeyList.length] = "${param.fdKey}";
</script>
<tr>
	<td class="td_normal_title" width="15%">
		<html:hidden property="notifySettingForms.${param.fdKey}.fdId" />
		<bean:message key="sysNotifySetting.fdNotifyType" bundle="sys-notify" />
	</td>
	<td colspan="3">
		<kmss:editNotifyType property="notifySettingForms.${param.fdKey}.fdNotifyType" />
	</td>
</tr>
<c:if test="${param.showTarget!='false'}">
	<tr>
		<td class="td_normal_title">
			<bean:message key="sysNotifySetting.notifyTarget" bundle="sys-notify"/>
		</td>
		<td colspan="3">
			<html:hidden property="notifySettingForms.${param.fdKey}.fdNotifyTargetIds" />
			<html:text property="notifySettingForms.${param.fdKey}.fdNotifyTargetNames" style="width:90%" readonly="true" styleClass="inputsgl"/>
			<a href="#" onclick="Dialog_Address(true, 'notifySettingForms.${param.fdKey}.fdNotifyTargetIds', 'notifySettingForms.${param.fdKey}.fdNotifyTargetNames', ';');">
				<bean:message key="dialog.selectOrg"/>
			</a>
		</td>
	</tr>
</c:if>
<c:if test="${param.replaceText!=null}">
	<tr>
		<td class="td_normal_title">
			<bean:message key="sysNotifySetting.replaceText" bundle="sys-notify" />
		</td>
		<td colspan="3">
			<input name="notifySettingForms.${param.fdKey}.fdReplaceText" type=hidden value="${param.replaceText}">
			<% pageContext.setAttribute("notifyReplaceTextArr", request.getParameter("replaceText").split(";")); %>
			<c:forEach items="${notifyReplaceTextArr}" var="notifyReplaceText">
				<a href="#" onclick="Notify_InsertReplaceText(this,'${param.fdKey}');">%<kmss:message key="${notifyReplaceText}" />%</a>&nbsp;&nbsp;
			</c:forEach>
		</td>
	</tr>
</c:if>
<tr>
	<td class="td_normal_title">
		<bean:message key="sysNotifySetting.fdSubject" bundle="sys-notify" />
	</td>
	<td colspan="3">
		<html:text property="notifySettingForms.${param.fdKey}.fdSubject" style="width:99%" onfocus="Notify_CurrentObject['${param.fdKey}']=this"/><span class="txtstrong">*</span>
	</td>
</tr>
<tr>
	<td class="td_normal_title">
		<bean:message key="sysNotifySetting.fdContent" bundle="sys-notify" />
	</td>
	<td colspan="3">
		<html:textarea property="notifySettingForms.${param.fdKey}.fdContent" style="width:100%" onfocus="Notify_CurrentObject['${param.fdKey}']=this"/>
	</td>
</tr>