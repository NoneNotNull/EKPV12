<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.dialog">
	<template:replace name="content">
<%@ include file="/sys/lbpmservice/include/sysLbpmProcess_script.jsp"%>
<%@ include file="/sys/lbpmservice/workitem/workitem_admin.jsp"%>
<%@ include file="/sys/lbpmservice/workitem/workitem_drafter.jsp"%>
<script>
Com_Parameter.CloseInfo="<bean:message key="message.closeWindow"/>";
lbpm.globals.includeFile("lbpmservice/node/node_common_review.js");
</script>
<form name="sysWfProcessForm" method="POST" action="<c:url value="/sys/lbpmservice/support/lbpm_process/lbpmProcess.do" />">
	<input type="hidden" id="sysWfBusinessForm.fdIsModify" name="sysWfBusinessForm.fdIsModify" value='' >
	<input type="hidden" needcopy="true" id="sysWfBusinessForm.fdParameterJson" name="sysWfBusinessForm.fdParameterJson" >
	<input type="hidden" needcopy="true" id="sysWfBusinessForm.fdAdditionsParameterJson" name="sysWfBusinessForm.fdAdditionsParameterJson" >
	<input type="hidden" needcopy="true" id="sysWfBusinessForm.fdCurHanderId" name="sysWfBusinessForm.fdCurHanderId" >
	<input type="hidden" needcopy="true" id="sysWfBusinessForm.fdCurNodeSavedXML" name="sysWfBusinessForm.fdCurNodeSavedXML" >
	<input type="hidden" needcopy="true" id="sysWfBusinessForm.fdFlowContent" name="sysWfBusinessForm.fdFlowContent" >
	<input type="hidden" needcopy="true" id="sysWfBusinessForm.fdProcessId" name="sysWfBusinessForm.fdProcessId">
	<input type="hidden" needcopy="true" id="sysWfBusinessForm.fdKey" name="sysWfBusinessForm.fdKey" >
	<input type="hidden" needcopy="true" id="sysWfBusinessForm.fdModelId" name="sysWfBusinessForm.fdModelId" >
	<input type="hidden" needcopy="true" id="sysWfBusinessForm.fdModelName" name="sysWfBusinessForm.fdModelName" >
	<input type="hidden" needcopy="true" id="sysWfBusinessForm.fdCurNodeXML" name="sysWfBusinessForm.fdCurNodeXML" >
	<input type="hidden" needcopy="true" id="sysWfBusinessForm.fdTemplateModelName" name="sysWfBusinessForm.fdTemplateModelName" >
	<input type="hidden" needcopy="true" id="sysWfBusinessForm.fdTemplateKey" name="sysWfBusinessForm.fdTemplateKey" >
	<input type="hidden" needcopy="true" id="sysWfBusinessForm.fdTranProcessXML" name="sysWfBusinessForm.fdTranProcessXML" >
	<input type="hidden" needcopy="true" id="sysWfBusinessForm.fdFinishedNames" name="sysWfBusinessForm.fdFinishedNames" >
	<input type="hidden" needcopy="true" id="sysWfBusinessForm.fdDraftorId" name="sysWfBusinessForm.fdDraftorId" >
	<input type="hidden" needcopy="true" id="sysWfBusinessForm.fdDraftorName" name="sysWfBusinessForm.fdDraftorName" >
	<input type="hidden" needcopy="true" id="sysWfBusinessForm.fdCurHanderNames" name="sysWfBusinessForm.fdCurHanderNames" >
	<input type="hidden" needcopy="true" id="sysWfBusinessForm.fdHandlerRoleInfoIds" name="sysWfBusinessForm.fdHandlerRoleInfoIds" >
	<input type="hidden" needcopy="true" id="sysWfBusinessForm.fdHandlerRoleInfoNames" name="sysWfBusinessForm.fdHandlerRoleInfoNames" >
	<input type="hidden" needcopy="true" id="docStatus" name="docStatus" >

