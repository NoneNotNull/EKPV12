<%@ page language="java" contentType="text/plain; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>

[ 	
	{ 
		moveTo : "dateView", 
		text : '<span class="icon"><i class="mui mui-meeting_date"></i></span><span class="txt">时间</span>',
		selected : true 
	},
	{ 
		moveTo : 'notifyView', 
		text : '<span class="icon"><i class="mui mui-address"></i></span><span class="txt">提醒</span>'
	},
	{   
		moveTo : "labelView", 
		text : '<span class="icon"><i class="mui mui-syn"></i></span><span class="txt">标签</span>'
	}
]
