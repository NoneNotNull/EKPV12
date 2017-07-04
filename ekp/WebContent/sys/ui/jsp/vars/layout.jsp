<%@page import="com.landray.kmss.sys.ui.xml.model.SysUiLayout"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="com.landray.kmss.sys.ui.plugin.SysUiPluginUtil"%>
<%@page import="com.landray.kmss.sys.ui.xml.model.SysUiSource"%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%
	SysUiLayout layout = SysUiPluginUtil.getLayoutById(request
			.getParameter("fdId"));
	if(layout==null){
		out.print("<div class='validation-advice'><span class='validation-advice-msg'><span class='validation-advice-title'>外观："+request.getParameter("fdId")+"不存在</span></span></div>");
	}else{
		request.setAttribute("vars",
				JSONArray.fromObject(layout.getFdVars()));
		request.getRequestDispatcher(
				"/sys/ui/jsp/vars/variable.jsp").forward(
				request, response);
	}
%>