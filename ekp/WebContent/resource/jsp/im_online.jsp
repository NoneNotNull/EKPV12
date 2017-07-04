<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
	<c:if test="${empty requestScope.resource_jsp_im_online}">
	<script src="${KMSS_Parameter_ContextPath}resource/js/browinfo.js"></script>
	<script src="${KMSS_Parameter_ContextPath}resource/js/rtxint.js"></script>
	<c:set var="resource_jsp_im_online" value="true" scope="request" />
	</c:if>
	<c:if test="${not empty param.userName}">
	<img align="absbottom" width=16 height=16 src="${KMSS_Parameter_StylePath}icons/blank.gif" 
	     onload="RAP('${param.userName}');">
	</c:if>
