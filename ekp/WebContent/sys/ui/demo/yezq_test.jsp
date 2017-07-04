<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.simple">
	<template:replace name="body">
		<table style="margin:50px auto;">
			<tr><td style="width:400px;border:1px red solid;">
		<ui:tabpanel height="300" scroll="true">
			<ui:content title="标签1">
				<ui:dataview>
					<ui:source type="AjaxJson">
					{"url":"/sys/ui/resources/example.jsp?code=sys.ui.slide"}
					</ui:source>
					<ui:render ref="sys.ui.slide.default"/>
				</ui:dataview>
			</ui:content>
			<ui:content title="标签2">
				<ui:dataview>
					<ui:source type="AjaxJson">
					{"url":"/sys/ui/resources/example.jsp?code=sys.ui.slide"}
					</ui:source>
					<ui:render ref="sys.ui.slide.default"/>
				</ui:dataview>
				<ui:operation href="a" name="更多"></ui:operation>
			</ui:content>
			<ui:content title="标签3">
				<div style="height:300px; background-color: yellow;">
					滚动
				</div>
				<ui:operation href="a" name="更多"></ui:operation>
			</ui:content>
		</ui:tabpanel>
			</td><td style="width:400px;border:1px red solid;">
		<ui:tabpanel height="300" scroll="false">
			<ui:content title="标签1">
				<ui:dataview>
					<ui:source type="AjaxJson">
					{"url":"/sys/ui/resources/example.jsp?code=sys.ui.slide"}
					</ui:source>
					<ui:render ref="sys.ui.slide.default"/>
				</ui:dataview>
			</ui:content>
			<ui:content title="标签2">
				<ui:dataview>
					<ui:source type="AjaxJson">
					{"url":"/sys/ui/resources/example.jsp?code=sys.ui.slide"}
					</ui:source>
					<ui:render ref="sys.ui.slide.default"/>
				</ui:dataview>
				<ui:operation href="a" name="更多"></ui:operation>
			</ui:content>
			<ui:content title="标签3">
				<div style="height:300px; background-color: yellow;">
					滚动
				</div>
				<ui:operation href="a" name="更多"></ui:operation>
			</ui:content>
		</ui:tabpanel>
			</td></tr>
		</table>
	</template:replace>
</template:include>
 
