<%@ page language="java" contentType="text/plain; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>

[ 
	{
		url : '/km/imeeting/km_imeeting_main/kmImeetingMain.do?method=listChildren&orderby=docCreateTime&ordertype=down',
		text: '会议安排'
	},
	{
		url : '/km/imeeting/km_imeeting_summary/kmImeetingSummary.do?method=listChildren&orderby=docCreateTime&ordertype=down',
		text: '会议纪要'
	}
]