<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<html:form action="/kms/integral/kms_integral_person_role/kmsIntegralPersonRole.do">
<div id="optBarDiv">
	<c:if test="${kmsIntegralPersonRoleForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="checkPerosn('update');">
	</c:if>
	<c:if test="${kmsIntegralPersonRoleForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="checkPerosn('save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="checkPerosn('saveadd');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="kms-integral" key="table.kmsIntegralPersonRole"/></p>

<center>
<table class="tb_normal" width=70%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-integral" key="kmsIntegralPersonRole.fdName"/>
		</td><td width="85%">
			<xform:text property="fdName" style="width:85%" required="true"/>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-integral" key="kmsIntegralPersonRole.fdBalance"/>
		</td><td width="85%">
			<xform:text property="fdBalance" style="width:25%" required="true"/>
		</td>
	</tr>
	<tr>
		<%String fdPerson = ResourceUtil.getString("kmsIntegralPersonRole.fdPerson","kms-integral"); %>
		<td class="td_normal_title" width=15% >
			<bean:message bundle="kms-integral" key="kmsIntegralPersonRole.fdPerson"/>
		</td><td width="85%">
			<input type="hidden" name="fdPersonIds" value="${kmsIntegralPersonRoleForm.fdPersonIds}"> 
			<html:textarea property="fdPersonNames"  readonly="true" style="width:90%;height:90px" onclick="Dialog_Address(true, 'fdPersonIds','fdPersonNames', ';', ORG_TYPE_PERSON);"/>
			<a href="#" onclick="Dialog_Address(true, 'fdPersonIds','fdPersonNames', ';', ORG_TYPE_PERSON);">
				<bean:message key="dialog.selectOrg" /></a>
		</td>
	</tr>
</table>
</center>
<html:hidden property="fdId" />
<html:hidden property="method_GET" />
<script>
	Com_IncludeFile("dialog.js");
	$KMSSValidation();
	
	function checkPerosn(obj){
		//var fdName = document.getElementsByName("fdName")[0].value ;
		//if(null == fdName || "" == fdName){
		//	alert("角色名称 不能为空!") ;
	//	return false ;
	//	}
		var fdBalance = document.getElementsByName("fdBalance")[0].value ;
		if(null == fdBalance || "" == fdBalance){
			alert("<bean:message bundle='kms-integral' key='kmsIntegralPersonRole.fdBalance.isNull'/>") ; 
			return false ;
		}
		var reg = /^\d+(?=\.{0,1}\d+$|$)/ ;
		if(!reg.test(fdBalance)){
			alert("<bean:message bundle='kms-integral' key='kmsIntegralPersonRole.fdBalance.isNumber'/>") ;
			return false ;
		}
		var fdPersonIds = document.getElementsByName("fdPersonIds")[0].value ;
		if(null == fdPersonIds || "" == fdPersonIds){
			alert("<bean:message bundle='kms-integral' key='kmsIntegralCommon.person.isNull'/>") ;
			return false ;
		}
 		$.ajax({
		   type: "POST",
		   url: "<c:url value='/kms/integral/kms_integral_person_role/kmsIntegralPersonRole.do?method=checkPerson&fdId=${kmsIntegralPersonRoleForm.fdId}&personIds='/>"+fdPersonIds,
		   success: function(msg){
			   if('true' == msg.json[0].flag){
				  alert("<bean:message bundle='kms-integral' key='kmsIntegralPersonRole.fdPerson.exist'/>");
			   }else{
				   if("save"==obj){
					   Com_Submit(document.kmsIntegralPersonRoleForm, 'save');
				   }else if("update"==obj){
					   Com_Submit(document.kmsIntegralPersonRoleForm, 'update');
				   }else {
					   Com_Submit(document.kmsIntegralPersonRoleForm, 'saveadd');
				   }
			   }
		   }
		});
	}
</script>
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>