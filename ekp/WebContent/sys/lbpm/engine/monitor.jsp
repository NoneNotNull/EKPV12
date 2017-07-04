<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ page errorPage="/resource/jsp/jsperror.jsp" %>
<%@ page import="
	com.landray.kmss.sys.lbpm.engine.support.execute.queue.*
"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>队列测试监控</title>
</head>
<body>
<%
String method = request.getParameter("method");

if ("throughput".equals(method)) {

	MonitorLogger monitor = MonitorLogger.INSTANCE;
	if (monitor != null) {
		int delay = Integer.parseInt(request.getParameter("delay"));
		int maxsize = Integer.parseInt(request.getParameter("maxsize"));
		int step = Integer.parseInt(request.getParameter("step"));
		monitor.calculateThroughput(delay, maxsize, step);
		%>
		<h2>开始进行监控。。。。。</h2>
		<%
	} else {
%>
<h2>无法进行监控，监控器没有初始化！</h2>
<%
	}
} else {
%>
<center>
<br>
<br>
<table>
<form action="" method="GET">
	<input type="hidden" name="method" value="throughput" >
	<tr>
	<td>
	执行时间<input type="text" name="delay" value="10">秒
	</td>
	</tr>
	<tr>
	<td>
	最大线程数<input type="text" name="maxsize" value="100">
	</td>
	</tr>
	<tr>
	<td>
	每次增加线程数<input type="text" name="step" value="20">
	</td>
	</tr>
	<tr>
	<td>
	<input type="submit" value="提交">
	</td>
	</tr>
</form>
</table>
</center>
<%
}
%>
</body>
</html>