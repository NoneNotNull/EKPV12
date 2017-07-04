<%@page import="net.sf.json.JSONArray"%>
<%@page import="java.util.*"%>
<%@page import="com.landray.kmss.sys.ui.plugin.SysUiPluginUtil"%>
<%@page import="com.landray.kmss.sys.ui.xml.model.*"%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%
	String renderId = request.getParameter("fdId");
	SysUiRender render = SysUiPluginUtil.getRenderById(renderId);
	request.setAttribute("render", render);
	request.setAttribute("viewVars", JSONArray.fromObject(render.getFdVars()).toString());
%>
<template:include file="/sys/ui/help/view-help.jsp">
	<template:replace name="top">
		<div style="margin:10px 0px 0px 30px;">
			当前路径：部件类型 >>
			<a href="${LUI_ContextPath}/sys/ui/help/dataview/index.jsp?fdId=dataview" target="_self">数据视图</a> >>
			<a href="${LUI_ContextPath}/sys/ui/help/dataview/format.jsp?fdId=${ render.fdFormat }" target="_self">${ param.formatName }</a> >>
			${ render.fdName }
		</div>
		<br><p class="txttitle">${ render.fdName }（${ render.fdId }）</p><br>
	</template:replace>
	<template:replace name="description">
		<table width="100%" class="tb_normal">
			<tr>
				<td width="15%" class="td_normal_title">数据格式</td>
				<td width="35%">${ render.fdFormat }</td>
				<td width="15%" class="td_normal_title">类型</td>
				<td width="35%">${ render.fdType }</td>
			</tr>
			<tr>
				<td class="td_normal_title">样式文件</td>
				<td>${ render.fdCss }</td>
				<td class="td_normal_title">缩略图</td>
				<td>${ render.fdThumb }</td>
			</tr>
		</table>
	</template:replace>
	<template:replace name="vars">
		<template:super/>
		<div style="background-color: #F0F0F0; padding:0px; text-align:center;">
			<button onclick="addOrRemovePanelFrame();">添加/移除外框</button>
		</div>
		
		<div style="display:none" id="panel-frame-holder">
			<ui:panel id="panel-frame" width="100%" height="100%" scroll="false" toggle="true" expand="true">
				<ui:content title="外框" id="content-frame">
				</ui:content>
			</ui:panel>
		</div>
		<script>
			var panelFrameAdded = false;
			function addOrRemovePanelFrame(){
				var panel = $('#panel-frame');
				var content = $('#content-frame');
				var testView = $('#test-view-frame');
				
				if(panelFrameAdded){
					content.children().appendTo(testView);
					panel.appendTo($('#panel-frame-holder'));
				}else{
					testView.children().appendTo(content);
					panel.appendTo(testView);
				}
				panelFrameAdded = !panelFrameAdded;
			}
		</script>
	</template:replace>
	<template:replace name="example">
		<ui:dataview id="test-view" format="${ render.fdFormat }">
			<ui:source type="AjaxJson">
			{"url":"/sys/ui/resources/example.jsp?code=${ render.fdFormat }"}
			</ui:source>
			<ui:render ref="${ render.fdId }"/>
		</ui:dataview>
		<script>
		seajs.use(['lui/topic', 'lui/base'], function(topic, base) {
			topic.subscribe("view-reload", function(){
				var dv = base.byId("test-view");
				dv.render.vars = getConfigValues();
				dv.erase();
				dv.draw();
			});
		});
		</script>
	</template:replace>
</template:include> 
