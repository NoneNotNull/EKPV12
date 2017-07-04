<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<script>
function confirm_invalidated(){
	var msg = confirm("<bean:message bundle="sys-organization" key="organization.invalidated.comfirm"/>");
	return msg;
}
function confirm_copy(){
	var msg = confirm("<bean:message bundle="sys-organization" key="sysOrgRoleConf.copy.comfirm"/>");
	return msg;	
}
</script>
<div id="optBarDiv">
	<input type="button" value="<bean:message bundle="sys-organization" key="sysOrgRoleConf.simulator"/>"
		onclick="Com_OpenWindow('<c:url value="/sys/organization/sys_org_role/sysOrgRole_simulator.jsp"/>','_blank');">
	<kmss:auth requestURL="/sys/organization/sys_org_role_conf/sysOrgRoleConf.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
		<input type="button" value="<bean:message bundle="sys-organization" key="table.sysOrgRoleLine"/>"
			onclick="Com_OpenWindow('<c:url value="/sys/organization/sys_org_role_line/sysOrgRoleLine.do?method=roleTree&fdConfId=${param.fdId}" />','_blank');">
		<input type="button" value="<bean:message key="button.edit"/>"
			onclick="Com_OpenWindow('sysOrgRoleConf.do?method=edit&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<!--<kmss:auth requestURL="/sys/organization/sys_org_role_conf/sysOrgRoleConf.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
		<input type="button" value="<bean:message key="button.delete"/>"
			onclick="if(!confirmDelete())return;Com_OpenWindow('sysOrgRoleConf.do?method=delete&fdId=${param.fdId}','_self');">
	</kmss:auth>-->
	<c:if test="${sysOrgRoleConfForm.fdIsAvailable}">
	<kmss:auth
		requestURL="/sys/organization/sys_org_role_conf/sysOrgRoleConf.do?method==invalidated&fdId=${param.fdId}"
		requestMethod="GET">
		<input type="button" value="<bean:message key="organization.invalidated" bundle="sys-organization"/>"
				onclick="if(!confirm_invalidated())return;Com_OpenWindow('sysOrgRoleConf.do?method=invalidated&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<kmss:auth
		requestURL="/sys/organization/sys_org_role_conf/sysOrgRoleConf.do?method==updateCopy&fdId=${param.fdId}"
		requestMethod="GET">
		<input type="button" value="<bean:message key="sysOrgRoleConf.copy" bundle="sys-organization"/>"
				onclick="if(!confirm_copy())return;Com_OpenWindow('sysOrgRoleConf.do?method=updateCopy&fdId=${param.fdId}','_self');">
	</kmss:auth>	
	</c:if>		
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>
<p class="txttitle"><bean:message  bundle="sys-organization" key="table.sysOrgRoleConf"/></p>
<center>
<table class="tb_normal" width=60%>
	<tr>
		<td class="td_normal_title" width=20%>
			<bean:message  bundle="sys-organization" key="sysOrgRoleConf.fdName"/>
		</td><td width=80%>
			<c:out value="${sysOrgRoleConfForm.fdName}" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=20%>
			<bean:message  bundle="sys-organization" key="sysOrgRoleConf.fdOrder"/>
		</td><td width=80%>
			<c:out value="${sysOrgRoleConfForm.fdOrder}" />
		</td>
	</tr>
	<tr>
		<td width=20% class="td_normal_title">
			<bean:message bundle="sys-organization" key="sysOrgRoleConf.fdIsAvailable"/>
		</td><td width=80%>
			<sunbor:enumsShow value="${sysOrgRoleConfForm.fdIsAvailable}" enumsType="common_yesno" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=20%>
			<bean:message  bundle="sys-organization" key="sysOrgRoleConf.fdRoleLineEditors"/>
		</td><td width=80%>
			<c:out value="${sysOrgRoleConfForm.fdRoleLineEditorNames}" /><br><br style="font-size:5px">
			<bean:message  bundle="sys-organization" key="sysOrgRoleConf.fdRoleLineEditors.detail"/>
		</td>
	</tr>
	<tr align="center">
		<td class="td_normal_title" colspan="2"><bean:message bundle="sys-organization" key="table.sysOrgRole" /></td>
	</tr>
	<tr>
		<td colspan="2">
			<table width="100%" class="tb_normal">
				<tr align="center">
					<td class="td_normal_title" width="10%">
						<bean:message bundle="sys-organization" key="sysOrgRole.fdOrder" />
					</td>
					<td class="td_normal_title" width="25%">
						<bean:message bundle="sys-organization" key="sysOrgRole.fdName" />
					</td>
					<td class="td_normal_title" width="45%">
						<bean:message bundle="sys-organization" key="sysOrgRole.fdDescription" />
					</td>
					<td class="td_normal_title" width="10%">
						<bean:message bundle="sys-organization" key="sysOrgRole.fdIsAvailable" />
					</td>
					<td class="td_normal_title" width="10%">
						<kmss:auth requestURL="/sys/organization/sys_org_role/sysOrgRole.do?method=add&fdConfId=${sysOrgRoleConfForm.fdId}" requestMethod="GET">
							<a target="_blank" href="<c:url value='/sys/organization/sys_org_role/sysOrgRole.do?method=add&fdConfId=${sysOrgRoleConfForm.fdId}'/>"><bean:message key="button.add"/></a>
							<a href="#" onclick="history.go(0);"><bean:message key="button.refresh"/></a>
						</kmss:auth>
					</td>
				</tr>
				<c:forEach items="${roles}" var="role">
					<tr align="center">
						<td><c:out value="${role.fdOrder}" /></td>
						<td><c:out value="${role.fdName}" /></td>
						<td><c:out value="${role.fdMemo}" /></td>
						<td><sunbor:enumsShow value="${role.fdIsAvailable}" enumsType="common_yesno" /></td>
						<td>
							<kmss:auth requestURL="/sys/organization/sys_org_role/sysOrgRole.do?method=edit&fdId=${role.fdId}&fdConfId=${sysOrgRoleConfForm.fdId}" requestMethod="GET">
								<a href="<c:url value='/sys/organization/sys_org_role/sysOrgRole.do?method=edit&fdId=${role.fdId}&fdConfId=${sysOrgRoleConfForm.fdId}'/>" target="_blank"><bean:message key="button.edit"/></a>
							</kmss:auth>
							<!--<kmss:auth requestURL="/sys/organization/sys_org_role/sysOrgRole.do?method=delete&fdId=${role.fdId}&fdConfId=${sysOrgRoleConfForm.fdId}" requestMethod="GET">
								<a href="<c:url value='/sys/organization/sys_org_role/sysOrgRole.do?method=delete&fdId=${role.fdId}&fdConfId=${sysOrgRoleConfForm.fdId}'/>" target="_blank"><bean:message key="button.delete"/></a>
							</kmss:auth>-->
						</td>
					</tr>
				</c:forEach>
			</table>
		</td>
	</tr>
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>