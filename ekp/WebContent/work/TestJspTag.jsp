<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
    <%@ taglib uri="/mytaglib" prefix="u"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Insert title here</title>
</head>
<body>
	<%pageContext.setAttribute("name", "userName");
	  pageContext.setAttribute("value", "liwenchang");%>
	<u:user name="${pageScope.name }" value="${pageScope.value }"/>
</body>
</html>