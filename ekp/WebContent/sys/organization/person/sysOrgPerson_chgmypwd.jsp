<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page import="com.landray.kmss.util.*" %>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/portal/portal.tld" prefix="portal"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="person.cfg">
	<template:replace name="title">
		<template:super/> - <bean:message bundle="sys-organization" key="sysOrgPerson.button.changePassword"/>
	</template:replace>
	<template:replace name="content">
		<script src="${KMSS_Parameter_ContextPath}sys/organization/sys_org_person/pwdstrength.js"></script>

<script>
Com_IncludeFile("security.js");
var errLen = '<bean:message bundle="sys-organization" key="sysOrgPerson.error.insufficientLength" />';
var errPwd = '<bean:message bundle="sys-organization" key="sysOrgPerson.error.passwordUndercapacity" />';
var saveMyPwdSuccess = "<bean:message bundle="sys-organization" key="sysOrgPerson.error.passwordUndercapacity" />";
function checkInput(){
	var pwdOldVal = document.getElementsByName("fdOldPassword")[0].value;
	var pwdNewVal = document.getElementsByName("fdNewPassword")[0].value;
	var pwdConVal = document.getElementsByName("fdConfirmPassword")[0].value;
	if(pwdOldVal=="" || pwdNewVal=="" || pwdConVal=="" || pwdNewVal!=pwdConVal){
		//alert("<bean:message bundle="sys-organization" key="sysOrgPerson.error.allPwdIsNotAvailable"/>");
		seajs.use(['lui/dialog'], function(dialog) {
			dialog.alert("<bean:message bundle="sys-organization" key="sysOrgPerson.error.allPwdIsNotAvailable"/>");
		});
		return false;
	}
	var pwdlen = <%= StringUtil.isNull(ResourceUtil.getKmssConfigString("kmss.org.passwordlength")) ? "1" : ResourceUtil.getKmssConfigString("kmss.org.passwordlength").toString() %>;
	if(pwdNewVal.length < pwdlen){
		//alert(errLen.replace("#len#", pwdlen));
		seajs.use(['lui/dialog'], function(dialog) {
			dialog.alert(errLen.replace("#len#", pwdlen));
		});
		return false;
	}
	var pwdsth = <%= StringUtil.isNull(ResourceUtil.getKmssConfigString("kmss.org.passwordstrength")) ? "0" : ResourceUtil.getKmssConfigString("kmss.org.passwordstrength").toString() %>;
	if(pwdsth>0){
		if(pwdstrength(pwdNewVal) < pwdsth){
			//alert(errPwd.replace("#len#", pwdsth));
			seajs.use(['lui/dialog'], function(dialog) {
				dialog.alert(errPwd.replace("#len#", pwdsth));
			});
			return false;
		}
	}

	document.getElementsByName("fdOldPassword")[0].value = desEncrypt(document.getElementsByName("fdOldPassword")[0].value);
	document.getElementsByName("fdNewPassword")[0].value = desEncrypt(document.getElementsByName("fdNewPassword")[0].value);
	document.getElementsByName("fdConfirmPassword")[0].value = desEncrypt(document.getElementsByName("fdConfirmPassword")[0].value);
	ajaxUpdate();
	return false;
}
function ajaxUpdate() {
	seajs.use(['lui/jquery', 'lui/dialog'], function($, dialog) {
		var loading = dialog.loading('', $('#passwordForm'));
		var data = $("#passwordForm").serialize();
		$.ajax({
			type : "POST",
			url : $("#passwordForm").attr('action'),
			data : data,
			dataType : 'json',
			success : function(result) {
				loading.hide();
				dialog["success"](result.msg, $('#passwordForm'));
				$("#passwordForm")[0].reset();
			},
			error : function(result) {
				loading.hide();
				var msg = [];
				if (result.responseJSON) {
					var messages = result.responseJSON.message;
					for (var i = 0 ; i < messages.length; i ++) {
						msg.push(messages[i].msg);
					}
				}
				dialog["failure"](msg.join(""), $('#passwordForm'));
				$("#passwordForm")[0].reset();
			}
		});
	});
}
</script>
<html:form styleId="passwordForm" action="/sys/organization/sys_org_person/chgPersonInfo.do?method=saveMyPwd" onsubmit="return checkInput();">
<ui:panel layout="sys.ui.panel.light" toggle="false" scroll="false">
       <ui:content title="${lfn:message('sys-organization:sysOrgPerson.button.changePassword') }">
<%
	if(request.getParameter("login") != null && request.getParameter("login").equals("yes")){
		%>
		<br><center><span style="color: red;">
		<bean:message bundle="sys-organization" key="sysOrgPerson.passwordTooSimple"/>
		<input type="hidden" name="redto" value="<%= request.getParameter("redto")%>" />
		 </span></center><br>
		<%
	}
%>
<table class="tb_simple" width=300px>
	<tr>
		<td width=30% class="td_normal_title">
			<bean:message bundle="sys-organization" key="sysOrgPerson.oldPassword"/>
		</td><td width=70%>
			<input type="password" name="fdOldPassword" style="width:100%" class="inputsgl"/>
		</td>
	</tr>
	<tr>
		<td width=30% class="td_normal_title">
			<bean:message bundle="sys-organization" key="sysOrgPerson.newPassword"/>
		</td><td width=70%>
			<input type="password" name="fdNewPassword" style="width:100%" class="inputsgl"/>
		</td>
	</tr>
	<tr>
		<td width=30% class="td_normal_title">
			<bean:message bundle="sys-organization" key="sysOrgPerson.confirmPassword"/>
		</td><td width=70%>
			<input type="password" name="fdConfirmPassword" style="width:100%" class="inputsgl"/>
		</td>
	</tr>
</table>
<!-- <input type="hidden" name="redto" value="/sys/person/setting.do?setting=sys_organization_chg_my_pwd" /> -->
<input type="submit" style="width: 0px;height: 0px;border: none;padding:0px;">
<html:hidden property="fdId"/>
				<div style="text-align: center;margin-bottom: 20px;">
				<ui:button onclick="if(checkInput())document.forms[0].submit();" title="${lfn:message('button.submit') }" text="${lfn:message('button.submit') }" />
				</div>
				
      </ui:content>
 </ui:panel>
 
</html:form>
	</template:replace>
</template:include>