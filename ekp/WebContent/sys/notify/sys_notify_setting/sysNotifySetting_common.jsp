<%@ include file="/resource/jsp/common.jsp" %>
<%
	String formName = request.getParameter("formName");
	if(formName.indexOf('.')>-1){
		
	}
%>
<script>Com_IncludeFile("notify.js");</script>
<tr>
	<td class="td_normal_title">
		<bean:message bundle="sys-notify" key="sysNotifySetting.fdNotifyType" />
	</td>
	<td colspan="3">
		<c:forEach items="${notifyTypeArr}" var="notifyType">
			<input type=checkbox value="${notifyType}"/>
			<bean:message bundle="sys-notify" key="sysNotify.type.${notifyType}" />&nbsp;
		</c:forEach>
		<input type="hidden" value="${notifySettingForm.fdNotifyType}">
		<script>notify_loadType(true);</script>
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
		<bean:message bundle="sys-notify" key="sysNotifySetting.fdTitle" />
	</td>
	<td colspan="3">
		<c:out value="${notifySettingForm.fdTitle}"/>
	</td>
</tr>
<tr>
	<td class="td_normal_title">
		<bean:message bundle="sys-notify" key="sysNotifySetting.fdContent" />
	</td>
	<td colspan="3">
		<kmss:showText value="${notifySettingForm.fdContent}" />
	</td>
</tr>
