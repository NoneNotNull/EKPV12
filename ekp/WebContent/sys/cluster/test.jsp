<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">


<%@page import="com.landray.kmss.sys.cluster.Test"%><html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
	<%
		String step = request.getParameter("step");
		if("1".equals(step)){
			Test.startNamesServer();
		}else if("2".equals(step)){
			Test.consumerMessage();
		}else{
			Test.sendMessage();
		}
	%>
	OK!
</body>
</html>