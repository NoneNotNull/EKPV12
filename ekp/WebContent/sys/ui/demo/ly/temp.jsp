<%@page import="com.landray.kmss.util.UserUtil"%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<!doctype html>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>
<template:block name="title">
</template:block>
</title>
</head>
<body>
<div style="border:1px red solid;margin:20px;">页眉</div>
<div style="border:1px red solid;margin:20px;">
	<template:block name="path">
	
	</template:block>
</div>
<table width="100%">
	<tr>
		<td style="width:300px;border:1px red solid;" valign="top">
			<template:block name="nav">
				默认导航
			</template:block>
		</td>
		<td style="width: 20px;border:0px"></td>
		<td style="border:1px red solid;" valign="top">
			<template:block name="content" />
		</td> 
	</tr>
</table>
<div style="border:1px red solid;margin:20px;">页脚</div>
</body>
</html>
