<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.landray.kmss.sys.authorization.constant.ISysAuthConstant"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<script>
Com_IncludeFile("dialog.js");
function sysAuthAfterAreaChange(data) {
	if(data){
		var dat = data.GetHashMapArray(), url = location.href, areaId = "";
		if(dat && dat[0]){
			areaId = dat[0].id;
		}
		url = Com_SetUrlParameter(url, "areaId", areaId);
		location.href = url;
	}
}
</script>
<div class="txttitle">
	<bean:message bundle="sys-authorization" key="sysAuthResearch.tree.role" />
</div>
<center>
	<table class="tb_normal" width=95%>
	    <% if(ISysAuthConstant.IS_AREA_ENABLED) { %>
		<c:if test="${not empty sysAuthResearchForm.areaName}">
		<tr>
			<td class="td_normal_title" width="15%">
				<bean:message bundle="sys-authorization" key="sysAuthRole.authArea" />
			</td>
			<td width="85%">
				<bean:write name="sysAuthResearchForm" property="areaName" />
				<kmss:authShow roles="ROLE_SYSAUTHROLE_ADMIN;SYSROLE_ADMIN">
				<input name="btn" class="btnopt" type="button" value="<bean:message bundle="sys-authorization" key="sysAuthRole.otherArea"/>" style="height:18px" 
				onclick="Dialog_Tree(false,null,null,';','sysAuthAreaTreeService&parentId=!{value}','<bean:message bundle="sys-authorization" key="table.sysAuthArea"/>',null,sysAuthAfterAreaChange);">
				</kmss:authShow>
			</td>
		</tr>
		</c:if>
		<% } %>
		<tr>
			<td class="td_normal_title" width="15%">
				<bean:message bundle="sys-authorization" key="sysAuthRole.fdAuthName" />
			</td>
			<td width="85%">
				<bean:write name="sysAuthResearchForm" property="roleName" />
			</td>
		</tr>
		<% if(ISysAuthConstant.IS_AREA_ENABLED) { %>
		<tr>
			<td class="td_normal_title" width=15%>
				<bean:message bundle="sys-authorization" key="sysAuthRole.fdType"/>
			</td><td width=85%>
				<xform:select property="roleType" showStatus="view">
					<xform:enumsDataSource enumsType="sys_authorization_fd_type"></xform:enumsDataSource>
				</xform:select>
			</td>
		</tr>
		<% } %>
		<tr>
			<td class="td_normal_title" width="15%">
				<bean:message bundle="sys-authorization" key="sysAuthRole.fdDescription" />
			</td>
			<td width="85%">
				<bean:write name="sysAuthResearchForm" property="memo" />
			</td>
		</tr>
		<tr>
			<td class="td_normal_title">
				<bean:message bundle="sys-authorization" key="sysAuthResearch.page.roleNames" />
			</td>
			<td>
				<bean:write name="sysAuthResearchForm" property="authRoleNames" />
			</td>
		</tr>
		<tr>
			<td class="td_normal_title">
				<bean:message bundle="sys-authorization" key="sysAuthResearch.page.orgNames" />
			</td>
			<td>
				<bean:write name="sysAuthResearchForm" property="authOrgNames" />
			</td>
		</tr>
		<tr>
			<td class="td_normal_title">
				<bean:message bundle="sys-authorization" key="sysAuthResearch.page.tree" />
			</td>
			<td>
				<table class="tb_noborder">
					<tr>
						<td>
							<div id=treeDiv></div>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</center>
<script type="text/javascript">Com_IncludeFile("treeview.js");</script>
<script type="text/javascript">
var LKSTree;
Tree_IncludeCSSFile();
//Com_Parameter.XMLDebug = true;
function generateTree()
{
	LKSTree = new TreeView("LKSTree", "<bean:write name="sysAuthResearchForm" property="roleName" />", document.getElementById("treeDiv"));
	var n1 = LKSTree.treeRoot;
	var roleId = Com_GetUrlParameter(location.href, "roleId");
	n1.parameter = Com_Parameter.ContextPath+"sys/authorization/sys_auth_sys_role/sysAuthSysRole.do?method=view&fdId="+roleId;
	n1.AppendBeanData("roleAuthResearchTreeService&roleId="+roleId+"&areaId=${param.areaId}");
	LKSTree.Show();
}
generateTree();
</script>
<%@ include file="/resource/jsp/view_down.jsp"%>
