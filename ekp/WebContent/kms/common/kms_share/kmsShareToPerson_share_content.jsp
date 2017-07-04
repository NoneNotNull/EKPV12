<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<style type="text/css">
body {
	color: #1b83d8;
	font-size: 12px;
	margin: 0px;
	height: 125px;
	font-family: Microsoft YaHei, Geneva, 'sans-serif', SimSun;
}
* { 
	padding:0; 
	margin:0; 
}
</style>
<script type="text/javascript">
	document.onmouseup = saveRange;
	document.onkeyup = saveRange;
	document.oninput = saveRange;
	
	function saveRange() {
		if (navigator.userAgent.indexOf("MSIE") > 0) {//IE浏览器
			parent.__range = document.selection.createRange();
		}
	}
	function initIframe(){
		if (navigator.userAgent.indexOf("MSIE") > 0) {//IE浏览器
			var r = document.body.createTextRange(); 
			r.collapse(true); 
			r.select(); 
			parent.__range = document.selection.createRange();
		}
		document.body.innerHTML = "";
	}
</script>
</head>
<body contentEditable="true" onload="initIframe()"></body>
</html>


