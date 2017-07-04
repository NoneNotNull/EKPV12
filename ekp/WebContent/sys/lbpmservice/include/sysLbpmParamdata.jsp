<%@ page language="java" contentType="application/jsonp; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page errorPage="/resource/jsp/jsperror.jsp"%>
<%@ page import="net.sf.json.JSON"%>
<%@ page import="org.springframework.context.ApplicationContext"%>
<%@ page
	import="org.springframework.web.context.support.WebApplicationContextUtils"%>
<%@ page import="com.landray.kmss.common.actions.RequestContext"%>
<%@ page import="com.landray.kmss.sys.lbpm.engine.service.IJSONDataBean"%>
<%
	ApplicationContext ctx = WebApplicationContextUtils
			.getRequiredWebApplicationContext(session
					.getServletContext());
	IJSONDataBean jsonDataBean = (IJSONDataBean) ctx.getBean("lbpmProcessParameterAccessService");
	JSON jsonp = jsonDataBean.getDataJSON(new RequestContext(request));
%>
<%=jsonp.toString()%>