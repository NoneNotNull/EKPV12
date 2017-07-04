<%@page import="com.landray.kmss.sys.ui.xml.model.SysUiLayout"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="com.landray.kmss.sys.ui.plugin.SysUiPluginUtil"%>
<%@page import="com.landray.kmss.sys.ui.xml.model.SysUiSource"%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%
	SysUiSource source = SysUiPluginUtil.getSourceById(request
			.getParameter("fdId"));
	if(source==null){
		out.print("<div class='validation-advice'><span class='validation-advice-msg'><span class='validation-advice-title'>部件："+request.getParameter("fdId")+"不存在</span></span></div>");
	}else{
		request.setAttribute("vars",
				JSONArray.fromObject(source.getFdVars()));
		request.getRequestDispatcher(
				"/sys/ui/jsp/vars/variable.jsp").forward(
				request, response);
	}
%>