<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include file="/kms/common/pda/template/personal.jsp">
	<template:replace name="myfilter">
		<ul>
			<li onclick="myfilter('mydoc','create')">我上传的<span></span></li>
			<li onclick="myfilter('mydoc','approval')">待我审的<span></span></li>
			<li onclick="myfilter('mydoc','approved')">我已审的<span></span></li>
			<li onclick="myfilter('docIsIntroduced','1')">精华文档<span></span></li>
			<li onclick="myfilter()">所有知识<span></span></li>
		</ul>
	</template:replace>
</template:include>