<%-- 收文编号 --%>
<%@page import="com.landray.kmss.util.StringUtil"%>
<%@page import="java.util.Map"%>
<%@page import="net.sf.json.JSONObject"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<html:hidden property="fdReceiveNum" />
<c:choose>
	<c:when 
			test="${kmImissiveReceiveMainForm.fdReceiveNum != '' && kmImissiveReceiveMainForm.fdReceiveNum != null}">
			<c:out value="${kmImissiveReceiveMainForm.fdReceiveNum}"></c:out>
    </c:when>
    <c:otherwise>
       (提交后系统自动生成)
    </c:otherwise>
</c:choose>
