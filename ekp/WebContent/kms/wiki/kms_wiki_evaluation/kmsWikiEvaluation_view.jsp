<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@page import="java.net.URLDecoder"%>
<html>
	<head>
	</head>
	<body>
		<div class="evaluation_div" id="test">
		   <c:if test="${isDelete == true}">
		   		<div>
					<span> 此点评已在新版本中被删除！</span>
				</div>
		   </c:if>
		   <c:if test="${empty isDelete }">
				<div>
					<strong>原文：</strong>
					<span> <strong>#</strong> <%=URLDecoder.decode(request.getAttribute("docSubject").toString(), "UTF-8") %><strong>#</strong></span>
				</div>
				<div>
					<strong>点评：</strong>
					<span> ${docContent }</span>
				</div>
				<div style="text-align:right;">
					<span>-----by</span><strong> ${fdName }</strong>
				</div>
			</c:if>
		</div>	
		
	</body>
	
</html>	

