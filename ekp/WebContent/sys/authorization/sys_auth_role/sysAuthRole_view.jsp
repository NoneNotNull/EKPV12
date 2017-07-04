<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<script>
function confirm_delete(msg) {
	var del = confirm('<bean:message key="page.comfirmDelete"/>');
	return del;
}
</script>
<div id="optBarDiv">
<kmss:auth requestURL="/sys/authorization/sys_auth_role/sysAuthRole.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
	<input type="button"
		value="<bean:message key="button.edit"/>"
		onclick="Com_OpenWindow('sysAuthRole.do?method=edit&fdId=<bean:write name="sysAuthRoleForm" property="fdId" />&type=${param.type}','_self');">
</kmss:auth>
<kmss:auth requestURL="/sys/authorization/sys_auth_role/sysAuthRole.do?method=delete&fdId=${param.fdId}&type=${param.type}" requestMethod="GET">
	<input type="button"
		value="<bean:message key="button.delete"/>"
		onclick="if(!confirm_delete())return;Com_OpenWindow('sysAuthRole.do?method=delete&fdId=<bean:write name="sysAuthRoleForm" property="fdId" />&type=${param.type}','_self');">
</kmss:auth>
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>
<p class="txttitle"><bean:message bundle="sys-authorization" key="table.sysAuthRole"/></p>
<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-authorization" key="sysAuthRole.fdName"/>
		</td><td width=35%>
			<bean:write name="sysAuthRoleForm" property="fdName"/>
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-authorization" key="sysAuthRole.sysAuthCategory" />
		</td><td width=35%>
			<xform:select property="fdCategoryId">
				<xform:beanDataSource serviceBean="sysAuthCategoryService" orderBy="sysAuthCategory.fdOrder"/>
			</xform:select>
		</td>
	</tr> 	
	
	<c:if test="${param.type != '2' && (sysAuthRoleForm.fdType == '1' || sysAuthRoleForm.fdType == '2')}">
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-authorization" key="sysAuthRole.authArea"/>
		</td><td width=85% colspan="3">
			<bean:write name="sysAuthRoleForm" property="authAreaName"/>
		</td>
	</tr>
	</c:if>

	<c:if test="${param.type != '2'}">
	<tr>
		<td class="td_normal_title">
			<bean:message bundle="sys-authorization" key="sysAuthRole.fdOrgElements"/>
		</td><td colspan="3">
			<bean:write name="sysAuthRoleForm" property="fdOrgElementNames"/>
		</td>
	</tr>
	</c:if>
	<tr>
		<td class="td_normal_title">
			<bean:message bundle="sys-authorization" key="sysAuthRole.fdAuthAssign"/>
		</td><td colspan="3">
			<!-- 权限部分 -->
			<c:import charEncoding="UTF-8" url="/sys/authorization/sys_auth_role/sysAuthAssign_view.jsp">
				<c:param name="formName" value="sysAuthRoleForm"/>
				<c:param name="authAssignMapName" value="fdAuthAssignMap"/>
			</c:import>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title">
			<bean:message bundle="sys-authorization" key="sysAuthRole.fdInhRoles"/>
		</td><td colspan="3">
			<bean:write name="sysAuthRoleForm" property="fdInhRoleNames"/>
		</td>
	</tr>
	<c:if test="${sysAuthRoleForm.fdType == '0'}">
	<tr>
		<td class="td_normal_title">
			<bean:message bundle="sys-authorization" key="sysAuthRole.authEditors"/>
		</td><td colspan="3">
			<bean:write name="sysAuthRoleForm" property="authEditorNames"/>
		</td>
	</tr>
	</c:if>
	<tr>
		<td class="td_normal_title">
			<bean:message bundle="sys-authorization" key="sysAuthRole.fdDescription"/>
		</td><td colspan="3">
			<bean:write name="sysAuthRoleForm" property="fdDescription"/>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title">
			<bean:message bundle="sys-authorization" key="sysAuthRole.fdCreator"/>
		</td><td width=35%>
			<bean:write name="sysAuthRoleForm" property="fdCreatorName"/>
		</td>
		<td class="td_normal_title">
		</td><td width=35%>
		</td>
	</tr>
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>