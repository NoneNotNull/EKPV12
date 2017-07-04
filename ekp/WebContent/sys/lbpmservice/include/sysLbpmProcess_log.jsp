<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.landray.kmss.sys.lbpmservice.support.actions.LbpmAuditNoteAction"%>
<%@ include file="/resource/jsp/common.jsp"%>
<c:set var="fdModelId" value="${requestScope[param.formName].fdId}" scope="request"/>
<c:set var="fdModelName" value="${requestScope[param.formName].modelClass.name}" scope="request"/>
<% new LbpmAuditNoteAction().listNote(null, null, request, response);%>
<c:import url="/sys/lbpmservice/support/lbpm_audit_note/lbpmAuditNote_print.jsp" charEncoding="UTF-8"/>