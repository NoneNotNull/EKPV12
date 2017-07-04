<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="person.home">
	<template:replace name="title">
		<c:out value="${ lfn:message('kms-multidoc:module.kms.multidoc') }"></c:out>
	</template:replace>
	<template:replace name="content">
		<c:import url="/kms/multidoc/kms_multidoc_personal/kmsMultidocKnowledge_my.jsp" charEncoding="UTF-8"/>
	</template:replace>
</template:include>
