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
<form name="templet" action="<%=request.getContextPath() %>/sys/transport/sys_transport_import/SysTransportImport.do" method="post">
	<input type="hidden" name="method" value="downloadTemplet">
	<input type="hidden" name="fdId" value="${param.fdId}">
	<input type="hidden" name="fdModelName" value="${sysTransportImportForm.fdModelName}">
</form>
<div id="optBarDiv">
	<!-- 模板下载按钮 -->
	<input type=button value="<bean:message bundle="sys-transport" key="sysTransport.button.download.templet"/>"
		onclick="submitExportForm();">
	<!-- 数据导入按钮 -->
	<input type="button" value="<bean:message bundle="sys-transport" key="sysTransport.button.dataImport"/>"
				onclick="Com_OpenWindow('SysTransportImport.do?method=showUploadForm&fdId=${param.fdId }&fdModelName=${sysTransportImportForm.fdModelName}');">
	<input type=button value="<bean:message key="button.edit"/>"
		onclick="Com_OpenWindow('SysTransportImport.do?method=edit&fdId=${param.fdId}&fdModelName=${sysTransportImportForm.fdModelName}','_self');">
	<input type=button value="<bean:message key="button.delete"/>"
		onclick="if(!confirmDelete())return;Com_OpenWindow('SysTransportImport.do?method=delete&fdId=${param.fdId}&fdModelName=${sysTransportImportForm.fdModelName}','_self');">
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>
<p class="txttitle"><kmss:message key="${modelMessageKey}"/><bean:message  bundle="sys-transport" key="table.sysTransportImportConfig"/></p>
<table class="tb_normal" width="500" align="center" id="transportTable">
	<tr>
		<td class="td_normal_title" width="20%"><bean:message  bundle="sys-transport" key="fdName"/></td>
		<td>${sysTransportImportForm.fdName }	</td>
	</tr>
	<tr>
		<td class="td_normal_title" width="20%"><bean:message  bundle="sys-transport" key="fdImportType"/></td>
		<td><sunbor:enumsShow value="${sysTransportImportForm.fdImportType}"
							enumsType="sysTransport_importType" bundle="sys-transport"/></td>
	</tr>
	<tr>
		<td class="td_normal_title" width="20%">
			<bean:message  bundle="sys-transport" key="sysTransport.label.selectedOptionList"/>
		</td>
		<td>${propertyNames }</td>
	</tr>
	<tr>
		<td class="td_normal_title" width="20%">
			<bean:message  bundle="sys-transport" key="sysTransport.label.primaryKey"/>
		</td>
		<td>${primaryKeyNames }</td>
	</tr>
	<c:forEach items="${foreignKeyMap }" var="foreignKey">
	<tr>
		<td class="td_normal_title" width="20%">${foreignKey.key }</td>
		<td>${foreignKey.value }</td>
	</tr>
	</c:forEach>
	<tr>
	<td class="td_normal_title" width="20%"><font color='red'><bean:message  bundle="sys-transport" key="sysTransport.import.hint"/></font></td>
		<td><bean:message  bundle="sys-transport" key="sysTransport.import.notice"/><br>
		 
		</td>
	</tr>
</table>
<%@ include file="/resource/jsp/view_down.jsp"%>