<script type="text/javascript">
lbpm.defaultOperationType = "${param.operationType}";
var dialogObject=null;
if(window.dialogArguments){
	dialogObject=window.dialogArguments;
}else if(opener && opener.Com_Parameter.Dialog){
	dialogObject=opener.Com_Parameter.Dialog;
}else{
	dialogObject=parent.dialogArguments?parent.dialogArguments:parent.opener.Com_Parameter.Dialog;
}
var pWin = dialogObject.Window;
var pDom = pWin.document;
</script>
<c:if test="${param.roleType eq 'drafter'}">
	<script type="text/javascript">
		var pDrafterJsArr=pWin.lbpm.drafterOperationsReviewJs;
		for(var i=0,size=pDrafterJsArr.length;i<size;i++){
			if(pDrafterJsArr[i]!="")
			lbpm.globals.includeFile(pDrafterJsArr[i],"<%=request.getContextPath()%>","js");
		}
	</script>
</c:if>
<c:if test="${param.roleType eq 'authority'}">
	<script type="text/javascript">
		var pAdminJsArr=pWin.lbpm.adminOperationsReviewJs;
		for(var i=0,size=pAdminJsArr.length;i<size;i++){
			if(pAdminJsArr[i]!="")
			lbpm.globals.includeFile(pAdminJsArr[i],"<%=request.getContextPath()%>","js");
		};
	</script>
</c:if>
<c:if test="${param.roleType eq 'historyhandler'}">
	<script type="text/javascript">
		var pHistoryhandlerJsArr=pWin.lbpm.historyhandlerOperationsReviewJs;
		for(var i=0,size=pHistoryhandlerJsArr.length;i<size;i++){
			if(pHistoryhandlerJsArr[i]!="")
			lbpm.globals.includeFile(pHistoryhandlerJsArr[i],"<%=request.getContextPath()%>","js");
		};
		$(document).ready(function(){
			$("#operationMethodsRow").hide(); // 历史操作选项隐藏
		});
	</script>
