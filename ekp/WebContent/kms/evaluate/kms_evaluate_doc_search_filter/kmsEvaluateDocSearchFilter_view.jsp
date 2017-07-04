<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.view" sidebar="no">
	<template:replace name="toolbar">
		<ui:toolbar id="toolbar" layout="sys.ui.toolbar.float" count="5">
			<ui:button text="${lfn:message('button.refresh')}"
				onclick="Com_OpenWindow('kmsEvaluateDocSearchFilter.do?method=refresh&fdId=${param.fdId}&fdAlterTime=${kmsEvaluateDocSearchFilterForm.fdAlterTime}','_self');" order="5" />
			<kmss:auth requestURL="/kms/evaluate/kms_evaluate_doc_search_filter/kmsEvaluateDocSearchFilter.do?method=download&fdId=${param.fdId}" requestMethod="GET">
				<ui:button text="${ lfn:message('kms-evaluate:kmsEvaluateCommon.zip.download') }"
					onclick="Com_OpenWindow('kmsEvaluateDocSearchFilter.do?method=download&fdId=${param.fdId}','_self');" order="5" />
			</kmss:auth>
			<kmss:auth requestURL="/kms/evaluate/kms_evaluate_doc_search_filter/kmsEvaluateDocSearchFilter.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
				<ui:button text="${lfn:message('button.edit')}"
					onclick="Com_OpenWindow('kmsEvaluateDocSearchFilter.do?method=edit&fdId=${param.fdId}','_self');" order="5" />
			</kmss:auth>
			<kmss:auth requestURL="/kms/evaluate/kms_evaluate_doc_search_filter/kmsEvaluateDocSearchFilter.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
				<ui:button text="${lfn:message('button.delete')}"
					onclick="checkDelete('kmsEvaluateDocSearchFilter.do?method=delete&fdId=${param.fdId}');" order="5" />
			</kmss:auth>
			<ui:button text="${lfn:message('button.close')}"
				onclick="Com_CloseWindow();" order="5" />
		</ui:toolbar>
	</template:replace>
	<template:replace name="content">
	
<%@ include file="/kms/evaluate/resource/jsp/kmsEvaluateGotoResult_js.jsp"%>
<p class="txttitle"><bean:message bundle="kms-evaluate" key="table.kmsEvaluateDocSearchFilter"/></p>
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
			<td><span style="font-size:15px;color:black;"><bean:message bundle="kms-evaluate" key="kmsEvaluateCommon.countObject"/></span></td>
			<td><xform:text property="fdDeptNames" /></td>
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
		<td><bean:message bundle="kms-evaluate" key="kmsEvaluateDocSearchCount.fdSearchCount"/></td>
		<td><bean:message bundle="kms-evaluate" key="kmsEvaluateDocSearchCount.openDocCount"/></td>
		<td><bean:message bundle="kms-evaluate" key="kmsEvaluateDocSearchCount.searchClickAVG"/></td>	
	</tr>
	<tr>
		<c:forEach items="${kmsEvaluateDocSearchFilterForm.fdDocSearchCountList}" var="kmsEvaluateDocSearchCountForm">
			<tr>
				<td><c:out value="${kmsEvaluateDocSearchCountForm.fdDeptName}" /></td>
				<td><a style="cursor: pointer;" onclick="gotoSearchResultView('searchKey','${kmsEvaluateDocSearchFilterForm.fdTimeUnit}','${kmsEvaluateDocSearchFilterForm.yearStartTime}','${kmsEvaluateDocSearchFilterForm.yearEndTime}','${kmsEvaluateDocSearchFilterForm.monthStartTime}','${kmsEvaluateDocSearchFilterForm.monthEndTime}','${kmsEvaluateDocSearchCountForm.fdDeptId}');">
					<c:out value="${kmsEvaluateDocSearchCountForm.fdSearchCount }" /></a></td>
				
				<td><a style="cursor: pointer;" onclick="gotoSearchResultView('searchDoc','${kmsEvaluateDocSearchFilterForm.fdTimeUnit}','${kmsEvaluateDocSearchFilterForm.yearStartTime}','${kmsEvaluateDocSearchFilterForm.yearEndTime}','${kmsEvaluateDocSearchFilterForm.monthStartTime}','${kmsEvaluateDocSearchFilterForm.monthEndTime}','${kmsEvaluateDocSearchCountForm.fdDeptId}');">
				<c:out value="${kmsEvaluateDocSearchCountForm.openDocCount }" /></a></td>
					
				<td><c:out value="${kmsEvaluateDocSearchCountForm.searchClickAVG }" />&nbsp;%</td>	
			</tr>
		</c:forEach>
	</tr>
</table>
</center><br/><br/>
	</template:replace>
</template:include>