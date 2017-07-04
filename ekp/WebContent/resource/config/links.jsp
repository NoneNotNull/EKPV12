<%@page import="com.landray.kmss.sys.person.interfaces.LinkInfo"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.Iterator"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="com.landray.kmss.sys.ui.util.SysUiConstant"%>
<%@page import="java.util.List"%>
<%@page import="com.landray.kmss.sys.person.service.plugin.LinksHelp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%
JSONObject json = new JSONObject();
try {
	Map xxx =  LinksHelp.getAllLinks();
	if(xxx != null){
		Iterator iterator = xxx.keySet().iterator();
		while(iterator.hasNext()){
			JSONArray array = new JSONArray();
			String key = iterator.next().toString();
			List infos = (List)xxx.get(key);
			for(int i=0;i<infos.size();i++){
				LinkInfo info = (LinkInfo)infos.get(i);
				if(info.getServer()==null || info.getServer().equals(LinkInfo.getCurrentServerGroupKey())){
					array.add(JSONObject.fromObject(infos.get(i))); 
				}
			} 
			json.put(key, array);
		}
	}
	out.print(json.toString()); 
} catch (Exception e) {
	json.put("error", e.getMessage());
	out.print(json.toString());
}
%>