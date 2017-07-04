<%@ page language="java" contentType="text/plain; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="zone.criInfo">
	<template:replace name="content">
		[
			{
				"url":"/km/review/km_review_index/kmReviewIndex.do?method=list&q.tadoc=create&rowsize=8&orderby=docCreateTime&ordertype=down&userid=!{userId}",
				"text":"启动的",
				"isDefault":true
			},
			{
				"url":"/km/review/km_review_index/kmReviewIndex.do?method=list&q.tadoc=create&rowsize=8&q.docStatus=30&orderby=docCreateTime&ordertype=down&userid=!{userId}",
				"text":"已审的"
			}
		]
	</template:replace>
</template:include>