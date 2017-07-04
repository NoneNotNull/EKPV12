<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<ui:ajaxtext>
<style>
.lui_tag_box a{ color:#333; font:normal 13px Microsoft YaHei,"宋体",Arial; line-height:30px; margin-right:10px;}
.lui_tag_box .H1{ font: Microsoft YaHei,"宋体",Arial;font-size: 100%}
.lui_tag_box .H2{ font: Microsoft YaHei,"宋体",Arial;font-size: 120%}
.lui_tag_box .H3{ font: Microsoft YaHei,"宋体",Arial;font-size: 140%}
.lui_tag_box .H4{ font: Microsoft YaHei,"宋体",Arial;font-size: 160%}
.lui_tag_box .H5{ font: Microsoft YaHei,"宋体",Arial;font-size: 180%}
.lui_tag_box .H6{ font: Microsoft YaHei,"宋体",Arial;font-size: 200%}
</style>
<ui:dataview>
	<ui:source type="AjaxJson">
		{url:'/sys/tag/sys_tag_portlet/sysTagPortlet.do?method=getHotTags&rowsize=${param.rowsize}'}
	</ui:source>
	<ui:render type="Template">
		{$
			
			<div class="lui_tag_box" style="word-wrap: break-word; word-break: normal;">
		$}
			for(var i = 0;i<data.length;i++){
				{$<a href="{%data[i].fdUrl%}" target="_blank" title="{%data[i].fdName%}" class="{% data[i].font %}" >{%data[i].fdName%}</a>$}
			}
		{$
			</div>
		
		$}
	</ui:render>
	<ui:event event="load">
	    var chars = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F'];
		LUI.$('.lui_tag_box a').each(function() {
			var c = (function(n) {
				var res = "";
				for(var i = 0; i < n; i++) {
					var id = Math.floor(Math.random() * 16);
					res += chars[id];
				}
				return res;
			})(6);
			LUI.$(this).css('color', '#' + c);
		});
	</ui:event>
</ui:dataview>
</ui:ajaxtext>