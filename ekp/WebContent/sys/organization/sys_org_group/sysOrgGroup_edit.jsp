<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<html:form action="/sys/organization/sys_org_group/sysOrgGroup.do">
<div id="optBarDiv">
	<logic:equal name="sysOrgGroupForm" property="method_GET" value="edit">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit(document.sysOrgGroupForm, 'update');">
	</logic:equal>
	<logic:equal name="sysOrgGroupForm" property="method_GET" value="add">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="Com_Submit(document.sysOrgGroupForm, 'save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="Com_Submit(document.sysOrgGroupForm, 'saveadd');">
	</logic:equal>
	<input type="button" value="<bean:message key="button.close"/>" onClick="Com_CloseWindow();">
</div>
<p class="txttitle"><bean:message bundle="sys-organization" key="sysOrgElement.group"/><bean:message key="button.edit"/></p>
<center>
<table class="tb_normal" width=95%>
	<tr>
		<td width=15% class="td_normal_title">
			<bean:message bundle="sys-organization" key="sysOrgGroup.fdName"/>
		</td><td width=85% colspan=3>
		    <xform:text property="fdName" style="width:90%"></xform:text>
		</td>
	</tr>
	<tr>
		<td width=15% class="td_normal_title">
			<bean:message bundle="sys-organization" key="sysOrgGroup.fdGroupCate"/>
		</td><td width=35%>
			<html:hidden property="fdGroupCateId"/>
			<html:text style="width:90%" property="fdGroupCateName" readonly="true" styleClass="inputsgl"/>
			<a href="#" onclick="Dialog_Tree(
				false,
				'fdGroupCateId',
				'fdGroupCateName',
				null,
				Tree_GetBeanNameFromService('sysOrgGroupCateService', 'hbmParent', 'fdName:fdId'),
				'<bean:message bundle="sys-organization" key="table.sysOrgGroupCate"/>');">
				<bean:message key="dialog.selectOrg"/>
			</a>
		</td>
		<td width=15% class="td_normal_title">
			<bean:message bundle="sys-organization" key="sysOrgGroup.fdNo"/>
		</td><td width=35%>
		   <xform:text property="fdNo" style="width:90%"></xform:text>
			
		</td>
	</tr>
	<tr>
		<td width=15% class="td_normal_title">
			<bean:message bundle="sys-organization" key="sysOrgGroup.fdKeyword"/>
		</td><td width=35%>
		   <xform:text property="fdKeyword" style="width:90%"></xform:text>
		
		</td>
		<td width=15% class="td_normal_title">
			<bean:message bundle="sys-organization" key="sysOrgDept.fdOrder"/>
		</td><td width=35%>
		    <xform:text property="fdOrder" style="width:90%"></xform:text>
		</td>
	</tr>
	<tr>
		<td width=15% class="td_normal_title">
			<bean:message bundle="sys-organization" key="sysOrgGroup.fdMembers"/>
		</td><td colspan=3>
			<html:hidden property="fdMemberIds" />
			<html:text style="width:90%" property="fdMemberNames" readonly="true" styleClass="inputsgl"/>
			<a href="#" onclick="Dialog_Address(true, 'fdMemberIds', 'fdMemberNames', ';', ORG_TYPE_ALL, null, null, null, null, null, null, '${sysOrgGroupForm.fdId}');">
				<bean:message key="dialog.selectOrg"/>
			</a>
		</td>
	</tr>
	<c:if test="${sysOrgGroupForm.method_GET=='edit'}">	
		<kmss:auth requestURL="/sys/organization/sys_org_group/sysOrgGroup.do?method=invalidated&fdId=${sysOrgGroupForm.fdId}" requestMethod="GET">
		<tr>
			<td width=15% class="td_normal_title">
				<bean:message bundle="sys-organization" key="sysOrgGroup.fdIsAvailable"/>
			</td><td colspan=3>
				<sunbor:enums property="fdIsAvailable" enumsType="common_yesno" elementType="radio" />
			</td>
		</tr>	
		</kmss:auth>
	</c:if>
	<tr>
		<td width=15% class="td_normal_title">
			<bean:message bundle="sys-organization" key="sysOrgGroup.fdMemo"/>
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
			$KMSSValidation(document.forms['sysOrgGroupForm']);
</script>
<%@ include file="/resource/jsp/edit_down.jsp"%>