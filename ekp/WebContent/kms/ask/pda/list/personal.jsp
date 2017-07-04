<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include file="/kms/common/pda/template/personal.jsp">
	<template:replace name="myfilter">
		<ul>
			<li onclick="myfilter('myknow','myask')">我的提问<span></span></li>
			<li onclick="myfilter('myknow','myanswer')">我的回答<span></span></li>
			<li onclick="myfilter()">所有问答<span></span></li>
			<li onclick="myfilter('intro','introduce')">推荐问答<span></span></li>
		</ul>
	</template:replace>
</template:include>