<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:import url="/sys/lbpmservice/mobile/audit_note_ext/log/sysLbpmProcess_log.jsp" charEncoding="UTF-8">
		<c:param name="fdKey" value="${param.auditNoteFdId}_hw" />
		<c:param name="formName" value="${param.formName}"/>
		<c:param name="fdAttType" value="pic"></c:param>
		<c:param name="fdExtendClass" value="muiAuditHandLog"/>
</c:import>