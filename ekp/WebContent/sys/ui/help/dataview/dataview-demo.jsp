<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<ui:dataview format="${param.format}">
	<ui:source type="AjaxJson">
		{"url":"/sys/ui/resources/example.jsp?code=${param.format}"}
	</ui:source>
	<template:block name="render">
		<c:if test="${not empty param.render}">
			<ui:render ref="${param.render}" />
		</c:if>
	</template:block>
</ui:dataview>