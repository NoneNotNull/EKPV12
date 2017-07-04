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
		<kmss:auth requestURL="/sys/lbpmext/integrate/authorize/lbpm_authorize/lbpmAuthorizeScope.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
			<input type="button"
				value="<bean:message key="button.edit"/>"
				onclick="Com_OpenWindow('lbpmAuthorizeScope.do?method=edit&fdId=${param.fdId}','_self');">
		</kmss:auth>
		<kmss:auth requestURL="/sys/lbpmext/integrate/authorize/lbpm_authorize/lbpmAuthorizeScope.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
			<input type="button"
				value="<bean:message key="button.delete"/>"
				onclick="if(!confirmDelete())return;Com_OpenWindow('lbpmAuthorizeScope.do?method=delete&fdId=${param.fdId}','_self');">
		</kmss:auth> 
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>
<p class="txttitle"><bean:message  bundle="sys-lbpmext-authorize" key="table.lbpmAuthorizeScope"/></p>
<center>
<table class="tb_normal" width=95%>
		<html:hidden name="lbpmAuthorizeScopeForm" property="fdId"/>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-lbpmext-authorize" key="table.lbpmAuthorize"/>.<bean:message  bundle="sys-lbpmext-authorize" key="sysWfAuthorize.fdId"/>
		</td><td width=35%>
			<c:out value="${lbpmAuthorizeScopeForm.sysWfAuthorize.fdId}" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-lbpmext-authorize" key="lbpmAuthorizeScope.fdAuthorizeCateId"/>
		</td><td width=35%>
			<c:out value="${lbpmAuthorizeScopeForm.fdAuthorizeCateId}" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-lbpmext-authorize" key="lbpmAuthorizeScope.fdAuthorizeCateName"/>
		</td><td width=35%>
			<c:out value="${lbpmAuthorizeScopeForm.fdAuthorizeCateName}" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-lbpmext-authorize" key="lbpmAuthorizeScope.fdAuthorizeCateShowtext"/>
		</td><td width=35%>
			<c:out value="${lbpmAuthorizeScopeForm.fdAuthorizeCateShowtext}" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-lbpmext-authorize" key="lbpmAuthorizeScope.fdModelName"/>
		</td><td width=35%>
			<c:out value="${lbpmAuthorizeScopeForm.fdModelName}" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-lbpmext-authorize" key="lbpmAuthorizeScope.fdModuleName"/>
		</td><td width=35%>
			<c:out value="${lbpmAuthorizeScopeForm.fdModuleName}" />
		</td>
	</tr>
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>