<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<html:form action="/sys/organization/sys_org_post/sysOrgPost.do">
<div id="optBarDiv">
	<logic:equal name="sysOrgPostForm" property="method_GET" value="edit">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit(document.sysOrgPostForm, 'update');">
	</logic:equal>
	<logic:equal name="sysOrgPostForm" property="method_GET" value="add">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="Com_Submit(document.sysOrgPostForm, 'save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="Com_Submit(document.sysOrgPostForm, 'saveadd');">
	</logic:equal>
	<input type="button" value="<bean:message key="button.close"/>" onClick="Com_CloseWindow();">
</div>
<p class="txttitle"><bean:message bundle="sys-organization" key="sysOrgElement.post"/><bean:message key="button.edit"/></p>
<center>
<table class="tb_normal" width=95%>
	<tr>
		<td width=15% class="td_normal_title">
			<bean:message bundle="sys-organization" key="sysOrgPost.fdName"/>
		</td><td width=35%>
			<xform:text property="fdName" style="width:90%"></xform:text>
		</td>
		<td width=15% class="td_normal_title">
			<bean:message bundle="sys-organization" key="sysOrgPost.fdNo"/>
		</td><td width=35%>
		<xform:text property="fdNo" style="width:90%"></xform:text>
		
		</td>
	</tr>
	<tr>
		<td width=15% class="td_normal_title">
			<bean:message bundle="sys-organization" key="sysOrgPost.fdParent"/>
		</td><td width=35%>
			<html:hidden property="fdParentId"/>
			<html:text style="width:90%" property="fdParentName" readonly="true" styleClass="inputsgl"/>
			<a href="#" onclick="Dialog_Address(false, 'fdParentId', 'fdParentName', null, ORG_TYPE_ORGORDEPT|ORG_FLAG_BUSINESSALL);">
				<bean:message key="dialog.selectOrg"/>
			</a>
		</td>
		<td width=15% class="td_normal_title">
			<bean:message bundle="sys-organization" key="sysOrgPost.fdThisLeader"/>
		</td><td width=35%>
			<html:hidden property="fdThisLeaderId"/>
			<html:text style="width:90%" property="fdThisLeaderName" readonly="true" styleClass="inputsgl"/>
			<a href="#" onclick="Dialog_Address(false, 'fdThisLeaderId', 'fdThisLeaderName', null, ORG_TYPE_POSTORPERSON);">
				<bean:message key="dialog.selectOrg"/>
			</a>
		</td>
	</tr>
	<tr>
		<td width=15% class="td_normal_title">
			<bean:message bundle="sys-organization" key="sysOrgPost.fdKeyword"/>
		</td><td width=35%>
		<xform:text property="fdKeyword" style="width:90%"></xform:text>
		
		</td>
		<td width=15% class="td_normal_title">
			<bean:message bundle="sys-organization" key="sysOrgPost.fdOrder"/>
		</td><td width=35%>
		    <xform:text property="fdOrder" style="width:90%"></xform:text>
		</td>
	</tr>
	<tr>
		<td width=15% class="td_normal_title">
			<bean:message bundle="sys-organization" key="sysOrgPost.fdIsBusiness"/>
		</td><td width=85% colspan="3">
			<sunbor:enums property="fdIsBusiness" enumsType="common_yesno" elementType="radio" />
		</td>
	</tr>			
	<tr>
		<td width=15% class="td_normal_title">
			<bean:message bundle="sys-organization" key="sysOrgPost.fdPersons"/>
		</td><td colspan=3>
			<html:hidden property="fdPersonIds" />
			<html:text style="width:90%" property="fdPersonNames" readonly="true" styleClass="inputsgl"/>
			<a href="#" onclick="Dialog_Address(true, 'fdPersonIds', 'fdPersonNames', ';', ORG_TYPE_PERSON|ORG_FLAG_BUSINESSALL);">
				<bean:message key="dialog.selectOrg"/>
			</a>
		</td>
	</tr>
	<c:if test="${sysOrgPostForm.method_GET=='edit'}">	
		<kmss:auth requestURL="/sys/organization/sys_org_post/sysOrgPost.do?method=invalidated&fdId=${sysOrgPostForm.fdId}" requestMethod="GET">
		<tr>
			<td width=15% class="td_normal_title">
				<bean:message bundle="sys-organization" key="sysOrgPost.fdIsAvailable"/>
			</td><td width=85% colspan="3">
				<sunbor:enums property="fdIsAvailable" enumsType="common_yesno" elementType="radio" />
			</td>
		</tr>
		</kmss:auth>
	</c:if>
	<tr>
		<td width=15% class="td_normal_title">
			<bean:message bundle="sys-organization" key="sysOrgPost.fdMemo"/>
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
			$KMSSValidation(document.forms['sysOrgPostForm']);
</script>
<%@ include file="/resource/jsp/edit_down.jsp"%>