<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<html:form action="/sys/appconfig/sys_appconfig/sysAppConfig.do">
<div id="optBarDiv">
	<input type=button value="<bean:message key="button.save"/>"
		onclick="Com_Submit(document.sysAppConfigForm, 'update');">
</div>
<p class="txttitle"><bean:message key="module.node.paramsSetup.base" bundle="sys-lbpm-engine"/></p>
<center>
<script language="JavaScript">
Com_IncludeFile("dialog.js|doclist.js");
</script>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-lbpm-engine" key="lbpmBaseInfo.nodeNameSelectItem"/>
		</td>
		<td width=85%>
			<xform:text property="value(nodeNameSelectItem)" style="width:85%" /><br />
			<bean:message bundle="sys-lbpm-engine" key="lbpmBaseInfo.nodeNameSelectItem.text"/>
		</td>
	</tr> 
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-lbpm-engine" key="lbpmBaseInfo.notify.type.default"/>
		</td>
		<td width=85%>
			<kmss:editNotifyType property="value(defaultNotifyType)" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-lbpm-engine" key="lbpmBaseInfo.notify.type.system"/>
		</td>
		<td width=85%>
			<kmss:editNotifyType property="value(systemNotifyType)" /><br>
			<bean:message bundle="sys-lbpm-engine" key="lbpmBaseInfo.notify.type.system.description"/>
		</td>

	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-lbpm-engine" key="lbpmBaseInfo.notify.crash.target"/>
		</td>
		<td width=85%>
			<xform:address propertyId="value(notifyCrashTargetIds)" propertyName="value(notifyCrashTargetNames)" mulSelect="true" orgType="ORG_TYPE_PERSON | ORG_TYPE_POST" style="width:85%">
			</xform:address>
			<br>
			<xform:checkbox property="value(notifyTargetAuthor)" showStatus="edit">
				<xform:simpleDataSource value="true">
					<bean:message bundle="sys-lbpm-engine" key="lbpmBaseInfo.notify.crash.target.type.author"/>
				</xform:simpleDataSource>
			</xform:checkbox>
			&nbsp;&nbsp;&nbsp;&nbsp;
			<xform:checkbox property="value(notifyTargetSubmit)" showStatus="edit">
				<xform:simpleDataSource value="true">
					<bean:message bundle="sys-lbpm-engine" key="lbpmBaseInfo.notify.crash.target.type.sumbit"/>
				</xform:simpleDataSource>
			</xform:checkbox>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-lbpm-engine" key="lbpmBaseInfo.expire"/>
		</td>
		<td width=85%>
			<bean:message bundle="sys-lbpm-engine" key="lbpmBaseInfo.expire.text1" />
			<xform:text property="value(notifyExpire)" style="width:25pt;" validators="digits,min(0)" /><bean:message bundle="sys-lbpm-engine" key="lbpmBaseInfo.expire.day" />
			<xform:text property="value(hourOfNotifyExpire)" style="width:25pt;" validators="digits,min(0)" /><bean:message bundle="sys-lbpm-engine" key="lbpmBaseInfo.expire.hour" />
			<xform:text property="value(minuteOfNotifyExpire)" style="width:25pt;" validators="digits,min(0)" /><bean:message bundle="sys-lbpm-engine" key="lbpmBaseInfo.expire.minute" /><bean:message bundle="sys-lbpm-engine" key="lbpmBaseInfo.expire.text2" />
			&nbsp;&nbsp;<i><bean:message bundle="sys-lbpm-engine" key="lbpmBaseInfo.notifyExpire.note" /></i>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-lbpm-engine" key="lbpmBaseInfo.threadPoolSize"/>
		</td>
		<td width=85%>
			<xform:text property="value(threadPoolSize)" style="width:25pt;" validators="digits,min(1)" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-lbpm-engine" key="lbpmBaseInfo.isQueueLogEnalbed"/>
		</td>
		<td width=85%>
			<xform:checkbox property="value(isQueueLogEnalbed)" showStatus="edit">
				<xform:simpleDataSource value="true">
					<bean:message key="message.yes"/>
				</xform:simpleDataSource>
			</xform:checkbox>
		</td>
	</tr>
</table>
</center>
<script>
	$KMSSValidation();
</script>
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>