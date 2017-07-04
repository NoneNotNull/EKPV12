<%@page import="com.landray.kmss.sys.ui.plugin.SysUiTools"%>
<%@ page language="java" pageEncoding="UTF-8"%>
<body style="margin:20px;">
主题：<input name="theme" value="${empty(param.theme)?'default':param.theme}">
<input type="button" value="执行" onclick="location.href='reloadIcon.jsp?theme='+document.getElementsByName('theme')[0].value;"><br>
<%
String theme = request.getParameter("theme");
if(theme!=null){
	try{
		String error = SysUiTools.reloadIcon(theme);
		out.write("成功重新加载Icon<br>");
		if(!error.isEmpty()){
			out.write(error);
		}
	}catch(Exception e){
		out.write("加载失败！");
		e.printStackTrace();
	}
}
%>
</body>