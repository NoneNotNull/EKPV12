<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<!doctype html>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="/sys/ui/jsp/jshead.jsp"%>
<script type="text/javascript">
	seajs.use(['theme!list','theme!zone']);	
</script>
<title>
<template:block name="title" />
</title>
<template:block name="head" />
</head>
<body>
	<template:block name="content" /> 
</body>
<script type="text/javascript">
	domain.autoResize();
</script>
</html>