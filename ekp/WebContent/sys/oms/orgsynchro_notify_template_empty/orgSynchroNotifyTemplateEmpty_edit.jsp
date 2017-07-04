<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<html:form action="/sys/oms/orgsynchro_notify_template_empty/orgSynchroNotifyTemplateEmpty.do">
<div id="optBarDiv">
	<input type=button value="<bean:message key="button.update"/>"
		onclick="Com_Submit(document.orgSynchroNotifyTemplateEmptyForm, 'update');">
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message  bundle="sys-oms-notify" key="table.orgSynchroNotifyTemplateEmpty"/><bean:message key="button.edit"/></p>

<center>
<html:hidden property="fdId"/>
<html:hidden property="method_GET"/>
<table class="tb_normal" width=95%>
  <tr class="tr_normal_title">
        <td>
                        适用场景:
        </td>
		<td colspan="3">
		    <div style="text-align: left">
			1）组织机构同步消息发布设置：适用于OMS接入出错时通知<br>
			<kmss:ifModuleExist path="/hr/">
			2）创建帐号消息发布设置：适用于开启hr同步开通帐号时通知<br>
			3）删除帐号消息发布设置：适用于开启hr同步删除帐号时通知
			</kmss:ifModuleExist>
			</div>
		</td>
	</tr>
	<tr class="tr_normal_title">
		<td colspan="4">
			<bean:message  bundle="sys-oms-notify" key="orgSynchroNotifyTemplateEmpty.setting.message"/>
		</td>
	</tr>
	<c:import url="/sys/notify/include/sysNotifySetting_msg_edit.jsp" charEncoding="UTF-8">
		<c:param name="formName" value="orgSynchroNotifyTemplateEmptyForm" />
		<c:param name="fdKey" value="orgSynchroMessageSetting" />
	</c:import>
<kmss:ifModuleExist path="/hr/">
	<tr class="tr_normal_title">
		<td colspan="4">
			<bean:message  bundle="sys-oms-notify" key="createAccountNotifyTemplateEmpty.setting.message"/>
		</td>
	</tr>
	<c:import url="/sys/notify/include/sysNotifySetting_msg_edit.jsp" charEncoding="UTF-8">
		<c:param name="formName" value="orgSynchroNotifyTemplateEmptyForm" />
		<c:param name="fdKey" value="createAccountMessageSetting" />
		<c:param name="replaceText" value="sys-oms-notify:orgSynchroNotifyTemplateEmpty.fdNotifyPersonName" />
	</c:import>

	<tr class="tr_normal_title">
		<td colspan="4">
			<bean:message  bundle="sys-oms-notify" key="deleteAccountNotifyTemplateEmpty.setting.message"/>
		</td>
	</tr>
	<c:import url="/sys/notify/include/sysNotifySetting_msg_edit.jsp" charEncoding="UTF-8">
		<c:param name="formName" value="orgSynchroNotifyTemplateEmptyForm" />
		<c:param name="fdKey" value="deleteAccountMessageSetting" />
		<c:param name="replaceText" value="sys-oms-notify:orgSynchroNotifyTemplateEmpty.fdNotifyPersonName" />
	</c:import>
</kmss:ifModuleExist>
</table>
</center>
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>