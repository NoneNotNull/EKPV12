<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include file="/kms/common/pda/template/personal.jsp">
	<template:replace name="myfilter">
		<ul>
			<li onclick="myfilter('intro','true')">推荐专家<span></span></li>
			<li onclick="myfilter()">所有专家<span></span></li>
		</ul>
	</template:replace>
</template:include>