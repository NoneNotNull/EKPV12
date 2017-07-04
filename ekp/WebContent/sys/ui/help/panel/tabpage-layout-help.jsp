<%@page import="net.sf.json.JSONArray"%>
<%@page import="java.util.*"%>
<%@page import="com.landray.kmss.sys.ui.plugin.SysUiPluginUtil"%>
<%@page import="com.landray.kmss.sys.ui.xml.model.*"%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:extend file="/sys/ui/help/layout-help.jsp">
	<template:override name="vars">
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
				<td></td>
				<td>
				<div id="temp-content" style="border: 2px solid blue;">abc</div>
				
				<input  type="button" value="添加上面的蓝边框DIV" onclick="addContent(this)"/>
					<script type="text/javascript">
					function addContent(obj){
						obj.style.display = "none";
						seajs.use(['lui/base'], function(base) {
							var config = {
								element:"#temp-content",
								title:"aa"
							};
							base.byId("test-view").addContent(config);
						});
					}				
					</script>				
				</td>
			</tr>
		</table>
	</template:override>
	<template:override name="example">
		 <ui:accordionpanel layout="${param.fdId}" id="test-view"> 
			<ui:content title="垂直多标签1">
				<ui:dataview format="sys.ui.classic">
					<ui:source type="AjaxJson">
						{"url":"/sys/ui/extend/dataview/format/classic-example.jsp"}
					</ui:source>
				</ui:dataview>
				<ui:operation href="#" name="新建" target="_blank" />
				<ui:operation href="#" name="更多" target="_blank"/>
			</ui:content>
			<ui:content title="垂直多标签2">
				垂直多标签2的内容
				<ui:operation href="#" name="新建" icon="lui_icon_s_add" target="_blank" />
				<ui:operation href="#" name="更多" target="_blank"/>
			</ui:content>
			<ui:content title="本标签不能折叠" toggle="false">
				垂直多标签3的内容
			</ui:content>
		</ui:accordionpanel>
		<script>
		seajs.use(['lui/topic', 'lui/base'], function(topic, base) {
			topic.subscribe("view-reload", function(){
				var panel = base.byId("test-view");
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
	</template:override>
</template:extend> 
