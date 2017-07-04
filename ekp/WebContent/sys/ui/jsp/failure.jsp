<%@page import="com.landray.kmss.util.KmssReturnPage"%>
<%@page import="com.landray.kmss.util.KmssMessageWriter"%>
<%@page import="java.net.URLEncoder"%>
<%@ page language="java" pageEncoding="UTF-8" contentType="application/json; charset=UTF-8"%>
<%
response.setHeader("Cache-Control", "no-cache");
response.setHeader("Pragma", "no-cache");
response.setDateHeader("Expires", -1);
response.setStatus(500);
response.setHeader("error",URLEncoder.encode("请求数据时出错", "UTF-8"));

KmssReturnPage rtnPage = (KmssReturnPage)request.getAttribute("KMSS_RETURNPAGE");
if(rtnPage!=null){
	KmssMessageWriter msgWriter = new KmssMessageWriter(request, rtnPage);
	msgWriter.DrawMessages();
}

Object json = request.getAttribute("lui-source");
if(json != null){
	out.print(json.toString());
}
%>