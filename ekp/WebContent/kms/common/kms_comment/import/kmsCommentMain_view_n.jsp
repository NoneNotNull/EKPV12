<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<%@ include file="/kms/common/kms_comment/import/kmsCommentMain_view_js.jsp"%>

<c:import url="/kms/common/kms_comment/import/kmsCommentMain_view_html.jsp">
	<c:param name="defaultShow" value="{param.defaultShow}"/>	
	<c:param name="fdModelId" value="${param.fdModelId}"/>
	<c:param name="fdModelName" value="${param.fdModelName }"></c:param>
</c:import>

