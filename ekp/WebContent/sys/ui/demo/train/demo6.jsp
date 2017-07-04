<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.simple">
	<template:replace name="body">
	
		<div style="margin:30px;">
			<ui:tabpage expand="true" >
				<ui:content title="流程" expand="false">
				a...
				</ui:content>
				<ui:content title="阅读" toggle="false">
				b...
				</ui:content>
			</ui:tabpage>		
		</div>
		
	</template:replace>
</template:include>