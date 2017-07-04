
<%@page import="com.landray.kmss.util.StringUtil"%>
<%@page import="com.landray.kmss.third.pda.model.PdaVersionConfig"%>
<%@ include file="/resource/jsp/common.jsp"%>
<%@ page language="java" contentType="text/plain; charset=UTF-8"
	pageEncoding="UTF-8"%>
	<%
	String version=(new PdaVersionConfig()).getMenuVersion();
	if(StringUtil.isNull(version))
		version="";
	%>
	{
	"version":"<%=version%>"
	}