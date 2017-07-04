<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page
	import="com.landray.kmss.sys.organization.forms.SysOrgPersonForm"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<script>
function confirm_invalidated(){
	var msg = confirm("<bean:message bundle="sys-organization" key="organization.invalidated.comfirm"/>");
	return msg;
}
</script>
<div id="optBarDiv"><c:if test="${!sysOrgPersonForm.anonymous}">
	<kmss:auth
		requestURL="/sys/organization/sys_org_person/chgPersonInfo.do?method=chgPwd&fdId=${sysOrgPersonForm.fdId}"
		requestMethod="GET">
		<input type="button"
			value="<bean:message bundle="sys-organization" key="sysOrgPerson.button.changePassword"/>"
			onClick="Com_OpenWindow('chgPersonInfo.do?method=chgPwd&fdId=<bean:write name="sysOrgPersonForm" property="fdId" />','_self');">
	</kmss:auth>
</c:if> <kmss:auth
	requestURL="/sys/organization/sys_org_person/sysOrgPerson.do?method=edit&fdId=${sysOrgPersonForm.fdId}"
	requestMethod="GET">
	<input type="button" value="<bean:message key="button.edit"/>"
		onClick="Com_OpenWindow('sysOrgPerson.do?method=edit&fdId=<bean:write name="sysOrgPersonForm" property="fdId" />','_self');">
</kmss:auth> <c:if test="${!sysOrgPersonForm.anonymous && sysOrgPersonForm.fdIsAvailable}">
	<kmss:auth
		requestURL="/sys/organization/sys_org_person/sysOrgPerson.do?method=invalidated&fdId=${sysOrgPersonForm.fdId}"
		requestMethod="GET">
		<input type="button" value="<bean:message bundle="sys-organization" key="organization.invalidated" />"
			onClick="if(!confirm_invalidated())return;Com_OpenWindow('sysOrgPerson.do?method=invalidated&fdId=<bean:write name="sysOrgPersonForm" property="fdId" />','_self');">
	</kmss:auth>
</c:if> <input type="button" value="<bean:message key="button.close"/>"
	onClick="Com_CloseWindow();"></div>
<p class="txttitle"><bean:message bundle="sys-organization"
	key="sysOrgElement.person" /></p>
<center>
<table class="tb_normal" width=95%>
	<c:if test="${sysOrgPersonForm.anonymous}">
		<tr>
			<td width=15% class="td_normal_title"><bean:message
				bundle="sys-organization" key="sysOrgPerson.fdName" /></td>
			<td width=35%><bean:write name="sysOrgPersonForm"
				property="fdName" /></td>
			<td width=15% class="td_normal_title"><bean:message
				bundle="sys-organization" key="sysOrgPerson.fdLoginName" /></td>
			<td width=35%><bean:write name="sysOrgPersonForm"
				property="fdLoginName" /></td>
		</tr>
		<tr>
			<td width=15% class="td_normal_title"><bean:message
				bundle="sys-organization" key="sysOrgPerson.fdMemo" /></td>
			<td colspan=3><kmss:showText value="${sysOrgPersonForm.fdMemo}" />
			</td>
		</tr>
	</c:if>
	<c:if test="${!sysOrgPersonForm.anonymous}">
		<c:if test="${personImportType=='outer'}">
			<c:import url="${personExtendFormUrl}" charEncoding="UTF-8" />
		</c:if>
		<c:if test="${personImportType!='outer'}">
			<c:import
				url="/sys/organization/sys_org_person/sysOrgPerson_commonView.jsp"
				charEncoding="UTF-8" />
		</c:if>
	</c:if>
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>