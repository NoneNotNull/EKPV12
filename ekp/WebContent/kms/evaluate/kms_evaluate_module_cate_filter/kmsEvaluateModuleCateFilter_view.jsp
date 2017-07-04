<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.view" sidebar="no">
	<template:replace name="toolbar">
		<ui:toolbar id="toolbar" layout="sys.ui.toolbar.float" count="5">
			<ui:button text="${lfn:message('button.refresh')}"
				onclick="Com_OpenWindow('kmsEvaluateModuleCateFilter.do?method=refresh&fdId=${param.fdId}&fdAlterTime=${kmsEvaluateModuleCateFilterForm.fdAlterTime}','_self');" order="5" />
			<kmss:auth requestURL="/kms/evaluate/kms_evaluate_module_cate_filter/kmsEvaluateModuleCateFilter.do?method=download&fdId=${param.fdId}" requestMethod="GET">
				<ui:button text="${ lfn:message('kms-evaluate:kmsEvaluateCommon.zip.download') }"
					onclick="Com_OpenWindow('kmsEvaluateModuleCateFilter.do?method=download&fdId=${param.fdId}','_self');" order="5" />
			</kmss:auth>
			<kmss:auth requestURL="/kms/evaluate/kms_evaluate_module_cate_filter/kmsEvaluateModuleCateFilter.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
				<ui:button text="${lfn:message('button.edit')}"
					onclick="Com_OpenWindow('kmsEvaluateModuleCateFilter.do?method=edit&fdId=${param.fdId}','_self');" order="5" />
			</kmss:auth>
			<kmss:auth requestURL="/kms/evaluate/kms_evaluate_module_cate_filter/kmsEvaluateModuleCateFilter.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
				<ui:button text="${lfn:message('button.delete')}"
					onclick="checkDelete('kmsEvaluateModuleCateFilter.do?method=delete&fdId=${param.fdId}');" order="5" />
			</kmss:auth>
			<ui:button text="${lfn:message('button.close')}"
				onclick="Com_CloseWindow();" order="5" />
		</ui:toolbar>
	</template:replace>
	<template:replace name="content">
	<%@ include file="/kms/evaluate/resource/jsp/kmsEvaluateGotoResult_js.jsp"%>
