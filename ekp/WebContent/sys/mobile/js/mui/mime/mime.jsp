<%@ page language="java" contentType="text/json; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="com.landray.kmss.util.StringUtil"%>
<%@page import="com.landray.kmss.util.FileMimeTypeUtil"%>
<%
	try {
		String fileName = request.getParameter("fileName");
		JSONObject json = new JSONObject();
		if(StringUtil.isNotNull(fileName)){
			json.accumulate("status",1);
			json.accumulate("message",FileMimeTypeUtil.getContentType(fileName));
		}else{
			json.accumulate("status",0);
			json.accumulate("message","文件名为空");
		}
		out.print(json.toString());
	} catch (Exception e) {
		e.printStackTrace();
	}
%>