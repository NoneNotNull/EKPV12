<%@page import="com.landray.kmss.sys.ui.plugin.SysUiPluginUtil"%>
<%
	String format = request.getParameter("code");
	request.getRequestDispatcher(
			SysUiPluginUtil.getFormatById(format).getFdExample())
			.forward(request, response);
%>