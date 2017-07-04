<%@ page language="java" contentType="text/plain; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="com.landray.kmss.util.StringUtil"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<c:set var="cri_info" scope="page">
	<template:block name="content" />
</c:set>
<%	
	String json = (String)pageContext.getAttribute("cri_info");
	String jsonpcallback = request.getParameter("jsonpcallback");
	if(StringUtil.isNotNull(jsonpcallback)){
		out.print(jsonpcallback+"("+json.toString()+")");
	}else{
		out.print(json.toString());
	}
%>