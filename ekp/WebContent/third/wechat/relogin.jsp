<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%
String KMSS_Parameter_ContextPath = request.getContextPath()+"/";
request.setAttribute("KMSS_Parameter_ContextPath", KMSS_Parameter_ContextPath);
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>系统绑定失败</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<style>
div {
	background-color: #99CCCC;
	padding: 10px;
}

input[type="submit"] {
	padding: 0 15px;
	border: 0;
	background: #f40;
	text-align: center;
	text-decoration: none;
	color: #fff;
	-webkit-border-radius: 2px;
	text-shadow: 0 -1px 1px #ca3511;
	min-width: 100%;
	height: 40px;
	font-size: 24px;
	text-shadow: 0 -1px 0 #441307;
	background: -webkit-gradient(linear, left top, left bottom, from(#0095cc),
		to(#00678e) );
}

font {
	background-color: #99CCFF;
}

body {
	font-family: arial;
}
</style>

</head>
<body>
	<form method="POST" id="_login">
		<input type="hidden" name="fdId" value="${wechatConfigForm.fdId }">
		<input type="hidden" name="fdOpenid" value="${wechatConfigForm.fdOpenid }"> 
		<input type="hidden" name="fdPublicCode" value="${wechatConfigForm.fdPublicCode }">
		<input type="hidden" name="fdFansId" value="${wechatConfigForm.fdFansId }">
		<input type="hidden" name="fdNickname" value="${wechatConfigForm.fdNickname }"> 
		<input type="hidden" name="fdLoginName" value="${wechatConfigForm.fdLoginName }" id="loginName"/> 
		<input type="hidden" name="fdPasswd" value="${wechatConfigForm.fdPasswd }" />
		<input type="hidden" name="fdCount" value="${wechatConfigForm.fdCount }" id="fdCount"/>
		<center>
			<img style="width: 30%"
				src="${KMSS_Parameter_ContextPath}resource/style/common/login/loading_logo.jpg" />
		</center>
		<div style="text-align: center">系统绑定失败!</div>

		<div style="text-align: center">非常抱歉!系统绑定失败,请联系管理员</div>
		<input type="submit" class="c-btn-oran-big" value="再次提交"
			id="submit" onclick="save();">

	</form>

	<script type="text/javascript">
	 window.onload = function initCube() {
		  document.getElementById("submit").value = "再次提交";
		  document.getElementById("submit").disabled = false;
	 }
		function save() {
			var count = document.getElementById("fdCount").value;
			var value = "";
			if(count==0){
				value = "尝试绑定中...";
			}else if(count ==1){
				value = "再次尝试绑定中...";
			}else if(count == 2){
				value = "第三次尝试绑定中...";
			}
			document.getElementById("submit").value = value;
			var url = 'wechatLoginHelper.do?method=toBindSystem';
			$("#_login").attr("action", url);
			$("#_login").attr("method", "post");
			$("#_login").submit();
			
		}
	</script>
</body>
</html>