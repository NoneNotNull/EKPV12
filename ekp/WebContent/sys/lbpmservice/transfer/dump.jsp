<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page
	import="org.springframework.context.ApplicationContext,
	org.springframework.web.context.support.WebApplicationContextUtils,
	com.landray.kmss.util.*,
	com.landray.kmss.sys.lbpm.engine.support.execute.queue.*,
	com.landray.kmss.sys.lbpm.engine.service.*,
	com.landray.kmss.sys.lbpm.engine.dispatcher.*"%>
<%
ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(session.getServletContext());
DefaultDistributeLoader defaultDistributeLoader = (DefaultDistributeLoader)ctx.getBean("distributeLoader");
ProcessQueueDistributor processQueueDistributor = (ProcessQueueDistributor)ctx.getBean("flowDriver");
%>

<%= StringUtil.replace(processQueueDistributor.dump().toString(), "\n", "<br>")%><br>

<%= StringUtil.replace(defaultDistributeLoader.dump().toString(), "\n", "<br>")%><br>
