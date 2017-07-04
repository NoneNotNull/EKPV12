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
function Sidebar_Refresh(){}
Com_Parameter.CloseInfo="<bean:message key="message.closeWindow"/>";
</script>
<title>
	<template:block name="title" />
</title>
<template:block name="head" />
</head>
<body>
<!-- 错误信息返回页面 -->
<c:import url="/resource/jsp/error_import.jsp" charEncoding="UTF-8" ></c:import>
<c:set var="frameWidth" scope="page" value="${empty param.width ? '90%' : param.width}"/>
<c:set var="minWidth" scope="page" value="${empty param.minWidth ? '300px' : param.minWidth}"/>

<template:block name="toolbar" />

<div id="lui_validate_message" style="width:${ frameWidth }; min-width:${ minWidth }; margin:0px auto;"></div>
<table style="width:${ frameWidth }; min-width:${ minWidth }; margin: 0px auto;">
	<tr>
		<td valign="top">
			<div class="lui_form_content">
				<template:block name="content" />
			</div>
		</td>
	</tr>
</table>
<div style="height:20px;"></div>
<ui:top id="top"></ui:top>
</body>
</html>

