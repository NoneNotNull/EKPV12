<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.view" sidebar="no">
	<template:replace name="toolbar">
	<ui:toolbar id="toolbar" layout="sys.ui.toolbar.float" count="5">
			<ui:button text="${lfn:message('button.refresh')}"
				onclick="Com_OpenWindow('kmsIntegralDeptFilter.do?method=refresh&fdId=${param.fdId}','_self');" order="5" />
	 		<kmss:auth requestURL="/kms/integral/kms_integral_dept_filter/kmsIntegralDeptFilter.do?method=download&fdId=${param.fdId}" requestMethod="GET">
				<ui:button text="${ lfn:message('kms-integral:kmsIntegralCommon.zip.download') }"
					onclick="Com_OpenWindow('kmsIntegralDeptFilter.do?method=download&fdId=${param.fdId}','_self');" order="5" />
			</kmss:auth>
			<kmss:auth requestURL="/kms/integral/kms_integral_dept_filter/kmsIntegralDeptFilter.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
				<ui:button text="${lfn:message('button.edit')}"
					onclick="Com_OpenWindow('kmsIntegralDeptFilter.do?method=edit&fdId=${param.fdId}','_self');" order="5" />
			</kmss:auth>
			<kmss:auth requestURL="/kms/integral/kms_integral_dept_filter/kmsIntegralDeptFilter.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
				<ui:button text="${lfn:message('button.delete')}"
					onclick="if(!confirmDelete())return;Com_OpenWindow('kmsIntegralDeptFilter.do?method=delete&fdId=${param.fdId}','_self');" order="5" />
			</kmss:auth>
			<ui:button text="${lfn:message('button.close')}"
				onclick="Com_CloseWindow();" order="5" />
		</ui:toolbar>
	</template:replace>
	<template:replace name="content">
<script>
	function confirmDelete(msg){
	var del = confirm("<bean:message key="page.comfirmDelete"/>");
	return del;
}
</script>
<%@ include file="/kms/integral/resource/jsp/kmsIntegralGotoResult_js.jsp"%>
<p class="txttitle"><bean:message bundle="kms-integral" key="table.kmsIntegralDeptFilter"/></p>

<center>
<div style="width:70%;text-align:left;" >
	<table>
		<tr style="line-height:30px;">
			<td  width="15%"><span style="font-size:15px;color:black;"><bean:message bundle="kms-integral" key="kmsIntegralCommon.docSubject"/></span></td>
			<td  width="85%"><xform:text property="docSubject" /></td>
		</tr>
		<tr>
			<td><span style="font-size:15px;color:black;"><bean:message bundle="kms-integral" key="kmsIntegralCommon.fdCountTime"/></span></td>
			<td><xform:text property="fdCountStartTime" />~<xform:text property="fdCountEndTime" /></td>
		</tr>
		<tr  style="line-height:30px;">
			<td><span style="font-size:15px;color:black;"><bean:message bundle="kms-integral" key="kmsIntegralCommon.countObject"/></span></td>
			<td><xform:text property="fdDeptNames" /></td>
		</tr>
		<tr  style="line-height:30px;">
			<td style="padding-right:20px;"><span style="font-size:15px;color:black;"><bean:message bundle="kms-integral" key="kmsIntegralCommon.lastUpdateTime"/></span></td>
			<td><xform:datetime property="docAlterTime" /></td>
		</tr>
	</table>
