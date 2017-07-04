<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.simple">
	<template:replace name="head">
		<template:super/>
		<script >
			Com_IncludeFile("validation.js|plugin.js|eventbus.js|xform.js", null, "js");
			seajs.use(['theme!form' ]);
		</script>
	</template:replace>
	<template:replace name="body">
		<div style="padding-top:20px">
			<html:form action="/kms/knowledge/kms_knowledge_base_doc/kmsKnowledgeBaseDoc.do"
			  		onsubmit="return true;">
				<html:hidden property="docSubject"  styleId="docSubject" value="${kmsKnowledgeBaseDoc.docSubject}"/> 
				<div style="float:left;">
					<nobr>
						<strong>${lfn:message('kms-multidoc:kmsMultidoc.docProperty') }</strong>
						<span aling="left">${lfn:message('kms-knowledge:kmsKnowledge.editPropertyTip') }</span>
					</nobr>
				</div>
				<table class="tb_simple" width="100%" >
					<!-- 属性 -->
					<c:import url="/sys/property/include/sysProperty_edit.jsp" charEncoding="UTF-8">
						<c:param name="formName" value="kmsKnowledgeBaseDocForm" />
						<c:param name="fdDocTemplateId" value="${kmsKnowledgeBaseDocForm.docCategoryId}" />
					</c:import>
				</table> 
				<html:hidden property="idList"/>
			</html:form>
		</div>
	</template:replace>
</template:include>
<script>
$KMSSValidation();
</script>