<%@ include file="/resource/jsp/common.jsp"%>
<c:set var="sysEvaluationForm" value="${requestScope[param.formName]}" />
<c:set var="evaluationUrl"
		value="/sys/evaluation/sys_evaluation_main/sysEvaluationMain.do?method=add&fdModelName=${sysEvaluationForm.evaluationForm.fdModelName}&fdModelId=${sysEvaluationForm.evaluationForm.fdModelId}&fdIsNewVersion=${sysEvaluationForm.evaluationForm.fdIsNewVersion}&notifyOtherName=${param.notifyOther}&bundel=${param.bundel}&key=${param.key}" />
<kmss:auth requestURL="${evaluationUrl}" requestMethod="GET">
<iframe id="evaluationEditIfram" src="<c:url value="/sys/evaluation/sys_evaluation_main/sysEvaluationMain.do" />?method=edit4Doc&fdModelId=${sysEvaluationForm.evaluationForm.fdModelId}&fdModelName=${sysEvaluationForm.evaluationForm.fdModelName}&fdIsNewVersion=${sysEvaluationForm.evaluationForm.fdIsNewVersion}" 
	width=100% height=210 frameborder=0 scrolling=no>
</iframe>
</kmss:auth>
