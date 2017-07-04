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
<body class="lui_portal_body">
<portal:header scene="portal" var-width="${empty param['pagewidth'] ? '980px' : param['pagewidth'] }" />
<div style="height: 15px;"></div>
<div style="margin: 0px auto;min-width:980px;${empty param['pagewidth'] ? 'width:980px' : lfn:concat('width:',param['pagewidth']) }">
<template:block name="body1"></template:block>
</div>
<div style="height: 15px;"></div>
<portal:footer scene="portal" var-width="${empty param['pagewidth'] ? '980px' : param['pagewidth'] }"/>
<ui:top></ui:top>
</body>
</html>
