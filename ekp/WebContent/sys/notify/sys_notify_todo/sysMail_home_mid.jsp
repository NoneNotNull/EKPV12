<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<%@page import="com.landray.kmss.framework.plugin.core.config.IExtension"%>
<%@page import="com.landray.kmss.framework.service.plugin.Plugin"%>
<%
//主页待办窗口显示邮件数扩展点Id以及参数名称
String EXTENSION_POINT = "com.landray.kmss.sys.notify";
String ITEM_NAME = "homeMailNum";
String PARAM_MAIL_NUM_JSP = "mailNumJsp";
String importMailNumJsp = null;

//获取主页待办窗口显示邮件数扩展点的扩展
IExtension extension = Plugin.getExtension(EXTENSION_POINT,"*", ITEM_NAME);
if(extension != null ){
	importMailNumJsp = (String)Plugin.getParamValue(extension, PARAM_MAIL_NUM_JSP);
	request.setAttribute("importMailNumJsp",importMailNumJsp);
}
%>
<c:if test="${!empty importMailNumJsp}">
	<c:import url="${importMailNumJsp }" charEncoding="UTF-8"></c:import>
</c:if>
