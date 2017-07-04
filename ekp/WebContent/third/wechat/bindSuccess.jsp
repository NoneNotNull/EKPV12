<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%
String KMSS_Parameter_ContextPath = request.getContextPath()+"/";
request.setAttribute("KMSS_Parameter_ContextPath", KMSS_Parameter_ContextPath);
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>系统绑定成功</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<script type="text/javascript" src="${KMSS_Parameter_ContextPath}resource/js/jquery.js"></script>
<style>

div {
	background-color: #99CCCC;
	padding: 10px;
}

font {
	background-color: #99CCFF;
}

body {
	font-family: arial;
}
</style>

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
	$("#_insystem").attr("href",pdaUrl);
});
</script>
</head>
<body>
<form action="" id="_insys">

<center>
<img style="width: 30%" src="${KMSS_Parameter_ContextPath}resource/style/common/login/loading_logo.jpg" /></center>
<div style="text-align: center">系统绑定成功!</div>

<div style="text-align: center"><a href="" id="_insystem">进入系统</div>

</form>

</body>
</html>