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
	<kmss:auth requestURL="/sys/organization/sys_org_dept/sysOrgDept.do?method=edit&fdId=${sysOrgDeptForm.fdId}" requestMethod="GET">
		<input type="button" value="<bean:message key="button.edit"/>"
			onClick="Com_OpenWindow('sysOrgDept.do?method=edit&fdId=<bean:write name="sysOrgDeptForm" property="fdId" />','_self');">
	</kmss:auth>
	<c:if test="${sysOrgDeptForm.fdIsAvailable}">
	<kmss:auth requestURL="/sys/organization/sys_org_dept/sysOrgDept.do?method=invalidated&fdId=${sysOrgDeptForm.fdId}" requestMethod="GET">
		<input type="button" value="<bean:message bundle="sys-organization" key="organization.invalidated" />"
			onClick="if(!confirm_invalidated())return;Com_OpenWindow('sysOrgDept.do?method=invalidated&fdId=<bean:write name="sysOrgDeptForm" property="fdId" />','_self');">
	</kmss:auth>
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onClick="Com_CloseWindow();">
</div>
<div class="txttitle"><bean:message bundle="sys-organization" key="sysOrgElement.dept"/></div>
<center>
<table class="tb_normal" width=95%>
	<tr>
		<td width=15% class="td_normal_title">
			<bean:message bundle="sys-organization" key="sysOrgDept.fdName"/>
		</td><td width=35% colspan="3">
			<bean:write name="sysOrgDeptForm" property="fdName"/>
		</td>
	</tr>
	<tr>
		<td width=15% class="td_normal_title">
			<bean:message bundle="sys-organization" key="sysOrgDept.fdParent"/>
		</td><td width=35%>
			<bean:write name="sysOrgDeptForm" property="fdParentName"/>
		</td>
		<td width=15% class="td_normal_title">
			<bean:message bundle="sys-organization" key="sysOrgDept.fdNo"/>
		</td><td width=35%>
			<bean:write name="sysOrgDeptForm" property="fdNo"/>
		</td>
	</tr>
	<tr>
		<td width=15% class="td_normal_title">
			<bean:message bundle="sys-organization" key="sysOrgDept.fdThisLeader"/>
		</td><td width=35%>
			<bean:write name="sysOrgDeptForm" property="fdThisLeaderName"/>
		</td>
		<td width=15% class="td_normal_title">
			<bean:message bundle="sys-organization" key="sysOrgDept.fdSuperLeader"/>
		</td><td width=35%>
			<bean:write name="sysOrgDeptForm" property="fdSuperLeaderName"/>
		</td>
	</tr>
	<tr>
		<td width=15% class="td_normal_title">
			<bean:message bundle="sys-organization" key="sysOrgDept.fdKeyword"/>
		</td><td width=35%>
			<bean:write name="sysOrgDeptForm" property="fdKeyword"/>
		</td>
		<td width=15% class="td_normal_title">
			<bean:message bundle="sys-organization" key="sysOrgDept.fdOrder"/>
		</td><td width=35%>
			<bean:write name="sysOrgDeptForm" property="fdOrder"/>
		</td>
	</tr>
	<tr>
		<td width=15% class="td_normal_title">
			<bean:message bundle="sys-organization" key="sysOrgDept.fdIsBusiness"/>
		</td><td width=35%>
			<sunbor:enumsShow value="${sysOrgDeptForm.fdIsBusiness}" enumsType="common_yesno" />
		</td>
		<td width=15% class="td_normal_title">
			<bean:message bundle="sys-organization" key="sysOrgDept.fdIsAvailable"/>
		</td><td width=35%>
			<sunbor:enumsShow value="${sysOrgDeptForm.fdIsAvailable}" enumsType="common_yesno" />
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
			<bean:message bundle="sys-organization" key="sysOrgDept.fdMemo"/>
		</td><td colspan="3">
			<kmss:showText value="${sysOrgDeptForm.fdMemo}"/>
		</td>
	</tr>
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>