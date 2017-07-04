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
	<kmss:auth requestURL="/sys/webservice2/sys_webservice_log/sysWebserviceLog.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.delete"/>"
			onclick="if(!confirmDelete())return;Com_OpenWindow('sysWebserviceLog.do?method=delete&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="sys-webservice2" key="table.sysWebserviceLog"/></p>

<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-webservice2" key="sysWebserviceLog.fdServiceName"/>
		</td><td width="35%">
			<xform:text property="fdServiceName" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-webservice2" key="sysWebserviceLog.fdServiceBean"/>
		</td><td width="35%">
			<xform:text property="fdServiceBean" style="width:85%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-webservice2" key="sysWebserviceLog.fdUserName"/>
		</td><td width="35%">
			<xform:text property="fdUserName" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-webservice2" key="sysWebserviceLog.fdClientIp"/>
		</td><td width="35%">
			<xform:text property="fdClientIp" style="width:85%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-webservice2" key="sysWebserviceLog.fdStartTime"/>
		</td><td width="35%">
			<xform:datetime property="fdStartTime" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-webservice2" key="sysWebserviceLog.fdEndTime"/>
		</td><td width="35%">
			<xform:datetime property="fdEndTime" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-webservice2" key="sysWebserviceLog.fdExecResult"/>
		</td><td width="85%" colspan="3">
			<xform:radio property="fdExecResult">
				<xform:enumsDataSource enumsType="sys_webservice_log_fd_exec_result" />
			</xform:radio> 
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-webservice2" key="sysWebserviceLog.fdErrorMsg"/>
		</td><td width="85%" colspan="3">
			<xform:textarea property="fdErrorMsg" style="width:85%"/>
		</td>
	</tr>	
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>