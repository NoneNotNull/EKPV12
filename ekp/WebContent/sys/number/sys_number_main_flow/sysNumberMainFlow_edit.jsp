<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<html:form action="/sys/number/sys_number_main_flow/sysNumberMainFlow.do">
<div id="optBarDiv">
	<c:if test="${sysNumberMainFlowForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit(document.sysNumberMainFlowForm, 'update');">
	</c:if>
	<c:if test="${sysNumberMainFlowForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="Com_Submit(document.sysNumberMainFlowForm, 'save');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="sys-number" key="table.sysNumberMainFlow"/></p>

<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-number" key="sysNumberMainFlow.fdNumberMain"/>
		</td><td width="35%">
			<c:out value="${sysNumberMainFlowForm.fdNumberMainName}" />&nbsp;
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-number" key="sysNumberMainFlow.fdVirtualNumberValue"/>
		</td><td width="35%">
			<xform:text property="fdVirtualNumberValue" style="width:85%" showStatus="view"/>&nbsp;
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-number" key="sysNumberMainFlow.fdFlowNum"/>
		</td><td width="35%">
			<xform:text property="fdFlowNum" style="width:85%" />&nbsp;
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-number" key="sysNumberMainFlow.fdLimitsValue"/>
		</td><td width="35%">
			<xform:text property="fdLimitsValue" style="width:85%" showStatus="view"/>&nbsp;
		</td>
	</tr>
	<tr>
		<td colspan="4">
			[流水号为-1时说明该规则目前还未被文档使用]
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