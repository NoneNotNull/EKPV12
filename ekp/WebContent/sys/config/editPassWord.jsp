<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/config/resource/edit_top.jsp"%>
<script type="text/javascript">
function check(){
    if (form.oldPassWord.value==""){
        alert("请输入原密码!!!");
        form.oldPassWord.focus();
        return false;
    }
    if (form.newPassWord.value==""){
        alert("请输入新密码!!!");
        form.newPassWord.focus();
        return false;
    }
    if (form.confirmPassword.value==""){
        alert("请输入确认密码!!!");
        form.confirmPassword.focus();
        return false;
    }
    if(form.confirmPassword.value != form.newPassWord.value){
    	alert("新密码和确认密码必须一致!!!");
   	    return false;
    }
}
</script>
<html>
<head>
<title>修改管理员密码</title>
</head>
<body>
<form name="form" onsubmit="return check()" action="admin.do?method=editPassWord"
	method="post">
<p class="txttitle" style="margin: 40px auto 10px auto;">修改管理员密码</p>
<center>
<span class="txtstrong">${alertPassword}</span>
<span class="txtstrong">${passwordStrength}</span>
<table class="tb_normal">
	<input type="hidden" name="redto" value="${redto}" />
	<tr>
		<td class="td_normal_title" width="80px" style="text-align: right;">
			原密码：
		</td><td width="160px">
			<input id=passowrd type=Password name=oldPassWord class="inputSgl" style="width:100%">
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width="80px" style="text-align: right;">
			新密码：
		</td><td width="160px">
			<input id=passowrd type=Password name=newPassWord class="inputSgl" style="width:100%">
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width="80px" style="text-align: right;">
			确认密码：
		</td><td width="160px">
			<input id=passowrd type=Password name=confirmPassword class="inputSgl" style="width:100%">
		</td>
	</tr>
	<tr>
		<td colspan="2" align=center>
			<input type=submit value=确认 class="btnopt">&nbsp;&nbsp;
			<input type=reset value=重置 class="btnopt">
		</td>
	</tr>
</table>
</center>
</form>
</body>
</html>
