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
		<td valign="top" style="width: 175px">
			<div class="lui_list_left_sidebar_frame">
				<template:block name="nav" />
			</div>
		</td>
		<td style="width: 15px;"></td>
		<td valign="top">
			<div class="lui_list_body_frame">
				<div id="queryListView" style="width:100%">
					<iframe id="tibMainIframe" style="width: 100%; border-top-color: currentColor; border-right-color: currentColor; border-bottom-color: currentColor; border-left-color: currentColor; border-top-width: 0px; border-right-width: 0px; border-bottom-width: 0px; border-left-width: 0px; border-top-style: none; border-right-style: none; border-bottom-style: none; border-left-style: none;" 
							src=""></iframe>
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
<script type="text/javascript">
function tibOpenPageResize(){
	try{
		var ifr = LUI.$("#tibMainIframe");
		var sh = ifr[0].contentWindow.document.body.scrollHeight;
		var oh = ifr[0].contentWindow.document.body.offsetHeight;			 
		var chs = ifr[0].contentWindow.document.body.childNodes;
		var bh = 0;
		var bw = 0;
		for(var i=0;i<chs.length;i++){
			var tbh = chs[i].offsetTop + chs[i].offsetHeight;
			var tbw = chs[i].offsetLeft + chs[i].offsetWidth;
			if(tbh > bh){
				bh = tbh;
			}
			if(tbw > bw){
				bw = tbw;
			}
		}
		if(ifr.contents().innerWidth() > ifr.width()){
			bh = bh + 28;
		}
		if(ifr.contents().innerHeight() > bh){
			bh = ifr.contents().innerHeight();
		}
		ifr[0].style.height = (bh) + 'px';
	}catch(e){}
	openPageReisizeTimeout = window.setTimeout(tibOpenPageResize, 200);
}
</script>