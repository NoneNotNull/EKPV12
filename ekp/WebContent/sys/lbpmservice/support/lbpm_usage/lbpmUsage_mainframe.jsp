<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<!doctype html>
<html>
	<head>
		<meta http-equiv="x-ua-compatible" content="IE=5"/>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title><bean:message key="lbpmUsage.definate.windowTitle" bundle="sys-lbpmservice-support"/></title>
	</head>
	<frameset framespacing=1 bordercolor=#003048 frameborder=1 rows="*">
		<frame frameborder="0" noresize scrolling="yes" id="topFrame"
			src="<c:url value="/sys/lbpmservice/support/lbpm_usage/lbpmUsage.do" />?method=define">
	</frameset>
</html>
