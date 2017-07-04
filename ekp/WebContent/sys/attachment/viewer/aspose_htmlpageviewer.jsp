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

.clrfix {
	zoom: 1;
}

.clrfix:after {
	display: block;
	clear: both;
	visibility: hidden;
	line-height: 0px;
	content: 'clear';
}

.lui_reader_w_bottom {
	padding-top: 10px;
	padding-bottom: 50px;
}

.lui_reader_w_top {
	padding-top: 55px;
	padding-bottom: 50px;
}

.lui_reader_content {
	text-align: center;
}

.lui_reader_main_body {
	display: inline-block;
	margin: 0px auto;
}

.lui_reader_bar_bottom {
	position: fixed;
	bottom: 0px;
	left: 0px;
	width: 100%;
	height: 45px;
	background: #f5f5f5;
	border-top: 1px solid #b5b5b5;
}

.lui_reader_bar_top {
	position: fixed;
	top: 0px;
	left: 0px;
	width: 100%;
	height: 45px;
	background: #f5f5f5;
	border-top: 1px solid #b5b5b5;
}

.lui_reader_bar_bottom .pageNav {
	display: inline-block;
	position: absolute;
	left: 50%;
	margin-left: -73px;
	top: 10px;
}

.lui_reader_bar_top .pageNav {
	display: inline-block;
	position: absolute;
	left: 50%;
	margin-left: -73px;
	top: 10px;
}

.lui_reader_bar_bottom .pageNav ul li {
	float: left;
	margin-right: 15px;
}

.lui_reader_bar_top .pageNav ul li {
	float: left;
	margin-right: 15px;
}

.lui_reader_bar_bottom .pageNav ul li.arrow a {
	display: inline-block;
	cursor: pointer;
	margin-top: 4px;
	width: 18px;
	height: 15px;
	background: url(../viewer/images/reader_arrow.png) no-repeat;
}

.lui_reader_bar_top .pageNav ul li.arrow a {
	display: inline-block;
	cursor: pointer;
	margin-top: 4px;
	width: 18px;
	height: 15px;
	background: url(../viewer/images/reader_arrow.png) no-repeat;
}

.lui_reader_bar_bottom .pageNav ul li.arrow a.prev {
	background-position: -20px 0px;
}

.lui_reader_bar_top .pageNav ul li.arrow a.prev {
	background-position: -20px 0px;
}

.lui_reader_bar_bottom .pageNav ul li.arrow a.next {
	background-position: -40px 0px;
}

.lui_reader_bar_top .pageNav ul li.arrow a.next {
	background-position: -40px 0px;
}

.lui_reader_bar_bottom .pageNav ul li.arrow a.prev.unable {
	background-position: 0px 0px;
}

.lui_reader_bar_top .pageNav ul li.arrow a.prev.unable {
	background-position: 0px 0px;
}

.lui_reader_bar_bottom .pageNav ul li.arrow a.next.unable {
	background-position: -60px 0px;
}

.lui_reader_bar_top .pageNav ul li.arrow a.next.unable {
	background-position: -60px 0px;
}

.lui_reader_bar_bottom .pageNav ul li.pages {
	color: #6b6b71;
}

.lui_reader_bar_top .pageNav ul li.pages {
	color: #6b6b71;
}

.lui_reader_bar_bottom .pageNav ul li.pages input {
	width: 44px;
	height: 20px;
	line-height: 20px;
	margin-right: 5px;
	text-align: center;
	color: #afafb2;
	border: 1px solid #e2e4e4;
	border-radius: 5px;
}

.lui_reader_bar_top .pageNav ul li.pages input {
	width: 44px;
	height: 20px;
	line-height: 20px;
	margin-right: 5px;
	text-align: center;
	color: #afafb2;
	border: 1px solid #e2e4e4;
	border-radius: 5px;
}

.reader_zoom_w {
	position: absolute;
	right: 0px;
	top: 10px;
}

.reader_zoom_w ul li {
	float: left;
	margin-right: 26px;
}

.reader_zoom_w .zoom_L {
	display: inline-block;
	cursor: pointer;
	width: 20px;
	height: 21px;
	background: url(../viewer/images/read_zoom_L.png) no-repeat -25px 0px;
}

.reader_zoom_w .zoom_L:hover {
	background-position: 0px 0px;
}

.reader_zoom_w .zoom_L.unable {
	background-position: -50px 0px;
}

.reader_zoom_w .zoom_S {
	display: inline-block;
	cursor: pointer;
	width: 20px;
	height: 21px;
	background: url(../viewer/images/read_zoom_S.png) no-repeat -25px 0px;
}

.reader_zoom_w .zoom_S:hover {
	background-position: 0px 0px;
}

.reader_zoom_w .zoom_S.unable {
	background-position: -50px 0px;
}

.reader_zoom_w .cancel_fullscreen {
	display: inline-block;
	cursor: pointer;
	width: 20px;
	height: 20px;
	background: url(../viewer/images/read_cancel_fullscreen.png) no-repeat
		-25px 0px;
}

