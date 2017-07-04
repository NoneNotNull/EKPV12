<%@ page language="java" contentType="application/jsonp; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page errorPage="/resource/jsp/jsperror.jsp"%>
<%@ page import="net.sf.json.JSON"%>
<%@ page import="org.springframework.context.ApplicationContext"%>
<%@ page
	import="org.springframework.web.context.support.WebApplicationContextUtils"%>
<%@ page import="org.springframework.util.ClassUtils"%>
<%@ page import="com.landray.kmss.util.*"%>
<%@ page import="com.landray.kmss.common.actions.RequestContext"%>
<%@ page import="com.landray.kmss.sys.lbpm.engine.service.IJSONDataBean"%>
<%
	String s_bean = request.getParameter("s_bean");
	IJSONDataBean jsonDataBean = null;
	if (StringUtil.isNotNull(s_bean)) {
		// bean
		ApplicationContext ctx = WebApplicationContextUtils
				.getRequiredWebApplicationContext(session
						.getServletContext());
		jsonDataBean = (IJSONDataBean) ctx.getBean(s_bean);
	} else {
		// java
		String s_name = request.getParameter("s_name");
		if (StringUtil.isNotNull(s_name)) {
			jsonDataBean = (IJSONDataBean) ClassUtils.forName(s_name)
					.newInstance();
		}
	}
	JSON jsonp = jsonDataBean.getDataJSON(new RequestContext(request));
%>
<%=jsonp.toString()%>