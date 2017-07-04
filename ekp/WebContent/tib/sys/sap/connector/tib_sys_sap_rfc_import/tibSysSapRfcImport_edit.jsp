<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<html:form action="/tib/sys/sap/connector/tib_sys_sap_rfc_import/tibSysSapRfcImport.do">
<div id="optBarDiv">
	<c:if test="${tibSysSapRfcImportForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit(document.tibSysSapRfcImportForm, 'update');">
	</c:if>
	<c:if test="${tibSysSapRfcImportForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="Com_Submit(document.tibSysSapRfcImportForm, 'save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="Com_Submit(document.tibSysSapRfcImportForm, 'saveadd');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="tib-sys-sap-connector" key="table.tibSysSapRfcImport"/></p>

<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-sap-connector" key="tibSysSapRfcImport.fdOrder"/>
		</td><td width="35%">
			<xform:text property="fdOrder" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-sap-connector" key="tibSysSapRfcImport.fdParameterUse"/>
		</td><td width="35%">
			<xform:radio property="fdParameterUse">
				<xform:enumsDataSource enumsType="common_yesno" />
			</xform:radio>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-sap-connector" key="tibSysSapRfcImport.fdParameterName"/>
		</td><td width="35%">
			<xform:text property="fdParameterName" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-sap-connector" key="tibSysSapRfcImport.fdParameterType"/>
		</td><td width="35%">
			<xform:text property="fdParameterType" style="width:85%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-sap-connector" key="tibSysSapRfcImport.fdParameterLength"/>
		</td><td width="35%">
			<xform:text property="fdParameterLength" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-sap-connector" key="tibSysSapRfcImport.fdParameterTypeName"/>
		</td><td width="35%">
			<xform:text property="fdParameterTypeName" style="width:85%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-sap-connector" key="tibSysSapRfcImport.fdParameterRequired"/>
		</td><td width="35%">
			<xform:radio property="fdParameterRequired">
				<xform:enumsDataSource enumsType="common_yesno" />
			</xform:radio>
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-sap-connector" key="tibSysSapRfcImport.fdParameterMark"/>
		</td><td width="35%">
			<xform:text property="fdParameterMark" style="width:85%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-sap-connector" key="tibSysSapRfcImport.fdHierarchyId"/>
		</td><td width="35%">
			<xform:text property="fdHierarchyId" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-sap-connector" key="tibSysSapRfcImport.fdFunction"/>
		</td><td width="35%">
			<xform:select property="fdFunctionId">
				<xform:beanDataSource serviceBean="tibSysSapRfcSettingService" selectBlock="fdId,fdId" orderBy="" />
			</xform:select>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-sap-connector" key="tibSysSapRfcImport.fdParent"/>
		</td><td width="35%">
			<xform:select property="fdParentId">
				<xform:beanDataSource serviceBean="tibSysSapRfcImportService" selectBlock="fdId,fdId" orderBy="fdOrder" />
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
