<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.simple">
	<template:replace name="body">
	
	Toolbar 样例 Demo <br>
		<ui:toolbar count="9">
			<ui:button text="button1"></ui:button>
			<ui:button text="button2"></ui:button>
			<ui:toggle text="toggle1" group="t1"></ui:toggle>
			<ui:toggle text="toggle2" group="t1"></ui:toggle>
			<ui:button text="button3"></ui:button>
			<ui:button text="button4"></ui:button>
			<ui:toggle text="toggle3" group="t2"></ui:toggle>
			<ui:toggle text="toggle4" group="t2"></ui:toggle>
		</ui:toolbar>
		
	</template:replace>
</template:include>