.reader_zoom_w .cancel_fullscreen:hover {
	background-position: 0px 0px;
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

.reader_new_window_hidden {
	position: absolute;
	right: 0px;
	top: 10px;
	display: none;
}

.reader_new_window_hidden ul li {
	float: left;
	margin-right: 26px;
}

.new_open {
	display: inline-block;
	cursor: pointer;
	width: 80px;
	height: 21px;
	font-weight: bold;
}

.reader_new_window_display {
	position: absolute;
	right: 0px;
	top: 10px;
	display: block;
}

.reader_new_window_display ul li {
	float: left;
	margin-right: 26px;
}
</style>
		<script type="text/javascript">		
		var viewerParam = "${viewerParam}";
		var toolPosition = "${toolPosition}";
		var newOpen = "${newOpen}";
		var dataSrc="${KMSS_Parameter_ContextPath}sys/attachment/sys_att_main/sysAttMain.do?method=view&fdId=${fdId}";
		var totalPageNum = parseInt(getParam(viewerParam,"totalPageCount"));
		var viewerStyle=getParam(viewerParam,"viewerStyle");
		var currentPage=1;
		var isLoad=true;
		window.onresize=function(){isLoad=false;}
	LUI.ready( function() {
		initialViewer(2);
	});


	function getPageHeight(){
		return parseInt(document.getElementById("dataFrame_1").height)+4;
	}
	
	var pageY=0,tempPageY=0;
	
	function loadPage(event){
		var prevPageTr=null;
		var currentPageTr=document.getElementById("pageTr_"+(currentPage));
		var nextPageTr=null;
		if(currentPage>1){
			prevPageTr=document.getElementById("pageTr_"+(currentPage-1));
		}
		if(currentPage<totalPageNum){
			nextPageTr=document.getElementById("pageTr_"+(currentPage+1));
		}
		var tmpScrollTop=getScrollTop();
		var tmpPageHeight=getPageHeight();
		var tmpWindowHeight=getWindowHeight();
		if(isLoad){
			if(prevPageTr!=null){
				var tempPreHeight=(tmpScrollTop+tmpWindowHeight)-(prevPageTr.offsetTop+63);
				if(tempPreHeight<=tmpPageHeight/2){
					goTo(currentPage-1,true);
				}
			}
			if(nextPageTr!=null){
				var tempNextHeight=(tmpScrollTop+tmpWindowHeight)-(nextPageTr.offsetTop+63);
				if(tempNextHeight>=-tmpPageHeight/2){
					goTo(currentPage+1,true);
				}
			}
		}else{
			isLoad=true;
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

	function initialViewer(initialPageNum) {
		var divContent=document.getElementById("viewerContent");
		var innerHTMLSTR="";
		var dataFrameSrc="";
		for(var i=1;i<=totalPageNum;i++){
			dataFrameSrc=dataSrc+"&filekey="+getFileName(i);
			if(i<=initialPageNum){
				innerHTMLSTR+="<tr id='pageTr_"+i+"' height='0px'>"+"<td width='30%' height='0px'></td><td width='40%' height='0px'><iframe"+" src='"+dataFrameSrc+"'"+" id='dataFrame_"+i+"' onload='setFrame(this,"+i+",true"+");' style='border:0px;' height='0px' scrolling='no'></iframe></td><td width='30%' height='0px'></td>"+"</tr>";
			}else{
				innerHTMLSTR+="<tr id='pageTr_"+i+"' height='0px'></tr>";
			}
		}
		divContent.innerHTML="<table id='viewerContent' align='center' width='100%' height='100%' cellpadding='0px;' cellspacing='0px;'>"+innerHTMLSTR+"</table>";
		document.getElementById("totalPageCount").innerHTML= totalPageNum;
		if(toolPosition=="top"){
			document.getElementById("readerContainer").className="lui_reader_w_top";
			document.getElementById("toolBar").className="lui_reader_bar_top clrfix";
		}
		if(newOpen=="true"){
			document.getElementById("newOpenTool").className="reader_new_window_display new_open";
		}
		goTo(1,true);
	}

	function setFrame(frameObj,pageNum,isScroll){
		if(frameObj.src!=""){
			setFrameSize(frameObj);
		}else{
			setFrameSize(frameObj,0,0);
		}
		setAuthentication(frameObj);
		if(!isScroll){
			window.location.href=replacePosition(window.location.href,pageNum);
			unScrollCallback();
		}
		window.onscroll=loadPage;
	}
	
	function unScrollCallback(){
		var gotoCallBack = top.gotoCallBack;
		if( gotoCallBack != undefined )
			gotoCallBack();
	}

	function replacePosition(old,pageNum){
		var newHref=old;
		if(newHref.indexOf("#")==-1){
			newHref=newHref+"#pageTr_"+pageNum;
		}else{
			newHref=newHref.split("#")[0]+"#pageTr_"+pageNum;
		}
		return newHref;
	}

	function setFrameSize(frameObj,height,width){
		if (frameObj && !window.opera){
			var fHeight=height||(frameObj.contentDocument.body.offsetHeight +20)||frameObj.Document.body.scrollHeight;
			var fWidth=width||(frameObj.contentDocument.body.scrollWidth +20)||frameObj.Document.body.scrollWidth;
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

	function goTo(pageNum,isScroll){
		//debugger;
		currentPage=pageNum;
		document.getElementById("currentPage").value=currentPage;
		document.getElementById("currentPageIndex").value=currentPage;
		var dataFrame=document.getElementById("dataFrame_"+pageNum);
		if(dataFrame!=null){
			if(dataFrame.src==""){
				dataFrame.src=dataSrc+"&filekey="+getFileName(pageNum);
			}else{
				if(!isScroll){
					window.location.href=replacePosition(window.location.href,pageNum);
					unScrollCallback();
				}
			}if(pageNum==totalPageNum){
				document.getElementById("nextBtn").className="unable next";
				document.getElementById("prevBtn").className="prev";
			}else if(pageNum==1){
				document.getElementById("prevBtn").className="unable prev";
				document.getElementById("nextBtn").className="next";
			}else{
				document.getElementById("nextBtn").className="next";
				document.getElementById("prevBtn").className="prev";
			}
			if(totalPageNum==1){
				document.getElementById("prevBtn").className="unable prev";
				document.getElementById("nextBtn").className="unable next";
			}
			//window.onscroll=viewerStyle=="ppt"?null:loadPage;
			//window.onscroll=loadPage;
		}else{
			window.onscroll=null;
			var pageTr=document.getElementById("pageTr_"+pageNum);
			pageTr.innerHTML="<td width='30%' height='0px'></td><td width='40%' height='0px'><iframe id='dataFrame_"+pageNum+"' onload='setFrame(this,"+pageNum+(isScroll?",true":",false")+");' style='border:0px;' height='0px' scrolling='no'></iframe></td><td width='30%' height='0px'></td>";
			goTo(pageNum,isScroll);
		}
	}
	
	function prev(){
		var currentPage=parseInt(document.getElementById("currentPage").value);
		if(currentPage>1){
			currentPage--;
			isLoad=false;
			goTo(currentPage,false);
		}
	}

	function next(){
		var currentPage=parseInt(document.getElementById("currentPage").value);
		if(currentPage<totalPageNum){
			currentPage++;
			isLoad=false;
			goTo(currentPage,false);
		}
	}
	
	function onPageKeyUp(evt){
		if(evt.keyCode == 13){
			var currentPage = parseInt(document.getElementById("currentPageIndex").value);
			if(currentPage<=totalPageNum&&currentPage>=1){
				isLoad=false;
				goTo(currentPage,false);
			}else{
				document.getElementById("currentPageIndex").value=document.getElementById("currentPage").value;
			}
		}
	}

	function onPageKeyDown(evt){
		if((evt.keyCode >=48 && evt.keyCode <=57) || evt.keyCode == 8){
			return true;
		}
		return false;
	}

	function zoom(){
		//debugger;
		//document.getElementById("dataFrame_1").contentDocument.body.style.zoom=5;
	}
</script>
	</template:replace>
	<template:replace name="body">
		<div id="readerContainer" class="lui_reader_w_bottom">
		<div class="lui_reader_content">
		<div class="lui_reader_main_body">
		<div id="viewerContent" align="center"
			style="width: 100%; height: 100%"></div>
		</div>
		</div>
		<div id="toolBar" class="lui_reader_bar_bottom clrfix">
		<div class="pageNav">
		<ul class="clrfix">
			<li class="arrow"><a href="javascript:;" id="prevBtn"
				class="unable prev" onclick="prev();"></a></li>
			<li class="pages"><input id="currentPageIndex" type="text"
				onkeydown="return onPageKeyDown(event)"
				onkeyup="onPageKeyUp(event);" />/<span id="totalPageCount"></span></li>
			<li class="arrow"><a href="javascript:;" id="nextBtn"
				class="next" onclick="next();"></a></li>
		</ul>
		</div>
		<div id="newOpenTool" class="reader_new_window_hidden">
		<ul class="clrfix">
			<li><a
				href="${LUI_ContextPath }/sys/attachment/sys_att_main/sysAttMain.do?method=view&fdId=${fdId }"
				title="独立打开" class="new_open" target="_blank">独立打开</a></li>
		</ul>
		</div>
		<!--
		<div class="reader_zoom_w"> <ul class="clrfix">
			<li><a href="javascript:void();" title="放大" class="zoom_L"></a></li>
			<li><a href="javascript:void();" title="缩小" class="zoom_S"></a></li>
			<li><a href="javascript:void();" title="取消全屏"
				class="cancel_fullscreen"></a></li>
			<li><a href="javascript:void();" title="全屏"
				class="icon_fullscreen" onclick="zoom();"></a></li>
		</ul>
		</div> --></div>
		</div>
		<input id="currentPage" type="hidden" />
	</template:replace>
</template:include>
