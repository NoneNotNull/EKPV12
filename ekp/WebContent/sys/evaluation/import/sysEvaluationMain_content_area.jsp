<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html>
<head>
<style type="text/css">
body {
	color: #1b83d8;
	font-size: 12px;
	margin: 0px;
	min-height: 70px;
	font-family: Microsoft YaHei, Geneva, 'sans-serif', SimSun;
}
body img{
	margin:0px 2px;
}
*{ 
	padding:0; 
	margin:0; 
}
</style>
<script type="text/javascript">
	
	document.onmouseup = saveRange;
	document.onkeyup = saveRange;

	var mSIE = navigator.userAgent.indexOf("MSIE") > 0;//IE浏览器
	var iframeType = '${param.iframeType}';
	//保存光标域，用于表情插入
	function saveRange() {
		if (mSIE) {
			if("dialogReply" == iframeType){
				parent.parent.__range__ = document.selection.createRange();
			}else{
				parent.__range__ = document.selection.createRange();
			}
		}
	}

	function initIframe(){
		if("eval" == iframeType){
			var opt = parent.eval_opt;
			if(opt!=null){
				opt.initEvalContentBox();
			}
		}else{
			var target = parent;
			var isParentCursor = true;
			var contentBody = parent.$("iframe[id='${param.iframeId}']").contents().find("body");
			if("reply" == iframeType){
				//点评回复字数控制
				target = parent.eval_opt;
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
			target.checkWordsNum(contentBody,iframeType,"${param.iframeId}");
			//绑定文本框事件
			contentBody.bind({
				"keyup":function(e){
							var keyCode = e.keyCode;
							if(keyCode == 8){
								target.delImgForIE(this);
							}
							
							target.checkWordsNum(this,iframeType,"${param.iframeId}");
						},
				"focus mouseup":function(){
							target.checkWordsNum(this,iframeType,"${param.iframeId}");
							//解决IE8下光标在表情图标后，光标自动跳到最前的问题
							target.adjustCursor(this);
						},
				// 兼容右键粘贴字数限制
				"input":function(){
							target.checkEvalContent(this);
							target.checkWordsNum(this,iframeType,"${param.iframeId}");
						},
				// 兼容IE右键粘贴字数限制
				"paste cut":function(){
							var _this = this;
							setTimeout(function(){
								target.checkEvalContent(_this);
								target.filterOuterImg(_this);
								target.checkWordsNum(_this,iframeType,"${param.iframeId}");
							},200);
						}
			});	
		}
	}

</script>
</head>
<body contentEditable="true" onload="initIframe();"></body>
</html>


