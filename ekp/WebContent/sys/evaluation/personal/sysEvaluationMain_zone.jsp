<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<c:set var="TA" value="${param.zone_TA}"/>
<template:include ref="zone.navlink">
	<template:replace name="title">
		<c:out value="${lfn:message(lfn:concat('sysEvaluationMain.zone.', TA))}"></c:out>
	</template:replace>
	<template:replace name="content">
		<c:import url="/sys/evaluation/personal/sysEvaluationMain_other.jsp" charEncoding="UTF-8">
				<c:param name="userId" value="${user.fdId}"></c:param>
		</c:import>
	</template:replace>
</template:include>

