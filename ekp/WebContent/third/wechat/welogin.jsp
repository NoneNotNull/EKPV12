<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%
String KMSS_Parameter_ContextPath = request.getContextPath()+"/";
request.setAttribute("KMSS_Parameter_ContextPath", KMSS_Parameter_ContextPath);
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>系统绑定</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<script type="text/javascript" src="${KMSS_Parameter_ContextPath}resource/js/jquery.js"></script>
<style>
body {
	color: #000;
	font-family: arial;
}

fieldset {
	border: none;
	-webkit-margin-start: 2px;
	-webkit-margin-end: 2px;
	-webkit-padding-before: 0.35em;
	-webkit-padding-start: 0.75em;
	-webkit-padding-end: 0.75em;
	-webkit-padding-after: 0.625em;
}

input[type="text"],input[type="password"] {
	height: 40px;
	border: solid 1px #DDD;
	border-top-color: #BBB;
	color: #333;
	font-size: 20px;
	-webkit-border-radius: 0;
	-webkit-appearance: none;
	background: -webkit-gradient(linear, 0 0, 0 100%, from(#f5f5f5),
		to(#fdfdfd) );
	vertical-align: middle;
	min-width: 100%;
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
	background: -webkit-gradient(linear, left top, left bottom, from(#0095cc), to(#00678e));
}

span {
	line-height: 3px;
}

.infos {
	color: red;
}
</style>

</head>
<body>
<form method="POST"  id="_login">
    <input type="hidden" name="fdOpenid" value="${wechatConfigForm.fdOpenid }">
    <input type="hidden" name="fdPublicCode" value="${wechatConfigForm.fdPublicCode }">
    <input type="hidden" name="fdFansId" value="${wechatConfigForm.fdFansId }">
    <input type="hidden" name="fdNickname" value="${wechatConfigForm.fdNickname }">
    <input type="hidden" name="fdScene" value="${wechatConfigForm.fdScene }">
	<center>
	<img style="width: 60%" src="${KMSS_Parameter_ContextPath}resource/style/common/login/loading_logo.jpg" />
	<fieldset>
		<span>&nbsp;</span>
		<div style="margin: 5px 4px;">
		   <input type="text" name="sysUrl" placeholder="系统URL" style="background-color:#D6D3CE;" id="sysUrl" readonly="readonly" disabled="disabled"/>
		</div>
		
		<div style="margin: 5px 4px;">
		   <input type="text" name="fdLoginName" placeholder="用户名" id="loginName" value="${wechatConfigForm.fdLoginName }" />
		   <span><font color="red"></font></span>
		</div>
		
		<div style="margin: 5px 4px;">
			<input type="password" name="fdPasswd" placeholder="密  码"  id="passwd" value="${wechatConfigForm.fdPasswd }" />
			<span><font color="red"></font></span>
		</div>
		
		<span>&nbsp;</span>
	
		<div class="">
		   <input type="submit" class="c-btn-oran-big" value="立即绑定"  id="submit" onclick="save();"></div>

	</fieldset>
	</center>
</form>
<script type="text/javascript">
function Com_GetCurDnsHost(){
	var host = location.protocol.toLowerCase()+"//" + location.hostname;
	if(location.port!='' && location.port!='80'){
		host = host+ ":" + location.port;
	}
	return host;
}
var pdaUrl =Com_GetCurDnsHost() + "${KMSS_Parameter_ContextPath}";
	$(document).ready(function(){
		$("#sysUrl").val(pdaUrl);
	});

    function save(){
		var loginName=$("#loginName").val();
		var passwd =$("#passwd").val();
		var flag=true;
		if (!(loginName!=null && loginName.length>0)) {
		    $("#loginName").find("span[id='fdNamelTip']").remove();
			$("#loginName").after("<span id='fdNamelTip'><font color='red'>用户名不能为空.</font></span>");
			flag=false;
		}

		if (!(passwd!=null && passwd.length>0)) {
		    $("#passwd").find("span[id='fdPwsTip']").remove();
			$("#passwd").after("<span id='fdPwsTip'><font color='red'>密码不能为空.</font></span>");
			flag=false;
		}
		
	    if(flag){
	    	$("#submit").val("正在绑定...");
	    	$("#submit").disabled = true;
		    var url='wechatLoginHelper.do?method=toBindSystem';
			$("#_login").attr("action", url);
			$("#_login").attr("method", "post");
			$("#_login").submit();
		}
	}

</script>

</body>
</html>