<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<script>Com_IncludeFile("dialog.js");</script>
<html:form action="/sys/organization/sys_org_role_conf/sysOrgRoleConf.do">
<div id="optBarDiv">
	<c:if test="${sysOrgRoleConfForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit(document.sysOrgRoleConfForm, 'update');">
	</c:if>
	<c:if test="${sysOrgRoleConfForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="Com_Submit(document.sysOrgRoleConfForm, 'save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="Com_Submit(document.sysOrgRoleConfForm, 'saveadd');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message  bundle="sys-organization" key="table.sysOrgRoleConf"/></p>

<center>
<table class="tb_normal" width=60%>
	<tr>
		<td class="td_normal_title" width=20%>
			<bean:message  bundle="sys-organization" key="sysOrgRoleConf.fdName"/>
		</td><td width=80%>
		    <xform:text property="fdName" style="width:85%"></xform:text>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=20%>
			<bean:message  bundle="sys-organization" key="sysOrgRoleConf.fdOrder"/>
		</td><td width=80%>
		    <xform:text property="fdOrder" style="width:85%"></xform:text>
		</td>
	</tr>
	<c:if test="${sysOrgRoleConfForm.method_GET=='edit'}">
		<tr>
			<td width=20% class="td_normal_title">
				<bean:message bundle="sys-organization" key="sysOrgRoleConf.fdIsAvailable"/>
			</td><td width=80%>
				<sunbor:enums property="fdIsAvailable" enumsType="common_yesno" elementType="radio" />
			</td>
		</tr>
	</c:if>
	<tr>
		<td class="td_normal_title" width=20%>
			<bean:message  bundle="sys-organization" key="sysOrgRoleConf.fdRoleLineEditors"/>
		</td><td width=80%>
			<html:hidden property="fdRoleLineEditorIds"/>
			<html:text style="width:85%" property="fdRoleLineEditorNames" readonly="true" styleClass="inputsgl"/>
			<a href="#" onclick="Dialog_Address(true, 'fdRoleLineEditorIds', 'fdRoleLineEditorNames');">
				<bean:message key="dialog.selectOrg"/>
			</a><br><br style="font-size:5px">
			<bean:message  bundle="sys-organization" key="sysOrgRoleConf.fdRoleLineEditors.detail"/>
		</td>
	</tr>
</table>
</center>
<html:hidden property="method_GET"/>
</html:form>
<script language="JavaScript">
			$KMSSValidation(document.forms['sysOrgRoleConfForm']);
</script>
<%@ include file="/resource/jsp/edit_down.jsp"%>