<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.Enumeration,java.util.Map,
	java.util.HashMap,
	org.springframework.context.ApplicationContext,
	org.springframework.web.context.support.WebApplicationContextUtils,
	com.landray.kmss.common.service.ICheckUniqueBean,
	com.landray.kmss.common.actions.RequestContext
	" %>
<%
	String serviceName = request.getParameter("serviceName");
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(session.getServletContext());
	ICheckUniqueBean checkuniqueBean = (ICheckUniqueBean)ctx.getBean(serviceName);
	String result = checkuniqueBean.checkUnique(new RequestContext(request));
	out.print(result);
%>
