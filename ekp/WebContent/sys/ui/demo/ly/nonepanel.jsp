<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.simple">
	<template:replace name="body">
		dddddddddddddddddddddddddddddddd
		<ui:nonepanel>
			<ui:content title="sss">
			
				aa
				<ui:tabpanel>
					<ui:content title="a">a</ui:content>
					<ui:content title="b">b</ui:content>
				</ui:tabpanel>
				bb
				
			</ui:content>
		</ui:nonepanel>
		dddddddddddddddddddddddd
	</template:replace>
</template:include>