<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.simple">
	<template:replace name="body">
		
		
		
		<ui:dataview id="ss" format="sys.ui.classic">
			<ui:source  ref="sys.ui.demo.source"></ui:source>
			<ui:render ref="sys.ui.classic.default"></ui:render>
		</ui:dataview>
		
		<script>
		LUI.ready(function(){
			//debugger;
			var sy = LUI("ss");
			
		});
		</script>
		
	</template:replace>
</template:include>