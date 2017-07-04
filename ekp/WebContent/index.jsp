<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<% 
	//request.getRequestDispatcher("/sys/portal/page.jsp").forward(request,response);
%>
<script>
	location.href = '<%=request.getContextPath()%>/sys/portal/page.jsp';
</script>