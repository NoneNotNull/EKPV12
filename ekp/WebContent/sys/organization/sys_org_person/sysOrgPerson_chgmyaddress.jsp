<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<script>Com_IncludeFile("dialog.js");</script>
<html:form action="/sys/organization/sys_org_person/chgPersonInfo.do">
<div id="optBarDiv">
	<input type="button" value="<bean:message key="button.submit"/>"
		onclick="Com_Submit(document.sysOrgPersonInfoForm, 'saveMyAddress');">
	<input type="button" value="<bean:message key="button.close"/>" onClick="Com_CloseWindow();">
</div>
<center>
<div class="txttitle"><bean:message bundle="sys-organization" key="sysOrgPerson.button.changeMyAddress"/></div>
<table class="tb_normal" width=600px style="border: #c0c0c0 1px solid">
	<tr>
		<td width=20% class="td_normal_title">
			<bean:message bundle="sys-organization" key="sysOrgPerson.fdName"/>
		</td><td width=80%>
			<html:text property="fdName" readonly="true" style="width:100%"/>
		</td>
	</tr>
	<tr>
		<td width=20% class="td_normal_title">
			<bean:message bundle="sys-organization" key="sysOrg.address.myAddress"/>
		</td><td width=80%>
			<html:hidden property="fdMyAddressIds"/>
			<html:textarea style="width:90%;height:80px;" property="fdMyAddressNames" readonly="true" styleClass="inputmul"/>
			<a href="#" onclick="Dialog_Address(true, 'fdMyAddressIds', 'fdMyAddressNames', ';', ORG_TYPE_ALL);">
				<bean:message key="dialog.selectOrg"/>
			</a>
		</td>
	</tr>
</table>
</center>
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>