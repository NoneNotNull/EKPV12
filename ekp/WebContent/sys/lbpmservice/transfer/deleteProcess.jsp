<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page
	import="org.springframework.context.ApplicationContext,
	org.springframework.web.context.support.WebApplicationContextUtils,
	com.landray.kmss.util.*,
	com.landray.kmss.sys.lbpm.engine.service.*"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>删除废弃的流程实例</title>
</head>
<body>
<kmss:authShow roles="SYSROLE_ADMIN">
<%
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(session.getServletContext());
	try {
		ProcessExecuteService processExecuteService = (ProcessExecuteService)ctx.getBean("lbpmProcessExecuteService");
		processExecuteService.delete(request.getParameter("fdId"));
		out.println("删除流程实例成功："+request.getParameter("fdId"));
	} catch(Exception e) {
		out.println("删除流程实例失败："+request.getParameter("fdId"));
		e.printStackTrace();
	}
%>
</kmss:authShow>
</body>
</html>