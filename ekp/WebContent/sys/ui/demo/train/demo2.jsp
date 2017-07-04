<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<!doctype html>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="/sys/ui/jsp/jshead.jsp"%>
<title><template:block name="title" /></title>
</head>
<body>
	<div> 页眉内容   这里可以是任意JSP </div>
	<table>
		<tr>
			<td>左侧导航  这里可以是任意JSP内容</td>
			<td>
				<template:block name="content">
					右侧内容区域。这里是个可编辑区域，这里的内容就由使用该模版的 页面去填充。
				</template:block>
			</td>
		</tr>
	</table>
	<div> 页脚内容  这里可以是任意JSP</div>
</body>
</html>