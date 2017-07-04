<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<%@page import="java.util.Enumeration"%>
<%@page import="java.net.URL"%>
<!doctype html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<body style="margin:20px;">
<form action="classtools.jsp" method="POST">
	类名：<input name="fdClassName" value="${param.fdClassName}" style="width:500px;">
	<input type="submit" value="检测">
</form>
<hr>
<div style="line-height:25px;">
<%
	String className = request.getParameter("fdClassName");
	if(className!=null && className.trim().length()>0){
		className = className.trim();
		out.write("<b>类 "+className+" 定义于：</b><br>");
		Enumeration<URL> en = Thread.currentThread().getContextClassLoader().getResources(className.replace('.','/')+".class");
		while(en.hasMoreElements()){
			out.write(en.nextElement()+"<br>");
		}
		out.write("<br><b>");
		try{
			Class<?> clz = Class.forName(className);
			out.write("本系统使用："+clz.getResource(clz.getSimpleName()+".class"));
		}catch(ClassNotFoundException e){
			out.write("无法加载类信息");
		}
		out.write("</b>");
	}
%>
</div>
</body>
</html>