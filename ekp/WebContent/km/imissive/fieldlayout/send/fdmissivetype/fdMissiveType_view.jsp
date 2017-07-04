<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<c:if test="${empty kmImissiveSendMainForm.fdMissiveType or kmImissiveSendMainForm.fdMissiveType eq '0'}">不限</c:if>
<c:if test="${kmImissiveSendMainForm.fdMissiveType eq '1'}">分发件</c:if>
<c:if test="${kmImissiveSendMainForm.fdMissiveType eq '2'}">上报件</c:if>
