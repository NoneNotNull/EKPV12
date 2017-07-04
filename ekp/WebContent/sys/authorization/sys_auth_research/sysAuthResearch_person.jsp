<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.landray.kmss.sys.authorization.constant.ISysAuthConstant"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<script>
Com_IncludeFile("dialog.js");
Com_Parameter.IsAutoTransferPara = true;
function typeChange(name){
	var url = location.href;
	url = Com_SetUrlParameter(url, "type", name);
	location.href = url;
}
function resetRadio() {
	var url = location.href.toString();
	var _type = Com_GetUrlParameter(url, "type");
	var fields = document.getElementsByName("fd_type");
	for(var i = 0; i < fields.length; i++) {
		if(fields[i].value == _type){
			fields[i].checked = true;
			break;
		}
	}
}
Com_AddEventListener(window, "load", function() {resetRadio();});

function sysAuthAfterAreaChange(data) {
	if(data){
		var dat = data.GetHashMapArray(), url = location.href, areaId = "";
		if(dat){
			areaId = dat[0].id;
		}
		url = Com_SetUrlParameter(url, "areaId", areaId);
		url = Com_SetUrlParameter(url, "type", "1");
		location.href = url;
	}
}
</script>
<div class="txttitle">
	<bean:message bundle="sys-authorization" key="sysAuthResearch.tree.person" />
</div>
<center>
	<table class="tb_normal" width=95%>
		<% if(ISysAuthConstant.IS_AREA_ENABLED) { %>
		<tr>
			<td class="td_normal_title" width=15%>
				<bean:message bundle="sys-authorization" key="sysAuthResearch.page.type" />
			</td>
			<td width=85%>
				<label><input type="radio" name="fd_type" value="0" onclick="typeChange(this.value);" /><bean:message bundle="sys-authorization" key="sysAuthRole.fdType.common" /></label>
				<label><input type="radio" name="fd_type" value="1" onclick="typeChange(this.value);" /><bean:message bundle="sys-authorization" key="sysAuthRole.currentArea" />
				<c:if test="${not empty sysAuthResearchForm.areaName}">（${sysAuthResearchForm.areaName}）</c:if>
				<bean:message bundle="sys-authorization" key="sysAuthRole.fdType.area" /></label>
				<kmss:authShow roles="ROLE_SYSAUTHROLE_ADMIN;SYSROLE_ADMIN">
				<input name="btn" class="btnopt" type="button" value="<bean:message bundle="sys-authorization" key="sysAuthRole.otherArea"/>" style="height:18px" 
				onclick="Dialog_Tree(false,null,null,';','sysAuthAreaTreeService&parentId=!{value}','<bean:message bundle="sys-authorization" key="table.sysAuthArea"/>',null,sysAuthAfterAreaChange);">
				</kmss:authShow>
			</td>
		</tr>
		<% } %>
		<tr>
			<td class="td_normal_title" width=15%>
				<bean:message bundle="sys-organization" key="sysOrgPerson.fdName" />
			</td>
			<td width=85%>
				<bean:write name="sysAuthResearchForm" property="personName" />
			</td>
		</tr>
		<tr>
			<td class="td_normal_title" width="15%">
				<bean:message bundle="sys-organization" key="sysOrgPerson.fdMemo" />
			</td>
			<td width="85%">
				<bean:write name="sysAuthResearchForm" property="memo" />
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
				<bean:message bundle="sys-authorization" key="sysAuthResearch.page.roleNames" />
			</td>
			<td>
				<!-- bean:write name="sysAuthResearchForm" property="authRoleNames" /-->
				<!-- 角色展示部分 -->
				<c:import charEncoding="UTF-8" url="/sys/authorization/sys_auth_role/sysAuthAssign_view.jsp">
					<c:param name="formName" value="sysAuthResearchForm"/>
					<c:param name="authAssignMapName" value="fdAuthRoleMap"/>
				</c:import>
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
	LKSTree = new TreeView("LKSTree", "<bean:write name="sysAuthResearchForm" property="personName"/>", document.getElementById("treeDiv"));
	var n1 = LKSTree.treeRoot;
	var personId = Com_GetUrlParameter(location.href, "personId");
	n1.nodeType = ORG_TYPE_PERSON;
	n1.parameter = Com_Parameter.ContextPath+"sys/organization/sys_org_person/sysOrgPerson.do?method=view&fdId="+personId;
	n1.AppendBeanData("personAuthResearchTreeService&orgType=person&id="+personId+"&type=${param.type}&areaId=${param.areaId}");
	LKSTree.Show();
}
generateTree();
</script>
<%@ include file="/resource/jsp/view_down.jsp"%>