<p class="txttitle"><bean:message bundle="kms-evaluate" key="table.kmsEvaluateModuleCateFilter"/></p>
<center>
<div style="width:70%;text-align:left;" >
	<table>
		<tr style="line-height:30px;">
			<td width="15%"><span style="font-size:15px;color:black;"><bean:message bundle="kms-evaluate" key="kmsEvaluateCommon.docSubject"/></span></td>
			<td width="85%"><xform:text property="docSubject" /></td>
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
<table class="tb_normal" width=70% style="text-align:center">
	<tr>
		<td><bean:message bundle="kms-evaluate" key="kmsEvaluateCommon.docCategory"/></td>
		<c:if test="${kmsEvaluateModuleCateFilterForm.docAddCount==true }">
			<td><bean:message bundle="kms-evaluate" key="kmsEvaluateCommon.docAddCount"/></td>
		</c:if>
		<c:if test="${kmsEvaluateModuleCateFilterForm.docUpdateCount==true }">
			<td><bean:message bundle="kms-evaluate" key="kmsEvaluateCommon.docUpdateCount"/></td>
		</c:if>
		<c:if test="${kmsEvaluateModuleCateFilterForm.docDeleteCount==true }">
			<td><bean:message bundle="kms-evaluate" key="kmsEvaluateCommon.docDeleteCount"/></td>
		</c:if>
		<c:if test="${kmsEvaluateModuleCateFilterForm.docReadCount==true }">	
			<td><bean:message bundle="kms-evaluate" key="kmsEvaluateCommon.docReadCount"/></td>
		</c:if>	
		<c:if test="${kmsEvaluateModuleCateFilterForm.docEvaluationCount==true }">
			<td><bean:message bundle="kms-evaluate" key="kmsEvaluateCommon.docEvaluationCount"/></td>
		</c:if>
		<c:if test="${kmsEvaluateModuleCateFilterForm.docIntroduceCount==true }">
			<td><bean:message bundle="kms-evaluate" key="kmsEvaluateCommon.docIntroduceCount"/></td>
		</c:if>	
	</tr>
	<c:forEach items="${kmsEvaluateModuleCateFilterForm.fdModuleCateCountList}" var="kmsEvaluateModuleCateCountForm">
	<tr>
		<td><c:out value="${kmsEvaluateModuleCateCountForm.docCategoryName}" /></td>
		<c:if test="${kmsEvaluateModuleCateFilterForm.docAddCount==true }">
			<td><a style="cursor: pointer;" onclick="gotoResultView('add','doc','${kmsEvaluateModuleCateFilterForm.fdTimeUnit}','${kmsEvaluateModuleCateFilterForm.yearStartTime}','${kmsEvaluateModuleCateFilterForm.yearEndTime}','${kmsEvaluateModuleCateFilterForm.monthStartTime}','${kmsEvaluateModuleCateFilterForm.monthEndTime}',null,'${kmsEvaluateModuleCateCountForm.docCategoryId}',null,'${typeModel}');">
			<c:out value="${kmsEvaluateModuleCateCountForm.docAddCount}" /></a></td>
		</c:if>
		<c:if test="${kmsEvaluateModuleCateFilterForm.docUpdateCount==true }">
			<td><a style="cursor: pointer;" onclick="gotoResultView('update','doc','${kmsEvaluateModuleCateFilterForm.fdTimeUnit}','${kmsEvaluateModuleCateFilterForm.yearStartTime}','${kmsEvaluateModuleCateFilterForm.yearEndTime}','${kmsEvaluateModuleCateFilterForm.monthStartTime}','${kmsEvaluateModuleCateFilterForm.monthEndTime}',null,'${kmsEvaluateModuleCateCountForm.docCategoryId}',null,'${typeModel}');" target="_blank">
			<c:out value="${kmsEvaluateModuleCateCountForm.docUpdateCount}" /></a></td>
		</c:if>
		<c:if test="${kmsEvaluateModuleCateFilterForm.docDeleteCount==true }">
			<td><a style="cursor: pointer;" onclick="gotoResultView('delete','doc','${kmsEvaluateModuleCateFilterForm.fdTimeUnit}','${kmsEvaluateModuleCateFilterForm.yearStartTime}','${kmsEvaluateModuleCateFilterForm.yearEndTime}','${kmsEvaluateModuleCateFilterForm.monthStartTime}','${kmsEvaluateModuleCateFilterForm.monthEndTime}',null,'${kmsEvaluateModuleCateCountForm.docCategoryId}',null,'${typeModel}');">
			<c:out value="${kmsEvaluateModuleCateCountForm.docDeleteCount}" /></a></td>
		</c:if>
		<c:if test="${kmsEvaluateModuleCateFilterForm.docReadCount==true }">	
			<td><a style="cursor: pointer;" onclick="gotoResultView('read','doc','${kmsEvaluateModuleCateFilterForm.fdTimeUnit}','${kmsEvaluateModuleCateFilterForm.yearStartTime}','${kmsEvaluateModuleCateFilterForm.yearEndTime}','${kmsEvaluateModuleCateFilterForm.monthStartTime}','${kmsEvaluateModuleCateFilterForm.monthEndTime}',null,'${kmsEvaluateModuleCateCountForm.docCategoryId}',null,'${typeModel}');">
			<c:out value="${kmsEvaluateModuleCateCountForm.docReadCount}" /></a></td>
		</c:if>
		<c:if test="${kmsEvaluateModuleCateFilterForm.docEvaluationCount==true }">
			<td><a style="cursor: pointer;" onclick="gotoResultView('evaluation','doc','${kmsEvaluateModuleCateFilterForm.fdTimeUnit}','${kmsEvaluateModuleCateFilterForm.yearStartTime}','${kmsEvaluateModuleCateFilterForm.yearEndTime}','${kmsEvaluateModuleCateFilterForm.monthStartTime}','${kmsEvaluateModuleCateFilterForm.monthEndTime}',null,'${kmsEvaluateModuleCateCountForm.docCategoryId}',null,'${typeModel}');">
			<c:out value="${kmsEvaluateModuleCateCountForm.docEvaluationCount}" /></a></td>
		</c:if>
		<c:if test="${kmsEvaluateModuleCateFilterForm.docIntroduceCount==true }">
			<td><a style="cursor: pointer;" onclick="gotoResultView('introduce','doc','${kmsEvaluateModuleCateFilterForm.fdTimeUnit}','${kmsEvaluateModuleCateFilterForm.yearStartTime}','${kmsEvaluateModuleCateFilterForm.yearEndTime}','${kmsEvaluateModuleCateFilterForm.monthStartTime}','${kmsEvaluateModuleCateFilterForm.monthEndTime}',null,'${kmsEvaluateModuleCateCountForm.docCategoryId}',null,'${typeModel}');">
			<c:out value="${kmsEvaluateModuleCateCountForm.docIntroduceCount}" /></a></td>
		</c:if>
	</tr>
	</c:forEach>
</table>
</center><br/><br/>
	</template:replace>
</template:include>