<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ page import="com.landray.kmss.sys.authorization.constant.ISysAuthConstant"%>	
<%@ page import="com.landray.kmss.sys.authorization.forms.SysAuthRoleForm"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<%
    SysAuthRoleForm sysAuthRoleForm = (SysAuthRoleForm)request.getAttribute("sysAuthRoleForm");
%>
<div id="optBarDiv">
	<kmss:auth requestURL="/sys/authorization/sys_auth_research/sysAuthResearch.do?method=researchRole">
		<input type="button"
			value="<bean:message bundle="sys-authorization" key="sysAuthResearch.tree.role"/>"
			onclick="Com_OpenWindow('<c:url value="/sys/authorization/sys_auth_research/sysAuthResearch.do" />?method=researchRole&roleId=${param.fdId}');">
	</kmss:auth>
	<% if(!ISysAuthConstant.IS_AREA_ENABLED || ISysAuthConstant.ROLE_COMMON.equals(sysAuthRoleForm.getFdType())) { %>
	<input type="button"
		value="<bean:message key="button.edit"/>"
		onclick="Com_OpenWindow('sysAuthSysRole.do?method=edit&fdId=<bean:write name="sysAuthRoleForm" property="fdId" />','_self');">
	<% } %>
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>
<p class="txttitle"><bean:message bundle="sys-authorization" key="sysAuthRole.sysRole"/></p>
<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-authorization" key="sysAuthRole.fdAuthName"/>
		</td><td width=85%>
			<kmss:message key="${sysAuthRoleForm.fdName}" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-authorization" key="sysAuthRole.fdType"/>
		</td><td width=85%>
			<xform:select property="fdType" showStatus="view">
				<xform:enumsDataSource enumsType="sys_authorization_fd_type"></xform:enumsDataSource>
			</xform:select>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title">
			<bean:message bundle="sys-authorization" key="sysAuthRole.fdDescription"/>
		</td><td>
			<kmss:message key="${sysAuthRoleForm.fdDescription}" />
		</td>
	</tr>
	<% if(!ISysAuthConstant.IS_AREA_ENABLED || ISysAuthConstant.ROLE_COMMON.equals(sysAuthRoleForm.getFdType())) { %>
	<tr>
		<td class="td_normal_title">
			<bean:message bundle="sys-authorization" key="sysAuthRole.fdOrgElements"/>
		</td><td>  
			<bean:write name="sysAuthRoleForm" property="fdOrgElementNames"/>		
		</td>
	</tr>
	<% } %>
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>