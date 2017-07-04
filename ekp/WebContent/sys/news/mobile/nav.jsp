<%@ page language="java" contentType="text/plain; charset=UTF-8"
	pageEncoding="UTF-8"%>
	<%@ include file="/sys/ui/jsp/common.jsp"%>
[
	{ 
		url : "/sys/news/sys_news_main/sysNewsMainIndex.do?method=listChildren&categoryId=&q.docStatus=30&orderby=fdIsTop%3BfdTopTime%3BdocAlterTime&ordertype=down", 
		text : "${lfn:message('sys-news:sysNewsMain.portlet.new')}", 
		selected : true 
	}
]
