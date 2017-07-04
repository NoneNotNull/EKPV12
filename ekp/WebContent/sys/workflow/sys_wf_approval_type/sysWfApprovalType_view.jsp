<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<script>
	function confirmDelete(msg){
	var del = confirm("<bean:message key="page.comfirmDelete"/>");
	return del;
}
</script>
<div id="optBarDiv">
		<kmss:auth requestURL="/sys/workflow/base/sys_wf_approval_type/sysWfApprovalType.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
			<input type="button"
				value="<bean:message key="button.edit"/>"
				onclick="Com_OpenWindow('sysWfApprovalType.do?method=edit&fdId=${param.fdId}','_self');">
		</kmss:auth>
		<kmss:auth requestURL="/sys/workflow/base/sys_wf_approval_type/sysWfApprovalType.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
			<input type="button"
				value="<bean:message key="button.delete"/>"
				onclick="if(!confirmDelete())return;Com_OpenWindow('sysWfApprovalType.do?method=delete&fdId=${param.fdId}','_self');">
		</kmss:auth>
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>
<p class="txttitle"><bean:message  bundle="sys-workflow" key="table.sysWfApprovalType"/></p>
<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-workflow" key="sysWfApprovalType.fdName"/>
		</td><td width=35%>
			<c:out value="${sysWfApprovalTypeForm.fdName}" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-workflow" key="sysWfApprovalType.fdOrder"/>
		</td><td width=35%>
			<c:out value="${sysWfApprovalTypeForm.fdOrder}" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-workflow" key="sysWfApprovalType.fdProhibit"/>
		</td><td width=85% colspan=3>
			<input type="checkbox" disabled='true' <c:if test="${sysWfApprovalTypeForm.fdProhibitDraftor == 'true'}">checked</c:if>>
			<bean:message  bundle="sys-workflow" key="sysWfApprovalType.fdProhibit.draftor"/>
		</td>
	</tr>
	<%--tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-workflow" key="sysWfApprovalType.description"/>
		</td><td width=85% colspan=3>
			<li><bean:message  bundle="sys-workflow" key="sysWfApprovalType.description.content.1"/></li>
			<li><bean:message  bundle="sys-workflow" key="sysWfApprovalType.description.content.2"/></li>
		</td>
	</tr>--%>
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>