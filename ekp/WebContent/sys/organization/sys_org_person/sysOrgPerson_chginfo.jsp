<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>

<%@page import="com.landray.kmss.sys.organization.forms.SysOrgPersonForm"%>
<%@page import="com.landray.kmss.sys.organization.forms.SysOrgPersonInfoForm"%>
<html:form action="/sys/organization/sys_org_person/chgPersonInfo.do?method=saveInfo" onsubmit="return validateSysOrgPersonInfoForm(this);">
<div id="optBarDiv">
	<input type="button" value="<bean:message key="button.submit"/>"
		onclick="Com_Submit(document.sysOrgPersonInfoForm, 'saveInfo');">
	<input type="button" value="<bean:message key="button.close"/>" onClick="Com_CloseWindow();">
</div>
<center>
<p class="txttitle"><bean:message bundle="sys-organization" key="sysOrgPerson.button.changeInfo"/></p>
<table class="tb_normal" width=400px style="border: #c0c0c0 1px solid">
	<tr>
		<td width=30% class="td_normal_title">
			<bean:message bundle="sys-organization" key="sysOrgPerson.fdName"/>
		</td><td width=70%>
			<html:text property="fdName" readonly="true" style="width:100%"/>
		</td>
	</tr>
	<tr>
		<td width=30% class="td_normal_title">
			<bean:message bundle="sys-organization" key="sysOrgPerson.fdMobileNo"/>
		</td><td width=70%>
			<html:text property="fdMobileNo" style="width:100%"/>
		</td>
	</tr>
	<tr>
		<td width=30% class="td_normal_title">
			<bean:message bundle="sys-organization" key="sysOrgPerson.fdWorkPhone" />
		</td><td width=70%>
			<html:text property="fdWorkPhone" style="width:100%" />
		</td>
	</tr>
	<tr>
		<td width=15% class="td_normal_title">
			<bean:message bundle="sys-organization" key="sysOrgPerson.fdDefaultLang" />
		</td>
		<td width=35%>
		<%
			SysOrgPersonInfoForm sysOrgPersonForm = (SysOrgPersonInfoForm) request
					.getAttribute("sysOrgPersonInfoForm");
			out.write(SysOrgPersonForm.getLangSelectHtml(request,
					"fdDefaultLang", sysOrgPersonForm.getFdDefaultLang()));
		%>
		</td>
	</tr>
	<tr>
		<td width=30% class="td_normal_title">
			<bean:message bundle="sys-organization" key="sysOrgPerson.fdMemo"/>
		</td><td width=70%>
			<html:textarea property="fdMemo" style="width:100%"/>
		</td>
	</tr>
	<html:hidden property="fdEmail"/>
</table>
</center>
</html:form>
<html:javascript formName="sysOrgPersonInfoForm"  cdata="false"
      dynamicJavascript="true" staticJavascript="false"/>
<%@ include file="/resource/jsp/edit_down.jsp"%>