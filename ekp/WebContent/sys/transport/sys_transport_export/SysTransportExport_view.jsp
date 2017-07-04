<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<script>
function confirmDelete(msg){
	var del = confirm("<bean:message key="page.comfirmDelete"/>");
	return del;
}
function submitExportForm() {
	document.templet.submit();
}
</script>
<form name="templet" action="<%=request.getContextPath() %>/sys/transport/sys_transport_export/SysTransportExport.do" method="post">
	<input type="hidden" name="method" value="export">
	<input type="hidden" name="fdId" value="${param.fdId}">
	<input type="hidden" name="fdModelName" value="${sysTransportExportForm.fdModelName}">
</form>
<div id="optBarDiv">
	<!-- 数据导出按钮 -->
	<input type="button" value="<bean:message bundle="sys-transport" key="sysTransport.button.dataExport"/>"
				onclick="submitExportForm();">
	<input type=button value="<bean:message key="button.edit"/>"
		onclick="Com_OpenWindow('SysTransportExport.do?method=edit&fdId=${param.fdId}&fdModelName=${sysTransportExportForm.fdModelName}','_self');">
	<input type=button value="<bean:message key="button.delete"/>"
		onclick="if(!confirmDelete())return;Com_OpenWindow('SysTransportExport.do?method=delete&fdId=${param.fdId}&fdModelName=${sysTransportExportForm.fdModelName}','_self');">
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>
<p class="txttitle"><kmss:message key="${modelMessageKey}"/><bean:message  bundle="sys-transport" key="table.sysTransportExportConfig"/></p>
<table class="tb_normal" width="500" align="center" id="transportTable">
	<tr>
		<td class="td_normal_title" width="20%"><bean:message  bundle="sys-transport" key="fdName"/></td>
		<td>${sysTransportExportForm.fdName }	</td>
	</tr>
	<tr>
		<td class="td_normal_title" width="20%">
			<bean:message  bundle="sys-transport" key="sysTransport.label.selectedOptionList"/>
		</td>
		<td>${propertyNames }</td>
	</tr>
</table>
<%@ include file="/resource/jsp/view_down.jsp"%>