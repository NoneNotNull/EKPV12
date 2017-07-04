<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<!doctype html>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="${LUI_ContextPath}/sys/ui/extend/theme/default/module/images/css.css"/>
<script type="text/javascript">
var Com_Parameter = {
	ContextPath:"${KMSS_Parameter_ContextPath}",
	ResPath:"${KMSS_Parameter_ResPath}",
	Style:"${KMSS_Parameter_Style}",
	JsFileList:new Array,
	StylePath:"${KMSS_Parameter_StylePath}",
	Lang:"<%= request.getLocale().toString().toLowerCase().replace('_', '-') %>",
	CurrentUserId:"${KMSS_Parameter_CurrentUserId}"
};
</script>
<script type="text/javascript" src="${LUI_ContextPath}/resource/js/sea.js"></script>
<script type="text/javascript" src="${LUI_ContextPath}/resource/js/seaconfig.jsp"></script>
<script type="text/javascript">
seajs.use([ 'lui/parser', 'lui/jquery', 'theme!common', 'theme!icon','theme!list' ],
		function(parser, $) {
			$(document).ready(function() {
				parser.parse();
			});
		});
</script>

<title>
<template:block name="title">
</template:block>
</title> 
</head>
<body>
<div style="margin: 0px auto;width: 980px;">
<template:block name="body1"></template:block>
</div>
</body>
</html>
