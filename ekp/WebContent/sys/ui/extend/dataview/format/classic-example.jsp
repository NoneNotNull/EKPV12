<%@page import="net.sf.json.JSONObject"%>
<%@page import="net.sf.json.JSONArray"%>
<%@ page language="java" contentType="text/json; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="com.landray.kmss.util.DateUtil"%>
<%@page import="java.util.Date"%>
<%
JSONObject json = null;
JSONArray array = new JSONArray();

json = new JSONObject();
json.put("catename","分类数据");
json.put("catehref","#");
json.put("text","这是非常完整的样例数据，时间为今天");
json.put("created", DateUtil.convertDateToString(new Date(), DateUtil.TYPE_DATE, request.getLocale()));
json.put("href","#");
json.put("creator","管理员");
json.put("otherinfo","（回复：10）");
json.put("icon","lui_icon_s_icon_info_sign");
array.add(json);

for(int i=0;i<4;i++){
	json = new JSONObject();
	json.put("catename","分类数据");
	json.put("catehref","#");
	json.put("text","这是正常的样例数据");
	json.put("created","2013-05-01");
	json.put("href","#");
	json.put("creator","管理员");
	json.put("otherinfo","（回复：10）");
	array.add(json);
}

json = new JSONObject();
json.put("text","这条数据没其它信息"); 
array.add(json);

request.setAttribute("lui-source",array);
request.getRequestDispatcher("/sys/ui/jsp/json.jsp").forward(request,response);
%>