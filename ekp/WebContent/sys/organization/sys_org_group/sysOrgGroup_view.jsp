<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<script>
function confirm_invalidated(){
	var msg = confirm("<bean:message bundle="sys-organization" key="organization.invalidated.comfirm"/>");
	return msg;
}
</script>
<div id="optBarDiv">
	<kmss:auth requestURL="/sys/organization/sys_org_group/sysOrgGroup.do?method=edit&fdId=${sysOrgGroupForm.fdId}" requestMethod="GET">
		<input type="button" value="<bean:message key="button.edit"/>"
			onClick="Com_OpenWindow('sysOrgGroup.do?method=edit&fdId=<bean:write name="sysOrgGroupForm" property="fdId" />','_self');">
	</kmss:auth>
	<c:if test="${sysOrgGroupForm.fdIsAvailable}">
	<kmss:auth requestURL="/sys/organization/sys_org_group/sysOrgGroup.do?method=invalidated&fdId=${sysOrgGroupForm.fdId}" requestMethod="GET">
		<input type="button" value="<bean:message bundle="sys-organization" key="organization.invalidated" />"
			onClick="if(!confirm_invalidated())return;Com_OpenWindow('sysOrgGroup.do?method=invalidated&fdId=<bean:write name="sysOrgGroupForm" property="fdId" />','_self');">
	</kmss:auth>
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onClick="Com_CloseWindow();">
</div>
<div class="txttitle"><bean:message bundle="sys-organization" key="sysOrgElement.group"/></div>
<center>
<table class="tb_normal" width=95%>
	<tr>
		<td width=15% class="td_normal_title">
			<bean:message bundle="sys-organization" key="sysOrgGroup.fdName"/>
		</td><td colspan="3">
			<bean:write name="sysOrgGroupForm" property="fdName"/>
		</td>
	</tr>
	<tr>
		<td width=15% class="td_normal_title">
			<bean:message bundle="sys-organization" key="sysOrgGroup.fdGroupCate"/>
		</td><td width=35%>
			<bean:write name="sysOrgGroupForm" property="fdGroupCateName"/>
		</td>
		<td width=15% class="td_normal_title">
			<bean:message bundle="sys-organization" key="sysOrgGroup.fdNo"/>
		</td><td width=35%>
			<bean:write name="sysOrgGroupForm" property="fdNo"/>
		</td>
	</tr>
	<tr>
		<td width=15% class="td_normal_title">
			<bean:message bundle="sys-organization" key="sysOrgGroup.fdKeyword"/>
		</td><td width=35%>
			<bean:write name="sysOrgGroupForm" property="fdKeyword"/>
		</td>
		<td width=15% class="td_normal_title">
			<bean:message bundle="sys-organization" key="sysOrgGroup.fdOrder"/>
		</td><td width=35%>
			<bean:write name="sysOrgGroupForm" property="fdOrder"/>
		</td>
	</tr>
	<tr>
		<td width=15% class="td_normal_title">
			<bean:message bundle="sys-organization" key="sysOrgGroup.fdMembers"/>
		</td><td colspan="3">
			<bean:write name="sysOrgGroupForm" property="fdMemberNames"/>
		</td>
	</tr>
	<tr>
		<td width=15% class="td_normal_title">
			<bean:message bundle="sys-organization" key="sysOrgGroup.fdIsAvailable"/>
		</td><td colspan="3">
			<sunbor:enumsShow value="${sysOrgGroupForm.fdIsAvailable}" enumsType="common_yesno" />
		</td>
	</tr>	
	<tr>
		<td width=15% class="td_normal_title">
			<bean:message bundle="sys-organization" key="sysOrgGroup.fdMemo"/>
		</td><td colspan="3">
			<kmss:showText value="${sysOrgGroupForm.fdMemo}"/>
		</td>
	</tr>
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>