</div>
<table class="tb_normal" width=70% style="text-align: center;">
	<tr>
			<td><bean:message bundle="kms-integral" key="kmsIntegralCommon.countObject"/></td>
			<c:if test="${kmsIntegralDeptFilterForm.fdTotalScore==true }">
				<td><bean:message bundle="kms-integral" key="kmsIntegralCommon.fdTotalScore"/></td>
			</c:if>	
			<c:if test="${kmsIntegralDeptFilterForm.fdExpScore==true }">
				<td><bean:message bundle="kms-integral" key="kmsIntegralCommon.fdExpScore"/></td>
			</c:if>	
			<c:if test="${kmsIntegralDeptFilterForm.fdDocScore==true }">
				<td><bean:message bundle="kms-integral" key="kmsIntegralCommon.fdDocScore"/></td>
			</c:if>	
			<c:if test="${kmsIntegralDeptFilterForm.fdOtherScore==true }">
				<td><bean:message bundle="kms-integral" key="kmsIntegralCommon.fdOtherScore"/></td>
			</c:if>	
			<c:if test="${kmsIntegralDeptFilterForm.fdTotalRiches==true }">
				<td><bean:message bundle="kms-integral" key="kmsIntegralCommon.fdTotalRiches"/></td>
			</c:if>	
			<c:if test="${kmsIntegralDeptFilterForm.fdExpRiches==true }">
				<td><bean:message bundle="kms-integral" key="kmsIntegralCommon.fdExpRiches"/></td>
			</c:if>	
			<c:if test="${kmsIntegralDeptFilterForm.fdDocRiches==true }">
				<td><bean:message bundle="kms-integral" key="kmsIntegralCommon.fdDocRiches"/></td>
			</c:if>	
			<c:if test="${kmsIntegralDeptFilterForm.fdOtherRiches==true }">
				<td><bean:message bundle="kms-integral" key="kmsIntegralCommon.fdOtherRiches"/></td>
			</c:if>
	</tr>	
		<c:forEach items="${kmsIntegralDeptFilterForm.fdDeptCountList}" var="kmsIntegralDeptCountForm">
			<tr>
				<td><c:out value="${kmsIntegralDeptCountForm.fdDeptName}" /></td>
				<c:if test="${kmsIntegralDeptFilterForm.fdTotalScore==true }">	
					<td>
					<c:out value="${kmsIntegralDeptCountForm.fdTotalScore }" /></td>
				</c:if>
				<c:if test="${kmsIntegralDeptFilterForm.fdExpScore==true }">	
					<td><a style="cursor: pointer;" onclick="gotoResultView('fdExpScore','${kmsIntegralDeptFilterForm.fdTimeUnit}','${kmsIntegralDeptFilterForm.yearStartTime}','${kmsIntegralDeptFilterForm.yearEndTime}','${kmsIntegralDeptFilterForm.monthStartTime}','${kmsIntegralDeptFilterForm.monthEndTime}',null,'${kmsIntegralDeptCountForm.fdDeptId}');">
					<c:out value="${kmsIntegralDeptCountForm.fdExpScore }" /></a></td>
				</c:if>
				<c:if test="${kmsIntegralDeptFilterForm.fdDocScore==true }">	
					<td><a style="cursor: pointer;" onclick="gotoResultView('fdDocScore','${kmsIntegralDeptFilterForm.fdTimeUnit}','${kmsIntegralDeptFilterForm.yearStartTime}','${kmsIntegralDeptFilterForm.yearEndTime}','${kmsIntegralDeptFilterForm.monthStartTime}','${kmsIntegralDeptFilterForm.monthEndTime}',null,'${kmsIntegralDeptCountForm.fdDeptId}');">
					<c:out value="${kmsIntegralDeptCountForm.fdDocScore }" /></a></td>
				</c:if>
				<c:if test="${kmsIntegralDeptFilterForm.fdOtherScore==true }">	
					<td><a style="cursor: pointer;" onclick="gotoResultView('fdOtherScore','${kmsIntegralDeptFilterForm.fdTimeUnit}','${kmsIntegralDeptFilterForm.yearStartTime}','${kmsIntegralDeptFilterForm.yearEndTime}','${kmsIntegralDeptFilterForm.monthStartTime}','${kmsIntegralDeptFilterForm.monthEndTime}',null,'${kmsIntegralDeptCountForm.fdDeptId}');">
					<c:out value="${kmsIntegralDeptCountForm.fdOtherScore }" /></a></td>
				</c:if>
				<c:if test="${kmsIntegralDeptFilterForm.fdTotalRiches==true }">	
					<td>
					<c:out value="${kmsIntegralDeptCountForm.fdTotalRiches }" /></td>
				</c:if>
				<c:if test="${kmsIntegralDeptFilterForm.fdExpRiches==true }">	
					<td><a style="cursor: pointer;" onclick="gotoResultView('fdExpRiches','${kmsIntegralDeptFilterForm.fdTimeUnit}','${kmsIntegralDeptFilterForm.yearStartTime}','${kmsIntegralDeptFilterForm.yearEndTime}','${kmsIntegralDeptFilterForm.monthStartTime}','${kmsIntegralDeptFilterForm.monthEndTime}',null,'${kmsIntegralDeptCountForm.fdDeptId}');">
					<c:out value="${kmsIntegralDeptCountForm.fdExpRiches }" /></a></td>
				</c:if>
				<c:if test="${kmsIntegralDeptFilterForm.fdDocRiches==true }">	
					<td><a style="cursor: pointer;" onclick="gotoResultView('fdDocRiches','${kmsIntegralDeptFilterForm.fdTimeUnit}','${kmsIntegralDeptFilterForm.yearStartTime}','${kmsIntegralDeptFilterForm.yearEndTime}','${kmsIntegralDeptFilterForm.monthStartTime}','${kmsIntegralDeptFilterForm.monthEndTime}',null,'${kmsIntegralDeptCountForm.fdDeptId}');">
					<c:out value="${kmsIntegralDeptCountForm.fdDocRiches }" /></a></td>
				</c:if>
				<c:if test="${kmsIntegralDeptFilterForm.fdOtherRiches==true }">	
					<td><a style="cursor: pointer;" onclick="gotoResultView('fdOtherRiches','${kmsIntegralDeptFilterForm.fdTimeUnit}','${kmsIntegralDeptFilterForm.yearStartTime}','${kmsIntegralDeptFilterForm.yearEndTime}','${kmsIntegralDeptFilterForm.monthStartTime}','${kmsIntegralDeptFilterForm.monthEndTime}',null,'${kmsIntegralDeptCountForm.fdDeptId}');">
					<c:out value="${kmsIntegralDeptCountForm.fdOtherRiches }" /></a></td>
				</c:if>
			</tr>
		 </c:forEach>
</table>
</center><br/><br/>
	</template:replace>
</template:include>