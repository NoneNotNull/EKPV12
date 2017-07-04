<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ page import="com.landray.kmss.util.ResourceUtil"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%
	response.addHeader("isloginpage","true");
%>
<!doctype html>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="/sys/ui/jsp/jshead.jsp"%>
<template:block name="head">
</template:block>
<script>
	function checkLocation(){
		if(top==window){
			return;
		}
		var href = top.location.href;
		var param = "s_try_login=true";
		if(href.substring(href.length-param.length)==param){
			return;
		}
		var index = href.indexOf("?");
		if(index==-1){
			top.location.href = top.location.href+"?"+param;
		}else{
			top.location.href = top.location.href+"&"+param;
		}
	}
	try{
		checkLocation();
	}catch(e){}
</script>
<title><%=ResourceUtil.getString(request.getSession(),"login.title")%></title>
</head>
<body>
  <template:block name="body">
  </template:block>
</body>
</html>
