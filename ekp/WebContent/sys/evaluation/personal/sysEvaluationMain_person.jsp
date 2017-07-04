<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="person.home">
	<template:replace name="title">
		<c:out value="${ lfn:message('sys-evaluation:table.sysEvaluationMain') }"></c:out>
	</template:replace>
	<template:replace name="content">
		<c:import url="/sys/evaluation/personal/sysEvaluationMain_other.jsp" charEncoding="UTF-8"/>
	</template:replace>
</template:include>
