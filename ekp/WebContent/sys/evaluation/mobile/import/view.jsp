<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<c:set var="sysEvaluationForm" value="${requestScope[param.formName]}" />
<c:if test="${sysEvaluationForm.evaluationForm.fdIsShow=='true'}">
	<c:set var="_eval_count" value=""/>
	<c:if test="${sysEvaluationForm.evaluationForm.fdEvaluateCount!=null && sysEvaluationForm.evaluationForm.fdEvaluateCount!=''}">
		<c:set var="_eval_count" value="${sysEvaluationForm.evaluationForm.fdEvaluateCount}"/>
		<c:set var="_eval_count" value="${fn:replace(_eval_count,'(','')}"/>
		<c:set var="_eval_count" value="${fn:replace(_eval_count,')','')}"/>
	</c:if>
	<li data-dojo-type="mui/tabbar/TabBarButton"
		data-dojo-props='icon1:"mui mui-eval",align:"${param.align}",
			badge:"${_eval_count}",
			href:"/sys/evaluation/mobile/index.jsp?modelName=${sysEvaluationForm.modelClass.name}&modelId=${sysEvaluationForm.fdId}&isNotify=${param.isNotify}"'></li>
</c:if>
