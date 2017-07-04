<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<c:set var="sysEvaluationForm" value="${requestScope[param.formName]}" />
<c:if test="${sysEvaluationForm.evaluationForm.fdIsShow=='true'}">
	<script>
		seajs.use(['${KMSS_Parameter_ContextPath}sys/evaluation/import/resource/eval.css']);
	</script>
	<div class="eval_doc_score">
		<span class="eval_score_mark">${sysEvaluationForm.evaluationForm.fdEvaluateScore}</span>
		<span class="eval_score lui_icon_s_starbad"></span>
		<span class="eval_score_val lui_icon_s_stargood" 
			  style="width:${60*(sysEvaluationForm.evaluationForm.fdEvaluateScore/5)}px;"></span> 
	</div>
</c:if>

