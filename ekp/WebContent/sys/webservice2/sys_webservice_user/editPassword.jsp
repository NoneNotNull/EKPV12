<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/config/resource/edit_top.jsp"%>
<script type="text/javascript">
function check(){
    if (form.oldPassword.value==""){
        alert("请输入原密码!");
        form.oldPassword.focus();
        return false;
    }
    if (form.newPassword.value==""){
        alert("请输入新密码!");
        form.newPassword.focus();
        return false;
    }
    if (form.confirmPassword.value==""){
        alert("请输入确认密码!");
        form.confirmPassword.focus();
        return false;
    }
    if(form.confirmPassword.value != form.newPassword.value){
    	alert("新密码和确认密码必须一致!");
   	    return false;
    }
}
</script>
<html>
<head>
<title>修改WebService用户密码</title>
</head>
<body>
<form name="form" onsubmit="return check()" action="sysWebserviceUser.do?method=editPassword"
	method="post">
<input type=hidden name=fdId value="${requestScope.fdId}">
<p class="txttitle">修改WebService用户密码</p>
<center>
<span class="txtstrong">${alertPassword}</span>
<table class="tb_normal" width=265>
	<tr>
		<td class="td_normal_title" width=15%>
			原密码：
		</td><td width=85%>
			<input id=passowrd type=Password name=oldPassword class="inputSgl">
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			新密码:
		</td><td width=85%>
			<input id=passowrd type=Password name=newPassword class="inputSgl">
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			确认密码：
		</td><td width=85%>
			<input id=passowrd type=Password name=confirmPassword class="inputSgl">
		</td>
	</tr>
	<tr>
		<td colspan="2" align=center>
			<input type=submit value=确认 class="btnopt">
			<input type=reset value=重置 class="btnopt">
		</td>
	</tr>
</table>
</center>
</form>
</body>
</html>
