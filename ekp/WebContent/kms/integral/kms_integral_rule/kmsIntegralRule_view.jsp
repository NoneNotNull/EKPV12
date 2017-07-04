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
	<kmss:auth requestURL="/kms/integral/kms_integral_rule/kmsIntegralRule.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.edit"/>"
			onclick="Com_OpenWindow('kmsIntegralRule.do?method=edit&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<kmss:auth requestURL="/kms/integral/kms_integral_rule/kmsIntegralRule.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.delete"/>"
			onclick="if(!confirmDelete())return;Com_OpenWindow('kmsIntegralRule.do?method=delete&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="kms-integral" key="table.kmsIntegralRule"/></p>

<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-integral" key="kmsIntegralRule.fdName"/>
		</td><td width="35%">
			<xform:text property="fdName" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-integral" key="kmsIntegralRule.fdStatus"/>
		</td><td width="35%">
			<xform:text property="fdStatus" style="width:85%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-integral" key="kmsIntegralRule.fdUpdateTime"/>
		</td><td width="35%">
			<xform:datetime property="fdUpdateTime" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-integral" key="kmsIntegralRule.fdExpValue"/>
		</td><td width="35%">
			<xform:text property="fdExpValue" style="width:85%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-integral" key="kmsIntegralRule.fdRichesValue"/>
		</td><td width="35%">
			<xform:text property="fdRichesValue" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-integral" key="kmsIntegralRule.fdObjectExpValue"/>
		</td><td width="35%">
			<xform:text property="fdObjectExpValue" style="width:85%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-integral" key="kmsIntegralRule.fdObjectRichesValue"/>
		</td><td width="35%">
			<xform:text property="fdObjectRichesValue" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-integral" key="kmsIntegralRule.fdModelName"/>
		</td><td width="35%">
			<xform:text property="fdModelName" style="width:85%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-integral" key="kmsIntegralRule.fdOperateName"/>
		</td><td width="35%">
			<xform:text property="fdOperateName" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-integral" key="kmsIntegralRule.fdCategory"/>
		</td><td width="35%">
			<xform:text property="fdCategory" style="width:85%" />
		</td>
	</tr>
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>