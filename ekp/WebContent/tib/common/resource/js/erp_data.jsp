<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page errorPage="/resource/jsp/jsperror.jsp" %>
<%@page import="java.util.Iterator"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="com.landray.kmss.common.service.IXMLDataBean"%>
<%@page import="com.landray.kmss.common.actions.RequestContext"%>
<%@page import="com.landray.kmss.util.SpringBeanUtil"%>
<%@page import="com.landray.kmss.util.StringUtil"%>
<%
		String service=request.getParameter("erpServcieName");
		RequestContext requestInfo = new RequestContext(request);
		if(StringUtil.isNull(service)){
			//log.info("没有获取到对应的servie："+service);
			return ;
		}
		Object serviceBean=SpringBeanUtil.getBean(service);
		if(serviceBean instanceof IXMLDataBean){
			List<Map<String,Object>> result=((IXMLDataBean)serviceBean).getDataList(requestInfo);
			if(result==null){
				return ;
			}
			JSONArray jsonArray=new JSONArray();
			for (Iterator iterator = result.iterator(); iterator.hasNext();) {
				Map<String, Object> parseObj = (Map<String, Object>) iterator.next();
				JSONObject json=new JSONObject();
				for(String key : parseObj.keySet()){
					Object value=parseObj.get(key);
					json.accumulate(key, value);
				}
				jsonArray.add(json);
			}
			out.print(jsonArray.toString());
		}

%>