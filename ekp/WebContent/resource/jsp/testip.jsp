<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="java.util.Enumeration"%>
<%
Enumeration e = request.getHeaderNames(); 
while (e.hasMoreElements()) { 
	String name = (String)e.nextElement(); 
	String value = request.getHeader(name); 
%>
<%=name%>=<%= value%><br>
<%}%>


