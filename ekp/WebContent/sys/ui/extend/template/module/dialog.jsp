<%@page import="com.landray.kmss.util.UserUtil"%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<!doctype html>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="/sys/ui/jsp/jshead.jsp"%>
<script>
	seajs.use(['theme!form']);
</script>
<template:block name="head" />
<title><template:block name="title" /></title>
</head>
<body>
	<template:block name="content" />
</body>
</html>
