<%@ page language="java" contentType="text/plain; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="zone.criInfo">
	<template:replace name="content">
		[
			{
				"url":"/kms/ask/kms_ask_index/kmsAskTopicIndex.do?method=index&fdOrgId=!{userId}&q.myknow=myask",
				"text":"提问",
				"isDefault":true
			},
			{
				"url":"/kms/ask/kms_ask_index/kmsAskTopicIndex.do?method=index&fdOrgId=!{userId}&q.myknow=myanswer",
				"text":"回答"
			}
		]
	</template:replace>
</template:include>