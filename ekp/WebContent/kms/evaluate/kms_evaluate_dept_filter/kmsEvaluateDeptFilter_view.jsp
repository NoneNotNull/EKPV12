<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.view" sidebar="no">
	<template:replace name="toolbar">
		<ui:toolbar id="toolbar" layout="sys.ui.toolbar.float" count="5">
			<ui:button text="${lfn:message('button.refresh')}"
				onclick="Com_OpenWindow('kmsEvaluateDeptFilter.do?method=refresh&fdId=${param.fdId}&fdAlterTime=${kmsEvaluateDeptFilterForm.fdAlterTime}','_self');" order="5" />
			<kmss:auth requestURL="/kms/evaluate/kms_evaluate_dept_filter/kmsEvaluateDeptFilter.do?method=download&fdId=${param.fdId}" requestMethod="GET">
				<ui:button text="${ lfn:message('kms-evaluate:kmsEvaluateCommon.zip.download') }"
					onclick="Com_OpenWindow('kmsEvaluateDeptFilter.do?method=download&fdId=${param.fdId}','_self');" order="5" />
			</kmss:auth>
			<kmss:auth requestURL="/kms/evaluate/kms_evaluate_dept_filter/kmsEvaluateDeptFilter.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
				<ui:button text="${lfn:message('button.edit')}"
					onclick="Com_OpenWindow('kmsEvaluateDeptFilter.do?method=edit&fdId=${param.fdId}','_self');" order="5" />
			</kmss:auth>
			<kmss:auth requestURL="/kms/evaluate/kms_evaluate_dept_filter/kmsEvaluateDeptFilter.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
				<ui:button text="${lfn:message('button.delete')}"
					onclick="checkDelete('kmsEvaluateDeptFilter.do?method=delete&fdId=${param.fdId}');" order="5" />
			</kmss:auth>
			<ui:button text="${lfn:message('button.close')}"
				onclick="Com_CloseWindow();" order="5" />
		</ui:toolbar>
	</template:replace>
	<template:replace name="content">
	<%@ include file="/kms/evaluate/resource/jsp/kmsEvaluateGotoResult_js.jsp"%>
