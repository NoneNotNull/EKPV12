<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<c:set var="sysWfBusinessForm" value="${requestScope[param.formName]}" />
<c:set var="lbpmProcessForm" value="${sysWfBusinessForm.sysWfBusinessForm.internalForm}" />
<%@page import="com.landray.kmss.third.pda.util.PdaFlagUtil"%>
<%@page import="com.landray.kmss.util.ResourceUtil"%>
<c:if test="${sysWfBusinessForm.sysWfBusinessForm!=null}">
<script type="text/javascript" src='<c:url value="/third/pda/resource/script/address.js"/>'></script>
<%@ include file="/sys/lbpmservice/include/sysLbpmProcess_script.jsp"%>
<%
   request.setAttribute("pdaflag",ResourceUtil.getString("lbpm.process.pda.log.from."+PdaFlagUtil.getPdaClientType(request),"sys-lbpmservice"));
%>
<script>
$(function() {
	Com_Parameter.event["submit"][Com_Parameter.event["submit"].length] = function() {
		var auditNodeObj = lbpm.operations.getfdUsageContent();
		if(auditNodeObj) {
			auditNodeObj.value  = auditNodeObj.value + '${pdaflag}';
			lbpm.globals.setOperationParameterJson(auditNodeObj,"auditNote", "param");
		}
		return true;
	};
});
</script>


		<c:if test="${requestScope.sysWfProcess_useActionView != 'true'}">
		<c:if test="${empty param.onClickSubmitButton}">
		<form name="sysWfProcessForm" method="POST"
				action="<c:url value="/sys/lbpmservice/support/lbpm_process/lbpmProcess.do" />" autocomplete="off">
		</c:if>
		</c:if>
		<input type="hidden" id="sysWfBusinessForm.fdParameterJson" name="sysWfBusinessForm.fdParameterJson" value='' >
		<input type="hidden" id="sysWfBusinessForm.fdAdditionsParameterJson" name="sysWfBusinessForm.fdAdditionsParameterJson" value='' >
		<input type="hidden" id="sysWfBusinessForm.fdIsModify" name="sysWfBusinessForm.fdIsModify" value='' >
		<input type="hidden" id="sysWfBusinessForm.fdCurHanderId" name="sysWfBusinessForm.fdCurHanderId" value='<c:out value="${sysWfBusinessForm.sysWfBusinessForm.fdCurHanderId}" />' >
		<input type="hidden" id="sysWfBusinessForm.fdCurNodeSavedXML" name="sysWfBusinessForm.fdCurNodeSavedXML" value='<c:out value="${sysWfBusinessForm.sysWfBusinessForm.fdCurNodeSavedXML}" />' >
		<input type="hidden" id="sysWfBusinessForm.fdFlowContent" name="sysWfBusinessForm.fdFlowContent" value='<c:out value="${sysWfBusinessForm.sysWfBusinessForm.fdFlowContent}" />' >
		<input type="hidden" id="sysWfBusinessForm.fdProcessId" name="sysWfBusinessForm.fdProcessId" value='<c:out value="${sysWfBusinessForm.sysWfBusinessForm.fdProcessId}" />'>
		<input type="hidden" id="sysWfBusinessForm.fdKey" name="sysWfBusinessForm.fdKey" value='<c:out value="${sysWfBusinessForm.sysWfBusinessForm.fdKey}" />' >
		<input type="hidden" id="sysWfBusinessForm.fdModelId" name="sysWfBusinessForm.fdModelId" value='<c:out value="${sysWfBusinessForm.fdId}" />' >
		<input type="hidden" id="sysWfBusinessForm.fdModelName" name="sysWfBusinessForm.fdModelName" value='<c:out value="${sysWfBusinessForm.modelClass.name}" />' >
		<input type="hidden" id="sysWfBusinessForm.fdCurNodeXML" name="sysWfBusinessForm.fdCurNodeXML" value='<c:out value="${sysWfBusinessForm.sysWfBusinessForm.fdCurNodeXML}" />' >
		<input type="hidden" id="sysWfBusinessForm.fdTemplateModelName" name="sysWfBusinessForm.fdTemplateModelName" value='<c:out value="${sysWfBusinessForm.sysWfBusinessForm.fdTemplateModelName}" />' >
		<input type="hidden" id="sysWfBusinessForm.fdTemplateKey" name="sysWfBusinessForm.fdTemplateKey" value='<c:out value="${sysWfBusinessForm.sysWfBusinessForm.fdTemplateKey}" />' >
		<input type="hidden" id="sysWfBusinessForm.fdTranProcessXML" name="sysWfBusinessForm.fdTranProcessXML" value='<c:out value="${sysWfBusinessForm.sysWfBusinessForm.fdTranProcessXML}" />' >
		<input type="hidden" id="sysWfBusinessForm.fdFinishedNames" name="sysWfBusinessForm.fdFinishedNames" value='<c:out value="${sysWfBusinessForm.sysWfBusinessForm.fdFinishedNames}" />' >
		<input type="hidden" id="sysWfBusinessForm.fdDraftorId" name="sysWfBusinessForm.fdDraftorId" value='<c:out value="${sysWfBusinessForm.sysWfBusinessForm.fdDraftorId}" />' >
		<input type="hidden" id="sysWfBusinessForm.fdDraftorName" name="sysWfBusinessForm.fdDraftorName" value='<c:out value="${sysWfBusinessForm.sysWfBusinessForm.fdDraftorName}" />' >
		<input type="hidden" id="sysWfBusinessForm.fdCurHanderNames" name="sysWfBusinessForm.fdCurHanderNames" value='<c:out value="${sysWfBusinessForm.sysWfBusinessForm.fdCurHanderNames}" />' >
		<input type="hidden" id="sysWfBusinessForm.fdHandlerRoleInfoIds" name="sysWfBusinessForm.fdHandlerRoleInfoIds" value='<c:out value="${sysWfBusinessForm.sysWfBusinessForm.fdHandlerRoleInfoIds}" />' >
		<input type="hidden" id="sysWfBusinessForm.fdHandlerRoleInfoNames" name="sysWfBusinessForm.fdHandlerRoleInfoNames" value='<c:out value="${sysWfBusinessForm.sysWfBusinessForm.fdHandlerRoleInfoNames}" />' >
		<input type="hidden" id="sysWfBusinessForm.fdAuditNoteFdId" name="sysWfBusinessForm.fdAuditNoteFdId" value='<c:out value="${sysWfBusinessForm.sysWfBusinessForm.fdAuditNoteFdId}" />' >
		<input type="hidden" id="docStatus" name="docStatus" value='<c:out value="${sysWfBusinessForm.docStatus}" />' >
		<input type="hidden" id="sysWfBusinessForm.fdIdentityId" name="sysWfBusinessForm.fdIdentityId" value='<c:out value="${sysWfBusinessForm.sysWfBusinessForm.fdIdentityId}" />' >
		<table class="tb_normal" width="100%">
			<c:if test="${(sysWfBusinessForm.docStatus>='20' && sysWfBusinessForm.docStatus<'30') || sysWfBusinessForm.docStatus == '11'}">
				<c:if test="${sysWfBusinessForm.sysWfBusinessForm.fdIsHander == 'true'}"><%-- start action --%>
				<tr id="operationItemsRow">
					<td class="td_title" >
						<bean:message bundle="sys-lbpmservice" key="lbpmNode.processingNode.operationItems" />
					</td>
					<td colspan="3">
						<select name="operationItemsSelect" onchange="lbpm.globals.operationItemsChanged(this);">
						</select>
					</td>
				</tr>
				<tr id="operationMethodsRow">
					<td class="td_title" >
						<bean:message bundle="sys-lbpmservice" key="lbpmNode.processingNode.handMethods" />
					</td>
					<td colspan="3">
					<select id="operationMethodsGroup" view-type="select" alertText='' key='operationType' name='oprGroup'></select>
					</td>
				</tr>
				<%-- 动态加载操作--%>
				<c:forEach items="${lbpmProcessForm.curHandlerOperationsReviewJs}" var="reviewJs" varStatus="vstatus">
					<c:import url="${reviewJs}" charEncoding="UTF-8" />
				</c:forEach>
				<%-- 用于起草节点 ,显示即将流向--%>
				<c:if test="${sysWfBusinessForm.docStatus == null || sysWfBusinessForm.docStatus<'20'}">
					<tr style="display:none;">
						<td class="td_title" >
							<bean:message bundle="sys-lbpmservice" key="lbpmNode.createDraft.manualNodeSelect" />
						</td>
						<td colspan="3" id="manualNodeSelectTD">
							&nbsp;
						</td>
					</tr>
					<tr style="display:none;">
						<td class="td_title" >
							<bean:message bundle="sys-lbpmservice" key="lbpmNode.createDraft.nextNode" />
						</td>
						<td colspan="3" id="nextNodeTD">
							&nbsp;
						</td>
					</tr>
				</c:if>
				<tr id="operationsRow" style="display:none;" lbpmMark="operation">
					<td id="operationsTDTitle" class="td_title" >
						&nbsp;
					</td>
					<td id="operationsTDContent" colspan="3">
						&nbsp;
					</td>
				</tr>
				<tr id="operationsRow_Scope" style="display:none;" lbpmMark="operation">
					<td id="operationsTDTitle_Scope" class="td_title" >
						&nbsp;
					</td>
					<td id="operationsTDContent_Scope" colspan="3">
						&nbsp;
					</td>
				</tr>
				
				<%@ include file="/sys/lbpmservice/pda/sysLbpmProcess_changeProcess.jsp" %>
				
				<%-- 审批意见扩展使用 --%>
				<c:import url="/sys/lbpmservice/support/lbpm_audit_note/lbpmAuditNote_ext.jsp" charEncoding="UTF-8">
					<c:param name="auditNoteFdId" value="${sysWfBusinessForm.sysWfBusinessForm.fdAuditNoteFdId}" />
					<c:param name="modelName" value="${sysWfBusinessForm.modelClass.name}" />
					<c:param name="modelId" value="${sysWfBusinessForm.fdId}" />
					<c:param name="formName" value="${param.formName}" />
					<c:param name="provideFor" value="pda" />
				</c:import>
				
				<tr id = "commonUsagesRow">
					<td class="td_title" >
						<bean:message bundle="sys-lbpmservice" key="lbpmNode.createDraft.commonUsages" />
					</td>
					<td colspan="3">
						<select name="commonUsages" onchange="lbpm.globals.setUsages(this);" style="max-width: 90%;">
						<option value=""><bean:message key="page.firstOption" /></option>
						</select>
					</td>
				</tr>
				<tr id="descriptionRow">
					<td class="td_title" >
						<bean:message bundle="sys-lbpmservice" key="lbpmNode.createDraft.opinion" />
					</td>
					<td colspan="3">
						<textarea name="fdUsageContent" class="inputMul" style="width:100%;" key="auditNode" subject="${lfn:message('sys-lbpmservice:lbpmNode.createDraft.opinion')}" validate="maxLength(2000)"></textarea>
					</td>
				</tr>
				
				<tr>
					<td align="center" colspan="4">
						<input class="btnopt" id="updateButton" type=button value="<bean:message key="button.update" bundle="sys-lbpmservice"/>"
							onclick="<%String onClickSubmitButton = request.getParameter("onClickSubmitButton");
							if (onClickSubmitButton == null || onClickSubmitButton.length() == 0) {
								out.print("Com_Submit(document.sysWfProcessForm, 'update');");
							} else {
								out.print(onClickSubmitButton);
							}%>">
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
						</script>
					</td>
				</tr>
				
				</c:if><%-- end action --%>
				
				<tr id="currentHandlersRow" style="display:none;">
					<td class="td_title" >
						<bean:message bundle="sys-lbpmservice" key="lbpmNode.processingNode.currentProcessor" />
					</td>
					<td colspan="3">
						<label id="currentHandlersLabel"></label>
					</td>
				</tr>
			</c:if>
			<c:if test="${sysWfBusinessForm.sysWfBusinessForm.fdFlowContent != null && sysWfBusinessForm.sysWfBusinessForm.fdFlowContent != ''}">
				<tr style="cursor: pointer;" onclick="Com_OpenWindow('<c:url value="/sys/lbpmservice/pda/sysLbpmProcess_flowchart.jsp?processId=${sysWfBusinessForm.fdId}"/>','_self');">
					<td class="td_title">
						<div style="margin:5px 0px;font-weight: bolder;color:black;">
							<bean:message bundle="sys-lbpmservice" key="lbpm.process.pda.chart.show"/>
						</div>
					</td>
					<td colspan="3">
						<div style="margin-top:5px; height:16px;width: 100%;" class="cateItemData"></div>
					</td>
				</tr>
			</c:if>
			<c:if test="${param.showlog != 'false' }">
				<tr class="tr_extendTitle">
					<td class="td_title">
						<bean:message bundle="sys-lbpmservice" key="lbpmProcess.history.title" />
					</td>
					<td colspan="3">&nbsp;</td>
				</tr>
			<%@ include file="/sys/lbpmservice/pda/sysLbpmProcess_log.jsp" %>
			</c:if>
		</table>
	<c:if test="${empty param.onClickSubmitButton}">
	</form>
	</c:if>
</c:if>
