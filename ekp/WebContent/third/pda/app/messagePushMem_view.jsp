<%@ include file="/resource/jsp/common.jsp"%>
<%@ page language="java" contentType="text/plain; charset=UTF-8"
	pageEncoding="UTF-8"%>
<c:choose>
	<c:when test="${rtnStr!=null && rtnStr!='' }">
		{
		"errorPage":"true",
		"message":"${rtnStr}"
		}
	</c:when>
	<c:otherwise>
		{
		"errorPage":"false",
		"dataUrl":"${dataUrl}"
		}
	</c:otherwise>
</c:choose>