<p class="txttitle"><bean:message bundle="kms-evaluate" key="table.kmsEvaluateDeptFilter"/></p>
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
			<c:if test="${kmsEvaluateDeptFilterForm.docAddCount==true }">
				<td><bean:message bundle="kms-evaluate" key="kmsEvaluateCommon.docAddCountNumber"/></td>
			</c:if>	
			<c:if test="${kmsEvaluateDeptFilterForm.docUpdateCount==true }">
				<td><bean:message bundle="kms-evaluate" key="kmsEvaluateCommon.docUpdateCountNumber"/></td>
			</c:if>	
			<c:if test="${kmsEvaluateDeptFilterForm.docDeleteCount==true }">
				<td><bean:message bundle="kms-evaluate" key="kmsEvaluateCommon.docDeleteCountNumber"/></td>
			</c:if>	
			<c:if test="${kmsEvaluateDeptFilterForm.docReadCount==true }">
				<td><bean:message bundle="kms-evaluate" key="kmsEvaluateCommon.docReadCountNumber"/></td>
			</c:if>
			<c:if test="${kmsEvaluateDeptFilterForm.docEvaluationCount==true }">
				<td><bean:message bundle="kms-evaluate" key="kmsEvaluateCommon.docEvaluationCountNumber"/></td>
			</c:if>
			<c:if test="${kmsEvaluateDeptFilterForm.docIntroduceCount==true }">
				<td><bean:message bundle="kms-evaluate" key="kmsEvaluateCommon.docIntroduceCountNumber"/></td>
			</c:if>	
		</tr>
		<c:forEach items="${kmsEvaluateDeptFilterForm.fdDeptCountList}" var="kmsEvaluateDeptCountForm">
			<tr>
				<td><c:out value="${kmsEvaluateDeptCountForm.fdDeptName}" /></td>
				<c:if test="${kmsEvaluateDeptFilterForm.docAddCount==true }">	
					<td><a style="cursor: pointer;" onclick="gotoResultView('add','doc','${kmsEvaluateDeptFilterForm.fdTimeUnit}','${kmsEvaluateDeptFilterForm.yearStartTime}','${kmsEvaluateDeptFilterForm.yearEndTime}','${kmsEvaluateDeptFilterForm.monthStartTime}','${kmsEvaluateDeptFilterForm.monthEndTime}','${kmsEvaluateDeptCountForm.fdDeptId}');">
					<c:out value="${kmsEvaluateDeptCountForm.docAddCount }" /></a></td>
				</c:if>
				<c:if test="${kmsEvaluateDeptFilterForm.docUpdateCount==true }">	
					<td><a style="cursor: pointer;" onclick="gotoResultView('update','doc','${kmsEvaluateDeptFilterForm.fdTimeUnit}','${kmsEvaluateDeptFilterForm.yearStartTime}','${kmsEvaluateDeptFilterForm.yearEndTime}','${kmsEvaluateDeptFilterForm.monthStartTime}','${kmsEvaluateDeptFilterForm.monthEndTime}','${kmsEvaluateDeptCountForm.fdDeptId}');">
					<c:out value="${kmsEvaluateDeptCountForm.docUpdateCount }" /></a></td>
				</c:if>		
				<c:if test="${kmsEvaluateDeptFilterForm.docDeleteCount==true }">	
					<td><a style="cursor: pointer;" onclick="gotoResultView('delete','doc','${kmsEvaluateDeptFilterForm.fdTimeUnit}','${kmsEvaluateDeptFilterForm.yearStartTime}','${kmsEvaluateDeptFilterForm.yearEndTime}','${kmsEvaluateDeptFilterForm.monthStartTime}','${kmsEvaluateDeptFilterForm.monthEndTime}','${kmsEvaluateDeptCountForm.fdDeptId}');">
					<c:out value="${kmsEvaluateDeptCountForm.docDeleteCount }" /></a></td>
				</c:if>	
				<c:if test="${kmsEvaluateDeptFilterForm.docReadCount==true }">
					<td><a style="cursor: pointer;" onclick="gotoResultView('read','doc','${kmsEvaluateDeptFilterForm.fdTimeUnit}','${kmsEvaluateDeptFilterForm.yearStartTime}','${kmsEvaluateDeptFilterForm.yearEndTime}','${kmsEvaluateDeptFilterForm.monthStartTime}','${kmsEvaluateDeptFilterForm.monthEndTime}','${kmsEvaluateDeptCountForm.fdDeptId}');">
					<c:out value="${kmsEvaluateDeptCountForm.docReadCount}" /></a></td>
				</c:if>		
				<c:if test="${kmsEvaluateDeptFilterForm.docEvaluationCount==true }">
					<td><a style="cursor: pointer;" onclick="gotoResultView('evaluation','doc','${kmsEvaluateDeptFilterForm.fdTimeUnit}','${kmsEvaluateDeptFilterForm.yearStartTime}','${kmsEvaluateDeptFilterForm.yearEndTime}','${kmsEvaluateDeptFilterForm.monthStartTime}','${kmsEvaluateDeptFilterForm.monthEndTime}','${kmsEvaluateDeptCountForm.fdDeptId}');">
					<c:out value="${kmsEvaluateDeptCountForm.docEvaluationCount}" /></a></td>
				</c:if>		
				<c:if test="${kmsEvaluateDeptFilterForm.docIntroduceCount==true }">
					<td><a style="cursor: pointer;" onclick="gotoResultView('introduce','doc','${kmsEvaluateDeptFilterForm.fdTimeUnit}','${kmsEvaluateDeptFilterForm.yearStartTime}','${kmsEvaluateDeptFilterForm.yearEndTime}','${kmsEvaluateDeptFilterForm.monthStartTime}','${kmsEvaluateDeptFilterForm.monthEndTime}','${kmsEvaluateDeptCountForm.fdDeptId}');">
					<c:out value="${kmsEvaluateDeptCountForm.docIntroduceCount}" /></a></td>
				</c:if>	
			</tr>
		</c:forEach>
	</table>
</center><br/><br/>
	</template:replace>
</template:include>