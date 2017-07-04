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
<div id="optBarDiv">
	<c:if test="${kmsIntegralAlterForm.fdStatus==false}">
		<kmss:auth requestURL="/kms/integral/kms_integral_alter/kmsIntegralAlter.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.edit"/>"
			onclick="Com_OpenWindow('kmsIntegralAlter.do?method=edit&fdId=${param.fdId}','_self');">
		</kmss:auth>
	</c:if>
	<kmss:auth requestURL="/kms/integral/kms_integral_alter/kmsIntegralAlter.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.delete"/>"
			onclick="if(!confirmDelete())return;Com_OpenWindow('kmsIntegralAlter.do?method=delete&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="kms-integral" key="table.kmsIntegralAlter"/></p>

<center>
<table class="tb_normal" width=70%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-integral" key="kmsIntegralCommon.docSubject"/>
		</td><td width="85%" colspan="3">
			<c:out value="${kmsIntegralAlterForm.fdSubject}" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-integral" key="kmsIntegralAlter.fdPerson"/>
		</td><td width="85%" colspan="3">
			${kmsIntegralAlterForm.fdDeptNames}
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-integral" key="kmsIntegralAlter.fdType"/>
		</td><td width="85%" colspan="3">
			<xform:radio property="fdType">
				<xform:enumsDataSource enumsType="kms_integral_alter_type" />
			</xform:radio>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-integral" key="kmsIntegralAlter.fdValue"/>
		</td><td width="85%" colspan="3">
			<xform:text property="fdValue" style="width:20%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-integral" key="kmsIntegralAlter.fdStatus"/>
		</td><td width="85%" colspan="3">
			<xform:radio property="fdStatus">
				<xform:enumsDataSource enumsType="common_yesno" />
			</xform:radio>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-integral" key="kmsIntegralAlter.fdDescription"/>
		</td><td width="85%" colspan="3">
			<xform:text property="fdDescription" style="width:85%" />
		</td>
	</tr>
	
	
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-integral" key="kmsIntegralAlter.fdCreate"/>
		</td><td width="35%">
			<c:out value="${kmsIntegralAlterForm.fdCreateName}" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-integral" key="kmsIntegralAlter.fdCreateTime"/>
		</td><td width="35%">
			<xform:datetime property="fdCreateTime" />
		</td>
	</tr>
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>