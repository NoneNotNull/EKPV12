<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="person.home">
	<template:replace name="head">
		<link rel="stylesheet" type="text/css" href="${ LUI_ContextPath}/kms/ask/kms_ask_ui/style/index.css" />
	</template:replace>
	<template:replace name="title">
		<c:out value="${ lfn:message('kms-ask:module.kms.ask') }"></c:out>
	</template:replace>
	<template:replace name="content">
			<c:import url="/kms/ask/kms_ask_personal/kmsAsk_my.jsp" charEncoding="UTF-8">
			</c:import>
	</template:replace>
	</template:include>
<script>
</script>
