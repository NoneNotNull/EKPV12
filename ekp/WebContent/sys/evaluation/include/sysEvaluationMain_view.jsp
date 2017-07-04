<%@ include file="/resource/jsp/common.jsp"%>
<c:set var="sysEvaluationForm" value="${requestScope[param.formName]}" />
<c:if test="${sysEvaluationForm.evaluationForm.fdIsShow=='true'}">
	<c:set var="evaluationUrl"
		value="/sys/evaluation/sys_evaluation_main/sysEvaluationMain.do?method=add&fdModelName=${sysEvaluationForm.evaluationForm.fdModelName}&fdModelId=${sysEvaluationForm.evaluationForm.fdModelId}&fdIsNewVersion=${sysEvaluationForm.evaluationForm.fdIsNewVersion}&notifyOtherName=${param.notifyOther}&bundel=${param.bundel}&key=${param.key}" />
	<div id="evaluationBtn" style="display:none;">
		<kmss:auth requestURL="${evaluationUrl}" requestMethod="GET">
			<input type="button" value="<bean:message key="sysEvaluationMain.button.evaluation" bundle="sys-evaluation"/>"
				onclick="Com_OpenWindow('<c:url value="${evaluationUrl}" />','_blank');">
		</kmss:auth>
	</div>
	<script language="JavaScript">
		Com_IncludeFile("optbar.js");
	</script>
	<script>
		OptBar_AddOptBar("evaluationBtn");
		function evaluation_LoadIframe(){
			Doc_LoadFrame("evaluationContent", '<c:url value="/sys/evaluation/sys_evaluation_main/sysEvaluationMain.do" />?method=list&fdModelId=${sysEvaluationForm.evaluationForm.fdModelId}&fdModelName=${sysEvaluationForm.evaluationForm.fdModelName}');
		}
	</script>

	<c:if test="${param.isNews ne 'yes'}">
		<tr LKS_LabelName="<bean:message bundle="sys-evaluation" key="sysEvaluationMain.tab.evaluation.label" />${sysEvaluationForm.evaluationForm.fdEvaluateCount}" style="display:none">
			<td>
				<table class="tb_normal" width="100%">
					<tr>
						<td id="evaluationContent" onresize="evaluation_LoadIframe();">
							<iframe src="" width=100% height=100% frameborder=0 scrolling=no style="min-height: 100px;">
							</iframe>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</c:if>
	<c:if test="${param.isNews eq 'yes'}">
		<table width="100%">
			<tr><td>
		<iframe src="<c:url value="/sys/evaluation/sys_evaluation_main/sysEvaluationMain.do" />?method=list&rowsize=10&forward=newsList&fdModelId=${sysEvaluationForm.evaluationForm.fdModelId}&fdModelName=${sysEvaluationForm.evaluationForm.fdModelName}" width=100% height=100% frameborder=0 scrolling=no>
		</iframe>
			</td></tr>
				<input type="hidden" name="_disReviewDisFlag" value="false">
		</table>			
	</c:if>
</c:if>

