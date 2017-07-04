<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.simple">
	<template:replace name="body"> 
		<ui:panel>
			<ui:content title="自定义数据和展现1" style="width:650px; height:180px;">
				<ui:dataview>
					<ui:source type="AjaxJson">
						{"url":"/sys/ui/extend/dataview/format/picmenu-example.jsp"}
					</ui:source>
					<ui:render ref="sys.ui.picMenu.default">
					</ui:render>
				</ui:dataview>
			</ui:content>
		</ui:panel>
	</template:replace>
</template:include>
