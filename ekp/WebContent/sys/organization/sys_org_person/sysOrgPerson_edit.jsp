<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<%@ page import="java.util.List"%>
<%@ page import="org.springframework.context.ApplicationContext"%>
<%@ page import="org.springframework.web.context.support.WebApplicationContextUtils"%>
<%@ page import="com.landray.kmss.sys.organization.forms.SysOrgPersonForm"%>
<html:form action="/sys/organization/sys_org_person/sysOrgPerson.do">
	<div id="optBarDiv">
		<logic:equal name="sysOrgPersonForm" property="method_GET" value="edit">
			<input type=button value="<bean:message key="button.update"/>"
				onclick="Com_Submit(document.sysOrgPersonForm, 'update');">
		</logic:equal>
		<logic:equal name="sysOrgPersonForm" property="method_GET" value="add">
			<input type=button value="<bean:message key="button.save"/>"
				onclick="Com_Submit(document.sysOrgPersonForm, 'save');">
			<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="Com_Submit(document.sysOrgPersonForm, 'saveadd');">
		</logic:equal>
		<input type="button" value="<bean:message key="button.close"/>"
			onClick="Com_CloseWindow();">
	</div>
	<p class="txttitle"><bean:message bundle="sys-organization"
		key="sysOrgElement.person" /><bean:message key="button.edit" /></p>
	<center>
	<table class="tb_normal" width=95%>
		<c:if test="${sysOrgPersonForm.anonymous}">
			<html:hidden property="fdNo" />
			<html:hidden property="fdOrder" />
			<html:hidden property="fdKeyword" />
			<html:hidden property="fdMobileNo" />
			<html:hidden property="fdRtxNo" />
			<html:hidden property="fdWechatNo" />
			<html:hidden property="fdCardNo" />
			<html:hidden property="fdEmail" />
			<html:hidden property="fdWorkPhone" />
			<html:hidden property="fdDefaultLang" />
			<tr>
				<td width=15% class="td_normal_title"><bean:message
					bundle="sys-organization" key="sysOrgPerson.fdName" /></td>
				<td width=35%><xform:text property="fdName" style="width:90%"></xform:text></td>
				<td width=15% class="td_normal_title"><bean:message
					bundle="sys-organization" key="sysOrgPerson.fdLoginName" /></td>
				<td width=35%><html:text style="width:90%"
					property="fdLoginName" readonly="true" /></td>
			</tr>
			<tr>
				<td width=15% class="td_normal_title"><bean:message
					bundle="sys-organization" key="sysOrgPerson.fdMemo" /></td>
				<td colspan=3><html:textarea property="fdMemo"
					style="width:100%" /></td>
			</tr>
		</c:if>
		<c:if test="${!sysOrgPersonForm.anonymous}">
			<c:if test="${personImportType=='outer'}">
				<c:import url="${personExtendFormUrl}" charEncoding="UTF-8" />
			</c:if>
			<c:if test="${personImportType!='outer'}">
				<c:import
					url="/sys/organization/sys_org_person/sysOrgPerson_commonEdit.jsp"
					charEncoding="UTF-8" />
			</c:if>
		</c:if>
	</table>
	</center>
	<html:hidden property="method_GET" />
	<html:hidden property="fdId" />
</html:form>
<script>
	Com_IncludeFile("dialog.js");
</script>
<script language="JavaScript">
			$KMSSValidation(document.forms['sysOrgPersonForm']);
</script>
<%@ include file="/resource/jsp/edit_down.jsp"%>