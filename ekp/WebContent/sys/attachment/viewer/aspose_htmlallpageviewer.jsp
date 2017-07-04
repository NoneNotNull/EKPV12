<%@page import="com.landray.kmss.util.StringUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.simple">
	<template:replace name="titile">
		<%
			Object obj = request.getAttribute("fileName");
					if (obj != null) {
						String fileName = obj.toString();
						if (fileName.indexOf(".") >= 0)
							out.append(fileName.substring(0, fileName
									.lastIndexOf(".")));

					}
		%>
	</template:replace>
	<template:replace name="head">
		<template:super />
		<style type="text/css">
.lui_reader_content {
	text-align: center;
}

.lui_reader_main_body {
	display: inline-block;
	margin: 0px auto;
}
</style>
<script type="text/javascript">	
var _height = "0";
		var viewerParam = "${viewerParam}";
		var dataSrc="${KMSS_Parameter_ContextPath}sys/attachment/sys_att_main/sysAttMain.do?method=view&fdId=${fdId}";
		var totalPageNum = parseInt(getParam(viewerParam,"totalPageCount"));
		var viewerStyle=getParam(viewerParam,"viewerStyle");
	LUI.ready( function() {
		initialViewer();
	});

	function getPageHeight(){
		return parseInt(document.getElementById("dataFrame_1").height)+4;
	}

	function getScrollTop(){
		var scrollTop = 0, bodyScrollTop = 0, documentScrollTop = 0;
		if(document.body){
			bodyScrollTop = document.body.scrollTop;
		}
		if(document.documentElement){
			documentScrollTop = document.documentElement.scrollTop;
		}
		scrollTop = (bodyScrollTop - documentScrollTop > 0) ? bodyScrollTop : documentScrollTop;
		return scrollTop;
	}

	function getScrollHeight(){
		var scrollHeight = 0, bodyScrollHeight = 0, documentScrollHeight = 0;
		if(document.body){
			bodyScrollHeight = document.body.scrollHeight;
		}
		if(document.documentElement){
			documentScrollHeight = document.documentElement.scrollHeight;
		}
		scrollHeight = (bodyScrollHeight - documentScrollHeight > 0) ? bodyScrollHeight : documentScrollHeight;
		return scrollHeight;
	}

	function getWindowHeight(){
		var windowHeight = document.documentElement.clientHeight||document.body.clientHeight;
		return windowHeight;
	}
	
	function setFrameSize(frameObj,height,width){
		if (frameObj && !window.opera){
			var fHeight=height||(frameObj.contentDocument.body.offsetHeight +20)||frameObj.Document.body.scrollHeight;
			var fWidth=width||(frameObj.contentDocument.body.scrollWidth +20)||frameObj.Document.body.scrollWidth;
			frameObj.height=fHeight;
			frameObj.width=fWidth;
			_height =parseInt(fHeight);
		}
	}

	function initialViewer(initialPageNum) {
		var tableContent=document.getElementById("viewerContent");
		var innerHTMLSTR="";
		var dataFrameSrc="";
		for(var i=1;i<=totalPageNum;i++){
			dataFrameSrc=dataSrc+"&filekey="+getFileName(i);
			innerHTMLSTR+="<tr id='pageTr_"+i+"'>"+"<td width='30%'></td><td width='40%'><iframe"+" src='"+dataFrameSrc+"'"+" id='dataFrame_"+i+"' onload='setFrame(this,"+i+",true"+");' style='border:0px;' height='0px' scrolling='no'></iframe></td><td width='30%'></td>"+"</tr>";
		}
		tableContent.innerHTML=innerHTMLSTR;
		
	}

	function setFrame(frameObj,pageNum,isScroll){
		if(frameObj.src!=""){
			setFrameSize(frameObj);
		}else{
			setFrameSize(frameObj,0,0);
		}
		setAuthentication(frameObj);
		if(pageNum == totalPageNum){
			var tableContent=document.getElementById("viewerContent");
			if (tableContent != null && window.frameElement != null && window.frameElement.tagName == "IFRAME") {
				window.frameElement.style.height = (parseInt(_height)*totalPageNum+100) + "px";
			}
		}
	}

	function setAuthentication(frameObj){
		var bodyEle=frameObj.contentDocument.body||frameObj.Document.body;
		bodyEle.oncopy=function(){return onAuthentication();};
		bodyEle.oncontextmenu=function(){return onAuthentication();};
		bodyEle.onselectstart=function(){return onAuthentication();};
		if(!onAuthentication()){
			bodyEle.style="-moz-user-select:none;-webkit-user-select: none;-ms-user-select: none;-khtml-user-select: none;user-select: none;";
		}
		var doc = frameObj.contentDocument||frameObj.Document;
		$(doc).find("img").each(function(){
			this.oncontextmenu= function(){ return false;};
		});
	}

	function onAuthentication(){
		var canCopy="${canCopy}";
		return canCopy=="true"?true:false;
	}
	
	function getParam(params,paramName) {
	    var value = "";
	    var paraNameValues = params.split(",");  
	    for (var i=0; i<paraNameValues.length; i++) {  
	        if (paramName==getKey(paraNameValues[i])) {  
	            value = getValue(paraNameValues[i])  
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
	
	function getFileName(pageNum){
		return "aspose_office2html_page-"+pageNum;
	}
</script>
	</template:replace>
	<template:replace name="body">
		<div id="readerContainer">
		<div class="lui_reader_content">
		<div class="lui_reader_main_body">
		<table id="viewerContent" align="center" cellpadding="0px;" cellspacing="0px;">
		</table>
		</div>
		</div>
		</div>
	</template:replace>
</template:include>
