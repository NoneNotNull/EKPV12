<%@ page language="java" contentType="text/plain; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>

[ 
	{ 
		moveTo : "contentView", 
		text : "会议内容", 
		selected : true 
	},
	{ 
		moveTo : "personView", 
		text : "会议人员"
	}
	<c:if test="${param.docStatus>='30' }">
	,
	{   
		moveTo : "feedbackListView", 
		text : "会议回执"
	}
	</c:if>
	
	<c:if test="${param.docStatus < '30' }">
	,
	{   
		moveTo : "processView", 
		text : "流程记录"
	}
	</c:if>
	
]
