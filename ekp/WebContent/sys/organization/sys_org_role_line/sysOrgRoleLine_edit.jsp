<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<script>Com_IncludeFile("dialog.js");</script>
<script type="text/javascript">
function checkSubmit(val){
	//成员和名称必须填写一个
	if(val.fdName.value==""&&val.fdMemberId.value==""){
		alert("<bean:message key='sysOrgRoleLine.write.data' bundle='sys-organization'/>");
		return false;
	}
	return true;
}
function selectMember(){
	var flag = document.getElementsByName("fdNotHasChildren")[0].value;
	if(flag=="false"){
		Dialog_Address(false, 'fdMemberId', 'fdMemberName', null, ORG_TYPE_POSTORPERSON);
	}else{
		Dialog_Address(false, 'fdMemberId', 'fdMemberName', null, ORG_TYPE_POSTORPERSON|ORG_TYPE_ORGORDEPT);
	}
}
</script>
<html:form action="/sys/organization/sys_org_role_line/sysOrgRoleLine.do" onsubmit="return checkSubmit(this);">
<div id="optBarDiv">
	<c:if test="${sysOrgRoleLineForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit(document.sysOrgRoleLineForm, 'update');">
	</c:if>
	<c:if test="${sysOrgRoleLineForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="Com_Submit(document.sysOrgRoleLineForm, 'save');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message  bundle="sys-organization" key="table.sysOrgRoleLine"/></p>

<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-organization" key="sysOrgRoleLine.fdName"/>
		</td><td width=35%>
			<xform:text property="fdName" style="width:85%"></xform:text>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-organization" key="sysOrgRoleLine.fdOrder"/>
		</td><td width=35%>
		   <xform:text property="fdOrder" style="width:85%"></xform:text>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-organization" key="sysOrgRoleLine.fdParent"/>
		</td><td width=35%>
			<html:hidden property="fdParentId" />
			<html:hidden property="fdParentName" />
			${sysOrgRoleLineForm.fdParentName}
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-organization" key="sysOrgRoleLine.fdMember"/>
		</td><td width=35%>
			<html:hidden property="fdMemberId"/>
			<html:text style="width:85%" property="fdMemberName" readonly="true" styleClass="inputsgl"/>
			<a href="#" onclick="selectMember();"><bean:message key="dialog.selectOrg"/></a>
		</td>
	</tr>
</table>
</center>
<html:hidden property="method_GET"/>
<html:hidden property="fdConfId"/>
<html:hidden property="fdId"/>
<html:hidden property="fdNotHasChildren"/>
</html:form>
<script language="JavaScript">
			$KMSSValidation(document.forms['sysOrgRoleLineForm']);
</script>
<%@ include file="/resource/jsp/edit_down.jsp"%>