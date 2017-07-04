<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp" %>
<template:include file="/sys/ui/help/dataview/render-help.jsp">

	<template:replace name="detail">
	<textarea style="width:100%;height:300px;">
幻灯片展示说明：
	使用要求：slide的使用，要求外层html元素要有宽度和高度，根据这两个信息，形成百分百高宽度的自适应；
 
数据展示HTML说明:

	<div class="lui_dataview_slide_content">
		<div class="lui_dataview_slide_imgDiv">
			<a href="href" target="_blank">
				<img src="image" alt="" width="100%" height="100%">
			</a>
			<h3>text</h3>
		</div>
		<div class="lui_dataview_slide_bg"></div>
		<ul>
			<li class="lui_dataview_slide_on"></li>
			...
		</ul>
	</div>
</textarea>
	</template:replace>
</template:include>