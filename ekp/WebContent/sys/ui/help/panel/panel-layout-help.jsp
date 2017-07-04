<%@page import="net.sf.json.JSONArray"%>
<%@page import="java.util.*"%>
<%@page import="com.landray.kmss.sys.ui.plugin.SysUiPluginUtil"%>
<%@page import="com.landray.kmss.sys.ui.xml.model.*"%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include file="/sys/ui/help/layout-help.jsp">
	<template:replace name="vars">
		<template:super/>
		<div style="background-color: #F0F0F0; padding:5px; text-align:center;">参数</div>
		<table width="100%" id="layout_param">
			<tr><td width="30%"></td><td width="70%"></td></tr>
			<tr>
				<td>
					折叠
				</td>
				<td>
					<label><input name="toggle" type="checkbox" checked>&nbsp;允许</label>
				</td>
			</tr>
			<tr>
				<td>
					默认展开
				</td>
				<td>
					<label><input name="expand" type="checkbox" checked>&nbsp;是</label>
				</td>
			</tr>
			<tr>
				<td>
					滚动条
				</td>
				<td>
					<label><input name="scroll" type="checkbox" >&nbsp;允许</label>
				</td>
			</tr>
		</table>
	</template:replace>
	<template:replace name="example">
		<ui:panel width="100%" height="100%" id="test-view" layout="${param.fdId}">
			<ui:content title="单标签">
				<ui:dataview format="sys.ui.classic">
					<ui:source type="AjaxJson">
						{"url":"/sys/ui/extend/dataview/format/classic-example.jsp"}
					</ui:source>
				</ui:dataview>
				<ui:operation href="#" name="新建" icon="lui_icon_s_add" target="_blank" />
				<ui:operation href="#" name="更多" target="_blank"/>
			</ui:content>
		</ui:panel>
		<script>
		seajs.use(['lui/topic', 'lui/base'], function(topic, base) {
			topic.subscribe("view-reload", function(){
				var panel = base.byId("test-view");
				var fdResizeHeight = $('#fdResizeHeight');
				if(fdResizeHeight.val()==''){
					panel.config.height = null;
				}else{
					panel.config.height = $('#test-view-frame').height();
				}
				panel.layout.vars = getConfigValues();
				$('#layout_param input').each(function(){
					for(var i=0;i<panel.contents.length;i++){
						panel.config[this.name] = this.checked;
					} 
				});
				panel.erase(false);
				panel.draw();
			});
		});
		</script>		 
	</template:replace>
</template:include> 
