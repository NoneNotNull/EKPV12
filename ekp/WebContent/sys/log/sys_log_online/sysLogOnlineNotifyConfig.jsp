<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<script>
Com_IncludeFile("dialog.js");
</script>
<html:form action="/sys/appconfig/sys_appconfig/sysAppConfig.do">
<div id="optBarDiv">
	<input type=button value="<bean:message key="button.update"/>"
		onclick="Com_Submit(document.sysAppConfigForm, 'update');">
</div>
<p class="txttitle"><bean:message bundle="sys-log" key="sysLogOnline.NotifyConfig.set"/></p>

<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-log" key="sysLogOnline.NotifyConfig.NotifyType"/>
		</td><td>
			<kmss:editNotifyType property="value(notifyType)"/>
		</td>
	</tr>	
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-log" key="sysLogOnline.NotifyConfig.NotifyTargets"/>
		</td>
		<td>
			<html:hidden property="value(notifyTargetIds)" />
			<html:textarea	property="value(notifyTargetNames)" style="width:90%;height:90px" styleClass="inputmul" readonly="true" /> 
			<a href="#"	onclick="Dialog_Address(true, 'value(notifyTargetIds)','value(notifyTargetNames)', ';', ORG_TYPE_ALL | ORG_FLAG_BUSINESSALL);">
			<bean:message key="dialog.selectOrg" /> </a>
		</td>
	</tr>
	<tr>
		<td colspan="2">
			<bean:message  bundle="sys-log" key="sysLogOnline.NotifyConfig.describe"/>
		</td>
	</tr>
</table>
</center>
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>