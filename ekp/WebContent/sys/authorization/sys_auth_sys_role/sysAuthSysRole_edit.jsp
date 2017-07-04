<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<script>
Com_IncludeFile("dialog.js");
</script>
<html:form action="/sys/authorization/sys_auth_sys_role/sysAuthSysRole.do">
<div id="optBarDiv">
	<kmss:auth requestURL="/sys/authorization/sys_auth_research/sysAuthResearch.do?method=researchRole">
		<input type="button"
			value="<bean:message bundle="sys-authorization" key="sysAuthResearch.tree.role"/>"
			onclick="Com_OpenWindow('<c:url value="/sys/authorization/sys_auth_research/sysAuthResearch.do" />?method=researchRole&roleId=${param.fdId}');">
	</kmss:auth>
	<input type=button value="<bean:message key="button.update"/>"
		onclick="Com_Submit(document.sysAuthRoleForm, 'update');">
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>
<p class="txttitle"><bean:message bundle="sys-authorization" key="sysAuthRole.sysRole"/></p>
<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-authorization" key="sysAuthRole.fdAuthName"/>
		</td><td width=85%>
			<html:hidden property="fdName"/>
			<kmss:message key="${sysAuthRoleForm.fdName}" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-authorization" key="sysAuthRole.fdType"/>
		</td><td width=85%>
			<html:hidden property="fdType"/>
			<xform:select property="fdType" showStatus="view">
				<xform:enumsDataSource enumsType="sys_authorization_fd_type"></xform:enumsDataSource>
			</xform:select>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title">
			<bean:message bundle="sys-authorization" key="sysAuthRole.fdDescription"/>
		</td><td>
			<html:hidden property="fdDescription"/>
			<kmss:message key="${sysAuthRoleForm.fdDescription}" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title">
			<bean:message bundle="sys-authorization" key="sysAuthRole.fdOrgElements"/>
		</td><td>
			<html:hidden property="fdOrgElementIds" />
			<html:textarea property="fdOrgElementNames" readonly="true" styleClass="inputmul" style="width:90%"/>
			<a href="#" onclick="Dialog_Address(true, 'fdOrgElementIds', 'fdOrgElementNames', ';', ORG_TYPE_ALL|ORG_FLAG_BUSINESSALL);">
				<bean:message key="dialog.selectOrg"/>
			</a>
		</td>
	</tr>
</table>
</center>
<html:hidden property="fdAlias"/>
<html:hidden property="method_GET"/>
<html:hidden property="fdId"/>
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>