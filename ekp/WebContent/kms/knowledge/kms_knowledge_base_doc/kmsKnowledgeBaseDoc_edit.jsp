<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.edit">
	<template:replace name="head">
	</template:replace>
<c:import url="/kms/knowledge/kms_knowledge_ui/kmsKnowledge_button.jsp" charEncoding="UTF-8"></c:import>
<script>
window.onload = function() {
	addDoc();
};
</script>
</template:include>