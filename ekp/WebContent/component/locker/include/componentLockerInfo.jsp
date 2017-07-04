<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<c:set var="sysWfBusinessForm" value="${requestScope[param.formName]}" />
<c:if test="${sysWfBusinessForm.sysWfBusinessForm.lockerInfo != null && sysWfBusinessForm.sysWfBusinessForm.lockerInfo.locked}">

<link rel="stylesheet" type="text/css" href="<c:url value="/component/locker/resource/jNotify.jquery.css"/>" media="screen" />
<script type="text/javascript" src="<c:url value="/component/locker/resource/jquery.js"/>"></script>
<script type="text/javascript" src="<c:url value="/component/locker/resource/jNotify.jquery.js"/>"></script>

<script>
$(document).ready(function() {
	jNotify('<kmss:message key="component-locker:lockInfo.writeLocked" />', {
		TimeShown: 5000,
		VerticalPosition: 'top',
		ShowOverlay: false
	});
});
</script>
</script>
</c:if>