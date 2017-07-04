
<%@page import="net.sf.json.JSONArray"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="com.landray.kmss.framework.plugin.core.config.IExtension"%>
<%@page import="com.landray.kmss.framework.service.plugin.Plugin"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%
//获取样式扩展点
IExtension[] extensions = Plugin.getExtensions(
		"com.landray.kmss.web.taglib.xform.ShowAuditNoteTag", "*");

List<Map<String,String>> list = new ArrayList<Map<String,String>>();
if(extensions !=null){
	for(int i=0;i<extensions.length;i++){
		Map<String,String> mapElement=new HashMap<String,String>();
		
		Object templateName =Plugin.getParamValue(extensions[i],"templateName");
		Object order =Plugin.getParamValue(extensions[i],"order");
		Object reviewPictureURL =Plugin.getParamValue(extensions[i],"reviewPictureURL");
		Object exhibitionStyle =Plugin.getParamValue(extensions[i],"exhibitionStyle");
		
		mapElement.put("templateName",null==templateName?"":(String)templateName);
		//确保没有输入序号的扩展排到最后
		mapElement.put("order",null==order?"100":(Integer)order+"");
		mapElement.put("reviewPictureURL",null==reviewPictureURL?"":(String)reviewPictureURL);
		mapElement.put("exhibitionStyle",null==exhibitionStyle?"":(String)exhibitionStyle);
		
		list.add(mapElement);
	}
}
//排序
for(int i=0;i<list.size();i++){
	Map<String,String> mapI=list.get(i);
	int mapIOrder=Integer.valueOf(mapI.get("order"));
	
	for(int j=i;j<list.size();j++){
		Map<String,String> mapJ=list.get(j);
		int mapJOrder=Integer.valueOf(mapJ.get("order"));
		
		if(mapJOrder<mapIOrder){
			Map<String,String> mapTemp=mapI;
			mapI=mapJ;
			mapJ=mapTemp;
			list.set(i,mapI);
			list.set(j,mapJ);
			break;
		}
	}
}
//构建JSON数组，相应给客户端
out.print(JSONArray.fromObject(list));
%>