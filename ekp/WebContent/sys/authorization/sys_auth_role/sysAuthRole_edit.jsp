<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<%
	request.setAttribute("currentUser", UserUtil.getKMSSUser(request));
%>
<script>
Com_IncludeFile("data.js|dialog.js|jquery.js");
function selectAuthAssign(){
	var dialog = new KMSSDialog(true, true);
	var node = dialog.CreateTree("<bean:message bundle="sys-authorization" key="sysAuthRole.sysRole"/>");
	dialog.winTitle = "<bean:message bundle="sys-authorization" key="sysAuthRole.sysRole"/>";
	node.AppendBeanData("sysAuthModuleTree", "sysAuthRoleDialog&module=!{value}", null, false);
	node.parameter = "sysAuthRoleDialog&module=!{value}";
	dialog.BindingField("fdAuthAssignIds", "fdAuthAssignNames", ";");
	dialog.Show();
}

function preSubmit(method){
	var authIds=document.getElementsByName("fdAuthAssignIds")[0];
	var authIdArr=document.getElementsByName("fdAuthAssignId");
	var authStr="";
	if(authIdArr.length>0){
		for (var i=0;i<authIdArr.length;i++) {
			if(authIdArr[i].checked){
				authStr+= ";" + authIdArr[i].value;
			}
		}
		if(authStr!="")
			authIds.value=authStr.substring(1);
		else
			authIds.value="";
	}
	// 校验角色唯一
	var fdName = document.getElementsByName("fdName")[0];
	if(fdName != null) {
		var data = new KMSSData();
	    data.AddBeanData("sysAuthRoleService&fdId=${sysAuthRoleForm.fdId}&fdType=${sysAuthRoleForm.fdType}&fdName=" + encodeURIComponent(fdName.value));
	    var selectData = data.GetHashMapArray();
	    if (selectData != null && selectData[0] != null) {
	    	if(selectData[0]['isDuplicate'] == "true") {
				alert('<bean:message bundle="sys-authorization" key="sysAuthRole.fdName.duplicate" />');
				return false;
			}
		}
	}
	Com_Submit(document.sysAuthRoleForm,method);
}
</script>
<html:form action="/sys/authorization/sys_auth_role/sysAuthRole.do">
<div id="optBarDiv">
	<logic:equal name="sysAuthRoleForm" property="method_GET" value="edit">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="preSubmit('update');">
	</logic:equal>
	<logic:equal name="sysAuthRoleForm" property="method_GET" value="add">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="preSubmit('save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="preSubmit('saveadd');">
	</logic:equal>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>
<%-- 权限请查看design.xml --%>
<kmss:authShow baseOrgIds="${sysAuthRoleForm.authEditorIds}">
	<c:set var="isOnlyOrgEditor" value="1"/>
</kmss:authShow>
<kmss:authShow roles="ROLE_SYSAUTHROLE_ADMIN;SYSROLE_ADMIN">
	<c:set var="isOnlyOrgEditor" value="0"/>
</kmss:authShow>
<c:if test="${sysAuthRoleForm.fdType == '1'}">
	<kmss:authShow authAreaIds="${sysAuthRoleForm.authAreaId}">
	<c:set var="isOnlyOrgEditor" value="0"/>
	</kmss:authShow>
</c:if>
<c:if test="${param.type == '1' && sysAuthRoleForm.fdType == '2'}">
	<kmss:authShow authAreaIds="${sysAuthRoleForm.authAreaId}">
	<c:set var="isOnlyOrgEditor" value="1"/>
	</kmss:authShow>
