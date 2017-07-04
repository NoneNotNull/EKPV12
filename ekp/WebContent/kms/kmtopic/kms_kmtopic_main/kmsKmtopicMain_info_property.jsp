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
			<html:form action="/kms/kmtopic/kms_kmtopic_main/kmsKmtopicMain.do"
			  		onsubmit="return true;">
				<html:hidden property="docSubject"  styleId="docSubject" value="${kmsKmtopicMainForm.docSubject}"/> 
				<table class="tb_simple" width="100%" >
					<!-- 属性 -->
					<c:import url="/sys/property/include/sysProperty_edit.jsp" charEncoding="UTF-8">
						<c:param name="formName" value="kmsKmtopicMainForm" />
						<c:param name="fdDocTemplateId" value="${kmsKmtopicMainForm.docCategoryId}" />
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