<%@ page language="java" contentType="text/plain; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>

[ 
	{ 
		moveTo : "contentView", 
		text : "任务详情", 
		selected : true 
	},
	{ 
		moveTo : "childTaskView", 
		text : "子任务"
	}
	,
	{   
		moveTo : "feedbackView", 
		text : "反馈评价"
	},
	{
		moveTo:"picView",
		text:"分解图"
	}
]
