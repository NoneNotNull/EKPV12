<%@ include file="/resource/jsp/common.jsp"%>
<c:set var="sysEvaluationForm" value="${requestScope[param.formName]}" />
<script>
	function evaluation_LoadIframe(){
		Doc_LoadFrame("evaluationContent", '<c:url value="/sys/evaluation/sys_evaluation_main/sysEvaluationMain.do" />?method=list&rowsize=10&forward=list4Doc&fdModelId=${sysEvaluationForm.evaluationForm.fdModelId}&fdModelName=${sysEvaluationForm.evaluationForm.fdModelName}');
	}
</script>
<c:if test="${sysEvaluationForm.evaluationForm.fdIsShow=='true'}">
	<tr LKS_LabelName="<bean:message bundle="sys-evaluation" key="sysEvaluationMain.tab.evaluation.label" />${sysEvaluationForm.evaluationForm.fdEvaluateCount}" style="display:none">
		<td>
			<table class="tb_normal" width="100%">
				<tr>
					<td id="evaluationContent" onresize="evaluation_LoadIframe();">
						<iframe src="" width=100% height=100% frameborder=0 scrolling=no id="evaluationListIfram">
						</iframe>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</c:if>
