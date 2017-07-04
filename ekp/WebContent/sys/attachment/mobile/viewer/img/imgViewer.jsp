<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="mobile.view" scale="true">
	<template:replace name="title">
	</template:replace>
	<template:replace name="content">
		<link rel="stylesheet" type="text/css"
			href="<%=request.getContextPath()%>/sys/attachment/mobile/viewer/base/css/attViewer.css"></link>
		<div data-dojo-type="sys/attachment/mobile/viewer/img/ImgViewer"
			data-dojo-props="fdId:'${param.fdId }'"></div>
	</template:replace>
</template:include>