</c:if>
<script type="text/javascript">
function WorkFlow_SetFormField(pName, tName) {
	tName = tName ? tName : pName;
	var pField = pDom.getElementsByName(pName);
	var tField = document.getElementsByName(tName);
	if (pField.length > 0 && tField.length > 0) {
		tField[0].value = pField[0].value;
	} else {
		//alert("error!!\n pName=" + pName + "\n tName=" + tName);
	}
}
function WorkFlow_PanelInit() {
	$("[needcopy='true']").each(function() {
		WorkFlow_SetFormField(this.name);
	});
	$(function() {
		if (!pWin.lbpm.globals.isError) {
			$("#rerunIfErrorRow").remove();
		}
	});
}
WorkFlow_PanelInit();
//Com_AddEventListener(window, 'load', WorkFlow_PanelInit);
</script>
	<center>
	<ui:toolbar layout="sys.ui.toolbar.float">
		<%--input id="saveDraftButton" type=button value="<bean:message key="button.saveDraft" bundle="sys-workflow" />"
			onclick="lbpm.globals.extendRoleOptWindowSubmit('saveDraftByPanel');"--%>
		<c:if test="${(param.docStatus >= '20' && param.docStatus < '30') || param.docStatus == '11'}">
			<ui:button id="updateButton" text="${ lfn:message('sys-lbpmservice:button.update') }" styleClass="lui_toolbar_btn_gray"
				onclick="lbpm.globals.extendRoleOptWindowSubmit('updateByPanel');">
			</ui:button>
		</c:if>
		<ui:button text="${ lfn:message('button.close') }" styleClass="lui_toolbar_btn_gray" onclick="Com_CloseWindow()">
		</ui:button>
	</ui:toolbar>
	<c:if test="${(param.docStatus >= '20' && param.docStatus < '30') || param.docStatus == '11'}">
	<table class="tb_normal" width=95% style="table-layout: fixed">
			<tr id="commonUsagesRow">
				<td class="td_normal_title" width="15%">
					<bean:message bundle="sys-lbpmservice" key="lbpmNode.createDraft.commonUsages" />
				</td>
				<td colspan="3">
					<select name="commonUsages" onchange="lbpm.globals.setUsages(this);" style="width: 90px; overflow-x: hidden">
						<option value=""><bean:message key="page.firstOption" /></option>
					</select>
					<a href="#" onclick="Com_EventPreventDefault();lbpm.globals.openDefiniateUsageWindow();">
						<bean:message bundle="sys-lbpmservice" key="lbpmNode.createDraft.commonUsages.definite" />
					</a>
				</td>
			</tr>
			<tr id="descriptionRow">
				<td class="td_normal_title" width="15%">
					<bean:message bundle="sys-lbpmservice" key="lbpmNode.createDraft.opinion" />
				</td>
				<td colspan="3">
					<table width=100% border=0 class="tb_noborder">
						<tr>
							<td>
								<textarea name="fdUsageContent" class="inputMul" style="width:100%;" key="auditNode" subject="${lfn:message('sys-lbpmservice:lbpmNode.createDraft.opinion')}" validate="maxLength(2000)"></textarea>
							</td>
						</tr>
						<tr>
							<td><label id="currentNodeDescription"></label></td>
						</tr>
					</table>
				</td>
			</tr>
			<tr id="operationItemsRow">
				<td class="td_normal_title" width="15%">
					<bean:message bundle="sys-lbpmservice" key="lbpmNode.processingNode.operationItems" />
				</td>
				<td colspan="3">
					<select name="operationItemsSelect" onchange="lbpm.globals.operationItemsChanged(this);">
					</select>
				</td>
			</tr>
			<tr id="operationMethodsRow">
				<td class="td_normal_title" width="15%">
					<bean:message bundle="sys-lbpmservice" key="lbpmNode.processingNode.operationMethods" />
				</td>
				<td colspan="3">
				<div id="operationMethodsGroup"></div>
				</td>
			</tr>
			<tr id="operationsRow" style="display:none;" lbpmMark="operation">
				<td id="operationsTDTitle" class="td_normal_title" width="15%">
					&nbsp;
				</td>
				<td id="operationsTDContent" colspan="3">
					&nbsp;
				</td>
			</tr>
			<tr id="operationsRow_Scope" style="display:none;" lbpmMark="operation">
				<td id="operationsTDTitle_Scope" class="td_normal_title" width="15%">
					&nbsp;
				</td>
				<td id="operationsTDContent_Scope" colspan="3">
					&nbsp;
				</td>
			</tr>
			<tr id="rerunIfErrorRow" style="display:none;" lbpmMark="hide">
				<td id="rerunIfErrorTDTitle" class="td_normal_title" width="15%">
					<kmss:message key="sys-lbpmservice-operation-admin:lbpmOperations.fdOperType.addition.rerunEventTitle" />
				</td>
				<td id="rerunIfErrorTDContent" colspan="3">
					<label id="rerunIfErrorLabel">
					<input type="checkbox" id="rerunIfError" value="true">
					<kmss:message key="sys-lbpmservice-operation-admin:lbpmOperations.fdOperType.addition.rerunEventFlag" />
					</label>
				</td>
			</tr>
		
				<!--通知紧急程度 -->
				<tr id="notifyLevelRow">
					<td class="td_normal_title"  width="15%">
						<bean:message bundle="sys-notify" key="sysNotifyTodo.level.title" />
					</td>
					<td colspan="3" id="notifyLevelTD">
						<kmss:editNotifyLevel property="sysWfBusinessForm.fdNotifyLevel" value="" htmlElementProperties="onclick='_selectNotifyType();'"/> 
					</td>
				</tr>									
				<script>
				function _selectNotifyType(){
					var notifyLevel = 3;
					$("input[name='sysWfBusinessForm.fdNotifyLevel']:checked").each(function(i){
						notifyLevel = this.value;
					});
					var notifyTypes=["","todo;email;mobile","todo;email","todo"];
					var systemNotifyTypeTD = document.getElementById("systemNotifyTypeTD");
					if(systemNotifyTypeTD != null){
						WorkFlow_RefreshNotifyType("systemNotifyTypeTD",notifyTypes[notifyLevel]);
						var systemNotifyTypeObj = document.getElementsByName("sysWfBusinessForm.fdSystemNotifyType")[0];
						if(systemNotifyTypeObj != null){
							systemNotifyTypeObj.value =notifyTypes[notifyLevel];
						}
					}	
				}
				</script>

			<tr id="notifyTypeRow">
				<td class="td_normal_title"  width="15%">
					<bean:message bundle="sys-lbpmservice" key="lbpmNode.currentNode.notify.type" />
				</td>
				<td colspan="3" id="systemNotifyTypeTD">
					<kmss:editNotifyType property="sysWfBusinessForm.fdSystemNotifyType" value="${param.notifyType}"/> 
				</td>
			</tr>
			<c:if test="${param.roleType  eq 'drafter'}">
			<tr id="notifyOptionTR">
				<td class="td_normal_title" width="15%">
					<bean:message bundle="sys-lbpmservice" key="lbpmNode.processingNode.notifyOption" />
				</td>
				<td colspan="3">
					<label>
					<input type="checkbox" id="notifyOnFinish" value="true" alertText="" key="notifyOnFinish">
					<bean:message bundle="sys-lbpmservice" key="lbpmNode.processingNode.notifyOption.message" />
					</label>
				</td>
			</tr>
			</c:if>
			<tr id="checkChangeFlowTR" style="display:none;" lbpmMark="hide">
				<td class="td_normal_title" width="15%">
					<bean:message bundle="sys-lbpmservice" key="lbpmNode.processingNode.changeProcessor" />
				</td>
				<td colspan="3">
					<label id="changeProcessorDIV" style="display:none;">
						<a href="#" onclick="Com_EventPreventDefault();lbpm.globals.changeProcessorClick();">
							<bean:message bundle="sys-lbpmservice" key="lbpmNode.processingNode.changeProcessor.button" />
						</a>&nbsp;&nbsp;
					</label>
					<label id="modifyFlowDIV" style="display:none;">
						<a href="javascript:lbpm.globals.modifyProcess('sysWfBusinessForm.fdFlowContent','sysWfBusinessForm.fdTranProcessXML');">
							<bean:message bundle="sys-lbpmservice" key="lbpmNode.currentNode.modifyFlow" />
						</a>
					</label>
				</td>
			</tr>
			<tr id="currentHandlersRow" style="display:none;">
				<td class="td_normal_title" width="15%">
					<bean:message bundle="sys-lbpmservice" key="lbpmNode.processingNode.currentProcessor" />
				</td>
				<td colspan="3">
					<label id="currentHandlersLabel"></label>
				</td>
			</tr>
			<tr id="historyHandlersRow" style="display:none;">
				<td class="td_normal_title" width="15%">
					<bean:message bundle="sys-lbpmservice" key="lbpmNode.processingNode.finishProcessor" />
				</td>
				<td colspan="3">
					<label id="historyHandlersLabel"></label>
				</td>
			</tr>
	</table>
	</c:if>
	</center>
