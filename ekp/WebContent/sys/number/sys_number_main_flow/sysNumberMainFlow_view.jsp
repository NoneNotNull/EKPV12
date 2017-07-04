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
	<kmss:auth requestURL="/sys/number/sys_number_main_flow/sysNumberMainFlow.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.edit"/>"
			onclick="Com_OpenWindow('sysNumberMainFlow.do?method=edit&fdId=${param.fdId}','_self');">
	</kmss:auth>

	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="sys-number" key="table.sysNumberMainFlow"/></p>

<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=25%>
			<bean:message bundle="sys-number" key="sysNumberMainFlow.fdNumberMain"/>
		</td><td width="35%">
			<c:out value="${sysNumberMainFlowForm.fdNumberMainName}" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-number" key="sysNumberMainFlow.fdVirtualNumberValue"/>
		</td><td width="35%">
			<xform:text property="fdVirtualNumberValue" style="width:85%" />
		</td>
		
	</tr>
	<tr>
		<td class="td_normal_title" width=25%>
			<bean:message bundle="sys-number" key="sysNumberMainFlow.fdFlowNum"/>
		</td><td width="35%">
			<xform:text property="fdFlowNum" style="width:85%" />
		</td>
		<td class="td_normal_title" width=25%>
			<bean:message bundle="sys-number" key="sysNumberMainFlow.fdLimitsValue"/>
		</td><td width="35%">
			<xform:text property="fdLimitsValue" style="width:85%" />
		</td>
		
	</tr>
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>