<%@ page language="java" contentType="application/jsonp; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.lang.reflect.Method,
	net.sf.json.JSON,
	org.springframework.context.ApplicationContext,
	org.springframework.web.context.support.WebApplicationContextUtils,
	com.landray.kmss.util.StringUtil,
	com.landray.kmss.common.actions.RequestContext,
	com.landray.kmss.kms.multidoc.service.IRequestJSONP" %> 
<%

	long max_age = 604800; // 默认最大缓存时间为一周，即(1秒* 3600 * 24 * 7)=604800秒 
	String _cachetime = request.getParameter("_cachetime");
	if (StringUtil.isNotNull(_cachetime)) {
		max_age = Long.parseLong(_cachetime);
	}
	String bean = request.getParameter("bean");
	String meth = request.getParameter("meth");
	String fdMultiDocByTemplateId = request.getParameter("fdMultiDocByTemplateId");
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(session.getServletContext());
	IRequestJSONP requestJSON = (IRequestJSONP) ctx.getBean(bean);
	Method method = null;
	if(fdMultiDocByTemplateId!=null&&!fdMultiDocByTemplateId.equals("")){
		method = requestJSON.getClass().getMethod(meth,RequestContext.class,String.class);
	}else {
		method = requestJSON.getClass().getMethod(meth, RequestContext.class);
	}
	JSON jsonp = null;
	if(fdMultiDocByTemplateId!=null&&!fdMultiDocByTemplateId.equals("")){
		Object[] params = new Object[2];
		params[0] = new RequestContext(request);
		params[1] = fdMultiDocByTemplateId;
		jsonp = (JSON) method.invoke(requestJSON, params);
	}else {
		jsonp = (JSON) method.invoke(requestJSON, new RequestContext(request));
	}
	
	
	response.addHeader("cache-control", "max-age=" + max_age + ",public");
%>
<%= jsonp.toString(1) %>