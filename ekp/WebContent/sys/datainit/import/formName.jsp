
<%@page import="net.sf.json.JSONObject"%>
<%@page import="org.apache.struts.config.ActionConfig"%>
<%@page import="org.apache.struts.Globals"%>
<%@page import="org.apache.struts.config.ModuleConfig"%><%@ page
	language="java" contentType="text/javascript; charset=UTF-8"
	pageEncoding="UTF-8"%>
define(function(require, exports, module) {
<%
	try {
		String sourceUrl = request.getParameter("url");
		if (sourceUrl.indexOf(".do") > -1)
			sourceUrl = sourceUrl
					.substring(0, sourceUrl.indexOf(".do"));
		ActionConfig actCfg = ((ModuleConfig) getServletContext()
				.getAttribute(Globals.MODULE_KEY))
				.findActionConfig(sourceUrl);
		JSONObject json = new JSONObject();
		json.accumulate("formName", actCfg.getName());
		out.print("module.exports = " + json.toString(4) + ";");
	} catch (Exception e) {
		e.printStackTrace();
	}
%>
});
