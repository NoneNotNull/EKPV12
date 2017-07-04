<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<c:if test="${empty kmImissiveReceiveMainForm.fdReceiveNum}">
     (提交后系统自动生成)
</c:if>
<c:if test="${not empty kmImissiveReceiveMainForm.fdReceiveNum}">
	<c:out value="${kmImissiveReceiveMainForm.fdReceiveNum}" />
</c:if>