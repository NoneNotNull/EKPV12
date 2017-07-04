<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<html:form action="/sys/organization/sys_org_org/sysOrgOrg.do">
<div id="optBarDiv">
	<logic:equal name="sysOrgOrgForm" property="method_GET" value="edit">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit(document.sysOrgOrgForm, 'update');">
	</logic:equal>
	<logic:equal name="sysOrgOrgForm" property="method_GET" value="add">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="Com_Submit(document.sysOrgOrgForm, 'save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="Com_Submit(document.sysOrgOrgForm, 'saveadd');">
	</logic:equal>
	<input type="button" value="<bean:message key="button.close"/>" onClick="Com_CloseWindow();">
</div>
<p class="txttitle"><bean:message bundle="sys-organization" key="sysOrgElement.org"/><bean:message key="button.edit"/></p>
<center>
<table class="tb_normal" width=95%>
	<tr>
		<td width=15% class="td_normal_title">
			<bean:message bundle="sys-organization" key="sysOrgOrg.fdName"/>
		</td><td width=35% colspan="3">
			<xform:text property="fdName" style="width:90%"></xform:text>
			<div id="fdName_id"></div>
		</td>
	</tr>
	<tr>
		<td width=15% class="td_normal_title">
			<bean:message bundle="sys-organization" key="sysOrgOrg.fdParent"/>
		</td><td width=35%>
			<html:hidden property="fdParentId"/>
			<html:text style="width:90%" property="fdParentName" readonly="true" styleClass="inputsgl"/>
			<a href="#" onclick="Dialog_Tree(
				false,
				'fdParentId',
				'fdParentName',
				null,
				'organizationTree&parent=!{value}&orgType='+(ORG_TYPE_ORG|ORG_FLAG_BUSINESSALL),
				'<bean:message bundle="sys-organization" key="organization.moduleName"/>',
				null,
				null,
				'<bean:write name="sysOrgOrgForm" property="fdId"/>');">
				<bean:message key="dialog.selectOrg"/>
			</a>
		</td>
		<td width=15% class="td_normal_title">
			<bean:message bundle="sys-organization" key="sysOrgOrg.fdNo"/>
		</td><td width=35%>
		<xform:text property="fdNo" style="width:90%"></xform:text>
		
		</td>
	</tr>
	<tr>
		<td width=15% class="td_normal_title">
			<bean:message bundle="sys-organization" key="sysOrgOrg.fdThisLeader"/>
		</td><td width=35%>
			<html:hidden property="fdThisLeaderId"/>
			<html:text style="width:90%" property="fdThisLeaderName" readonly="true" styleClass="inputsgl"/>
			<a href="#" onclick="Dialog_Address(false, 'fdThisLeaderId', 'fdThisLeaderName', null, ORG_TYPE_POSTORPERSON);">
				<bean:message key="dialog.selectOrg"/>
			</a>
		</td>
		<td width=15% class="td_normal_title">
			<bean:message bundle="sys-organization" key="sysOrgOrg.fdSuperLeader"/>
		</td><td width=35%>
			<html:hidden property="fdSuperLeaderId"/>
			<html:text style="width:90%" property="fdSuperLeaderName" readonly="true" styleClass="inputsgl"/>
			<a href="#" onclick="Dialog_Address(false, 'fdSuperLeaderId', 'fdSuperLeaderName', null, ORG_TYPE_POSTORPERSON);">
				<bean:message key="dialog.selectOrg"/>
			</a>
		</td>
	</tr>
	<tr>
		<td width=15% class="td_normal_title">
			<bean:message bundle="sys-organization" key="sysOrgOrg.fdKeyword"/>
		</td><td width=35%>
		  <xform:text property="fdKeyword" style="width:90%"></xform:text>
		
		</td>
		<td width=15% class="td_normal_title">
			<bean:message bundle="sys-organization" key="sysOrgOrg.fdOrder"/>
		</td><td width=35%>
			<xform:text property="fdOrder" style="width:90%"></xform:text>
		</td>
	</tr>
	<tr>
		<td width=15% class="td_normal_title">
		    <bean:message bundle="sys-organization" key="sysOrgDept.fdIsBusiness"/>	
		</td><td width=35%>
		    <sunbor:enums property="fdIsBusiness" enumsType="common_yesno" elementType="radio" />	
		</td>
		<c:if test="${sysOrgOrgForm.method_GET=='edit'}">
			<kmss:auth requestURL="/sys/organization/sys_org_org/sysOrgOrg.do?method=invalidated&fdId=${sysOrgOrgForm.fdId}" requestMethod="GET">
				<td width=15% class="td_normal_title">
					<bean:message bundle="sys-organization" key="sysOrgDept.fdIsAvailable"/>
				</td><td width="35%">
					<sunbor:enums property="fdIsAvailable" enumsType="common_yesno" elementType="radio" />
				</td>
			</kmss:auth>
		</c:if>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-organization" key="sysOrgElement.authElementAdmins"/>
		</td><td width="85%" colspan="3">
			<xform:address propertyId="authElementAdminIds" propertyName="authElementAdminNames" mulSelect="true" orgType="ORG_TYPE_POSTORPERSON" style="width:85%" />
			<div class="description_txt">
				<bean:message bundle="sys-organization" key="sysOrgElement.authElementAdmins.describe"/>
			</div>
		</td>
	</tr>			
	<tr>
		<td width=15% class="td_normal_title">
			<bean:message bundle="sys-organization" key="sysOrgOrg.fdMemo"/>
		</td><td colspan="3">
			<xform:textarea property="fdMemo" style="width:100%"></xform:textarea>
		</td>
	</tr>
</table>
</center>
<html:hidden property="method_GET"/>
<html:hidden property="fdId"/>
</html:form>
<script>Com_IncludeFile("dialog.js");</script>
<script language="JavaScript">
			$KMSSValidation(document.forms['sysOrgOrgForm']);
</script>
<%@ include file="/resource/jsp/edit_down.jsp"%>

<script>Com_IncludeFile("ajax.js");</script>
<script>
Com_Parameter.event["submit"][Com_Parameter.event["submit"].length] = function(){
	var url = "<c:url value="/resource/jsp/ajax.jsp"/>";
	url +="?fdName="+document.getElementsByName("fdName")[0].value;
	url +="&fdOrgType=1";
	var propertyName = "fdName";
	var serviceName = "sysOrgElementService";
	propertyUniqueCheck(url,propertyName,serviceName);
	var divId = document.getElementById(propertyName+"_id");
	if(divId.innerHTML!=""){
		return false;
	}
	return true;
};
</script>