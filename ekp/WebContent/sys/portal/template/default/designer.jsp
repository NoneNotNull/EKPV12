<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/portal/portal.tld" prefix="portal"%>
<!doctype html>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="/sys/ui/jsp/jshead.jsp"%>
<title>
<portal:title/>
</title>
<script>
	seajs.use(['theme!portal']);
</script>
</head>
<body class="lui_portal_body" onselectstart="return false;">
<div style="margin: 0px auto;width: 980px;display: table;">
	<div style="margin: 0px auto;height: 50px;border: 1px #e5e5e5 solid;background: #82d0f4;text-align: center;">
		<portal:header/>
	</div>	
	<div style="height: 15px;"></div>
	<template:block name="body1"></template:block>
	<div style="height: 15px;"></div>
	<div style="margin: 0px auto;height: 50px;border: 1px #e5e5e5 solid;background: #c8c8c8;text-align: center;">
	 	<portal:footer/>
	</div>
</div> 
</body>
</html>
