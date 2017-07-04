<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<script language="JavaScript">
	Com_IncludeFile("dialog.js|calendar.js|dialog.js|doclist.js|optbar.js|data.js|jquery.js");
</script>
<script src="${KMSS_Parameter_ContextPath}tib/common/resource/js/custom_validations.js" type="text/javascript"></script>
<script language="javascript">
/************标记修正。。。************
 * 使用国际化的资源文件
 ************************/
$(function(){
	var spanNode = document.createElement("span");
	spanNode.id = "Include_Custom_Validations_Span_Id";
	document.body.appendChild(spanNode);
	$("#Include_Custom_Validations_Span_Id").load(Com_Parameter.ContextPath +
			"tib/common/resource/jsp/custom_validations.jsp", sapServer_callValid);
});

function sapServer_callValid() {
	FUN_AddValidates("fdServerCode:required", "fdServerName:required", 
			"fdServerIp:required", "fdTibSysSapCode:required",
			"fdClientCode:required", "fdLanguage:required");
}
</script>
<html:form
	action="/tib/sys/sap/connector/tib_sys_sap_server_setting/tibSysSapServerSetting.do">
	<div id="optBarDiv"><c:if
		test="${tibSysSapServerSettingForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit(document.tibSysSapServerSettingForm, 'update');">
	</c:if> <c:if test="${tibSysSapServerSettingForm.method_GET=='add'}">
		<input type=button id="_save" value="<bean:message key="button.save"/>"
			onclick="Com_Submit(document.tibSysSapServerSettingForm, 'save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="Com_Submit(document.tibSysSapServerSettingForm, 'saveadd');">
	</c:if> <input type="button" value="<bean:message key="button.close"/>"
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

					<td class="td_normal_title" width="45%"><bean:message
						bundle="tib-sys-sap-connector" key="tibSysSapServerSettingExt.fdExtName" /></td>
					<td class="td_normal_title" width="45%"><bean:message
						bundle="tib-sys-sap-connector" key="tibSysSapServerSettingExt.fdExtValue" /></td>
					<td class="td_normal_title" width="10%"><center><img
						style="cursor: pointer" class=optStyle
						src="<c:url value="/resource/style/default/icons/add.gif"/>"
						onclick="DocList_AddRow();"></center></td>
				</tr>
				<tr KMSS_IsReferRow="1" style="display: none">
					<td ><input type="text" name="fdTibSysSapExtList[!{index}].fdExtName" class="inputsgl"
						value="${tibSysSapServerSettingExtForm.fdExtName}" style="width:85%"></td>
					<td><input type="text"
						name="fdTibSysSapExtList[!{index}].fdExtValue" class="inputsgl"
						value="${tibSysSapServerSettingExtForm.fdExtValue}" style="width:85%"></td>
					<td><input type="hidden" name="fdTibSysSapExtList[!{index}].fdId" 
						value="${tibSysSapServerSettingExtForm.fdId}">
						<input type="hidden" name="fdTibSysSapExtList[!{index}].fdServerId"
							       value="${tibSysSapServerSettingForm.fdId}">
					<center><img
						src="${KMSS_Parameter_StylePath}icons/delete.gif"
						onclick="DocList_DeleteRow();" style="cursor: pointer"></center>
					</td>
				</tr>
				<c:forEach items="${tibSysSapServerSettingForm.fdTibSysSapExtList}"
					var="tibSysSapServerSettingExtForm" varStatus="vstatus">
					<tr KMSS_IsContentRow="1">
						<td><input type="text" class="inputsgl"
							name="fdTibSysSapExtList[${vstatus.index}].fdExtName"
							value="${tibSysSapServerSettingExtForm.fdExtName}" style="width:85%"></td>
						<td><input type="text" class="inputsgl"
							name="fdTibSysSapExtList[${vstatus.index}].fdExtValue"
							value="${tibSysSapServerSettingExtForm.fdExtValue}" style="width:85%"></td>
						<td><input type="hidden" name="fdTibSysSapExtList[${vstatus.index}].fdId"
							value="${tibSysSapServerSettingExtForm.fdId}">
							<input type="hidden" name="fdTibSysSapExtList[${vstatus.index}].fdServerId"
							       value="${tibSysSapServerSettingExtForm.fdServerId}">
						<center><img
							src="${KMSS_Parameter_StylePath}icons/delete.gif"
							onclick="DocList_DeleteRow();" style="cursor: pointer"></center>
						</td>
					</tr>
				</c:forEach>
			</table>
			</td>
		</tr>
		<tr>
			<td class="td_normal_title" width=15%><bean:message
				bundle="tib-sys-sap-connector" key="tibSysSapServerSetting.fdDescribe" /></td>
			<td width="35%" colspan="3"><xform:textarea
				property="fdDescribe" style="width:95%" /></td>
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
