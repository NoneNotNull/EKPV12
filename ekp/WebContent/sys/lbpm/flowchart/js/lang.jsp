<%@ page language="java" contentType="javascript/x-javascript; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,java.lang.reflect.*,com.landray.kmss.util.ResourceUtil"%>
<%
	//设置缓存
	long expires = 7 * 24 * 60 * 60;
	long nowTime = System.currentTimeMillis();
	response.addDateHeader("Last-Modified", nowTime + expires);
	response.addDateHeader("Expires", nowTime + expires * 1000);
	response.addHeader("Cache-Control", "max-age=" + expires);

	try {
		String bundle = request.getParameter("bundle");
		String resource = "com.landray.kmss."
				+ bundle.replaceAll("-", ".") + "."
				+ ResourceUtil.APPLICATION_RESOURCE_NAME;

		Method method = ResourceUtil.class
				.getDeclaredMethod("getLocaleByUser");
		method.setAccessible(true);
		Locale locale = (Locale) method.invoke(ResourceUtil.class);
		//System.out.println(bundle + " " + locale);

		ResourceBundle resourceBundle = (locale == null) ? ResourceBundle
				.getBundle(resource)
				: ResourceBundle.getBundle(resource, locale);
		if (resourceBundle != null) {
			Enumeration<String> keys = resourceBundle.getKeys();
			for (; keys.hasMoreElements();) {
				String key = keys.nextElement();
				if (key.startsWith("FlowChartObject.Lang.")) {
					out.println("FlowChartObject.Lang.Register(\""
							+ key + "\", \""
							+ resourceBundle.getString(key) + "\");");
				}
				//System.out.println(key + "=" + resourceBundle.getString(key));
			}
		}

	} catch (Exception e) {
		e.printStackTrace();
		out.print("FlowChartObject.Lang.Error = 'error'");
	}
%>
