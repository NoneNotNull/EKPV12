<%@ page language="java" contentType="text/javascript; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.landray.kmss.util.StringUtil"%>
<%@ page import="net.sf.json.JSONObject"%>
<%@ page import="java.util.*,java.lang.reflect.*,com.landray.kmss.util.ResourceUtil"%>
define(function(require, exports, module) {
<%
	//设置缓存
	long expires = 7 * 24 * 60 * 60;
	long nowTime = System.currentTimeMillis();
	response.addDateHeader("Last-Modified", nowTime + expires);
	response.addDateHeader("Expires", nowTime + expires * 1000);
	response.addHeader("Cache-Control", "max-age=" + expires);

	JSONObject json = new JSONObject();
	try {

		Boolean debug = ResourceUtil.debug;
		String bundle = request.getParameter("bundle");
		String prefix = request.getParameter("prefix");
		String resource = "";
		if (StringUtil.isNull(bundle))
			resource = ResourceUtil.APPLICATION_RESOURCE_NAME;
		else
			resource = "com.landray.kmss."
					+ bundle.replaceAll("-", ".") + "."
					+ ResourceUtil.APPLICATION_RESOURCE_NAME;
		Method method = ResourceUtil.class
				.getDeclaredMethod("getLocaleByUser");
		method.setAccessible(true);
		Locale locale = (Locale) method.invoke(ResourceUtil.class);

		ResourceBundle resourceBundle = (locale == null) ? ResourceBundle
				.getBundle(resource)
				: ResourceBundle.getBundle(resource, locale);
		if (resourceBundle != null) {
			Enumeration<String> keys = resourceBundle.getKeys();
			for (; keys.hasMoreElements();) {
				String key = keys.nextElement();
				if (!"____all".equals(prefix)
						&& !key.startsWith(prefix)) {
					continue;
				}
				if (debug) {
					json.accumulate(key, "["
							+ resourceBundle.getString(key) + "]");
				} else
					json.accumulate(key, resourceBundle.getString(key));
			}
			out.print("module.exports = " + json.toString(4) + ";");
		}
	} catch (Exception e) {
		e.printStackTrace();
	}
%>
});
