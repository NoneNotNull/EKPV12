<%@page import="com.landray.kmss.sys.ui.util.SysUiConstant"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.Map"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="com.landray.kmss.sys.ui.plugin.SysUiPluginUtil"%>
<%@page import="com.landray.kmss.util.StringUtil"%>
<%@page import="net.sf.json.JSONObject"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%
String type = request.getParameter("type");
JSONObject json = new JSONObject();
try {
	JSONArray array = new JSONArray();
	Map xxx = null;
	if (StringUtil.isNull(type)) {
		json.put("error", "类型不能为空");
	} else if ("portlet".equals(type)) {
		xxx = SysUiPluginUtil.getPortlets();
	} else if ("render".equals(type)) {
		xxx = SysUiPluginUtil.getRenders();
	} else if ("format".equals(type)) {
		xxx = SysUiPluginUtil.getFormats();
	} else if ("source".equals(type)) {
		xxx = SysUiPluginUtil.getSources();
	} else {
		json.put("error", "类型错误");
	}
	if(xxx != null){
		Iterator iterator = xxx.keySet().iterator();
		while(iterator.hasNext()){
			String key = iterator.next().toString();
			if(key.indexOf(SysUiConstant.SEPARATOR)>0){
			}else{
				array.add(JSONObject.fromObject(xxx.get(key)));
			}
		}
	}
	json.put(type, array);
	out.print(json.toString()); 
} catch (Exception e) {
	json.put("error", e.getMessage());
	out.print(json.toString());
}
%>