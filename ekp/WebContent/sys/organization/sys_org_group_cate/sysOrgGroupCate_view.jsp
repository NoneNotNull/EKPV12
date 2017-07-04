<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<script>
	function confirm_delete(msg){
	var del = confirm("<bean:message key="page.comfirmDelete"/>");
	return del;
}
</script>
<div id="optBarDiv">
<kmss:auth requestURL="/sys/organization/sys_org_group_cate/sysOrgGroupCate.do?method=edit&fdId=${sysOrgGroupCateForm.fdId}" requestMethod="GET">
	<input type="button" value="<bean:message key="button.edit"/>"
		onClick="Com_OpenWindow('sysOrgGroupCate.do?method=edit&fdId=<bean:write name="sysOrgGroupCateForm" property="fdId" />','_self');">
</kmss:auth>
<kmss:auth requestURL="/sys/organization/sys_org_group_cate/sysOrgGroupCate.do?method=delete&fdId=${sysOrgGroupCateForm.fdId}" requestMethod="GET">
	<input type="button" value="<bean:message key="button.delete"/>"
		onClick="if(!confirm_delete())return;Com_OpenWindow('sysOrgGroupCate.do?method=delete&fdId=<bean:write name="sysOrgGroupCateForm" property="fdId" />','_self');">
</kmss:auth>
<input type="button" value="<bean:message key="button.close"/>" onClick="Com_CloseWindow();">
</div>
<p class="txttitle"><bean:message bundle="sys-organization" key="table.sysOrgGroupCate"/></p>
<center>
<table class="tb_normal" width=95%>
	<tr>
		<td width=15% class="td_normal_title">
			<bean:message bundle="sys-organization" key="sysOrgGroupCate.fdParent"/>
		</td><td width=35%>
			<bean:write name="sysOrgGroupCateForm" property="fdParentName"/>
		</td>
		<td width=15% class="td_normal_title">
			<bean:message bundle="sys-organization" key="sysOrgGroupCate.fdName"/>
		</td><td width=35%>
			<bean:write name="sysOrgGroupCateForm" property="fdName"/>
		</td>
	</tr>
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>