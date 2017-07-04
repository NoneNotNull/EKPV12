<%@ page language="java" contentType="text/plain; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="zone.criInfo">
	<template:replace name="content">
		[
			{
				"url":"/kms/knowledge/kms_knowledge_base_doc/kmsKnowledgeBaseDocIndex.do?method=listPerson&orderby=docPublishTime&ordertype=down&rowsize=8&userId=!{userId}&personType=other&q.mydoc=myOriginal",
				"text":"原创的",
				"isDefault":true
			},
			{
				"url":"/kms/knowledge/kms_knowledge_base_doc/kmsKnowledgeBaseDocIndex.do?method=listPerson&orderby=docPublishTime&ordertype=down&rowsize=8&userId=!{userId}&personType=other&q.mydoc=myCreate",
				"text":"上传的"
				
			},
			{
				"url":"/kms/knowledge/kms_knowledge_base_doc/kmsKnowledgeBaseDocIndex.do?method=listPerson&orderby=docPublishTime&ordertype=down&rowsize=8&userId=!{userId}&personType=other&q.mydoc=myEva",
				"text":"点评的"
		
			},
			{
				"url":"/kms/knowledge/kms_knowledge_base_doc/kmsKnowledgeBaseDocIndex.do?method=listPerson&orderby=docPublishTime&ordertype=down&rowsize=8&userId=!{userId}&personType=other&q.mydoc=myIntro",
				"text":"推荐的"
			}
		]
	</template:replace>
</template:include>