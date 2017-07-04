<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.simple">
	<template:replace name="body">
		部件样例
		<br><br>
		<ui:tabpanel style="width:90%;margin-left:15px;">
			<ui:layout ref="sys.ui.tabpanel.light"></ui:layout>
			<ui:content title="面板1">
				面板1 的内容。这里可以是任意的JSP代码
			</ui:content>
			<ui:content title="面板2">
				<ui:dataview format="sys.ui.classic">
					<ui:source ref="sys.ui.demo.source"></ui:source>
					<ui:render ref="sys.ui.classic.default"></ui:render>
				</ui:dataview>
				<ui:operation href="#" name="更多"></ui:operation>
			</ui:content>
		</ui:tabpanel>
		
	</template:replace>
</template:include>