<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<script>
	function confirmDelete(msg){
	var del = confirm("<bean:message key="page.comfirmDelete"/>");
	return del;
}
</script>
<div id="optBarDiv">
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>
<p class="txttitle">
	<bean:message bundle="sys-evaluation" key="table.sysEvaluationMain" />
</p>
<center>
	<table class="tb_normal" width=95%>
		<tr>
			<td class="td_normal_title" width=15%>
				<bean:message bundle="sys-evaluation" key="sysEvaluationMain.sysEvaluator" />
			</td>
			<td width=85%>
				<bean:write name="sysEvaluationMainForm" property="fdEvaluatorName" />
			</td>
		</tr>
		<tr>
			<td class="td_normal_title">
				<bean:message bundle="sys-evaluation" key="sysEvaluationMain.fdEvaluationTime" />
			</td>
			<td>
				<bean:write name="sysEvaluationMainForm" property="fdEvaluationTime" />
			</td>
		</tr>
		<tr>
			<td class="td_normal_title">
				<bean:message bundle="sys-evaluation" key="sysEvaluationMain.fdEvaluationScore" />
			</td>
			<td>
				<sunbor:enumsShow value="${sysEvaluationMainForm.fdEvaluationScore}" enumsType="sysEvaluation_Score"></sunbor:enumsShow>
			</td>
		</tr>
		<tr>
			<td class="td_normal_title">
				<bean:message bundle="sys-evaluation" key="sysEvaluationMain.fdEvaluationContent" />
			</td>
			<td>
				<kmss:showText value="${sysEvaluationMainForm.fdEvaluationContent}" />
			</td>
		</tr>
	</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>
