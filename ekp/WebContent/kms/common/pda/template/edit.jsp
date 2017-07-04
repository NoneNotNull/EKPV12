<%@ page language="java" pageEncoding="UTF-8"%>
<%@page import="com.landray.kmss.util.*"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<!doctype html>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width, initial-scale=1,minimum-scale=1.0,maximum-scale=1.0">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="/kms/common/pda/template/jshead.jsp"%>
<script type="text/javascript" src="${LUI_ContextPath}/resource/js/common.js"></script>
<link rel="stylesheet" href="${LUI_ContextPath }/kms/common/pda/core/category/style/category.css" />
<title>
<template:block name="title" />
</title>
<template:block name="head" />
</head>
<body>
	<div data-lul-role="body" style="position: relative;">
		<div data-lui-role="page" id="page">
			<template:block name="header">
			</template:block>
			<div class="lui-content">
				<template:block name="content" />
			</div>
			
			<div class="lui-footer clearfloat">
				<template:block name="footer">
				</template:block>
			</div>
		</div>
	</div>
</body>
<script>
	$(function() {
		setTimeout(function() {
			var fdTemplateId = "${param.fdTemplateId }";
			if (!fdTemplateId)
				selectCategory();
		}, 300);
	});
	
</script>
<script type="text/javascript" src="${LUI_ContextPath}/kms/common/pda/script/pda_step.js">
</script>
</html>
