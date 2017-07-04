<%@ page language="java" contentType="text/xml; charset=UTF-8"   pageEncoding="UTF-8"%>
<%@page import="com.landray.kmss.util.StringUtil"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="java.util.Map"%><%
	Map rtnMap  = (Map)request.getAttribute("resultMap");
	String format = (String)request.getAttribute("format");
	if (rtnMap != null && !rtnMap.isEmpty()) { 
		if("xml".equals(format)){
			out.println("<return>");
			for (Object key : rtnMap.keySet()) {
				out.println("<" + (String) key + ">"
						+ StringUtil.XMLEscape(rtnMap.get(key).toString())
						+ "</" + key + ">");
			}
			out.println("</return>");
		}else{
			response.setHeader("content-type","text/plain; charset=UTF-8");
			out.print(JSONObject.fromObject(rtnMap).toString());
		}
	}
%>