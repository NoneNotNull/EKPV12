<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<html:form action="/tib/sys/sap/connector/tib_sys_sap_rfc_table/tibSysSapRfcTable.do">
<div id="optBarDiv">
	<c:if test="${tibSysSapRfcTableForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit(document.tibSysSapRfcTableForm, 'update');">
	</c:if>
	<c:if test="${tibSysSapRfcTableForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="Com_Submit(document.tibSysSapRfcTableForm, 'save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="Com_Submit(document.tibSysSapRfcTableForm, 'saveadd');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="tib-sys-sap-connector" key="table.tibSysSapRfcTable"/></p>

<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-sap-connector" key="tibSysSapRfcTable.fdOrder"/>
		</td><td width="35%">
			<xform:text property="fdOrder" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-sap-connector" key="tibSysSapRfcTable.fdUse"/>
		</td><td width="35%">
			<xform:text property="fdUse" style="width:85%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-sap-connector" key="tibSysSapRfcTable.fdParameterName"/>
		</td><td width="35%">
			<xform:text property="fdParameterName" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-sap-connector" key="tibSysSapRfcTable.fdParameterType"/>
		</td><td width="35%">
			<xform:text property="fdParameterType" style="width:85%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-sap-connector" key="tibSysSapRfcTable.fdParameterLength"/>
		</td><td width="35%">
			<xform:text property="fdParameterLength" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-sap-connector" key="tibSysSapRfcTable.fdParameterTypeName"/>
		</td><td width="35%">
			<xform:text property="fdParameterTypeName" style="width:85%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-sap-connector" key="tibSysSapRfcTable.fdParameterRequired"/>
		</td><td width="35%">
			<xform:text property="fdParameterRequired" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-sap-connector" key="tibSysSapRfcTable.fdMark"/>
		</td><td width="35%">
			<xform:text property="fdMark" style="width:85%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-sap-connector" key="tibSysSapRfcTable.fdFunction"/>
		</td><td width="35%">
			<xform:text property="fdFunction" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-sap-connector" key="tibSysSapRfcTable.fdParentId"/>
		</td><td width="35%">
			<xform:text property="fdParentId" style="width:85%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-sap-connector" key="tibSysSapRfcTable.fdHierarchyId"/>
		</td><td width="35%">
			<xform:text property="fdHierarchyId" style="width:85%" />
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
