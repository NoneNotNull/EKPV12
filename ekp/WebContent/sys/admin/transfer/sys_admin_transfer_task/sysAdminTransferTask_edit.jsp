<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<html:form action="/sys/admin/transfer/sys_admin_transfer_task/sysAdminTransferTask.do">
<div id="optBarDiv">
	<c:if test="${sysAdminTransferTaskForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit(document.sysAdminTransferTaskForm, 'update');">
	</c:if>
	<c:if test="${sysAdminTransferTaskForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="Com_Submit(document.sysAdminTransferTaskForm, 'save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="Com_Submit(document.sysAdminTransferTaskForm, 'saveadd');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="sys-admin-transfer" key="table.sysAdminTransferTask"/></p>

<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-admin-transfer" key="sysAdminTransferTask.fdName"/>
		</td><td width="35%">
			<xform:text property="fdName" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-admin-transfer" key="sysAdminTransferTask.fdUuid"/>
		</td><td width="35%">
			<xform:text property="fdUuid" style="width:85%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-admin-transfer" key="sysAdminTransferTask.fdDescription"/>
		</td><td width="85%" colspan="3">
			<xform:textarea property="fdDescription" style="width:85%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-admin-transfer" key="sysAdminTransferTask.fdStatus"/>
		</td><td width="35%">
			<xform:radio property="fdStatus">
				<xform:enumsDataSource enumsType="sysAdminTransferTask.fdStatus" />
			</xform:radio>
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-admin-transfer" key="sysAdminTransferTask.fdResult"/>
		</td><td width="35%">
			<xform:select property="fdResult">
				<xform:enumsDataSource enumsType="sysAdminTransferTask.fdResult" />
			</xform:select>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-admin-transfer" key="sysAdminTransferTask.fdDetails"/>
		</td><td width="85%" colspan="3">
			<xform:rtf property="fdDetails" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-admin-transfer" key="sysAdminTransferTask.fdParams"/>
		</td><td width="85%" colspan="3">
			<xform:textarea property="fdParams" style="width:85%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-admin-transfer" key="sysAdminTransferTask.fdRunTime"/>
		</td><td width="35%">
			<xform:datetime property="fdRunTime" showStatus="view" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-admin-transfer" key="sysAdminTransferTask.docCreateTime"/>
		</td><td width="35%">
			<xform:datetime property="docCreateTime" showStatus="view" />
		</td>
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