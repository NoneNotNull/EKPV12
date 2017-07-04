<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<html:form action="/kms/integral/kms_integral_team/kmsIntegralTeam.do">
<div id="optBarDiv">
	<c:if test="${kmsIntegralTeamForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="if(checkPersonIsNull())Com_Submit(document.kmsIntegralTeamForm, 'update');">
	</c:if>
	<c:if test="${kmsIntegralTeamForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="if(checkPersonIsNull())Com_Submit(document.kmsIntegralTeamForm, 'save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="if(checkPersonIsNull())Com_Submit(document.kmsIntegralTeamForm, 'saveadd');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="kms-integral" key="table.kmsIntegralTeam"/></p>

<center>
<table class="tb_normal" width=70%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-integral" key="kmsIntegralTeam.fdName"/>
		</td><td width="80%">
			<xform:text property="fdName" style="width:85%" required="true"/>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-integral" key="kmsIntegralTeam.fdPersons"/>
		</td>
		<td width="80%">
		<%String fdPerson = ResourceUtil.getString("kmsIntegralTeam.fdPersons","kms-integral"); %>
		<input type="hidden" name="fdPersonIds" value="${kmsIntegralTeamForm.fdPersonIds}">
			<html:textarea property="fdPersonNames"  readonly="true" style="width:90%;height:90px"  onclick="Dialog_Address(true, 'fdPersonIds','fdPersonNames', ';', null);"/>
			<a href="#" onclick="Dialog_Address(true, 'fdPersonIds','fdPersonNames', ';', null);">
				<bean:message key="dialog.selectOrg" /></a>
		</td>
	</tr>
</table>
</center>
<html:hidden property="fdId" />
<html:hidden property="method_GET" />
<script>
	$KMSSValidation();
</script>
<script>
	Com_IncludeFile("calendar.js");
	Com_IncludeFile("dialog.js");
	function checkPersonIsNull(){
		var fdPersonIds = document.getElementsByName("fdPersonIds")[0].value ;
		if(null == fdPersonIds || "" == fdPersonIds || fdPersonIds.length < 32){
			alert("<bean:message bundle='kms-integral' key='kmsIntegralCommon.person.isNull'/>") ;
			return false ;
		}
		return true ;
	}
</script>
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>