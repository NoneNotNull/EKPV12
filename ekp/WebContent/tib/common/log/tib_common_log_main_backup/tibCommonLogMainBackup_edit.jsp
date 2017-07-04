<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<html:form action="/tib/common/log/tib_common_log_main_backup/tibCommonLogMainBackup.do">
<div id="optBarDiv">
	<c:if test="${tibCommonLogMainBackupForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit(document.tibCommonLogMainBackupForm, 'update');">
	</c:if>
	<c:if test="${tibCommonLogMainBackupForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="Com_Submit(document.tibCommonLogMainBackupForm, 'save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="Com_Submit(document.tibCommonLogMainBackupForm, 'saveadd');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="tib-common-log" key="table.tibCommonLogMainBackup"/></p>

<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-common-log" key="tibCommonLogMainBackup.fdType"/>
		</td><td width="35%">
			<xform:text property="fdType" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-common-log" key="tibCommonLogMainBackup.fdUrl"/>
		</td><td width="35%">
			<xform:text property="fdUrl" style="width:85%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-common-log" key="tibCommonLogMainBackup.fdPoolName"/>
		</td><td width="35%">
			<xform:text property="fdPoolName" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-common-log" key="tibCommonLogMainBackup.fdStartTime"/>
		</td><td width="35%">
			<xform:datetime property="fdStartTime" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-common-log" key="tibCommonLogMainBackup.fdEndTime"/>
		</td><td width="35%">
			<xform:datetime property="fdEndTime" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-common-log" key="tibCommonLogMainBackup.fdImportPar"/>
		</td><td width="35%">
			<xform:rtf property="fdImportPar" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-common-log" key="tibCommonLogMainBackup.fdExportPar"/>
		</td><td width="35%">
			<xform:rtf property="fdExportPar" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-common-log" key="tibCommonLogMainBackup.fdMessages"/>
		</td><td width="35%">
			<xform:textarea property="fdMessages" style="width:85%" />
		</td>
	</tr>
</table>
</center>
<html:hidden property="fdId" />
<html:hidden property="method_GET" />
<script>
	Com_IncludeFile("calendar.js");
	$KMSSValidation();
</script>
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>