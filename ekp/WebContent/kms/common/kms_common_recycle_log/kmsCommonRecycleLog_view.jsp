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
	<kmss:auth requestURL="/kms/common/kms_common_recycle_log/kmsCommonRecycleLog.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.delete"/>"
			onclick="if(!confirmDelete())return;Com_OpenWindow('kmsCommonRecycleLog.do?method=delete&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="kms-common" key="table.kmsCommonRecycleLog"/></p>

<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-common" key="kmsCommonRecycleLog.fdOperateName"/>
		</td><td width="35%">
			<xform:select property="fdOperateName">
				<xform:enumsDataSource enumsType="kms_common_recycle_log_fd_operate_name" />
			</xform:select>
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-common" key="kmsCommonRecycleLog.fdOperateTime"/>
		</td><td width="35%">
			<xform:datetime property="fdOperateTime" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-common" key="kmsCommonRecycleLog.operateDocSubject"/>
		</td><td width="35%">
			<c:out value="${kmsCommonRecycleLogForm.operateDocSubject}" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-common" key="kmsCommonRecycleLog.fdOperatorName"/>
		</td><td width="35%">
			<c:out value="${kmsCommonRecycleLogForm.fdOperatorName}" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-common" key="kmsCommonRecycleLog.fdOperateDescription"/>
		</td><td width="85%" colspan="3">
			<c:out value="${kmsCommonRecycleLogForm.fdOperateDescription}" />
		</td>
	</tr>
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>