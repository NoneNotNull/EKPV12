<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<html:form action="/tib/sys/soap/connector/tib_sys_soap_setting_ext/tibSysSoapSettingExt.do">
<div id="optBarDiv">
	<c:if test="${tibSysSoapSettingExtForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit(document.tibSysSoapSettingExtForm, 'update');">
	</c:if>
	<c:if test="${tibSysSoapSettingExtForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="Com_Submit(document.tibSysSoapSettingExtForm, 'save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="Com_Submit(document.tibSysSoapSettingExtForm, 'saveadd');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="tib-sys-soap-connector" key="table.tibSysSoapSettingExt"/></p>

<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapSettingExt.fdWsExtName"/>
		</td><td width="35%">
			<xform:text property="fdWsExtName" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapSettingExt.fdWsExtValue"/>
		</td><td width="35%">
			<xform:text property="fdWsExtValue" style="width:85%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapSettingExt.fdServer"/>
		</td><td width="35%">
			<xform:select property="fdServerId">
				<xform:beanDataSource serviceBean="tibSysSoapSettingService" selectBlock="fdId,docSubject" orderBy="" />
			</xform:select>
		</td>
		<td class="td_normal_title" width=15%>&nbsp;</td><td width=35%>&nbsp;</td>
	</tr>
</table>
</center>
<html:hidden property="fdId" />
<html:hidden property="method_GET" />
<script>
	$KMSSValidation();
</script>
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>
