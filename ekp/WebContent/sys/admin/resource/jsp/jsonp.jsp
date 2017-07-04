<%@ page language="java" contentType="application/jsonp; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page errorPage="/resource/jsp/jsperror.jsp" %>
<%@ page import="net.sf.json.JSON,
	org.springframework.context.ApplicationContext,
	org.springframework.web.context.support.WebApplicationContextUtils,
	org.springframework.util.ClassUtils,
	com.landray.kmss.util.*,
	com.landray.kmss.common.actions.RequestContext,
	com.landray.kmss.sys.admin.common.service.IJSONDataBean" %>
<%
	String s_bean = request.getParameter("s_bean");
	IJSONDataBean jsonDataBean = null;
	if(StringUtil.isNotNull(s_bean)) {
		ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(session.getServletContext());
		jsonDataBean = (IJSONDataBean) ctx.getBean(s_bean);
	} else {
		String s_name = request.getParameter("s_name");
		if(StringUtil.isNotNull(s_name)) {
			jsonDataBean = (IJSONDataBean) ClassUtils.forName(s_name).newInstance();
		}
	}
	JSON jsonp = jsonDataBean.getDataJSON(new RequestContext(request));
%>
<%= jsonp.toString() %>