<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.view" sidebar="no">
	<template:replace name="toolbar">
		<ui:toolbar id="toolbar" layout="sys.ui.toolbar.float" count="5">
			<ui:button text="${lfn:message('button.refresh')}"
				onclick="Com_OpenWindow('kmsEvaluateDocFilter.do?method=refresh&fdId=${param.fdId}&fdAlterTime=${kmsEvaluateDocFilterForm.fdAlterTime}','_self');" order="5" />
			<kmss:auth requestURL="/kms/evaluate/kms_evaluate_doc_filter/kmsEvaluateDocFilter.do?method=download&fdId=${param.fdId}" requestMethod="GET">
				<ui:button text="${ lfn:message('kms-evaluate:kmsEvaluateCommon.zip.download') }"
					onclick="Com_OpenWindow('kmsEvaluateDocFilter.do?method=download&fdId=${param.fdId}','_self');" order="5" />
			</kmss:auth>
			<kmss:auth requestURL="/kms/evaluate/kms_evaluate_doc_filter/kmsEvaluateDocFilter.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
				<ui:button text="${lfn:message('button.edit')}"
					onclick="Com_OpenWindow('kmsEvaluateDocFilter.do?method=edit&fdId=${param.fdId}','_self');" order="5" />
			</kmss:auth>
			<kmss:auth requestURL="/kms/evaluate/kms_evaluate_doc_filter/kmsEvaluateDocFilter.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
				<ui:button text="${lfn:message('button.delete')}"
					onclick="checkDelete('kmsEvaluateDocFilter.do?method=delete&fdId=${param.fdId}');" order="5" />
			</kmss:auth>
			<ui:button text="${lfn:message('button.close')}"
				onclick="Com_CloseWindow();" order="5" />
		</ui:toolbar>
	</template:replace>
	<template:replace name="content">
	<%@ include file="/kms/evaluate/resource/jsp/kmsEvaluateGotoResult_js.jsp"%>
<p class="txttitle"><bean:message bundle="kms-evaluate" key="table.kmsEvaluateDocFilter"/></p>

<center>
<div style="width:70%;text-align:left;" >
	<table>
		<tr style="line-height:30px;">
			<td  width="15%"><span style="font-size:15px;color:black;"><bean:message bundle="kms-evaluate" key="kmsEvaluateCommon.docSubject"/></span></td>
			<td  width="85%"><xform:text property="docSubject" /></td>
		</tr>
		<tr>
			<td><span style="font-size:15px;color:black;"><bean:message bundle="kms-evaluate" key="kmsEvaluateCommon.timeRange"/></span></td>
			<td><xform:text property="fdCountStartTime" />~<xform:text property="fdCountEndTime" /></td>
		</tr>
		<tr  style="line-height:30px;">
			<td><span style="font-size:15px;color:black;"><bean:message bundle="kms-evaluate" key="kmsEvaluateCommon.docCategory"/></span></td>
			<td><xform:text property="docCategoryNames" /></td>
		</tr>
		<tr style="line-height:30px;">
			<td><span style="font-size:15px;color:black;"><bean:message bundle="kms-evaluate" key="kmsEvaluateCommon.knowledgeType"/></span></td>
			<td>${typeName}</td>
		</tr>
		<tr  style="line-height:30px;">
			<td style="padding-right:20px;"><span style="font-size:15px;color:black;"><bean:message bundle="kms-evaluate" key="kmsEvaluateCommon.lastUpdateTime"/></span></td>
			<td><xform:datetime property="fdAlterTime" /></td>
		</tr>
	</table>
</div>
<table class="tb_normal" width=70% style="text-align: center;">
	<tr>
		<td><bean:message bundle="kms-evaluate" key="kmsEvaluateCommon.docSubject"/></td>
		<c:if test="${kmsEvaluateDocFilterForm.docReadCount==true }">
			<td><bean:message bundle="kms-evaluate" key="kmsEvaluateCommon.docReadCountNumber"/></td>
		</c:if>
		<c:if test="${kmsEvaluateDocFilterForm.docIntroduceCount==true }">
			<td><bean:message bundle="kms-evaluate" key="kmsEvaluateCommon.docEvaluationCountNumber"/></td>
		</c:if>
		<c:if test="${kmsEvaluateDocFilterForm.docEvaluationCount==true }">
			<td><bean:message bundle="kms-evaluate" key="kmsEvaluateCommon.docIntroduceCountNumber"/></td>
		</c:if>
	</tr>
	<c:forEach items="${kmsEvaluateDocFilterForm.fdDocCountList}" var="kmsEvaluateDocCountForm">
	<tr>
		<td><c:out value="${kmsEvaluateDocCountForm.docSubject}" /></td>
		<c:if test="${kmsEvaluateDocFilterForm.docReadCount==true }">
			<td><a style="cursor: pointer;" onclick="gotoResultView('read','doc','${kmsEvaluateDocFilterForm.fdTimeUnit}','${kmsEvaluateDocFilterForm.yearStartTime}','${kmsEvaluateDocFilterForm.yearEndTime}','${kmsEvaluateDocFilterForm.monthStartTime}','${kmsEvaluateDocFilterForm.monthEndTime}',null,'${kmsEvaluateDocCountForm.docCategoryId}','${kmsEvaluateDocCountForm.fdModelId}');">
			<c:out value="${kmsEvaluateDocCountForm.docReadCount}" /></a></td>
		</c:if>
		<c:if test="${kmsEvaluateDocFilterForm.docEvaluationCount==true }">
			<td><a style="cursor: pointer;" onclick="gotoResultView('evaluation','doc','${kmsEvaluateDocFilterForm.fdTimeUnit}','${kmsEvaluateDocFilterForm.yearStartTime}','${kmsEvaluateDocFilterForm.yearEndTime}','${kmsEvaluateDocFilterForm.monthStartTime}','${kmsEvaluateDocFilterForm.monthEndTime}',null,'${kmsEvaluateDocCountForm.docCategoryId}','${kmsEvaluateDocCountForm.fdModelId}');">
			<c:out value="${kmsEvaluateDocCountForm.docEvaluationCount}" /></a></td>
		</c:if>
		<c:if test="${kmsEvaluateDocFilterForm.docIntroduceCount==true }">
			<td><a style="cursor: pointer;" onclick="gotoResultView('introduce','doc','${kmsEvaluateDocFilterForm.fdTimeUnit}','${kmsEvaluateDocFilterForm.yearStartTime}','${kmsEvaluateDocFilterForm.yearEndTime}','${kmsEvaluateDocFilterForm.monthStartTime}','${kmsEvaluateDocFilterForm.monthEndTime}',null,'${kmsEvaluateDocCountForm.docCategoryId}','${kmsEvaluateDocCountForm.fdModelId}');">
			<c:out value="${kmsEvaluateDocCountForm.docIntroduceCount}" /></a></td>
		</c:if>
	</tr>
	</c:forEach>
</table>
</center><br/><br/>
	</template:replace>
</template:include>