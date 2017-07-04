<%@ page language="java" contentType="application/jsonp; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.lang.reflect.Method"%>
<%@ page import="net.sf.json.JSON"%>
<%@ page import="org.springframework.context.ApplicationContext"%>
<%@ page import="org.springframework.web.context.support.WebApplicationContextUtils"%>
<%@ page import="com.landray.kmss.util.StringUtil"%>
<%@ page import="com.landray.kmss.sys.cache.KmssCache"%>
<%@ page import="com.landray.kmss.common.actions.RequestContext"%>
<%@ page import="com.landray.kmss.kms.common.annotations.*"%>

<%! 
	Map cache = new HashMap();
%>

<%
	long max_age = 604800; // 默认最大缓存时间为一周，即(1秒* 3600 * 24 * 7)=604800秒 
	String _cachetime = request.getParameter("_cachetime");
	if (StringUtil.isNotNull(_cachetime)) {
		max_age = Long.parseLong(_cachetime);
	}
	String s_bean = request.getParameter("s_bean");
	String s_method = request.getParameter("s_method");
	
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(session.getServletContext());
	Object serviceBean = ctx.getBean(s_bean);
	JSON jsonData = null;
	Class clas = serviceBean.getClass();
	String cacheKey = clas.getName() + "-" + s_method;
	
	Method[] methods = clas.getDeclaredMethods();
	// 从缓存中读取调用的bean方法 
	Method invokeMethod = (Method) cache.get(cacheKey);
	
	if (invokeMethod == null) {
		for (Method m: clas.getDeclaredMethods()) {
			HttpJSONP annotation = m.getAnnotation(HttpJSONP.class);
			if (annotation != null) {
				cacheKey = clas.getName() + "-" + m.getName();
				cache.put(cacheKey, m);
			
				if (m.getName().equals(s_method)) {
					invokeMethod = m;
				}
			}
		}
	}
	jsonData = (JSON) invokeMethod.invoke(serviceBean, new RequestContext(request));
	//response.addHeader("cache-control", "max-age=" + max_age + ",public");
%>
<%= jsonData.toString(1) %>