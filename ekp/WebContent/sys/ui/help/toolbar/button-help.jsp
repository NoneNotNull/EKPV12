<%@page import="com.landray.kmss.sys.ui.xml.model.*"%>
<%@page import="java.util.*"%>
<%@page import="com.landray.kmss.sys.ui.plugin.SysUiPluginUtil"%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include file="/sys/ui/help/assembly-help.jsp">
	<template:replace name="detail">
		<textarea style="width:100%;height:300px;">
			普通按钮使用说明
				1.按钮标签提供属性href(连接)、target(目标)、text(按钮名)、title(提示)、icon(图标)、onclick(点击事件)、style(样式)等设置。
			  		其中icon为css样式名，用于按钮中图标部分的样式。
			 
			展示的HTML结构为
			<div class="lui_widget_btn" style="样式" onclick="点击事件">
				<div class="图标样式">图标展示区域</div>
				<div>按钮名区域</div>
			</div>
		</textarea>
	</template:replace>
</template:include>