</form>
<div id="subprocess_list_table_temp" style="display:none;">
<table id="_id_" class="tb_normal" style="width:100%;">
	<tr class="tr_normal_title">
	<td><bean:message bundle="sys-lbpmservice" key="lbpmNode.processingNode.adminrecover.subtitle" /></td>
	<td style="width:26px;">
		<a href="javascript:void(0);" onclick="lbpm.globals.adminOperationTypeRecover_AddNewSubprocessRows()" >
		<bean:message key="dialog.selectOther" />
		</a>
	</td>
	</tr>
</table>
<input type="hidden" _key_="recoverProcessIds" id="_recoverProcessIds_"
	alertText="<bean:message bundle="sys-lbpmservice" key="lbpmNode.processingNode.adminrecover.alertText" />" >
</div>
<table style="display:none;">
	<tr>
	<td id="subprocess_list_table_col_1">
		<input type="hidden" name="workflow_recover_subprocessid" value="">
		<span></span>
	</td>
	<td id="subprocess_list_table_col_2">
		<a href="javascript:void(0);" onclick="lbpm.globals.adminOperationTypeRecover_DeleteSubprocessRow(this);" >
		<bean:message bundle="sys-lbpmservice" key="lbpmNode.processingNode.adminrecover.delete" />
		</a>
	</td>
	</tr>
</table>
	</template:replace>
</template:include>