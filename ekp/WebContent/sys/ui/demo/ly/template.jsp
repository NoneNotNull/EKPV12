<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%-- 
<template:include ref="default.list">
--%>
<template:include file="/sys/ui/demo/ly/temp.jsp">
	<template:replace name="title">
		测试标题	
	</template:replace>	
	<template:replace name="path">
		测试路径
	</template:replace>
	<template:replace name="nav">
		前面
		<template:super/>
		后面
	</template:replace>
	<template:replace name="content">
		测试右测
	</template:replace>
</template:include>