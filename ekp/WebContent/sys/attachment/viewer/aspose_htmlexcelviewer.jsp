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
					out.append(fileName.substring(0,
							fileName.lastIndexOf(".")));

			}
		%>
	</template:replace>
	<template:replace name="head">
		<template:super />
		<script type="text/javascript">
		window.onscroll=loadPage;
		var viewerParam = "${viewerParam}";
		var dataSrc="${KMSS_Parameter_ContextPath}sys/attachment/sys_att_main/sysAttMain.do?method=view&fdId=${fdId}";
		var totalPageNum = parseInt(getParam(viewerParam,"totalPageCount"));
		var loadPageNum=1;
	LUI.ready( function() {
		initialViewer();
	});

	function loadPage(){
		//var scrollTop = document.documentElement.scrollTop || window.pageYOffset || document.body.scrollTop;
		if(getScrollTop() + getWindowHeight() == getScrollHeight()){
			loadPageNum=loadPageNum+1;
			if(loadPageNum<=totalPageNum){
				if(loadPageNum<totalPageNum){
					window.scrollTo(0, getScrollTop()-1);
				}
				goToPage(loadPageNum);
			}
		}
		//alert(scrollTop);
	}

	function goToPage(pageNum){
		if(pageNum<=totalPageNum){
			var frameObj=document.getElementById("dataFrame_"+pageNum);
			frameObj.src=dataSrc+"&filekey="+getFileName(pageNum);
			setFrame(frameObj,pageNum);
		}
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

	function initialViewer() {
		var tableContent=document.getElementById("viewerContent");
		var innerHTMLSTR="";
		for(var i=1;i<=totalPageNum;i++){
			var fileName=getFileName(i);
			if(i==1){
				innerHTMLSTR+="<iframe src='"+dataSrc+"&filekey="+fileName+"' id='dataFrame_"+i+"' onload='setFrame(this,1);' style='border:0px;' width='100%' height='100%' scrolling='auto'></iframe>";
			}else{
				//
			}
		}
		tableContent.innerHTML=innerHTMLSTR;
	}

	function setFrame(frameObj,pageNum){
		setAuthentication(frameObj);
	}

	function visibleOtherPage(pageNum){
		if(pageNum>1){
			document.getElementById("otherPage_"+pageNum).style.display='table-row';
		}
	}

	function setFrameSize(frameObj,height,width){
		if (frameObj && !window.opera){
			var fHeight;
			var fWidth;
			if(height==0&&width==0){
				fHeight=0;
				fWidth=0;
			}else{
				fHeight=height||(frameObj.contentDocument.body.offsetHeight +20)||frameObj.Document.body.scrollHeight;
				fWidth=width||(frameObj.contentDocument.body.scrollWidth +20)||frameObj.Document.body.scrollWidth;
			}
			frameObj.height=fHeight;
			frameObj.width=fWidth;
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

		<style type="text/css">
body {
	font-family: "微软雅黑", Geneva, "sans-serif", "微软雅黑", "宋体";
	font-size: 12px;
}

body,div,dl,dt,dd,ul,ol,li,h1,h2,h3,h4,h5,h6,pre,form,iieldset,input,textarea,p,blockquote,th,td
	{
	margin: 0;
	padding: 0;
}

table {
	border-collapse: collapse;
	border-spacing: 0;
}

fieldset,img {
	border: 0;
}

address,caption,cite,code,dfn,em,strong,th,var {
	font-style: normal;
	font-weight: normal;
}

ol,ul {
	list-style: none;
}

a {
	text-decoration: none;
	transition: background-color 0.3s ease 0s, border 0.3s ease 0s, color
		0.3s ease 0s, opacity 0.3s ease-in-out 0s;
}

caption,th {
	text-align: left;
}

h1,h2,h3,h4,h5,h6 {
	font-size: 100%;
	font-weight: normal;
}

q:before,q:after {
	content: '';
}

abbr,acrnym {
	border: 0;
}

em {
	font-style: normal;
}

.textEllipsis {
	width: 90%;
	overflow: hidden;
	display: block;
	white-space: nowrap;
	text-overflow: ellipsis;
}

.clr {
	clear: both;
	line-height: 0px;
}

.lui_reader_w {
	position: fixed;
	top: 0px;
	bottom: 0px;
	width: 100%;
}

.lui_reader_content {
	text-align: center;
	width: 100%;
	height: 100%;
}

.lui_reader_main_body {
	display: inline-block;
	margin: 0px auto;
	width: 100%;
	height: 100%;
}

.icon_fullscreen {
	display: inline-block;
	text-indent: -99999px;
	cursor: pointer;
	width: 20px;
	height: 20px;
	background: url(../viewer/images/read_fullscreen.png) no-repeat -25px
		0px;
}

.icon_fullscreen:hover {
	background-position: 0px 0px;
}

.lui_reader_content .icon_fullscreen {
	position: fixed;
	right: 20px;
	top: 10px;
}
</style>
	</template:replace>
	<template:replace name="body">
		<div class="lui_reader_w">
		<div class="lui_reader_content">
		<div class="lui_reader_main_body">
		<div id="viewerContent" style="width: 100%; height: 100%;"></div>
		</div>
		</div>
		</div>
	</template:replace>
</template:include>
