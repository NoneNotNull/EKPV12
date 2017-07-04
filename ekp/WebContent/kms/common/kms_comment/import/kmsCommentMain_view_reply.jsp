<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<!doctype html>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<style type="text/css">
body {
	color: #1b83d8;
	font-size: 12px;
	margin: 0px;
	min-height: 60px;
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

	var mSIE = navigator.userAgent.indexOf("MSIE") > 0;//IE浏览器
	var iframeType = 'reply';
	//保存光标域，用于表情插入
	function saveRange() {
		if (mSIE) {
			if("dialogReply" == iframeType){
				parent.parent.__range__ = document.selection.createRange();
			}else{
				parent.__range__ = document.selection.createRange();
			}

			//解决IE8下，表情图标后无法聚焦问题
			if (navigator.userAgent.indexOf("MSIE 8.0")>0) {
				var iframeCtn = document.body.innerHTML;
				var endWidthGif = endWith(iframeCtn,'type="face">');
				if(endWidthGif){
					document.body.innerHTML = iframeCtn+" ";
					var r = document.body.createTextRange(); 
					r.collapse(false); 
					r.select(); 
				}
			}
		}
	}

	function _initIframe(){
		var ifrId = "${param.iframeId}";
		var target = parent;
		var isParentCursor = true;
		var contentBody = parent.$("#" + ifrId).contents().find("body");
		if("reply" == iframeType){
			//点评回复字数控制
			target = parent["comment_${param.fdModelId}"];
		}else if("dialogReply" == iframeType){
			//查看对话中回复框字数控制
			target = parent;
			isParentCursor = false;
		}
		
		if (mSIE) {
			var r = document.body.createTextRange(); 
			r.collapse(true); 
			r.select(); 
			
			if(isParentCursor){
				//回复框
				parent.__range__ = document.selection.createRange();
			}else{
				//查看对话框
				parent.parent.__range__ = document.selection.createRange();
			}
		}else{
			document.body.focus();
		}
		contentBody[0].innerHTML = "";

		var vt = "commentL_${param.fdModelId}";
		contentBody.bind({
			"keyup input focus" : function() {
				parent.window[vt].checkCommentContent(this);
				parent.window[vt].checkWordsNum(this, iframeType, "${param.iframeId}");
			},
			// 兼容IE右键粘贴字数限制
			"paste cut" : function() {
				var _this = this;
				setTimeout(function(){
					parent.window[vt].checkCommentContent(_this);
					parent.window[vt].filterOuterImg(_this);
					parent.window[vt].checkWordsNum(_this,iframeType, "${param.iframeId}");
				}, 2);
			}
		});	
	}

	function endWith(proStr,endStr){
		 var d = proStr.length - endStr.length;
		 return (d>=0 && proStr.lastIndexOf(endStr)==d);
	}
	
</script>
</head>
<body contentEditable="true" hideFocus="" onload="_initIframe();"></body>
</html>