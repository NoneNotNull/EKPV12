<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<c:set var="sysWfBusinessForm" value="${requestScope[param.formName]}" />
<c:set var="lbpmProcessForm" value="${sysWfBusinessForm.sysWfBusinessForm.internalForm}" />
<style type="text/css">
	.inputSgl{height: 20px;border: 0px;border-bottom: 1px solid #b4b4b4;}
	select{padding-left:0px;}
</style>
<%@ include file="/sys/lbpmservice/include/sysLbpmProcess_script.jsp"%>
<%@ include file="/sys/lbpmservice/workitem/workitem_admin.jsp"%>
<script language="JavaScript">
	lbpm.globals.includeFile("lbpmservice/node/node_common_review.js");
	var pWin = window;
	var pDom = pWin.document;
</script>
<c:if test="${param.roleType eq 'authority'}">
	<script type="text/javascript">
		var pAdminJsArr=lbpm.adminOperationsReviewJs;
		for(var i=0,size=pAdminJsArr.length;i<size;i++){
			if(pAdminJsArr[i]!="")
			lbpm.globals.includeFile(pAdminJsArr[i],"<%=request.getContextPath()%>","js");
		};
	</script>
</c:if>
<script type="text/javascript">
$(function() {
	if (!lbpm.globals.isError) {
		$("#rerunIfErrorRow").remove();
	}
});
</script>
<c:if test="${requestScope.sysWfProcess_useActionView != 'true'}">
	<c:if test="${empty param.onClickSubmitButton}">
		<form name="sysWfProcessForm" method="POST" action="<c:url value="/sys/lbpmservice/support/lbpm_process/lbpmProcess.do" />">
	</c:if>
</c:if>
<input type="hidden" id="sysWfBusinessForm.fdParameterJson" name="sysWfBusinessForm.fdParameterJson" value=''>
<input type="hidden" id="sysWfBusinessForm.fdAdditionsParameterJson" name="sysWfBusinessForm.fdAdditionsParameterJson" value=''>
<input type="hidden" id="sysWfBusinessForm.fdIsModify" name="sysWfBusinessForm.fdIsModify" value=''>
<input type="hidden" id="sysWfBusinessForm.fdCurHanderId" name="sysWfBusinessForm.fdCurHanderId" value='<c:out value="${sysWfBusinessForm.sysWfBusinessForm.fdCurHanderId}" />'>
<input type="hidden" id="sysWfBusinessForm.fdCurNodeSavedXML" name="sysWfBusinessForm.fdCurNodeSavedXML" value='<c:out value="${sysWfBusinessForm.sysWfBusinessForm.fdCurNodeSavedXML}" />'>
<input type="hidden" id="sysWfBusinessForm.fdFlowContent" name="sysWfBusinessForm.fdFlowContent" value='<c:out value="${sysWfBusinessForm.sysWfBusinessForm.fdFlowContent}" />'>
<input type="hidden" id="sysWfBusinessForm.fdProcessId" name="sysWfBusinessForm.fdProcessId" value='<c:out value="${sysWfBusinessForm.sysWfBusinessForm.fdProcessId}" />'>
<input type="hidden" id="sysWfBusinessForm.fdKey" name="sysWfBusinessForm.fdKey" value='<c:out value="${sysWfBusinessForm.sysWfBusinessForm.fdKey}" />'>
<input type="hidden" id="sysWfBusinessForm.fdModelId" name="sysWfBusinessForm.fdModelId" value='<c:out value="${sysWfBusinessForm.fdId}" />'>
<input type="hidden" id="sysWfBusinessForm.fdModelName" name="sysWfBusinessForm.fdModelName" value='<c:out value="${sysWfBusinessForm.fdModelName}" />'>
<input type="hidden" id="sysWfBusinessForm.fdCurNodeXML" name="sysWfBusinessForm.fdCurNodeXML" value='<c:out value="${sysWfBusinessForm.sysWfBusinessForm.fdCurNodeXML}" />'>
<input type="hidden" id="sysWfBusinessForm.fdTemplateModelName" name="sysWfBusinessForm.fdTemplateModelName" value='<c:out value="${sysWfBusinessForm.sysWfBusinessForm.fdTemplateModelName}" />'>
<input type="hidden" id="sysWfBusinessForm.fdTemplateKey" name="sysWfBusinessForm.fdTemplateKey" value='<c:out value="${sysWfBusinessForm.sysWfBusinessForm.fdTemplateKey}" />'>
<input type="hidden" id="sysWfBusinessForm.fdTranProcessXML" name="sysWfBusinessForm.fdTranProcessXML" value='<c:out value="${sysWfBusinessForm.sysWfBusinessForm.fdTranProcessXML}" />'>
<input type="hidden" id="sysWfBusinessForm.fdFinishedNames" name="sysWfBusinessForm.fdFinishedNames" value='<c:out value="${sysWfBusinessForm.sysWfBusinessForm.fdFinishedNames}" />'>
<input type="hidden" id="sysWfBusinessForm.fdDraftorId" name="sysWfBusinessForm.fdDraftorId" value='<c:out value="${sysWfBusinessForm.sysWfBusinessForm.fdDraftorId}" />'>
<input type="hidden" id="sysWfBusinessForm.fdDraftorName" name="sysWfBusinessForm.fdDraftorName" value='<c:out value="${sysWfBusinessForm.sysWfBusinessForm.fdDraftorName}" />'>
<input type="hidden" id="sysWfBusinessForm.fdCurHanderNames" name="sysWfBusinessForm.fdCurHanderNames" value='<c:out value="${sysWfBusinessForm.sysWfBusinessForm.fdCurHanderNames}" />'>
<input type="hidden" id="sysWfBusinessForm.fdHandlerRoleInfoIds" name="sysWfBusinessForm.fdHandlerRoleInfoIds" value='<c:out value="${sysWfBusinessForm.sysWfBusinessForm.fdHandlerRoleInfoIds}" />'>
<input type="hidden" id="sysWfBusinessForm.fdHandlerRoleInfoNames" name="sysWfBusinessForm.fdHandlerRoleInfoNames" value='<c:out value="${sysWfBusinessForm.sysWfBusinessForm.fdHandlerRoleInfoNames}" />'>
<input type="hidden" id="docStatus" name="docStatus" value='<c:out value="${sysWfBusinessForm.docStatus}" />'>
<input type="hidden" id="sysWfBusinessForm.fdIdentityId" name="sysWfBusinessForm.fdIdentityId" value='<c:out value="${sysWfBusinessForm.sysWfBusinessForm.fdIdentityId}" />'>
<input type="hidden" id="sysWfBusinessForm.fdProcessStatus" name="sysWfBusinessForm.fdProcessStatus" value='<c:out value="${sysWfBusinessForm.sysWfBusinessForm.fdProcessStatus}" />'>

<table class="tb_normal process_review_panel" width="100%">
	<c:if test="${not empty param.historyPrePage}">
		<c:import url="${param.historyPrePage}" charEncoding="UTF-8" />
	</c:if>
	<tr>
		<td class="td_normal_title" width="15%"><bean:message
				bundle="sys-lbpmservice" key="lbpmProcess.history.description" /></td>
		<td colspan="3"><span id="fdFlowDescription"></span></td>
	</tr>
	<c:if
		test="${(sysWfBusinessForm.docStatus>='20' && sysWfBusinessForm.docStatus<'30') || sysWfBusinessForm.docStatus == '40'}">
		<c:if test="${requestScope.sysWfProcess_useActionView != 'true'}">
			<%-- start action --%>
			<tr id="operationItemsRow">
				<td class="td_normal_title" width="15%"><bean:message
						bundle="sys-lbpmservice"
						key="lbpmNode.processingNode.operationItems" /></td>
				<td colspan="3"><select name="operationItemsSelect"
					onchange="lbpm.globals.operationItemsChanged(this);">
				</select></td>
			</tr>
			<tr id="operationMethodsRow">
				<td class="td_normal_title" width="15%"><bean:message
						bundle="sys-lbpmservice"
						key="lbpmNode.processingNode.operationMethods" /></td>
				<td colspan="3">
					<div id="operationMethodsGroup"
						style="float: left; margin-right: 10px;"></div>
				</td>
			</tr>
			<tr id="operationsRow" style="display: none;" lbpmMark="operation">
				<td id="operationsTDTitle" class="td_normal_title" width="15%">
					&nbsp;</td>
				<td id="operationsTDContent" colspan="3">&nbsp;</td>
			</tr>
			<tr id="operationsRow_Scope" style="display: none;"
				lbpmMark="operation">
				<td id="operationsTDTitle_Scope" class="td_normal_title" width="15%">
					&nbsp;</td>
				<td id="operationsTDContent_Scope" colspan="3">&nbsp;</td>
			</tr>
			<tr id="rerunIfErrorRow" style="display: none;" lbpmMark="hide">
				<td id="rerunIfErrorTDTitle" class="td_normal_title" width="15%">
					<kmss:message
						key="sys-lbpmservice-operation-admin:lbpmOperations.fdOperType.addition.rerunEventTitle" />
				</td>
				<td id="rerunIfErrorTDContent" colspan="3"><label
					id="rerunIfErrorLabel"> <input type="checkbox"
						id="rerunIfError" value="true"> <kmss:message
							key="sys-lbpmservice-operation-admin:lbpmOperations.fdOperType.addition.rerunEventFlag" />
				</label></td>
			</tr>

			<tr id="notifyTypeRow">
				<td class="td_normal_title" width="15%"><bean:message
						bundle="sys-lbpmservice" key="lbpmNode.currentNode.notify.type" />
				</td>
				<td colspan="3" id="systemNotifyTypeTD"><kmss:editNotifyType
						property="sysWfBusinessForm.fdSystemNotifyType"
						value="${param.notifyType}" /></td>
			</tr>
			<tr id="checkChangeFlowTR" style="display: none;">
				<td class="td_normal_title" width="15%"><bean:message
						bundle="sys-lbpmservice"
						key="lbpmNode.processingNode.changeProcessor" /></td>
				<td colspan="3"><label id="changeProcessorDIV"
					style="display: none;"> <a href="#"
						onclick="Com_EventPreventDefault();lbpm.globals.changeProcessorClick();">
							<bean:message bundle="sys-lbpmservice"
								key="lbpmNode.processingNode.changeProcessor.button" />
					</a>&nbsp;&nbsp;
				</label> <label id="modifyFlowDIV" style="display: none;"> <a
						href="javascript:lbpm.globals.modifyProcess('sysWfBusinessForm.fdFlowContent','sysWfBusinessForm.fdTranProcessXML');">
							<bean:message bundle="sys-lbpmservice"
								key="lbpmNode.currentNode.modifyFlow" />
					</a>
				</label></td>
			</tr>
			<tr id="descriptionRow">
				<td class="td_normal_title" width="15%"><bean:message
						bundle="sys-lbpmservice" key="lbpmNode.createDraft.opinion" /></td>
				<td colspan="3">
					<table width=100% border=0 class="tb_noborder">
						<tr>
							<td colspan="2"><bean:message bundle="sys-lbpmservice"
									key="lbpmNode.createDraft.commonUsages" />:&nbsp;&nbsp; <select
								name="commonUsages" onchange="lbpm.globals.setUsages(this);"
								style="width: 120px; overflow-x: hidden; padding-left: 0px;">
									<option value="">
										<bean:message key="page.firstOption" />
									</option>
							</select> <a href="javascript:;" class="com_btn_link"
								style="margin: 0 10px;"
								onclick="Com_EventPreventDefault();lbpm.globals.openDefiniateUsageWindow();">
									<bean:message bundle="sys-lbpmservice"
										key="lbpmNode.createDraft.commonUsages.definite" />
							</a></td>
						</tr>
						<tr>
							<td width="85%"><textarea name="fdUsageContent"
									class="process_review_content" alertText="" key="auditNode"></textarea>
							</td>
							<td width="15%"><input id="process_review_button"
								style="margin-left: 8px;" class="process_review_button"
								type=button value="<bean:message key="button.submit"/>"
								onclick="<%String onClickSubmitButton = request
							.getParameter("onClickSubmitButton");
					if (onClickSubmitButton == null
							|| onClickSubmitButton.length() == 0) {
						out.print("Com_Submit(document.sysWfProcessForm, 'update');");
					} else {
						out.print(onClickSubmitButton);
					}%>" />

								<script>
									$(document).ready(function() {
										if (document.forms == null || document.forms.length < 1 || window.$GetFormValidation == null) {
											return;
										}
										var validation = $GetFormValidation(document.forms[0]);
										if (validation) {
											validation.options.beforeFormValidate= function() {
												return (lbpm.currentOperationType == null
														|| (lbpm.operations[lbpm.currentOperationType] && lbpm.operations[lbpm.currentOperationType].isPassType)
												);
											};
										}
									});
									</script></td>
						</tr>
						<tr>
							<td colspan="2"><label id="currentNodeDescription"></label></td>
						</tr>
					</table>
				</td>
			</tr>

		</c:if>
		<%-- end action --%>
		<%-- 当前流程状态 --%>
		<tr id="processStatusRow" style="display: none">
			<td class="td_normal_title" width="15%"><bean:message
					bundle="sys-lbpmservice"
					key="lbpmNode.processingNode.processStatus" /></td>
			<td colspan="3"><label id="processStatusLabel"></label></td>
		</tr>
		<tr>
			<td class="td_normal_title" width="15%"><bean:message
					bundle="sys-lbpmservice"
					key="lbpmNode.processingNode.currentProcessor" /></td>
			<td colspan="3"><label id="currentHandlersLabel"></label></td>
		</tr>
		<tr>
			<td class="td_normal_title" width="15%"><bean:message
					bundle="sys-lbpmservice"
					key="lbpmNode.processingNode.finishProcessor" /></td>
			<td colspan="3"><label id="historyHandlersLabel"></label></td>
		</tr>
	</c:if>
</table>
<c:if test="${requestScope.sysWfProcess_useActionView != 'true'}">
	<c:if test="${empty param.onClickSubmitButton}">
		</form>
	</c:if>
</c:if>
<div id="subprocess_list_table_temp" style="display: none;">
	<table id="_id_" class="tb_normal" style="width: 100%;">
		<tr class="tr_normal_title">
			<td><bean:message bundle="sys-lbpmservice"
					key="lbpmNode.processingNode.adminrecover.subtitle" /></td>
			<td style="width: 26px;"><a href="javascript:void(0);"
				onclick="lbpm.globals.adminOperationTypeRecover_AddNewSubprocessRows()">
					<bean:message key="dialog.selectOther" />
			</a></td>
		</tr>
	</table>
	<input type="hidden" _key_="recoverProcessIds" id="_recoverProcessIds_"
		alertText="<bean:message bundle="sys-lbpmservice" key="lbpmNode.processingNode.adminrecover.alertText" />">
</div>
<table style="display: none;">
	<tr>
		<td id="subprocess_list_table_col_1"><input type="hidden"
			name="workflow_recover_subprocessid" value=""> <span></span>
		</td>
		<td id="subprocess_list_table_col_2"><a
			href="javascript:void(0);"
			onclick="lbpm.globals.adminOperationTypeRecover_DeleteSubprocessRow(this);">
				<bean:message bundle="sys-lbpmservice"
					key="lbpmNode.processingNode.adminrecover.delete" />
		</a></td>
	</tr>
</table>
