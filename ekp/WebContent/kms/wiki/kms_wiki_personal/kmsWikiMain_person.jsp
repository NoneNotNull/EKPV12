<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="person.home">
	<template:replace name="title">
		<c:out value="${ lfn:message('kms-wiki:kmsWikiMain.person.my') }"/>
	</template:replace>
	<template:replace name="content">
		<c:import url="/kms/wiki/kms_wiki_personal/kmsWikiMain_my.jsp" charEncoding="UTF-8"/>
	</template:replace>
</template:include>