<%@ page language="java" contentType="text/plain; charset=UTF-8"
	pageEncoding="UTF-8"%>
	<%@ include file="/sys/ui/jsp/common.jsp"%>
[

	{ 
		url : "/km/forum/km_forum/kmForumTopicIndex.do?method=listChildren&orderby=fdLastPostTime&ordertype=down", 
		text : "${lfn:message('km-forum:kmForum.portlet.topic.latest')}", 
		selected : true 
	},
	{
		url : "/km/forum/km_forum/kmForumTopicIndex.do?method=listChildren&q.fdOther=hot&orderby=fdLastPostTime&ordertype=down", 
		text : "${lfn:message('km-forum:kmForumTopic.otherSearch.hot')}"
	},
	{
		url : "/km/forum/km_forum/kmForumTopicIndex.do?method=listChildren&q.myTopic=create&orderby=fdLastPostTime&ordertype=down", 
		text : "${lfn:message('km-forum:menu.kmForum.Create.my')}"
	}
]
