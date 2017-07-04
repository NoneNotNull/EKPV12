<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:choose>
	<c:when test="${param['isAppflag']=='1'}">
		<c:redirect url="${redirectto}&isAppflag=1" />
	</c:when>
	<c:otherwise>
		<c:redirect url="${redirectto}" />
	</c:otherwise>
</c:choose>


