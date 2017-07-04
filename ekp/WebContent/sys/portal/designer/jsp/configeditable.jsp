<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%
request.setAttribute("sys.ui.theme", "default");
%>
<template:include ref="default.simple">
	<template:replace name="title">配置容器</template:replace>
	<template:replace name="body">
	<ui:toolbar layout="sys.ui.toolbar.float" count="10" var-navwidth="100%">
		<ui:button onclick="onEnter()" text="确定"></ui:button>
	</ui:toolbar>
	<script>
		seajs.use(['theme!form']);
		</script>
<script>
	function onReady(){
		if(window.$dialog == null){
			window.setTimeout(onReady, 100);
			return
		}
		window.$ = LUI.$;
		var dp = window.$dialog.dialogParameter;
		$("#vSpacing").val($.trim(dp.vSpacing));
	}

	LUI.ready(onReady);
	function onEnter(){
		var data = {};
		data.vSpacing = $("#vSpacing").val();
		window.$dialog.hide(data);
	}

	function DigitInput(el,e) {
	    //8：退格键、46：delete、37-40： 方向键
	    //48-57：小键盘区的数字、96-105：主键盘区的数字
	    //110、190：小键盘区和主键盘区的小数
	    //189、109：小键盘区和主键盘区的负号
	    var e = e || window.event; //IE、FF下获取事件对象
	    var cod = e.charCode||e.keyCode; //IE、FF下获取键盘码
	    //小数点处理
	    //if (cod == 110 || cod == 190){
	    //    (el.value.indexOf(".")>=0 || !el.value.length) && notValue(e);
	   // } else {
	        if(cod!=8 && cod != 46 && (cod<37 || cod>40) && (cod<48 || cod>57) && (cod<96 || cod>105)) notValue(e);
	    //}
	    function notValue(e){
	        e.preventDefault ? e.preventDefault() : e.returnValue=false;
	    }
	}
</script>
<br>
<br>
<table class="tb_normal" style="width: 300px;">
	<tbody>
		<tr>
			<td>上下间距：</td>
			<td><input type="text" id="vSpacing" name="vSpacing" value="15" style="width:50px;" onkeydown="DigitInput(this,event);" />px</td>
		</tr>
	</tbody>
</table> 

	</template:replace>
</template:include>