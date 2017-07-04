<%@ page language="java" contentType="application/x-javascript; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ page errorPage="/resource/jsp/jsperror.jsp" %>
<%@ page import="org.springframework.context.ApplicationContext,
	org.springframework.web.context.support.WebApplicationContextUtils,
	com.landray.kmss.common.service.IXMLDataBean,
	com.landray.kmss.common.actions.RequestContext,
	com.landray.kmss.util.StringUtil,
	java.util.*
"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="net.sf.json.JSONArray"%>
<% 
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
	response.setDateHeader("Expires", -1);
	
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(session.getServletContext());
	RequestContext requestInfo = new RequestContext(request);
	String[] beanList = request.getParameter("s_bean").split(";");
	IXMLDataBean treeBean;
	List result = null;	
	HashMap nodeMap;
	Object node;
	Object[] nodeList;
	Iterator attr;	
	for(int i=0; i<beanList.length; i++){
		treeBean = (IXMLDataBean) ctx.getBean(beanList[i]);
		 result = treeBean.getDataList(requestInfo);
	if(result!=null){
	JSONArray jsonArray=new JSONArray();	
	for (Iterator iterator = result.iterator(); iterator.hasNext();) {
		node =  iterator.next();
		if(node instanceof HashMap){
			Map<String, Object> parseObj =(Map<String, Object>)node;
			JSONObject json=new JSONObject();	
		for(String key1 : parseObj.keySet()){
			Object value1=parseObj.get(key1);
			json.accumulate(key1, value1);
		}
		jsonArray.add(json);
	  }else if(node instanceof Object[]){
			nodeList = (Object[])node;
			JSONObject json=new JSONObject();	
			for(int k=0; k<nodeList.length; k++){
				if(nodeList[k]!=null){
					String key2 = "key"+k;
					Object value2 = nodeList[k];
					json.accumulate(key2, value2);
				}			
		  }
			jsonArray.add(json);
	   }else{
			if(node!=null){
				JSONObject json=new JSONObject();	
				String key3 = "key0";
				Object value3 = node;
				json.accumulate(key3, value3);
				jsonArray.add(json);
			}
	   }
	}
	out.print(request.getParameter("jsoncallback")+"("+jsonArray.toString()+")");
  }
}
%>