<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<c:if test="${not empty kmImissiveReceiveMainForm.fdDocNum}">
	<c:out value="${kmImissiveReceiveMainForm.fdDocNum}"/>
</c:if>	
<c:if test="${empty kmImissiveReceiveMainForm.fdDocNum}">
      ${lfn:message("km-imissive:kmImissiveReceiveMain.fdDocNum.title")}
</c:if>