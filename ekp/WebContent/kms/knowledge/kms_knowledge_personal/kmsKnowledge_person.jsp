<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="person.home">
	<template:replace name="title">
		<c:out value="${ lfn:message('kms-knowledge:kmsKnowledge.my') }"/>
	</template:replace>
	<template:replace name="content">
		<c:import url="/kms/knowledge/kms_knowledge_personal/kmsKnowledge_my.jsp" charEncoding="UTF-8"/>
	</template:replace>
</template:include>