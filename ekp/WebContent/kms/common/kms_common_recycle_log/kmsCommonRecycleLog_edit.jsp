<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<html:form action="/kms/common/kms_common_recycle_log/kmsCommonRecycleLog.do">
<div id="optBarDiv">
	<c:if test="${kmsCommonRecycleLogForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit(document.kmsCommonRecycleLogForm, 'update');">
	</c:if>
	<c:if test="${kmsCommonRecycleLogForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="Com_Submit(document.kmsCommonRecycleLogForm, 'save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="Com_Submit(document.kmsCommonRecycleLogForm, 'saveadd');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="kms-common" key="table.kmsCommonRecycleLog"/></p>

<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-common" key="kmsCommonRecycleLog.fdOperateTime"/>
		</td><td width="35%">
			<xform:datetime property="fdOperateTime" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-common" key="kmsCommonRecycleLog.fdOperateName"/>
		</td><td width="35%">
			<xform:select property="fdOperateName">
				<xform:enumsDataSource enumsType="kms_common_recycle_log_fd_operate_name" />
			</xform:select>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-common" key="kmsCommonRecycleLog.fdStatusBefore"/>
		</td><td width="35%">
			<xform:text property="fdStatusBefore" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-common" key="kmsCommonRecycleLog.fdOperator"/>
		</td><td width="35%">
			<xform:address propertyId="fdOperatorId" propertyName="fdOperatorName" orgType="ORG_TYPE_ALL" style="width:85%" />
		</td>
	</tr>
</table>
</center>
<html:hidden property="fdModelId"/>
<html:hidden property="fdModelName"/>
<html:hidden property="fdId" />
<html:hidden property="method_GET" />
<script>
	Com_IncludeFile("calendar.js");
	Com_IncludeFile("dialog.js");
	$KMSSValidation();
</script>
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>