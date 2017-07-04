<%@ page language="java" contentType="application/jsonp; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page errorPage="/resource/jsp/jsperror.jsp"%>
<%@ page import="net.sf.json.JSON"%>
<%@ page import="java.lang.reflect.Method"%>
<%@ page import="org.springframework.context.ApplicationContext"%>
<%@ page
	import="org.springframework.web.context.support.WebApplicationContextUtils"%>
<%@ page import="org.springframework.util.ClassUtils"%>
<%@ page import="com.landray.kmss.util.*"%>
<%@ page import="com.landray.kmss.common.actions.RequestContext"%>
<%@ page import="com.landray.kmss.kms.common.service.IRequestJSONP"%>
<%
	String bean = request.getParameter("s_bean");
	String meth = request.getParameter("s_meth");
	IRequestJSONP requestJSON = null;
	if (StringUtil.isNotNull(bean)) {
		// bean
		ApplicationContext ctx = WebApplicationContextUtils
				.getRequiredWebApplicationContext(session
						.getServletContext());
		requestJSON = (IRequestJSONP) ctx.getBean(bean);
	} else {
		// java
		String s_name = request.getParameter("s_name");
		if (StringUtil.isNotNull(s_name)) {
			requestJSON = (IRequestJSONP) ClassUtils.forName(s_name)
					.newInstance();
		}
	}
	JSON jsonp = null;
	if(meth!=null && !meth.equals("")){
		 Method method = requestJSON.getClass().getMethod(meth, RequestContext.class);
		 jsonp = (JSON) method.invoke(requestJSON, new RequestContext(request));
	}else{
		 jsonp = requestJSON.getDataJSON(new RequestContext(request));
	}
%>
<%=jsonp.toString()%>