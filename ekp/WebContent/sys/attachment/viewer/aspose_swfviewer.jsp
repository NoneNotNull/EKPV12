<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.simple">
	<template:replace name="head">
		<template:super/>
		<style type="text/css">
			html,body {
				overflow: hidden;
			}
		</style>
<script type="text/javascript">
	var viewerParam = "${viewerParam}";
	function getParam(params,paramName) {
	    var value = "";
	    var paraNameValues = params.split(",");  
	    for (var i=0; i<paraNameValues.length; i++) {  
	        if (paramName==getKey(paraNameValues[i])) {  
	            value = getValue(paraNameValues[i]);
	        }  
	    }  
	    return value;  
	}
	function getKey(str) {  
	    var start = str.indexOf(":");  
	    if (start==-1) {  
	        return str;  
	    }  
	    return str.substring(0,start);  
	}  
	  
	function getValue(str) {  
	    var start = str.indexOf(":");  
	    if (start==-1) {  
	        return "";  
	    }  
	    return str.substring(start+1);  
	}
	function mouseWheel(evt) {
		debugger;
		evt = window.event || evt;
		var xxx = 0;
		if(evt.wheelDelta){
			xxx = evt.wheelDelta;
		}else{
			xxx = evt.detail*-1;
		}
		try {
			document.getElementById("att_swf_viewer")
					.mouseWheelScroll(xxx);
		} catch (e) {
		}
		if (evt.preventDefault) {
			evt.preventDefault();
		} else {
			evt.returnValue = false;
		}
	}
	function createFlashViewer(divid, swfUrl, pageCount) {
		var htmlArray = new Array();
		if (Com_Parameter.IE) {
			htmlArray
					.push('<object id="att_swf_viewer" classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,19,0" style="cursor:pointer;width:100%">');
			htmlArray.push('<param name="wmode" value="window">');
			htmlArray.push('<param name="allowFullScreen" value="true">');
			htmlArray.push('<param name="movie" value="'
					+ Com_Parameter.ContextPath
					+ 'sys/attachment/swf/docviewer.swf" />');
			htmlArray.push('<param name="flashVars" value="firstLoadPages=3&docurl=', swfUrl,
					'&pagecount=', pageCount, '&pageType=swf"/>');
			htmlArray.push('<param name="quality" value="high" />');
			htmlArray.push('</object>');
		} else {
			htmlArray
					.push('<embed id="att_swf_viewer" src="'
							+ Com_Parameter.ContextPath
							+ 'sys/attachment/swf/docviewer.swf" quality="high" pluginspage="http://www.macromedia.com/go/getflashplayer" type="application/x-shockwave-flash" style="width:100%;height:350px;"');
			htmlArray.push(' allowFullScreen=true ');
			htmlArray.push(' flashVars="firstLoadPages=3&docurl=', swfUrl, '&pagecount=', pageCount,
					'&pageType=swf"></embed>');
		}
		document.getElementById(divid).innerHTML = htmlArray.join("");
	
		var objViewer = document.getElementById('att_swf_viewer');
		if (objViewer) {
			if (objViewer.addEventListener) {
				objViewer.addEventListener("mousewheel", mouseWheel, false);
				// firefox不支持mousewheel--替代方案是DOMMouseScroll
				objViewer.addEventListener("DOMMouseScroll", mouseWheel, false);
			} else if (objViewer.attachEvent) {
				objViewer.attachEvent("onmousewheel", mouseWheel);
			}
		}
	}
	LUI.ready(function() { 
		seajs.use('lui/jquery',function($){
			var pageCount = getParam(viewerParam,"total");
			var swfUrl = encodeURIComponent(Com_Parameter.ContextPath+"sys/attachment/sys_att_main/sysAttMain.do?method=view&fdId=${param['fdId']}&"); 
			createFlashViewer("swfviewer",swfUrl, pageCount);
			
			$(window).resize(function(){
				var winw = $(window).width() >= document.body.clientWidth ? $(window).width() : document.body.clientWidth, 
				     winh = $(window).height() >= document.body.clientHeight ? $(window).height() : document.body.clientHeight;
				var pw = winw;
				var ph = winh;
				$("#att_swf_viewer").width(pw).height(ph);
			});
			
			$(window).resize();
		});
	});
</script>
	</template:replace>
	<template:replace name="body">
		<div id="swfviewer"></div>
	</template:replace>
</template:include>
