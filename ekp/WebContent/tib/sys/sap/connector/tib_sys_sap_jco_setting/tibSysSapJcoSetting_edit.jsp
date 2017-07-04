<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>

<script src="${KMSS_Parameter_ContextPath}tib/common/resource/js/custom_validations.js" type="text/javascript"></script>
<script>
	Com_IncludeFile("jquery.js");
</script>
<script language="javascript">
/************标记修正。。。************
 * 使用国际化的资源文件
 ************************/
$(function(){
	var spanNode = document.createElement("span");
	spanNode.id = "Include_Custom_Validations_Span_Id";
	document.body.appendChild(spanNode);
	$("#Include_Custom_Validations_Span_Id").load(Com_Parameter.ContextPath +
			"tib/common/resource/jsp/custom_validations.jsp", jco_call_validation);
});

function jco_call_validation() {
	FUN_AddValidates("fdPoolName:required", "fdPoolAdmin:required", "fdPoolSecret:required");
}
</script>
<html:messages id="messages" message="true">
	<table style="margin:0 auto" align="center"><tr><td><img src='${KMSS_Parameter_ContextPath}resource/style/default/msg/dot.gif'>&nbsp;&nbsp;<font color='red'>
      <bean:write name="messages" /></font>
	 </td></tr></table><hr />
 </html:messages> 
 
<html:form action="/tib/sys/sap/connector/tib_sys_sap_jco_setting/tibSysSapJcoSetting.do">
	<div id="optBarDiv">
	<input type=button value="<bean:message key="button.test" bundle="tib-sys-sap-connector"/>"
			onclick="Com_Submit(document.tibSysSapJcoSettingForm, 'test');"><c:if
		test="${tibSysSapJcoSettingForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit(document.tibSysSapJcoSettingForm, 'update');">
	</c:if> <c:if test="${tibSysSapJcoSettingForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="Com_Submit(document.tibSysSapJcoSettingForm, 'save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="Com_Submit(document.tibSysSapJcoSettingForm, 'saveadd');">
	</c:if> <input type="button" value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();"></div>

	<p class="txttitle"><bean:message bundle="tib-sys-sap-connector"
		key="table.tibSysSapJcoSetting" /></p>

	<center>
	<table class="tb_normal" width=95%>
		<tr>
			<td class="td_normal_title" width=15%><bean:message
				bundle="tib-sys-sap-connector" key="tibSysSapJcoSetting.fdPoolName" /></td>
			<td width="35%"><xform:text property="fdPoolName"
				style="width:85%" /></td>
			<td class="td_normal_title" width=15%><bean:message
				bundle="tib-sys-sap-connector" key="tibSysSapJcoSetting.fdTibSysSapCode" /></td>
			<td width="35%"><xform:select property="fdTibSysSapCodeId" required="true" 
				subject="${lfn:message('tib-sys-sap-connector:tibSysSapJcoSetting.fdTibSysSapCode') }">
				<xform:beanDataSource serviceBean="tibSysSapServerSettingService"
					selectBlock="fdId,fdServerName" orderBy="" />
			</xform:select></td>
		</tr>
		<tr>
			<td class="td_normal_title" width=15%><bean:message
				bundle="tib-sys-sap-connector" key="tibSysSapJcoSetting.fdPoolAdmin" /></td>
			<td width="35%"><xform:text property="fdPoolAdmin"
				style="width:85%" /></td>
			<td class="td_normal_title" width=15%><bean:message
				bundle="tib-sys-sap-connector" key="tibSysSapJcoSetting.fdPoolSecret" /></td>
			<td width="35%"><html:password property="fdPoolSecret"
				style="width:85%" styleClass="inputsgl"/></td>

		</tr>
		<tr>
			<td class="td_normal_title" width=15%><bean:message
				bundle="tib-sys-sap-connector" key="tibSysSapJcoSetting.fdPoolStatus" /></td>
			<td width="35%"><xform:radio property="fdPoolStatus">
				<xform:enumsDataSource  enumsType="status_type" />
			</xform:radio></td>
			<td class="td_normal_title" width=15%><bean:message
				bundle="tib-sys-sap-connector" key="tibSysSapJcoSetting.fdConnectType" /></td>
			<td width="35%"><xform:radio property="fdConnectType" >
			<xform:enumsDataSource  enumsType="connect_type" />
			</xform:radio></td>

		</tr>
		<tr>
			<td class="td_normal_title" width=15%><bean:message
				bundle="tib-sys-sap-connector" key="tibSysSapJcoSetting.fdPoolCapacity" /></td>
			<td width="35%"><xform:text property="fdPoolCapacity"
				style="width:85%" /></td>
			<td class="td_normal_title" width=15%><bean:message
				bundle="tib-sys-sap-connector" key="tibSysSapJcoSetting.fdPoolNumber" /></td>
			<td width="35%"><xform:text property="fdPoolNumber"
				style="width:85%" /></td>
		</tr>
		<tr>
			<td class="td_normal_title" width=15%><bean:message
				bundle="tib-sys-sap-connector" key="tibSysSapJcoSetting.fdPoolTime" /></td>
			<td width="35%" colspan="3"><xform:text property="fdPoolTime"
				style="width:85%" /></td>
		</tr>
		<tr>
			<td class="td_normal_title" width=15%><bean:message
				bundle="tib-sys-sap-connector" key="tibSysSapJcoSetting.fdDescribe" /></td>
			<td width="35%" colspan="3"><xform:textarea property="fdDescribe"
				style="width:85%" /></td>
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
