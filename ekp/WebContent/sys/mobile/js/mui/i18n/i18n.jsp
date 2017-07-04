
<%@page import="com.landray.kmss.util.StringUtil"%><%@ page language="java" contentType="text/json; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.*,
				java.lang.reflect.*,
				com.landray.kmss.util.ResourceUtil,
				net.sf.json.*"%>

<%

	try {
		String bundle = request.getParameter("bundle");
		String starts = "mui.";
		if (bundle.indexOf(':') > -1) {
			String[] sps = bundle.split(":");
			bundle = sps[0];
			starts = sps[1];
		}
		String resource = ResourceUtil.APPLICATION_RESOURCE_NAME;
		if(StringUtil.isNotNull(bundle)){
			resource = "com.landray.kmss."
				+ bundle.replaceAll("-", ".") + "."
				+ ResourceUtil.APPLICATION_RESOURCE_NAME;
		}
		Method method = ResourceUtil.class
				.getDeclaredMethod("getLocaleByUser");
		method.setAccessible(true);
		Locale locale = (Locale) method.invoke(ResourceUtil.class);

		ResourceBundle resourceBundle = (locale == null) ? ResourceBundle
				.getBundle(resource)
				: ResourceBundle.getBundle(resource, locale);
		if (resourceBundle != null) {
			JSONObject keyMap = new JSONObject();
			Enumeration<String> keys = resourceBundle.getKeys();
			for (; keys.hasMoreElements();) {
				String key = keys.nextElement();
				if (key.startsWith(starts)) {
					keyMap.accumulate(key, resourceBundle.getString(key));
				}
			}
			out.print(keyMap);
		}

	} catch (Exception e) {
		e.printStackTrace();
		out.print("['error']");
	}
%>