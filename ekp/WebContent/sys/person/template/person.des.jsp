<%@page import="com.landray.kmss.util.UserUtil"%>
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
<script type="text/javascript" src="${LUI_ContextPath}/resource/js/common.js"></script>
<script type="text/javascript" src="${LUI_ContextPath}/resource/js/sea.js"></script>
<script type="text/javascript" src="${LUI_ContextPath}/resource/js/seaconfig.jsp"></script>
<script type="text/javascript">
seajs.use([ 'sys/ui/js/parser', 'lui/jquery', 'theme!common', 'theme!icon', 'theme!form' ],
	function(parser, $) {
		$(document).ready(function() {
				parser.parse();
		});
	}
);
</script>
<template:block name="head" />
<title>
<template:block name="title">
未设置标题
</template:block>
</title>
</head>
<body>
<div class="toolbar_body">
<template:block name="toolbar">

</template:block>
</div>
<div class="nav_body">
<div style="width:98%" class="nav_content">
<template:block name="path">

</template:block>
</div>
</div>
<table width="790px" align="center" style="margin: 0px auto;">
	<tr>
		<td valign="top">
			<div style="min-width: 790px;">
				<template:block name="content" />
			</div>
		</td>
	</tr>
</table>
<div style="height: 15px;"></div> 
<ui:top></ui:top>

<script>
		seajs.use(["lui/jquery"], function($) {
			$(document).ready(function() {
				emitResize();
			});
			function doResize() {
				var height = document.body.scrollHeight;
				if (height < 600)
					height = 600;
				if (window.frameElement != null
						&& window.frameElement.tagName == "IFRAME") {
					window.frameElement.style.height = height + "px";
				}
			}
			function emitResize() {
				doResize();
				setTimeout(emitResize, 500);
			}
			window.emitResize = emitResize;
		});
		
</script>
</body>
</html>
