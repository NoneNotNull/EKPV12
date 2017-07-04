<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.List,
	org.springframework.context.ApplicationContext,
	org.springframework.web.context.support.WebApplicationContextUtils,
	com.landray.kmss.third.ldap.oms.in.ISynchroToolkit
	" %>
<%
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(session.getServletContext());
	ISynchroToolkit ldapSynchroToolkit = (ISynchroToolkit)ctx.getBean("ldapSynchroToolkit");
	ldapSynchroToolkit.updateRelationLdap2IT();
	out.println("转换完成！");
%>
