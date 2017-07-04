<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<%@page import="com.landray.kmss.sys.ims.util.ImsPluginUtil"%>
<%@page import="com.landray.kmss.util.StringUtil"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<% String value = request.getParameter("imName");
   List<Map<String,String>> plugins= ImsPluginUtil.getConfigs();
   for(Map<String,String> item: plugins){
	   String awareIp=item.get(ImsPluginUtil.AWAREIP); 
	   String awareJsp=item.get(ImsPluginUtil.AWAREJSP); 
	   String awarePort=item.get(ImsPluginUtil.AWAREPORT); 
	   String imsName=item.get(ImsPluginUtil.IMSNAME); 
	   if(StringUtil.isNotNull(value)){
		   if(!value.equals(imsName)){
			   continue;
		   }
		   %>
		   <c:import url="<%=awareJsp%>">
		   <c:param name="imName" value="${param.imName}"></c:param>
		   <c:param name="imParams" value="${param.imParams}"></c:param>
		   <c:param name="awareIp" value="<%=awareIp%>"></c:param>
		   <c:param name="awarePort" value="<%=awarePort%>"></c:param>
		 </c:import>
		<%   
	   }
	   else{
		   %>
		   <c:import url="<%=awareJsp%>">
		   <c:param name="imName" value="${param.imName}"></c:param>
		   <c:param name="imParams" value="${param.imParams}"></c:param>
		   <c:param name="awareIp" value="<%=awareIp%>"></c:param>
		   <c:param name="awarePort" value="<%=awarePort%>"></c:param>
		 </c:import>
		<%   
		   
	   }
   }
%>

