<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<html:form action="/kms/integral/kms_integral_dept_filter/kmsIntegralDeptFilter.do">
<div id="optBarDiv">
	<c:if test="${kmsIntegralDeptFilterForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit(document.kmsIntegralDeptFilterForm, 'update');">
	</c:if>
	<c:if test="${kmsIntegralDeptFilterForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="Com_Submit(document.kmsIntegralDeptFilterForm, 'save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="Com_Submit(document.kmsIntegralDeptFilterForm, 'saveadd');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="kms-integral" key="table.kmsIntegralDeptFilter"/></p>

<center>
<table class="tb_normal" width=60%>
	<%@ include file="/kms/integral/resource/jsp/kmsIntegralPublic.jsp"%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-integral" key="kmsIntegralCommon.fdDept"/>
		</td><td width="80%">
			<input type="hidden" name="fdDeptIds" value="${kmsIntegralDeptFilterForm.fdDeptIds}">
			<xform:textarea property="fdDeptNames" required="true" style="width:90%;height:90px"></xform:textarea>
			<a href="#" onclick="Dialog_Address(true, 'fdDeptIds','fdDeptNames', ';', ORG_TYPE_DEPT);">
				<bean:message key="dialog.selectOrg" /></a>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title">
			<bean:message bundle="kms-integral" key="kmsIntegralCommon.count"/> 
		</td><td>
			<xform:checkbox property="fdTotalScore" subject="<bean:message bundle='kms-integral' key='kmsIntegralCommon.fdTotalScore'/>" >
				<xform:simpleDataSource value="true"><bean:message bundle="kms-integral" key="kmsIntegralCommon.fdTotalScore"/></xform:simpleDataSource>
			</xform:checkbox>
			<xform:checkbox property="fdExpScore" subject="<bean:message bundle='kms-integral' key='kmsIntegralCommon.fdExpScore'/>" >
				<xform:simpleDataSource value="true"><bean:message bundle="kms-integral" key="kmsIntegralCommon.fdExpScore"/></xform:simpleDataSource>
			</xform:checkbox>
			<xform:checkbox property="fdDocScore" subject="<bean:message bundle='kms-integral' key='kmsIntegralCommon.fdDocScore'/>" >
				<xform:simpleDataSource value="true"><bean:message bundle="kms-integral" key="kmsIntegralCommon.fdDocScore"/></xform:simpleDataSource>
			</xform:checkbox>
			<xform:checkbox property="fdOtherScore" subject="<bean:message bundle='kms-integral' key='kmsIntegralCommon.fdOtherScore'/>" >
				<xform:simpleDataSource value="true"><bean:message bundle="kms-integral" key="kmsIntegralCommon.fdOtherScore"/></xform:simpleDataSource>
			</xform:checkbox>
			<xform:checkbox property="fdTotalRiches" subject="<bean:message bundle='kms-integral' key='kmsIntegralCommon.fdTotalRiches'/>" >
				<xform:simpleDataSource value="true"><bean:message bundle="kms-integral" key="kmsIntegralCommon.fdTotalRiches"/></xform:simpleDataSource>
			</xform:checkbox>
			<xform:checkbox property="fdExpRiches" subject="<bean:message bundle='kms-integral' key='kmsIntegralCommon.fdExpRiches'/>" >
				<xform:simpleDataSource value="true"><bean:message bundle="kms-integral" key="kmsIntegralCommon.fdExpRiches"/></xform:simpleDataSource>
			</xform:checkbox>
			<xform:checkbox property="fdDocRiches" subject="<bean:message bundle='kms-integral' key='kmsIntegralCommon.fdDocRiches'/>" >
				<xform:simpleDataSource value="true"><bean:message bundle="kms-integral" key="kmsIntegralCommon.fdDocRiches"/></xform:simpleDataSource>
			</xform:checkbox>
			<xform:checkbox property="fdOtherRiches" subject="<bean:message bundle='kms-integral' key='kmsIntegralCommon.fdOtherRiches'/>" >
				<xform:simpleDataSource value="true"><bean:message bundle="kms-integral" key="kmsIntegralCommon.fdOtherRiches"/></xform:simpleDataSource>
			</xform:checkbox>
		</td>
	</tr>
</table>
</center>
<html:hidden property="fdId" />
<html:hidden property="method_GET" />
<script>
	Com_IncludeFile("dialog.js");
	$KMSSValidation();
</script>
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>