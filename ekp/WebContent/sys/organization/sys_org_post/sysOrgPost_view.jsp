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
	<kmss:auth requestURL="/sys/organization/sys_org_post/sysOrgPost.do?method=edit&fdId=${sysOrgPostForm.fdId}" requestMethod="GET">
		<input type="button" value="<bean:message key="button.edit"/>"
			onClick="Com_OpenWindow('sysOrgPost.do?method=edit&fdId=${sysOrgPostForm.fdId}','_self');">
	</kmss:auth>
	<c:if test="${sysOrgPostForm.fdIsAvailable}">
	<kmss:auth requestURL="/sys/organization/sys_org_post/sysOrgPost.do?method=invalidated&fdId=${sysOrgPostForm.fdId}" requestMethod="GET">
		<input type="button" value="<bean:message bundle="sys-organization" key="organization.invalidated" />"
			onClick="if(!confirm_invalidated())return;Com_OpenWindow('sysOrgPost.do?method=invalidated&fdId=${sysOrgPostForm.fdId}','_self');">
	</kmss:auth>
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onClick="Com_CloseWindow();">
</div>
<p class="txttitle"><bean:message bundle="sys-organization" key="sysOrgElement.post"/></p>
<center>
<table class="tb_normal" width=95%>
	<tr>
		<td width=15% class="td_normal_title">
			<bean:message bundle="sys-organization" key="sysOrgPost.fdName"/>
		</td><td width=35%>
			<bean:write name="sysOrgPostForm" property="fdName"/>
		</td>
		<td width=15% class="td_normal_title">
			<bean:message bundle="sys-organization" key="sysOrgPost.fdNo"/>
		</td><td width=35%>
			<bean:write name="sysOrgPostForm" property="fdNo"/>
		</td>
	</tr>
	<tr>
		<td width=15% class="td_normal_title">
			<bean:message bundle="sys-organization" key="sysOrgPost.fdParent"/>
		</td><td width=35%>
			<bean:write name="sysOrgPostForm" property="fdParentName"/>
		</td>
		<td width=15% class="td_normal_title">
			<bean:message bundle="sys-organization" key="sysOrgPost.fdThisLeader"/>
		</td><td width=35%>
			<bean:write name="sysOrgPostForm" property="fdThisLeaderName"/>
		</td>
	</tr>
	<tr>
		<td width=15% class="td_normal_title">
			<bean:message bundle="sys-organization" key="sysOrgPost.fdKeyword"/>
		</td><td width=35%>
			<bean:write name="sysOrgPostForm" property="fdKeyword"/>
		</td>
		<td width=15% class="td_normal_title">
			<bean:message bundle="sys-organization" key="sysOrgPost.fdOrder"/>
		</td><td width=35%>
			<bean:write name="sysOrgPostForm" property="fdOrder"/>
		</td>
	</tr>
	<tr>
		<td width=15% class="td_normal_title">
			<bean:message bundle="sys-organization" key="sysOrgPost.fdIsBusiness"/>
		</td><td colspan=3>
			<sunbor:enumsShow value="${sysOrgPostForm.fdIsBusiness}" enumsType="common_yesno" />
		</td>
	</tr>
	<tr>
		<td width=15% class="td_normal_title">
			<bean:message bundle="sys-organization" key="sysOrgPost.fdPersons"/>
		</td><td colspan=3>
			<bean:write name="sysOrgPostForm" property="fdPersonNames"/>
		</td>
	</tr>
	<tr>
		<td width=15% class="td_normal_title">
			<bean:message bundle="sys-organization" key="sysOrgPost.fdIsAvailable"/>
		</td><td colspan=3>
			<sunbor:enumsShow value="${sysOrgPostForm.fdIsAvailable}" enumsType="common_yesno" />
		</td>
	</tr>	
	<tr>
		<td width=15% class="td_normal_title">
			<bean:message bundle="sys-organization" key="sysOrgPost.fdMemo"/>
		</td><td colspan="3">
			<kmss:showText value="${sysOrgPostForm.fdMemo}"/>
		</td>
	</tr>
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>