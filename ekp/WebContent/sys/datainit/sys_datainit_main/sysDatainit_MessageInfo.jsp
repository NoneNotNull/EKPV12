<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<%
	String loadMessage = (String)request.getAttribute("_loadMessageInfo");
	if(loadMessage==null) {
%>
 
 if(typeof Datainit_MessageInfo == "undefined")
	Datainit_MessageInfo = new Array();
 if(Datainit_MessageInfo.length==0) {
 
 	Datainit_MessageInfo["sysDatainitMain.export"]="<bean:message bundle="sys-datainit" key="sysDatainitMain.data.export" />";
 	
 }
 
 <%
		request.setAttribute("_loadMessageInfo","1");
	}
 %>