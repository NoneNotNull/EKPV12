<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%
request.setAttribute("sys.ui.theme", "default");
%>
<template:include ref="default.simple">
	<template:replace name="title">页面属性</template:replace>
	<template:replace name="body">
	<ui:toolbar layout="sys.ui.toolbar.float" count="10" var-navwidth="100%">
		<ui:button onclick="onEnter()" text="确定"></ui:button>
	</ui:toolbar>
	<script>
		seajs.use(['theme!form']);
		</script>
<script>
String.prototype.startsWith = function (substring) {
    var reg = new RegExp("^" + substring);
    return reg.test(this);
};
 
//
// 给字符串对象添加一个endsWith()方法
//
String.prototype.endsWith = function (substring) {
    var reg = new RegExp(substring + "$");
    return reg.test(this);
};
	function onReady(){
		if(window.$dialog == null){
			window.setTimeout(onReady, 100);
			return
		}
		window.$ = LUI.$;
		var dp = window.$dialog.dialogParameter;
		$("#pageWidth").val(dp.pageWidth);
	}

	LUI.ready(onReady);
	function onEnter(){
		var data = {};
		data.pageWidth = $("#pageWidth").val();
		
		if(!data.pageWidth.endsWith("%")&&!data.pageWidth.endsWith("px")){
			alert("页面宽度必须以px或%结尾");
			return;
		}
		
		if(data.pageWidth.endsWith("%")){
			if(parseInt(data.pageWidth)>=98){
				if(!confirm("页面宽度设置大于98%可能会出现横向滚动条，是否继续？")){
					return false;
				}
			}
		}
		
		window.$dialog.hide(data);
	}
 
</script>
<br>
<br>
<table class="tb_normal" style="width: 400px;">
	<tbody>
		<tr>
			<td width="60px;" valign="top">页面宽度：<br> <span class="com_help">&nbsp; </span></td>
			<td valign="top"><input type="text" id="pageWidth" name="pageWidth" value="" style="width:50px;"  />
			<br>
			<span class="com_help">
			样例："980px"（绝对宽度）或"95%"（相对宽度）</span>
			<br>
			<br>
			<span class="com_help">
			页面宽度不影响设计时的宽度，但影响最终展现的效果，最终展现效果将根据屏幕的实际宽度进行缩放，对于部分列不期望进行缩放的，请在容器属性中勾选“缩放锁定”
			</span>
			</td>
		</tr> 
	</tbody>
</table> 

	</template:replace>
</template:include>