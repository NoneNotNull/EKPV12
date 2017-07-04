<%@ page
	language="java"
	contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<c:if test="${param.type == 'tmpdoc'}">
	<c:import
		url="right_batch_change.jsp"
		charEncoding="UTF-8" />
</c:if>
<c:if test="${param.type == 'tmp' }">
	<c:import
		url="tmp_right_batch_change.jsp"
		charEncoding="UTF-8" />
</c:if>
