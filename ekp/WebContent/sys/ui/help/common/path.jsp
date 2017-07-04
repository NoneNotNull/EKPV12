<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<div style="padding:10px 0px;">
	当前路径：
	<c:if test="${empty paths}">
		<c:out value="${param.s_path}"/>
	</c:if>
	<c:if test="${not empty paths}">
		<c:forEach items="${paths}" var="path" varStatus="vstatus">
			<c:if test="${vstatus.index>0}">&gt;&gt</c:if>
			<c:if test="${not empty path.href}">
				<a href="${LUI_ContextPath}${path.href}">
					<c:out value="${path.name}"/>
				</a>
			</c:if>
			<c:if test="${empty path.href}">
				<c:out value="${path.name}"/>
			</c:if>
		</c:forEach>
	</c:if>
</div>