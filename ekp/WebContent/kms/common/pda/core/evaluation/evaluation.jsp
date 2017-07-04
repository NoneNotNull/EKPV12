<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<c:set var="sysEvaluationForm" value="${requestScope[param.formName]}" />
<c:set var="eval_modelName" value="${sysEvaluationForm.evaluationForm.fdModelName}"/>
<c:set var="eval_modelId" value="${sysEvaluationForm.evaluationForm.fdModelId}"/>
<a data-lui-role="button">
	<script type="text/config">
		{
			currentClass : 'lui-eval-icon-view',
			onclick : "evaluationSelected()",
			group : 'group1',
			text : '点评'
		}
	</script>	
</a>

<section data-lui-role="panel" id="evaluation_panel">
	<script type="text/config">
		{
			url : '${LUI_ContextPath}/kms/common/pda/core/evaluation/tmpl/evaluation.jsp?eval_modelName=${eval_modelName}&eval_modelId=${eval_modelId}'
		}
	</script>
</section>

<script>
	function evaluationSelected(){
		Pda.Element('evaluation_panel').selected();
	}
</script>
