<%@ page language="java" contentType="javascript/x-javascript; charset=UTF-8" pageEncoding="UTF-8" %>
<%
response.setHeader("Cache-Control", "no-cache");
response.setHeader("Pragma", "no-cache");
response.setDateHeader("Expires", -1);
%>
function getSessionId(){
	return "<%= request.getSession().getId() %>";
}