<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<c:set var="sysIntroduceForm" value="${requestScope[param.formName]}"/>
	<c:set var="intr_modelName" value="${sysIntroduceForm.introduceForm.fdModelName}"/>
	<c:set var="intr_modelId" value="${sysIntroduceForm.introduceForm.fdModelId}"/>
	<c:set var="intr_docSubject" value="${sysIntroduceForm.docSubject}"/>
	<c:set var="intr_docCreatorName" value="${sysIntroduceForm.docCreatorName}"/>
<a data-lui-role="button">
	<script type="text/config">
		{
			currentClass : 'lui-intr-icon-view',
			onclick : "intrSelected()",
			group : 'group1',
			text : '推荐'
		}
	</script>	
</a>

<section data-lui-role="panel" id="introduce_panel">
	<script type="text/config">
		{
			url : '${LUI_ContextPath}/kms/common/pda/core/introduce/tmpl/introduce.jsp?docCreatorName=${intr_docCreatorName}&docSubject=${intr_docSubject}&intr_modelName=${intr_modelName}&intr_modelId=${intr_modelId}&fdKey=${param.fdKey}&toEssence=${param.toEssence}&toNews=${param.toNews}&fdCateModelName=${param.fdCateModelName}'
		}
	</script>
</section>
<script>
	function intrSelected(){
		Pda.Element('introduce_panel').selected();
	}
</script>
