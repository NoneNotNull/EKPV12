<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<!doctype html>
<html >
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width, initial-scale=1,minimum-scale=1.0,maximum-scale=1.0">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="/kms/common/pda/template/jshead.jsp"%>
<title>
<template:block name="title" />
</title>
<template:block name="head" />
</head>
<body style="overflow: hidden;">
	<div data-lul-role="body" style="position: relative;">
		<div data-lui-role="page" id="page" style="padding-top: 40px">
			<header class="lui-header"  style="position:absolute">
				<template:block name="header">
				</template:block>
			</header>
			<template:block name="personal">
			</template:block>
			<div class="lui-content">
				<template:block name="listview" />
			</div>
			<template:block name="footer">
			</template:block>
			<!-- 
			<div class="lui-add">
			</div>
			 -->
		</div>
	</div>
	<div data-lui-role="button" id="button_top" >
		<script type="text/config">
			{
				currentClass : 'lui-top',
				onclick : "___top___();",
				group : 'group_top',
		    }
		</script>
	</div>
	
	<script>
		function ___top___(){
			var listviews = Pda.Role('listview');
			if(listviews && listviews.length>0)
				listviews[0].top();
		}
	</script>
</body>
</html>
