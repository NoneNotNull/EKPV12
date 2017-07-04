<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<c:set var="sysWfBusinessForm" value="${requestScope[param.formName]}" />
<c:set var="lbpmProcessForm" value="${sysWfBusinessForm.sysWfBusinessForm.internalForm}" />
<%--
<c:if test="${sysWfBusinessForm.sysWfBusinessForm!=null && sysWfBusinessForm.sysWfBusinessForm.fdHandlerInfo!=''}">
--%>
<c:if test="${sysWfBusinessForm.sysWfBusinessForm!=null}">
<script type="text/javascript" src='<c:url value="/third/pda/resource/script/address.js"/>'></script>
<%@ include file="/sys/lbpmservice/include/sysLbpmProcess_script.jsp"%>

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
		<table class="tb_normal">
				<tr id="operationItemsRow">
					<td class="td_title" >
						<bean:message bundle="sys-lbpmservice" key="lbpmNode.processingNode.operationItems" />
					</td>
					<td colspan="3">
						<select name="operationItemsSelect" onchange="lbpm.globals.operationItemsChanged(this);">
						</select>
					</td>
				</tr>
				<tr style="display: none;">
					<td class="td_title" >
						<bean:message bundle="sys-lbpmservice" key="lbpmNode.processingNode.handMethods" />
					</td>
					<td colspan="3">
					<div id="operationMethodsRow"></div>
					<select id="operationMethodsGroup" view-type="select" alertText='' key='operationType' name='oprGroup'></select>
					</td>
				</tr>
				<%-- 动态加载操作--%>
				<c:forEach items="${lbpmProcessForm.curHandlerOperationsReviewJs}" var="reviewJs" varStatus="vstatus">
					<c:import url="${reviewJs}" charEncoding="UTF-8" />
				</c:forEach>
				<%-- 用于起草节点 ,显示即将流向--%>
				<tr id="manualBranchNodeRow" style="display:none">
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
				<tr id="operationsRow" style="display:none;" lbpmMark="operation">
					<td id="operationsTDTitle" class="td_title" >
						&nbsp;
					</td>
					<td id="operationsTDContent" colspan="3">
						&nbsp;
					</td>
				</tr>
				
				<%@ include file="/sys/lbpmservice/pda/sysLbpmProcess_changeProcess.jsp" %>
				
				<tr>
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
				
				<tr id="currentHandlersRow" style="display:none;">
					<td class="td_title" >
						<bean:message bundle="sys-lbpmservice" key="lbpmNode.processingNode.currentProcessor" />
					</td>
					<td colspan="3">
						<label id="currentHandlersLabel"></label>
					</td>
				</tr>
		</table>
</c:if>
