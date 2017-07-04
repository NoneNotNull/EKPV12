<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:import url="/sys/lbpmservice/pda/sysAttMain_view.jsp" charEncoding="UTF-8">
		<c:param name="fdKey" value="${param.auditNoteFdId}_hw" />
		<c:param name="formBeanName" value="${param.formName}"/>
</c:import>