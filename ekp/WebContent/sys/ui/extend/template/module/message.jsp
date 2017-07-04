<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<!doctype html>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="/sys/ui/jsp/jshead.jsp"%>
<link type="text/css" rel="stylesheet" href="${LUI_ContextPath }/<%=(JSONObject.fromObject(SysUiPluginUtil.getThemes(request))).getJSONArray("prompt").get(0)%>"/>
<script>
	seajs.use( [ 'lui/jquery'], function($) {
		$( function() {
			try {
				var arguObj = document.getElementsByTagName("div")[0];
				if(window.frameElement!=null && window.frameElement.tagName=="IFRAME"){
					window.frameElement.style.height = Math.max(document.documentElement.scrollHeight, document.body.scrollHeight) + "px";
				}
			} catch(e) {
			}
		});
	});
</script>
<template:block name="head">
</template:block>
<title><template:block name="title"></template:block></title>
</head>
<body>
  <template:block name="body">
  </template:block>
</body>
</html>
