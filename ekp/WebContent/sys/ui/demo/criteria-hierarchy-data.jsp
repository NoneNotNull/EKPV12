<%@ page language="java" contentType="text/json; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="net.sf.json.JSONObject,
				net.sf.json.JSONArray" %>
<%
String pId = request.getParameter("parentId");
String baseId = "1-";
if (pId != null && pId.length() > 0) {
	baseId = pId + "-";
}

JSONArray array = new JSONArray();
JSONObject obj = new JSONObject();
for (int i = 0; i < 5; i ++) {
	String val = baseId + (i + 1);
	JSONObject row = new JSONObject();
	row.put("value", val);
	row.put("text", "text " + val);
	array.add(row);
}
obj.put("datas", array);

out.println(obj.toString());
%>