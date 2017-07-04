<%@ page language="java" contentType="application/jsonp; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page errorPage="/resource/jsp/jsperror.jsp" %>
<%@ page import="net.sf.json.JSON,
	org.springframework.context.ApplicationContext,
	org.springframework.web.context.support.WebApplicationContextUtils,
	com.landray.kmss.common.actions.RequestContext,
	com.landray.kmss.sys.property.service.IJSONDataBean" %>
<%
	String s_bean = request.getParameter("s_bean");
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(session.getServletContext());
	IJSONDataBean jsonDataBean = (IJSONDataBean) ctx.getBean(s_bean);
	JSON jsonp = jsonDataBean.getDataJSON(new RequestContext(request));
%>
<%= jsonp.toString() %>