<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include file="/kms/common/pda/template/list.jsp">
	<template:replace name="title">
		${lfn:message('kms-expert:title.kms.expert') }
	</template:replace>
	<template:replace name="header">
		<script src="${LUI_ContextPath }/kms/expert/pda/list/script/list.js"></script>
		<c:import url="/kms/common/pda/core/search/search.jsp" charEncoding="UTF-8">
			<c:param name="modelName" value="com.landray.kmss.kms.expert.model.KmsExpertInfo"></c:param>
		</c:import>
		<%@ include file="/kms/expert/pda/list/header.jsp"%>
	</template:replace>
	
	<template:replace name="listview">
		<c:import url="/kms/common/pda/core/category/category.jsp" charEncoding="UTF-8">
			<c:param name="templateClass" value="com.landray.kmss.kms.expert.model.KmsExpertType" />
			<c:param name="mainModelName" value="com.landray.kmss.kms.expert.model.KmsExpertInfo" />
		</c:import>
		<c:import url="/kms/common/pda/core/personal/personal.jsp" charEncoding="UTF-8">
			<c:param name="url" value="/kms/expert/pda/list/personal.jsp"></c:param>
		</c:import>
		<div class="lui-listview" data-lui-role="listview" id="listview">
			<%@ include file="/kms/common/pda/core/connect/connect.jsp" %>
			<%@ include file="/kms/expert/pda/list/rowtable.jsp" %>
			<%@ include file="/kms/expert/pda/list/grid.jsp" %>
		</div>
	</template:replace>
	
	<template:replace name="footer">
		<c:import url="/kms/ask/pda/import/ask_to_him.jsp" charEncoding="UTF-8"/>
		<%@ include file="/kms/expert/pda/list/footer.jsp" %>
	</template:replace>
</template:include>