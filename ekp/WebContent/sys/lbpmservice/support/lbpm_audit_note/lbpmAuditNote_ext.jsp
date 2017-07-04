<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" errorPage="/resource/jsp/jsperror.jsp"%>
<%@ page import="com.landray.kmss.sys.lbpmservice.support.service.spring.*" %>
<%@ page import="java.util.Collection" %>
<%@ include file="/resource/jsp/common.jsp"%>
<%
String modelName = request.getParameter("modelName");
String provideFor = request.getParameter("provideFor");
Collection auditNoteOperationJsps = LbpmAuditNoteExtsManager.getInstance().getAuditNoteOperationJsps(provideFor, modelName);
pageContext.setAttribute("auditNoteOperationJsps", auditNoteOperationJsps);
%>
<c:forEach items="${auditNoteOperationJsps}" var="auditNoteOperationJsp">
	<c:import url="${auditNoteOperationJsp}" charEncoding="UTF-8">
		<c:param name="auditNoteFdId" value="${param.auditNoteFdId}" />
		<c:param name="modelName" value="${param.modelName}" />
		<c:param name="modelId" value="${param.modelId}" />
		<c:param name="formName" value="${param.formName}" />
	</c:import>
</c:forEach>
