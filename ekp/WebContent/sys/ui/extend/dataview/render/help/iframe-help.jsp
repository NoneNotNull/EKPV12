<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp" %>
<template:include file="/sys/ui/help/dataview/render-help.jsp">
	<template:replace name="example">
		<ui:dataview id="test-view" format="${ render.fdFormat }">
			<ui:source type="AjaxJson">
			{"url":"/sys/ui/extend/dataview/format/iframe-example.jsp?LUIElementId=!{lui.element.id}"}
			</ui:source>
			<ui:render ref="sys.ui.iframe.default"/>
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