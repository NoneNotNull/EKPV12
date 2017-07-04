<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<script>
	function confirmDelete(msg){
	var del = confirm("<bean:message key="page.comfirmDelete"/>");
	return del;
}


</script>
<div id="optBarDiv"><kmss:auth
	requestURL="/tib/sys/sap/connector/tib_sys_sap_server_setting/tibSysSapServerSetting.do?method=edit&fdId=${param.fdId}"
	requestMethod="GET">
	<input type="button" value="<bean:message key="button.edit"/>"
		onclick="Com_OpenWindow('tibSysSapServerSetting.do?method=edit&fdId=${param.fdId}','_self');">
</kmss:auth> <kmss:auth
	requestURL="/tib/sys/sap/connector/tib_sys_sap_server_setting/tibSysSapServerSetting.do?method=delete&fdId=${param.fdId}"
	requestMethod="GET">
	<input type="button" value="<bean:message key="button.delete"/>"
		onclick="if(!confirmDelete())return;Com_OpenWindow('tibSysSapServerSetting.do?method=delete&fdId=${param.fdId}','_self');">
</kmss:auth> <input type="button" value="<bean:message key="button.close"/>"
	onclick="Com_CloseWindow();"></div>

<p class="txttitle"><bean:message bundle="tib-sys-sap-connector"
	key="table.tibSysSapServerSetting" /></p>

<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%><bean:message
			bundle="tib-sys-sap-connector" key="tibSysSapServerSetting.fdServerCode" /></td>
		<td width="35%"><xform:text property="fdServerCode"
			style="width:85%" /></td>
		<td class="td_normal_title" width=15%><bean:message
			bundle="tib-sys-sap-connector" key="tibSysSapServerSetting.fdServerName" /></td>
		<td width="35%"><xform:text property="fdServerName"
			style="width:85%" /></td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%><bean:message
			bundle="tib-sys-sap-connector" key="tibSysSapServerSetting.fdServerIp" /></td>
		<td width="35%"><xform:text property="fdServerIp"
			style="width:85%" /></td>
		<td class="td_normal_title" width=15%><bean:message
			bundle="tib-sys-sap-connector" key="tibSysSapServerSetting.fdTibSysSapCode" /></td>
		<td width="35%"><xform:text property="fdTibSysSapCode"
			style="width:85%" /></td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%><bean:message
			bundle="tib-sys-sap-connector" key="tibSysSapServerSetting.fdClientCode" /></td>
		<td width="35%"><xform:text property="fdClientCode"
			style="width:85%" /></td>
		<td class="td_normal_title" width=15%><bean:message
			bundle="tib-sys-sap-connector" key="tibSysSapServerSetting.fdLanguage" /></td>
		<td width="35%"><xform:text property="fdLanguage"
			style="width:85%" /></td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%><bean:message
			bundle="tib-sys-sap-connector" key="fdTibSysSapExtList" /></td>
		<td width=35% colspan="3">
		<table class="tb_normal" width=100% id="TABLE_DocList">
			<tr>
				<td class="td_normal_title" width=45%><bean:message
					bundle="tib-sys-sap-connector" key="tibSysSapServerSettingExt.fdExtName" /></td>
				<td class="td_normal_title" width=45%><bean:message
					bundle="tib-sys-sap-connector" key="tibSysSapServerSettingExt.fdExtValue" /></td>
			</tr>
			<c:forEach items="${tibSysSapServerSettingForm.fdTibSysSapExtList}"
				var="tibSysSapServerSettingExtForm" varStatus="vstatus">
				<tr KMSS_IsContentRow="1">
					<td><c:out value="${tibSysSapServerSettingExtForm.fdExtName}" />
					<td><c:out value="${tibSysSapServerSettingExtForm.fdExtValue}" /></td>
				</tr>
			</c:forEach>
		</table>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%><bean:message
			bundle="tib-sys-sap-connector" key="tibSysSapServerSetting.fdUpdateTime" /></td>
		<td width="35%" colspan="3"><xform:datetime
			property="fdUpdateTime" /></td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%><bean:message
			bundle="tib-sys-sap-connector" key="tibSysSapServerSetting.fdDescribe" /></td>
		<td width="35%" colspan="3"><xform:text property="fdDescribe"
			style="width:85%" /></td>
	</tr>
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>
