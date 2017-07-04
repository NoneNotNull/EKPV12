<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include file="/kms/common/pda/template/list.jsp">
	<template:replace name="title">
		${lfn:message('kms-knowledge:module.kms.knowledge') }
	</template:replace>
	<template:replace name="header">
		<c:import url="/kms/common/pda/core/search/search.jsp" charEncoding="UTF-8">
			<c:param name="modelName" value="com.landray.kmss.kms.wiki.model.KmsWikiMain;com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge"></c:param>
			<c:param name="hasAdd" value="true"></c:param>
		</c:import>
		<%@ include file="/kms/knowledge/pda/list/header.jsp"%>
	</template:replace>
	
	<template:replace name="listview">
		<c:import url="/kms/common/pda/core/category/category.jsp" charEncoding="UTF-8">
			<c:param name="templateClass" value="com.landray.kmss.kms.knowledge.model.KmsKnowledgeCategory" />
			<c:param name="mainModelName" value="com.landray.kmss.kms.knowledge.model.KmsKnowledgeBaseDoc" />
		</c:import>
		<c:import url="/kms/common/pda/core/personal/personal.jsp" charEncoding="UTF-8">
			<c:param name="url" value="/kms/knowledge/pda/list/personal.jsp"></c:param>
		</c:import>
		<div class="lui-listview" data-lui-role="listview" id="listview">
			<c:import url="/kms/knowledge/pda/list/column.jsp" charEncoding="UTF-8">
			</c:import>
			<c:import url="/kms/knowledge/pda/list/rowtable.jsp" charEncoding="UTF-8">
			</c:import>
			<c:import url="/kms/knowledge/pda/list/grid.jsp" charEncoding="UTF-8">
			</c:import>
		</div>
	</template:replace>
	
	<template:replace name="footer">
		<%@ include file="/kms/knowledge/pda/list/footer.jsp" %>
	</template:replace>
</template:include>