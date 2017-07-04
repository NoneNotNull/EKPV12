<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="com.landray.kmss.util.ResourceUtil"%>
<%
	String debug = request.getParameter("debug");
	if(debug!=null){
		ResourceUtil.debug = "true".equals(request.getParameter("debug"));
	}
	if(ResourceUtil.debug){
		out.write("多语言调试模式设置为：开");
	}else{
		out.write("多语言调试模式设置为：关");
	}
%>
<script>
	function switchDebug(value){
		location.href="langtools.jsp?debug="+value;
	}
</script>
<br><br>
<input type="button" value="打开多语言调试模式" onclick="switchDebug('true')">
<input type="button" value="关闭多语言调试模式" onclick="switchDebug('false')">
