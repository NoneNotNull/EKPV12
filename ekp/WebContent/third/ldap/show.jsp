<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/config/resource/edit_top.jsp"%>
<%@ page import="com.landray.kmss.third.ldap.SampleDataShow" %>

<html>
<head>
<title>LDAP样本采集</title>
<style>
body,table,td{
	font-size:12px;
	background: #E6EAE9; 
}

table{
	border-collapse:collapse; 
	width: 90%; 
	padding: 0; 
	margin: 0; 
}
td {
	border-style:solid;
	border-color:#85CFFE;
	border-width: 1px 1px 1px 1px;
	padding:5px 1px 6px 1px;
}
.tdb{
	background: #CAE8EA  no-repeat; 
	width:22%
}

</style>
<script>
function retSetting(){
	window.location.href="<c:url value="/third/ldap/setting.do"/>?method=edit";
}
</script>
</head>
<body>
<div align="right">
<input type="button" name="r" value="返回配置" onclick="retSetting();">
<input type="button" name="c" value="关闭" onclick="window.close();">
</div>
<%
SampleDataShow sd = new SampleDataShow();
try{
	sd.handle();
	out.println(sd.getOtherInfo());
	out.println(sd.getDeptInfo());
	out.println(sd.getPersonInfo());
	out.println(sd.getGroupInfo());
	out.println(sd.getPostInfo());
}catch(javax.naming.CommunicationException cex){
	out.println("<font color='red'>LDAP服务器连接不成功，可能是IP地址或端口设置有误！</font>");
}catch(javax.naming.AuthenticationException aex){
	out.println("<font color='red'>错误的用户名或秘密，不能登录LDAP服务器！</font>");
} catch (Exception ex) {
	ex.printStackTrace();
}
%>
<body>
</html>
