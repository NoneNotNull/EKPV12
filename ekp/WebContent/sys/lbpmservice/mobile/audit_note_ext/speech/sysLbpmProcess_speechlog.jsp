<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:import url="/sys/lbpmservice/mobile/audit_note_ext/log/sysLbpmProcess_log.jsp" charEncoding="UTF-8">
		<c:param name="fdKey" value="${param.auditNoteFdId}_sp" />
		<c:param name="formName" value="${param.formName}"/>
		<c:param name="fdExtendClass" value="muiAuditSpeechLog"/>
		<c:param name="fdItemMixin" value="sys/lbpmservice/mobile/audit_note_ext/speech/_AuditSpeechItem"/>
</c:import>