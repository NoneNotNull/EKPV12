<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.view" sidebar="no">
	<template:replace name="toolbar">
		<ui:toolbar id="toolbar" layout="sys.ui.toolbar.float" count="5">
			<ui:button text="${lfn:message('button.refresh')}"
				onclick="Com_OpenWindow('kmsEvaluateAskCFilter.do?method=refresh&fdId=${param.fdId}&fdAlterTime=${kmsEvaluateAskCFilterForm.fdAlterTime}','_self');" order="5" />
			<kmss:auth requestURL="/kms/evaluate/kms_evaluate_ask_c_filter/kmsEvaluateAskCFilter.do?method=download&fdId=${param.fdId}" requestMethod="GET">
				<ui:button text="${ lfn:message('kms-evaluate:kmsEvaluateCommon.zip.download') }"
					onclick="Com_OpenWindow('kmsEvaluateAskCFilter.do?method=download&fdId=${param.fdId}','_self');" order="5" />
			</kmss:auth>
			<kmss:auth requestURL="/kms/evaluate/kms_evaluate_ask_c_filter/kmsEvaluateAskCFilter.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
				<ui:button text="${lfn:message('button.edit')}"
					onclick="Com_OpenWindow('kmsEvaluateAskCFilter.do?method=edit&fdId=${param.fdId}','_self');" order="5" />
			</kmss:auth>
			<kmss:auth requestURL="/kms/evaluate/kms_evaluate_ask_c_filter/kmsEvaluateAskCFilter.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
				<ui:button text="${lfn:message('button.delete')}"
					onclick="checkDelete('kmsEvaluateAskCFilter.do?method=delete&fdId=${param.fdId}');" order="5" />
			</kmss:auth>
			<ui:button text="${lfn:message('button.close')}"
				onclick="Com_CloseWindow();" order="5" />
		</ui:toolbar>
	</template:replace>
	<template:replace name="content">
	<%@ include file="/kms/evaluate/resource/jsp/kmsEvaluateGotoResult_js.jsp"%>
	

<p class="txttitle"><bean:message bundle="kms-evaluate" key="table.kmsEvaluateAskCFilter"/></p>
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
		<tr  style="line-height:30px;">
			<td style="padding-right:20px;"><span style="font-size:15px;color:black;"><bean:message bundle="kms-evaluate" key="kmsEvaluateCommon.lastUpdateTime"/></span></td>
			<td><xform:datetime property="fdAlterTime" /></td>
		</tr>
	</table>
</div>

	<table class="tb_normal" width=70% style="text-align:center">
		<tr>
			<td><bean:message bundle="kms-evaluate" key="kmsEvaluateCommon.countObject"/></td>
			<td><bean:message bundle="kms-evaluate" key="kmsEvaluateAskDeptCount.fdTopicCount"/></td>
			<td><bean:message bundle="kms-evaluate" key="kmsEvaluateAskDeptCount.fdPostCount"/></td>
			<td><bean:message bundle="kms-evaluate" key="kmsEvaluateAskDeptCount.fdSolveRate"/></td>
		</tr>
		<c:forEach items="${kmsEvaluateAskCFilterForm.fdAskCCountList}" var="kmsEvaluateAskCCountForm">
			<tr>
				<td>
					<c:out value="${kmsEvaluateAskCCountForm.docCategoryName}" />
				</td>
				<td>
					<a style="cursor: pointer;" onclick="gotoResultView('add','addAsk','${kmsEvaluateAskCFilterForm.fdTimeUnit}','${kmsEvaluateAskCFilterForm.yearStartTime}','${kmsEvaluateAskCFilterForm.yearEndTime}','${kmsEvaluateAskCFilterForm.monthStartTime}','${kmsEvaluateAskCFilterForm.monthEndTime}',null,'${kmsEvaluateAskCCountForm.docCategoryId}',null);">
					<c:out value="${kmsEvaluateAskCCountForm.fdTopicCount}" /></a>
				</td>
				<td>
					<a style="cursor: pointer;" onclick="gotoResultView('add','postAsk','${kmsEvaluateAskCFilterForm.fdTimeUnit}','${kmsEvaluateAskCFilterForm.yearStartTime}','${kmsEvaluateAskCFilterForm.yearEndTime}','${kmsEvaluateAskCFilterForm.monthStartTime}','${kmsEvaluateAskCFilterForm.monthEndTime}',null,'${kmsEvaluateAskCCountForm.docCategoryId}',null);">
					<c:out value="${kmsEvaluateAskCCountForm.fdPostCount}" /></a>
				</td>
				<td><c:out value="${kmsEvaluateAskCCountForm.fdSolveRate}" />&nbsp;%</td>
			</tr>
		</c:forEach>
	</table>
</center><br/><br/>
	</template:replace>
</template:include>