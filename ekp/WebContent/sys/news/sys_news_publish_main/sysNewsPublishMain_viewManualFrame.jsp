<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title><bean:message key="sysNewsPublishMain.fdTitle" bundle="sys-news"/></title>
	</head>
	
	<frameset framespacing=1 bordercolor=#003048 frameborder=1 rows="*">
		<frame frameborder="0" noresize scrolling="yes" id="topFrame"
			src="<c:url value="/sys/news/sys_news_main/sysNewsMain.do?method=editManualPublish&fdModelNameParam=${param.fdModelNameParam}&fdModelIdParam=${param.fdModelIdParam}&fdKeyParam=${param.fdKeyParam}"/>"
	</frameset>
</html>
