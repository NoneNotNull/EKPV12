<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" errorPage="/resource/jsp/jsperror.jsp"%>
<%@ page import="com.landray.kmss.sys.lbpmservice.support.service.spring.*" %>
<%@ page import="java.util.Set" %>
<%@ include file="/resource/jsp/common.jsp"%>

<%
String modelName = request.getParameter("modelName");
Set exts = LbpmProcessJspExtManager.getInstance().getJspExts(modelName);
pageContext.setAttribute("jspExts", exts);
%>

<c:forEach items="${jspExts}" var="jspExt">
	<c:import url="${jspExt}" charEncoding="UTF-8" />
</c:forEach>