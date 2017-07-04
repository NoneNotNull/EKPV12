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
	<kmss:auth requestURL="/sys/organization/sys_org_org/sysOrgOrg.do?method=edit&fdId=${sysOrgOrgForm.fdId}" requestMethod="GET">
		<input type="button" value="<bean:message key="button.edit"/>"
			onClick="Com_OpenWindow('sysOrgOrg.do?method=edit&fdId=<bean:write name="sysOrgOrgForm" property="fdId" />','_self');">
	</kmss:auth>
	<c:if test="${sysOrgOrgForm.fdIsAvailable}">
	<kmss:auth requestURL="/sys/organization/sys_org_org/sysOrgOrg.do?method=invalidated&fdId=${sysOrgOrgForm.fdId}" requestMethod="GET">
		<input type="button" value="<bean:message bundle="sys-organization" key="organization.invalidated" />"
			onClick="if(!confirm_invalidated())return;Com_OpenWindow('sysOrgOrg.do?method=invalidated&fdId=<bean:write name="sysOrgOrgForm" property="fdId" />','_self');">
	</kmss:auth>
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onClick="Com_CloseWindow();">
</div>
<div class="txttitle"><bean:message bundle="sys-organization" key="sysOrgElement.org"/></div>
<center>
<table class="tb_normal" width=95%>
	<tr>
		<td width=15% class="td_normal_title">
			<bean:message bundle="sys-organization" key="sysOrgOrg.fdName"/>
		</td><td width=35% colspan="3">
			<bean:write name="sysOrgOrgForm" property="fdName"/>
		</td>
	</tr>
	<tr>
		<td width=15% class="td_normal_title">
			<bean:message bundle="sys-organization" key="sysOrgOrg.fdParent"/>
		</td><td width=35%>
			<bean:write name="sysOrgOrgForm" property="fdParentName"/>
		</td>
		<td width=15% class="td_normal_title">
			<bean:message bundle="sys-organization" key="sysOrgOrg.fdNo"/>
		</td><td width=35%>
			<bean:write name="sysOrgOrgForm" property="fdNo"/>
		</td>
	</tr>
	<tr>
		<td width=15% class="td_normal_title">
			<bean:message bundle="sys-organization" key="sysOrgOrg.fdThisLeader"/>
		</td><td width=35%>
			<bean:write name="sysOrgOrgForm" property="fdThisLeaderName"/>
		</td>
		<td width=15% class="td_normal_title">
			<bean:message bundle="sys-organization" key="sysOrgOrg.fdSuperLeader"/>
		</td><td width=35%>
			<bean:write name="sysOrgOrgForm" property="fdSuperLeaderName"/>
		</td>
	</tr>
	<tr>
		<td width=15% class="td_normal_title">
			<bean:message bundle="sys-organization" key="sysOrgOrg.fdKeyword"/>
		</td><td width=35%>
			<bean:write name="sysOrgOrgForm" property="fdKeyword"/>
		</td>
		<td width=15% class="td_normal_title">
			<bean:message bundle="sys-organization" key="sysOrgOrg.fdOrder"/>
		</td><td width=35%>
			<bean:write name="sysOrgOrgForm" property="fdOrder"/>
		</td>
	</tr>
	<tr>
		<td width=15% class="td_normal_title">
			<bean:message bundle="sys-organization" key="sysOrgOrg.fdIsBusiness"/>
		</td><td width=35%>
			<sunbor:enumsShow value="${sysOrgOrgForm.fdIsBusiness}" enumsType="common_yesno" />
		</td>
		<td width=15% class="td_normal_title">
			<bean:message bundle="sys-organization" key="sysOrgOrg.fdIsAvailable"/>
		</td><td width=35%>
			<sunbor:enumsShow value="${sysOrgOrgForm.fdIsAvailable}" enumsType="common_yesno" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-organization" key="sysOrgElement.authElementAdmins"/>
		</td><td width="85%" colspan="3">
			<xform:address propertyId="authElementAdminIds" propertyName="authElementAdminNames" mulSelect="true" orgType="ORG_TYPE_POSTORPERSON" style="width:85%" />
		</td>
	</tr>		
	<tr>
		<td width=15% class="td_normal_title">
			<bean:message bundle="sys-organization" key="sysOrgOrg.fdMemo"/>
		</td><td colspan="3">
			<kmss:showText value="${sysOrgOrgForm.fdMemo}"/>
		</td>
	</tr>
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>