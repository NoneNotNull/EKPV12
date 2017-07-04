<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<!doctype html>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="/sys/ui/jsp/jshead.jsp"%>
<script type="text/javascript">
seajs.use(['theme!form']);
</script>
<template:block name="head">
<style>
.button_resize{
	padding:0px 4px 0px 4px; border: 1px solid #999999; cursor:pointer; background-color:#F0F0F0; height:20px; line-height:15px;
}
.input_resize{
	color: #0066FF; border: 1px solid #999999; width:50px; height:18px;
}
</style>
<script type="text/javascript">
	seajs.use(['lui/jquery'], function($) {
		window.$ = $;
	});
	function resizeViewFrameWidth(dt){
		var field = $("#fdResizeWidth");
		var frame = $("#test-view-frame");
		var value = field.val();
		if(value=="" && dt==0){
			frame.width("auto");
			return;
		}
		value = value==""?frame.outerWidth():parseInt(value);
		value += dt*50;
		frame.width(value);
		field.val(value);
	}
	function resizeViewFrame(){
		$("#fdResizeWidth").val("");
		$("#fdResizeHeight").val("");
		resizeViewFrameWidth(0);
		resizeViewFrameHeight(0);
	}
	function resizeViewFrameHeight(dt){
		var field = $("#fdResizeHeight");
		var frame = $("#test-view-frame");
		var value = field.val();
		if(value=="" && dt==0){
			frame.height("auto");
			return;
		}
		value = value==""?frame.outerHeight():parseInt(value);
		value += dt*50;
		frame.height(value);
		field.val(value);
	}
	function reloadViewFrame(){
		resizeViewFrameWidth(0);
		resizeViewFrameHeight(0);
		seajs.use(['lui/topic'], function(topic){
			topic.publish('view-reload');
		});
	}
</script>
</template:block>
</head>
<body>
<template:block name="top" />
<table align="center" width="1000px" class="tb_normal">
	<tr class="tr_normal_title"><td colspan="2">基本信息</td></tr>
	<tr>
		<td colspan="2"><template:block name="description" /></td>
	</tr>
	<tr class="tr_normal_title">
		<td width="400px">参数配置</td>
		<td width="600px">效果预览</td>
	</tr>
	<tr>
		<td style="vertical-align: top;">
			<div class="tb_noborder" style="width:400px;">
				<div style="background-color: #F0F0F0; padding:5px; text-align:center;" onclick="varDebug();">容器</div>
				<div style="padding:5px;">
					宽
					<button class="button_resize" onclick="resizeViewFrameWidth(-1);">－</button>
					<input class="input_resize" id="fdResizeWidth">
					<button class="button_resize" onclick="resizeViewFrameWidth(1);">＋</button>&nbsp;&nbsp;
					高
					<button class="button_resize" onclick="resizeViewFrameHeight(-1);">－</button>
					<input class="input_resize" id="fdResizeHeight">
					<button class="button_resize" onclick="resizeViewFrameHeight(1);">＋</button>&nbsp;&nbsp;
					<button class="button_resize" onclick="resizeViewFrame();">×</button>&nbsp;&nbsp;
					<button class="button_resize" onclick="reloadViewFrame();">刷新</button>
				</div>
				<template:block name="vars">
					<c:import url="/sys/ui/help/varkind/config.jsp">
						<c:param name="vars" value="${viewVars}"></c:param>
					</c:import>
				</template:block>
			</div>
		</td>
		<td style="vertical-align: top; background-color: #F3F3F3;">
			<div class="tb_noborder" style="border: 1px yellow dashed;" id="test-view-frame">
				<template:block name="example" />
			</div>
		</td>
	</tr>
	<tr class="tr_normal_title">
		<td colspan="2">详细说明</td>
	</tr>
	<tr>
		<td colspan="2"><template:block name="detail">无</template:block></td>
	</tr>
</table>
<br>
</body>
</html>
