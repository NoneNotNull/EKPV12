<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<script>
	function confirmDelete(msg){
	var del = confirm("<bean:message key="page.comfirmDelete"/>");
	return del;
}
</script>
<div id="optBarDiv">
	<kmss:auth requestURL="/kms/evaluate/kms_evaluate_doc_detail/kmsEvaluateDocDetail.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.edit"/>"
			onclick="Com_OpenWindow('kmsEvaluateDocDetail.do?method=edit&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<kmss:auth requestURL="/kms/evaluate/kms_evaluate_doc_detail/kmsEvaluateDocDetail.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.delete"/>"
			onclick="checkDelete('kmsEvaluateDocDetail.do?method=delete&fdId=${param.fdId}');">
	</kmss:auth>
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="kms-evaluate" key="table.kmsEvaluateDocDetail"/></p>

<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-evaluate" key="kmsEvaluateDocDetail.countId"/>
		</td><td width="35%">
			<xform:text property="countId" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-evaluate" key="kmsEvaluateDocDetail.docReadCount"/>
		</td><td width="35%">
			<xform:text property="docReadCount" style="width:85%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-evaluate" key="kmsEvaluateDocDetail.docEvaluationCount"/>
		</td><td width="35%">
			<xform:text property="docEvaluationCount" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-evaluate" key="kmsEvaluateDocDetail.docIntroduceCount"/>
		</td><td width="35%">
			<xform:text property="docIntroduceCount" style="width:85%" />
		</td>
	</tr>
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>