</c:if>
<p class="txttitle"><bean:message bundle="sys-authorization" key="table.sysAuthRole"/></p>
<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-authorization" key="sysAuthRole.fdName"/>
		</td><td width=35%>
			<c:choose>
			<c:when test="${isOnlyOrgEditor=='0'}">
				<xform:text property="fdName" style="width:90%"></xform:text>
			</c:when>
			<c:otherwise>
				<xform:text property="fdName" style="width:90%" showStatus="readOnly" className="inputread"></xform:text>
			</c:otherwise>
			</c:choose>
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-authorization" key="sysAuthRole.sysAuthCategory" />
		</td><td width=35%>
			<c:choose>
			<c:when test="${isOnlyOrgEditor=='0'}">
				<xform:select property="fdCategoryId">
					<xform:beanDataSource serviceBean="sysAuthCategoryService" orderBy="sysAuthCategory.fdOrder"/>
				</xform:select>
			</c:when>
			<c:otherwise>
				<xform:select property="fdCategoryId" showStatus="view">
					<xform:beanDataSource serviceBean="sysAuthCategoryService" orderBy="sysAuthCategory.fdOrder"/>
				</xform:select>
			</c:otherwise>
			</c:choose>
		</td>
	</tr>  	
 	
	<c:if test="${param.type != '2' && (sysAuthRoleForm.fdType == '1' || sysAuthRoleForm.fdType == '2')}">
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-authorization" key="sysAuthRole.authArea"/>
		</td><td width=85% colspan="3">
			<html:hidden property="authAreaId" />
			<html:hidden property="authAreaName" />
			<bean:write name="sysAuthRoleForm" property="authAreaName"/>
		</td>
	</tr>
	</c:if>

	<c:if test="${param.type != '2'}">
	<tr>
		<td class="td_normal_title">
			<bean:message bundle="sys-authorization" key="sysAuthRole.fdOrgElements"/>
		</td><td colspan="3">
			<c:choose>
			<c:when test="${isOnlyOrgEditor=='0' || isOnlyOrgEditor=='1'}">
				<xform:address propertyId="fdOrgElementIds" propertyName="fdOrgElementNames"
					orgType="ORG_TYPE_ALL|ORG_FLAG_BUSINESSALL" textarea="true" mulSelect="true" style="width: 90%">
				</xform:address>
			</c:when>
			<c:otherwise>
				<xform:address propertyId="fdOrgElementIds" propertyName="fdOrgElementNames"
					orgType="ORG_TYPE_ALL|ORG_FLAG_BUSINESSALL" textarea="true" mulSelect="true" style="width: 90%" showStatus="readOnly">
				</xform:address>
			</c:otherwise>
			</c:choose>
		</td>
	</tr>
	</c:if>	
	<tr>
		<td class="td_normal_title">
			<bean:message bundle="sys-authorization" key="sysAuthRole.fdAuthAssign"/>
		</td><td colspan="3">
			<html:hidden property="fdAuthAssignIds" />
			<!-- 权限部分 -->
			<c:choose>
			<c:when test="${isOnlyOrgEditor=='0'}">
				<c:import charEncoding="UTF-8" url="/sys/authorization/sys_auth_role/sysAuthAssign_edit.jsp">
					<c:param name="formName" value="sysAuthRoleForm"/>
					<c:param name="authAssignMapName" value="fdAuthAssignMap"/>
					<c:param name="authAssignAllMapName" value="fdAuthAssignAllMap"/>
				</c:import>
			</c:when>
			<c:otherwise>
				<c:import charEncoding="UTF-8" url="/sys/authorization/sys_auth_role/sysAuthAssign_view.jsp">
					<c:param name="formName" value="sysAuthRoleForm"/>
					<c:param name="authAssignMapName" value="fdAuthAssignMap"/>
				</c:import>
			</c:otherwise>
			</c:choose>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title">
			<bean:message bundle="sys-authorization" key="sysAuthRole.fdInhRoles"/>
		</td><td colspan="3">
			<c:choose>
			<c:when test="${isOnlyOrgEditor=='0'}">
				<xform:dialog propertyId="fdInhRoleIds" propertyName="fdInhRoleNames" textarea="true" style="width: 90%">
					Dialog_List(true, 'fdInhRoleIds', 'fdInhRoleNames', ';' , 'sysAuthRoleDialog&fdId=${sysAuthRoleForm.fdId}&type=${sysAuthRoleForm.fdType}');
				</xform:dialog>
			</c:when>
			<c:otherwise>
			    <html:hidden name="sysAuthRoleForm" property="fdInhRoleIds"/>
			    <bean:write name="sysAuthRoleForm" property="fdInhRoleNames"/>
			</c:otherwise>
			</c:choose>
		</td>
	</tr>
	<c:if test="${sysAuthRoleForm.fdType == '0'}">
	<tr>
		<td class="td_normal_title">
			<bean:message bundle="sys-authorization" key="sysAuthRole.authEditors"/>
		</td><td colspan="3">
			<c:choose>
			<c:when test="${isOnlyOrgEditor=='0'}">
				<xform:address propertyId="authEditorIds" propertyName="authEditorNames"
					orgType="ORG_TYPE_ALL|ORG_FLAG_BUSINESSALL" textarea="true" mulSelect="true" style="width: 90%">
				</xform:address>
			</c:when>
			<c:otherwise>
				<xform:address propertyId="authEditorIds" propertyName="authEditorNames"
					orgType="ORG_TYPE_ALL|ORG_FLAG_BUSINESSALL" textarea="true" mulSelect="true" style="width: 90%" showStatus="readOnly">
				</xform:address>
			</c:otherwise>
			</c:choose>
		</td>
	</tr>
	</c:if>
	<tr>
		<td class="td_normal_title">
			<bean:message bundle="sys-authorization" key="sysAuthRole.fdDescription"/>
		</td><td colspan="3">
			<c:choose>
			<c:when test="${isOnlyOrgEditor=='0'}">
				<xform:textarea property="fdDescription" style="width:90%"></xform:textarea>
			</c:when>
			<c:otherwise>
				<xform:textarea property="fdDescription" style="width:90%" showStatus="view"></xform:textarea>
			</c:otherwise>
			</c:choose>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title">
			<bean:message bundle="sys-authorization" key="sysAuthRole.fdCreator"/>
		</td><td width=35%>
			<html:hidden property="fdCreatorId" />
			<html:text property="fdCreatorName" readonly="true" />
		</td>
		<td class="td_normal_title">
		</td><td width=35%>
		</td>
	</tr>
</table>
</center>
<html:hidden property="method_GET"/>
<html:hidden property="fdId"/>
<html:hidden property="fdType"/>
<script>
	$KMSSValidation();
</script>
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>