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
Com_IncludeFile("docutil.js|optbar.js"); 
function confirmDelete(msg){
	var del = confirm("<bean:message key="page.comfirmDelete"/>");
	return del;
}
</script>
<title>
<template:block name="title" />
</title>
<template:block name="head" />
</head>
<body>
	<template:block name="toolbar" />
	<template:block name="content" /> 
</body>
</html>
