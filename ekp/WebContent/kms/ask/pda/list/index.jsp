<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include file="/kms/common/pda/template/list.jsp">
	<template:replace name="title">
		${lfn:message('kms-ask:title.kms.ask') }
	</template:replace>
	<template:replace name="header">
		<c:set var="hasAdd" value="false"/>
		<kmss:auth requestURL="/kms/ask/kms_ask_topic/kmsAskTopic.do?method=add" requestMethod="GET">
			<c:set var="hasAdd" value="true"/>
		</kmss:auth>
		<c:import url="/kms/common/pda/core/search/search.jsp" charEncoding="UTF-8">
			<c:param name="modelName" value="com.landray.kmss.kms.ask.model.KmsAskTopic">
			</c:param>
			<c:param name="hasFilter" value="false">
			</c:param>
			<c:param name="hasAdd" value="${hasAdd}"/>
		</c:import>
		<%@ include file="/kms/ask/pda/list/header.jsp"%>
		<link rel="stylesheet"  href="${LUI_ContextPath }/kms/ask/pda/css/list.css" />
	</template:replace>
	
	<template:replace name="listview">
		<c:import url="/kms/common/pda/core/category/category.jsp" charEncoding="UTF-8">
			<c:param name="templateClass" value="com.landray.kmss.kms.ask.model.KmsAskCategory" />
			<c:param name="mainModelName" value="com.landray.kmss.kms.ask.model.KmsAskTopic" />
		</c:import>
		<c:import url="/kms/common/pda/core/personal/personal.jsp" charEncoding="UTF-8">
			<c:param name="url" value="/kms/ask/pda/list/personal.jsp"></c:param>
		</c:import>
		<div class="lui-listview" data-lui-role="listview" id="listview">
			<%@ include file="/kms/ask/pda/list/column.jsp" %>
		</div>
	</template:replace>
	
	<template:replace name="footer">
		<%@ include file="/kms/ask/pda/list/footer.jsp" %>
		<c:import url="/kms/ask/pda/import/ask_to_him.jsp" charEncoding="UTF-8"/>
	</template:replace>
</template:include>