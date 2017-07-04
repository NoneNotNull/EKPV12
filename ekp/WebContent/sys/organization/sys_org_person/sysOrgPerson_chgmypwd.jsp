<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<script src="${KMSS_Parameter_ContextPath}sys/organization/sys_org_person/pwdstrength.js"></script>

<script>
Com_IncludeFile("security.js");
var errLen = '<bean:message bundle="sys-organization" key="sysOrgPerson.error.insufficientLength" />';
var errPwd = '<bean:message bundle="sys-organization" key="sysOrgPerson.error.passwordUndercapacity" />';
function checkInput(){
	var pwdOldVal = document.getElementsByName("fdOldPassword")[0].value;
	var pwdNewVal = document.getElementsByName("fdNewPassword")[0].value;
	var pwdConVal = document.getElementsByName("fdConfirmPassword")[0].value;
	if(pwdOldVal=="" || pwdNewVal=="" || pwdConVal=="" || pwdNewVal!=pwdConVal){
		alert("<bean:message bundle="sys-organization" key="sysOrgPerson.error.allPwdIsNotAvailable"/>");
		return false;
	}
	var pwdlen = <%= StringUtil.isNull(ResourceUtil.getKmssConfigString("kmss.org.passwordlength")) ? "1" : ResourceUtil.getKmssConfigString("kmss.org.passwordlength").toString() %>;
	if(pwdNewVal.length < pwdlen){
		alert(errLen.replace("#len#", pwdlen));
		return false;
	}
	var pwdsth = <%= StringUtil.isNull(ResourceUtil.getKmssConfigString("kmss.org.passwordstrength")) ? "0" : ResourceUtil.getKmssConfigString("kmss.org.passwordstrength").toString() %>;
	if(pwdsth>0){
		if(pwdstrength(pwdNewVal) < pwdsth){
			alert(errPwd.replace("#len#", pwdsth));
			return false;
		}
	}

	document.getElementsByName("fdOldPassword")[0].value = desEncrypt(document.getElementsByName("fdOldPassword")[0].value);
	document.getElementsByName("fdNewPassword")[0].value = desEncrypt(document.getElementsByName("fdNewPassword")[0].value);
	document.getElementsByName("fdConfirmPassword")[0].value = desEncrypt(document.getElementsByName("fdConfirmPassword")[0].value);
	return true;
}
</script>
<p class="txttitle"><bean:message bundle="sys-organization" key="sysOrgPerson.button.changePassword"/></p>
<html:form action="/sys/organization/sys_org_person/chgPersonInfo.do?method=saveMyPwd" onsubmit="return checkInput();">
<div id="optBarDiv">
	<input type=submit value="<bean:message key="button.submit"/>">
	<input type="button" value="<bean:message key="button.close"/>" onClick="Com_CloseWindow();">
</div>
<center>

<%
	if(request.getParameter("login") != null && request.getParameter("login").equals("yes")){
		%>
		<span style="color: red;">
		您的密码过于简单，请修改密码后再使用本系统。
		<input type="hidden" name="redto" value="<%= request.getParameter("redto")%>" />
		 </span><br><br>
		<%
	}
	%> 

<table class="tb_normal" width=300px style="border: #c0c0c0 1px solid">
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
</center>
<%-- 个别浏览器下可能会现实出来 --%>
<input type="submit" style="width:0px;height:0px">
<html:hidden property="fdId"/>
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>