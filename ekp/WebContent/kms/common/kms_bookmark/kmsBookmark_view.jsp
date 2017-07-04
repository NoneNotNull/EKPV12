<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<%@ include file="kmsBookmark_view_js.jsp"%>
<%@page import="com.landray.kmss.util.SpringBeanUtil"%>
<%@page import="com.landray.kmss.util.UserUtil"%>
<%@page import="java.util.List" %>
<%@page import="com.landray.kmss.kms.common.service.IKmsBookMarkMainService"%>
<link rel="stylesheet" type="text/css" href="${ LUI_ContextPath}/kms/common/kms_bookmark/style/bookmark_view.css" />
<%
	IKmsBookMarkMainService kmsBookMarkMainService=(IKmsBookMarkMainService)SpringBeanUtil.getBean("kmsBookMarkMainService");
	Boolean isMarked=kmsBookMarkMainService.checkIsMarked(UserUtil.getUser().getFdId(),request.getParameter("fdModelId"),request.getParameter("fdModelName"));
    int fdNum=kmsBookMarkMainService.getBookMarkNum(request.getParameter("fdModelName"),request.getParameter("fdModelId"));
   
    pageContext.setAttribute("isMarked",isMarked);
    pageContext.setAttribute("fdNum",fdNum);
%>
<div class="bookmarkDiv" id="bookmarkDiv">
	<input type="hidden" id="isMarked" value="${isMarked}"></input>
	<input type="hidden" id="mark_docSubject" value="${param.docSubject}"></input>
   
	   <c:choose>
	   			<c:when test="${isMarked}">
	   			<a id="BMBtn_${param.fdModelId}" href="javascript:void(0)" title="${lfn:message('kms-common:kmsBookMarkMain.del')}" onclick="changeBM('${param.fdModelId}','${param.fdModelName}');">
	   				<span class="bml" id="starItem"></span>
	   			</c:when>
	   			<c:otherwise>
	   			<a id="BMBtn_${param.fdModelId}" href="javascript:void(0)" title="${lfn:message('kms-common:kmsBookMarkMain.todo')}" onclick="changeBM('${param.fdModelId}','${param.fdModelName}');">
	   				<span class="bml0" id="starItem"></span>
	   			</c:otherwise>
	   	</c:choose>
	   	<span class="bmc" id="bmIcon" >
	   		 ${fdNum} 
	   </span>
	   	<span class="bmr"></span>
   </a> 
</div>