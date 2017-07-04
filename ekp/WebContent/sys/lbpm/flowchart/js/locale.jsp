<%@ page language="java" contentType="javascript/x-javascript; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,java.lang.reflect.*,com.landray.kmss.util.ResourceUtil"%>
<%
	Method method = ResourceUtil.class
			.getDeclaredMethod("getLocaleByUser");
	method.setAccessible(true);
	Locale locale = (Locale) method.invoke(ResourceUtil.class);
	if (locale != null) {
		out.print("FlowChartObject.Lang.Locale = '" + locale
				+ "'");
	}
%>