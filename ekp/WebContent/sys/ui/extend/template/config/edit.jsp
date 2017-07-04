<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<!doctype html>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="/sys/ui/jsp/jshead.jsp"%>
<script type="text/javascript">
	seajs.use(['theme!form']);
</script>
<script type="text/javascript">
Com_Parameter.CloseInfo="<bean:message key="message.closeWindow"/>";
Com_IncludeFile("docutil.js|validation.jsp|validation.js|plugin.js|eventbus.js|xform.js", null, "js");
</script>
<title>
<template:block name="title" />
</title>
<template:block name="head" />
</head>
<body>
	<c:import url="/resource/jsp/error_import.jsp" charEncoding="UTF-8" ></c:import>
	<template:block name="toolbar" />
	<template:block name="content" /> 
</body>
</html>
