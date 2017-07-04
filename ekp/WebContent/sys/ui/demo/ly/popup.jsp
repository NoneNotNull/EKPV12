<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.simple">
	<template:replace name="body">
	
	Popup 样例 Demo <br><br><br>
	
	<div style="width:100px;margin-left: 200px;">
		 aaa
		<ui:popup>
			<div style="width: 150px; height: 150px;background-color: white;">aaa popup</div>
		</ui:popup>
	</div>
	<br><br><br>
	<div id="xx" style="width:100px;margin-left: 200px;">bbb</div>
	<ui:popup positionObject="#xx">
		<div style="width: 150px; height: 150px;background-color: white;">bbb popup</div>
	</ui:popup>
	</template:replace>
</template:include>