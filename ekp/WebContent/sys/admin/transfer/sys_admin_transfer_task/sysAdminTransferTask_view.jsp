<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<script>
function confirmTransfer(msg){
	return confirm('<bean:message bundle="sys-admin-transfer" key="page.comfirmTransfer"/>');
}
</script>
<div id="optBarDiv">
<c:if test="${sysAdminTransferTaskForm.fdStatus != '9'}">
	<kmss:auth requestURL="/sys/admin/transfer/sys_admin_transfer_task/sysAdminTransferTask.do?method=transfer&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message bundle="sys-admin-transfer" key="button.transfer"/>"
			onclick="if(!confirmTransfer())return;Com_OpenWindow('sysAdminTransferTask.do?method=transfer&fdId=${param.fdId}','_self');">
	</kmss:auth>
</c:if>
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
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
			<bean:message bundle="sys-admin-transfer" key="sysAdminTransferTask.fdType"/>
		</td><td width="35%">
			<b>
			<c:choose>
			<c:when test="${sysAdminTransferTaskForm.fdStatus == '0' || sysAdminTransferTaskForm.fdStatus == '1'}">
				<bean:message bundle="sys-admin-transfer" key="sysAdminTransferTask.fdType.transfer"/>
			</c:when>
			<c:otherwise>
				<bean:message bundle="sys-admin-transfer" key="sysAdminTransferTask.fdType.notify"/>
			</c:otherwise>
			</c:choose>
			</b>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-admin-transfer" key="sysAdminTransferTask.fdUuid"/>
		</td><td width="85%" colspan="3">
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
			<xform:select property="fdStatus">
				<xform:enumsDataSource enumsType="sysAdminTransferTask.fdStatus" />
			</xform:select>
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
<%@ include file="/resource/jsp/view_down.jsp"%>