<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.simple">
	<template:replace name="body"> 
		 <ui:dataview format="sys.ui.classic">
			<ui:source ref="sys.ui.ajaxxml2.source">
			</ui:source>
			<ui:render ref="sys.ui.classic.template"></ui:render>
		</ui:dataview>
	</template:replace>
</template:include>
 
