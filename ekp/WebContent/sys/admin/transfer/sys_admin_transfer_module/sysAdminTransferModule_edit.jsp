<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<html:form action="/sys/admin/transfer/sys_admin_transfer_module/sysAdminTransferModule.do">
<div id="optBarDiv">
	<c:if test="${sysAdminTransferModuleForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit(document.sysAdminTransferModuleForm, 'update');">
	</c:if>
	<c:if test="${sysAdminTransferModuleForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="Com_Submit(document.sysAdminTransferModuleForm, 'save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="Com_Submit(document.sysAdminTransferModuleForm, 'saveadd');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="sys-admin-transfer" key="table.sysAdminTransferModule"/></p>

<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-admin-transfer" key="sysAdminTransferModule.fdName"/>
		</td><td width="35%">
			<xform:text property="fdName" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-admin-transfer" key="sysAdminTransferModule.fdPath"/>
		</td><td width="35%">
			<xform:text property="fdPath" style="width:85%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-admin-transfer" key="sysAdminTransferModule.fdStatus"/>
		</td><td width="35%">
			<xform:radio property="fdStatus">
				<xform:enumsDataSource enumsType="sysAdminTransferModule.fdStatus" />
			</xform:radio>
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-admin-transfer" key="sysAdminTransferModule.docCreateTime"/>
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