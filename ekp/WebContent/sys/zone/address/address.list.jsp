<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/portal/portal.tld" prefix="portal"%>
<!doctype html>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="/sys/ui/jsp/jshead.jsp"%>
<script type="text/javascript">
	seajs.use(['theme!list', 'theme!portal']);	
</script>
<script src="${ LUI_ContextPath }/sys/ui/extend/template/module/list.js?s_cache=${LUI_Cache}"></script>
<title>
<template:block name="title" />
</title>
<template:block name="head" />
</head>
<body class="lui_list_body">
<c:set var="frameWidth" scope="page" value="${empty param.width ? '90%' : param.width}"/>  
<portal:header var-width="${frameWidth}" />
<table style="width:${frameWidth}; min-width:980px; margin:4px auto 15px auto;">
	<tr>
		<td valign="top">
			<div class="lui_list_body_frame">
				<div id="queryListView" style="width:100%">
					<template:block name="path" />
					<template:block name="content" />
				</div>
				<div id="mainContent" class="lui_list_mainContent" style="display: none;margin: 0">
					<div class="lui_list_mainContent_close" onclick="openQuery()" title="${lfn:message('button.back') }">
					</div>
					<iframe id="mainIframe" style="width: 100%;border: 0px;">
					</iframe>		
				</div>
			</div>
		</td>
	</tr>
</table>
<portal:footer var-width="${frameWidth}" />
<ui:top id="top"></ui:top>
</body>
</html>
