<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page errorPage="/resource/jsp/jsperror.jsp" %>
<%@ include file="/sys/config/resource/htmlhead.jsp" %>

<script type="text/javascript">
Com_IncludeFile("document.js", "style/"+Com_Parameter.Style+"/doc/");
Com_IncludeFile("docutil.js|optbar.js");
</script>
</head>
<body>
<c:set var="sysWfBusinessForm" value="${lbpmProcessMainForm}" />
<c:set var="lbpmProcessForm" value="${sysWfBusinessForm.sysWfBusinessForm.internalForm}" />

<%@ include file="/sys/lbpmservice/include/sysLbpmProcess_script.jsp"%> 
		<c:if test="${requestScope.sysWfProcess_useActionView != 'true'}">
		<c:if test="${empty param.onClickSubmitButton}">
		<form name="sysWfProcessForm" method="POST"
				action="<c:url value="/sys/lbpmservice/support/lbpm_process/lbpmProcess.do" />">
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
		<input type="hidden" id="sysWfBusinessForm.fdModelName" name="sysWfBusinessForm.fdModelName" value='<c:out value="${sysWfBusinessForm.sysWfBusinessForm.fdModelName}" />' >
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
		<input type="hidden" id="sysWfBusinessForm.fdProcessStatus" name="sysWfBusinessForm.fdProcessStatus" value='<c:out value="${sysWfBusinessForm.sysWfBusinessForm.fdProcessStatus}" />' >
		
		<table class="tb_normal process_review_panel" width="100%">
			<c:if test="${not empty param.historyPrePage}">
				<c:import url="${param.historyPrePage}" charEncoding="UTF-8"/>
			</c:if>
			<c:if test="${(sysWfBusinessForm.docStatus>='20' && sysWfBusinessForm.docStatus<'30') || sysWfBusinessForm.docStatus == '11'}">
				<c:if test="${requestScope.sysWfProcess_useActionView != 'true'}">
				<tr class="tr_normal_title" id="extendRoleOptRow">
					<td align="right" colspan="4">
						<span id="historyhandlerOpt" style="display:none;"></span>
						<a href="javascript:void(0);" id="drafterOptButton" class="lui_view_doc_operation" style="display:none; margin: 0 10px 0 0;"
							onclick="lbpm.globals.openExtendRoleOptWindow('drafter');">
							<bean:message key="lbpmNode.processingNode.identifyRole.button.drafter" bundle="sys-lbpmservice" />
						</a>
						<a href="javascript:void(0);" id="authorityOptButton" class="lui_view_doc_operation" style="display:none; margin: 0 10px 0 0;"
							onclick="lbpm.globals.openExtendRoleOptWindow('authority');">
							<bean:message key="lbpmNode.processingNode.identifyRole.button.authority" bundle="sys-lbpmservice" />
						</a>
					</td>
				</tr>
				</c:if>
			</c:if>
			<tr>
				<td class="td_normal_title" width="15%">
					<bean:message bundle="sys-lbpmservice" key="lbpmProcess.history.description" />
				</td>
				<td colspan=3>
					<span id="fdFlowDescription"></span>	 
				</td>
			</tr>
			<c:if test="${not empty sysWfBusinessForm.docStatus}">
			<tr class="tr_normal_title">
				<td align="left" colspan="4">
					<label><input type="checkbox" value="true" checked onclick="lbpm.globals.showHistoryDisplay(this);">
					<bean:message bundle="sys-lbpmservice" key="lbpmProcess.history.description.show" /></label>
				</td>
			</tr>
			
			<tr id="historyTableTR">
				<td colspan=4 id="historyInfoTableTD" onresize="lbpm.load_Frame();" style="padding: 0;">
					<iframe id="historyInfoTableIframe" width="100%" style="margin-bottom: -4px;border: none;" scrolling="no" FRAMEBORDER=0></iframe>
				</td>
			</tr>
			<script>
				$(document).ready(function() {
					lbpm.load_Frame();
				});
			</script>
			</c:if>
			<c:if test="${(sysWfBusinessForm.docStatus>='20' && sysWfBusinessForm.docStatus<'30') || sysWfBusinessForm.docStatus == '11' ||sysWfBusinessForm.docStatus=='10'}">
				<c:if test="${requestScope.sysWfProcess_useActionView != 'true'}"><%-- start action --%>
				<tr id="operationItemsRow">
					<td class="td_normal_title" width="15%">
						<bean:message bundle="sys-lbpmservice" key="lbpmNode.processingNode.operationItems" />
					</td>
					<td colspan="3">
						<select name="operationItemsSelect" onchange="lbpm.globals.operationItemsChanged(this);">
						</select>
					</td>
				</tr>
				<%-- 起草人选择人工分支节点 --%>
				<c:if test="${sysWfBusinessForm.docStatus == null || sysWfBusinessForm.docStatus<'20'}">
					<tr id="manualBranchNodeRow" style="display:none">
						<td class="td_normal_title" width="15%">
							<bean:message bundle="sys-lbpmservice" key="lbpmNode.createDraft.manualNodeSelect" />
						</td>
						<td colspan="3" id="manualNodeSelectTD">
	
						</td>
					</tr>
				</c:if>
				<tr id="operationMethodsRow">
					<td class="td_normal_title" width="15%">
						<bean:message bundle="sys-lbpmservice" key="lbpmNode.processingNode.operationMethods" />
					</td>
					<td colspan="3">
					<div id="operationMethodsGroup" style="float: left; margin-right: 10px;"></div>
					</td>
				</tr>
				<%-- 动态加载操作--%>
				<c:forEach items="${lbpmProcessForm.curHandlerOperationsReviewJs}" var="reviewJs" varStatus="vstatus">
					<c:import url="${reviewJs}" charEncoding="UTF-8" />
				</c:forEach>
				<%-- 用于起草节点 ,显示即将流向--%>
				<c:if test="${sysWfBusinessForm.docStatus == null || sysWfBusinessForm.docStatus<'20'}">
					<tr style="display:none;">
						<td class="td_normal_title" width="15%">
							<bean:message bundle="sys-lbpmservice" key="lbpmNode.createDraft.nextNode" />
						</td>
						<td colspan="3" id="nextNodeTD">
							&nbsp;
						</td>
					</tr>
				</c:if>
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
			    <!-- 审批意见 提交处理框 -->
				<tr id="descriptionRow">
					<td class="td_normal_title" width="15%">
						<bean:message bundle="sys-lbpmservice" key="lbpmNode.createDraft.opinion" />
					</td>
					<td colspan="3">
						<table width=100% border=0 class="tb_noborder">
							<tr>
								<td colspan="2">
									<bean:message bundle="sys-lbpmservice" key="lbpmNode.createDraft.commonUsages" />:&nbsp;&nbsp;
									<select name="commonUsages" onchange="lbpm.globals.setUsages(this);" style="width: 120px; overflow-x: hidden">
									<option value=""><bean:message key="page.firstOption" /></option>
									</select>
									<a href="#" class="lui_view_doc_operation" style="margin: 0 10px;" onclick="Com_EventPreventDefault();lbpm.globals.openDefiniateUsageWindow();">
									<bean:message bundle="sys-lbpmservice" key="lbpmNode.createDraft.commonUsages.definite" />
									</a>
									<a href="#" class="lui_view_doc_operation" id="saveDraftButton" onclick="lbpm.globals.saveDraftAction(this);">
									<bean:message key="button.saveDraft" bundle="sys-lbpmservice" />
									</a>
								</td>
							</tr>
							<tr>
								<td width="85%">
									<textarea name="fdUsageContent" class="process_review_content" key="auditNode" subject="${lfn:message('sys-lbpmservice:lbpmNode.createDraft.opinion')}" validate="maxLength(2000)"></textarea>
								</td>
								<td width="15%">
								    <%-- //屏蔽掉提交按钮  作者 曹映辉 #日期 2013年11月13日
									<input id="process_review_button" style="margin-left: 8px;" class="process_review_button" type=button value="<bean:message key="button.submit"/>"
										onclick="<%String onClickSubmitButton = request.getParameter("onClickSubmitButton");
										if (onClickSubmitButton == null || onClickSubmitButton.length() == 0) {
											out.print("Com_Submit(document.sysWfProcessForm, 'update');");
										} else {
											out.print(onClickSubmitButton);
										}%>"/>
										
									--%>
								</td>
							</tr>
							<tr>
								<td colspan="2"><label id="currentNodeDescription"></label></td>
							</tr>
						</table>
					</td>
				</tr>
				
				
				
				</c:if><%-- end action --%>
				<%-- 当前流程状态 --%>
				<tr id="processStatusRow" style="display:none">
					<td class="td_normal_title" width="15%">
						<bean:message bundle="sys-lbpmservice" key="lbpmNode.processingNode.processStatus" />
					</td>
					<td colspan="3">
						<label id="processStatusLabel"></label>
					</td>
				</tr>
				<tr id="currentHandlersRow" style="display:none">
					<td class="td_normal_title" width="15%">
						<bean:message bundle="sys-lbpmservice" key="lbpmNode.processingNode.currentProcessor" />
					</td>
					<td colspan="3">
						<label id="currentHandlersLabel"></label>
					</td>
				</tr>
				<tr id="historyHandlersRow" style="display:none">
					<td class="td_normal_title" width="15%">
						<bean:message bundle="sys-lbpmservice" key="lbpmNode.processingNode.finishProcessor" />
					</td>
					<td colspan="3">
						<label id="historyHandlersLabel"></label>
					</td>
				</tr>
			</c:if>
			
			<%-- 扩展使用 --%>
			<c:import url="/sys/lbpmservice/common/process_ext.jsp" charEncoding="UTF-8">
				<c:param name="modelName" value="${sysWfBusinessForm.modelClass.name}" />
				<c:param name="modelId" value="${sysWfBusinessForm.fdId}" />
				<c:param name="formName" value="${param.formName}" />
			</c:import>
			
			<c:if test="${sysWfBusinessForm.sysWfBusinessForm.fdFlowContent != null && sysWfBusinessForm.sysWfBusinessForm.fdFlowContent != ''}">
			<tr class="tr_normal_title">
				<td align="left" colspan="4">
					<label><input type="checkbox" value="true" onclick="this.checked ? $('#flowGraphic').show() : $('#flowGraphic').hide();">
					<bean:message bundle="sys-lbpmservice" key="lbpm.tab.graphic" /></label>
				</td>
			</tr>
			<tr id="flowGraphic" style="display:none">
				<td id="workflowInfoTD" onresize="lbpm.flow_chart_load_Frame();" colspan="4">
					<iframe width="100%" height="100%" scrolling="no" id="${sysWfBusinessFormPrefix}WF_IFrame"></iframe>
					<script>
					$("#${sysWfBusinessFormPrefix}WF_IFrame").ready(function() {
						var lbpm_panel_reload = function() {
							$("#${sysWfBusinessFormPrefix}WF_IFrame").attr('src', function (i, val) {return val;});
						};
						lbpm.events.addListener(lbpm.constant.EVENT_MODIFYNODEATTRIBUTE, lbpm_panel_reload);
						lbpm.events.addListener(lbpm.constant.EVENT_MODIFYPROCESS, lbpm_panel_reload);
						lbpm.events.addListener(lbpm.constant.EVENT_SELECTEDMANUAL, lbpm_panel_reload);
					});
					</script>
				</td>
			</tr>
			</c:if>
			<tr class="tr_normal_title">
				<td align="left" colspan="4">
					<label><input type="checkbox" value="true" onclick="lbpm.globals.showDetails(checked);">
					<bean:message bundle="sys-lbpmservice" key="lbpmNode.currentNode.details" /></label>
				</td>
			</tr>
			<tr id="showDetails" style="display:none">
				<td colspan="4">
					<table id="Label_Tabel_Workflow_Info" width=100%>
						<c:if test="${sysWfBusinessForm.sysWfBusinessForm.fdFlowContent != null && sysWfBusinessForm.sysWfBusinessForm.fdFlowContent != ''}">
						<tr id="lbpm_highLevelTab" LKS_LabelName="<bean:message bundle="sys-lbpmservice" key="label.highLevel" />" style="display:none">
							<td>
								<table class="tb_normal" width=100%>
									<c:if test="${(sysWfBusinessForm.docStatus>='20' && sysWfBusinessForm.docStatus<'30') || sysWfBusinessForm.docStatus == '11'}">
									<c:if test="${requestScope.sysWfProcess_useActionView != 'true'}">
									<tr id="notifyTypeRow">
										<td class="td_normal_title"  width="15%">
											<bean:message bundle="sys-lbpmservice" key="lbpmNode.currentNode.notify.type" />
										</td>
										<td colspan="3" id="systemNotifyTypeTD">
											<kmss:editNotifyType property="sysWfBusinessForm.fdSystemNotifyType" value=""/> 
										</td>
									</tr>
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
									<tr id="checkChangeFlowTR" style="display:none;">
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
									</c:if>
									</c:if>
									<tr id="nodeCanViewCurNodeTR" style="display:none;">
										<td class="td_normal_title" width="15%"><bean:message bundle="sys-lbpmservice" key="lbpmSupport.curNodeCanViewCurNode" /></td>
										<td>
											<input type="hidden" name="wf_nodeCanViewCurNodeIds">
											<textarea name="wf_nodeCanViewCurNodeNames" style="width:85%" readonly></textarea>
											<a href="#" onclick="lbpm.globals.selectNotionNodes();"><bean:message key="dialog.selectOther" /></a>
										</td>
									</tr>
									<tr id="otherCanViewCurNodeTR" style="display:none;">
										<td class="td_normal_title" width="15%"><bean:message bundle="sys-lbpmservice" key="lbpmSupport.curNodeotherCanViewCurNode" /></td>
										<td>
											<input type="hidden" name="wf_otherCanViewCurNodeIds">
											<textarea name="wf_otherCanViewCurNodeNames" style="width:85%" readonly></textarea>
											<a href="#" onclick="Dialog_Address(true,'wf_otherCanViewCurNodeIds','wf_otherCanViewCurNodeNames', ';',ORG_TYPE_ALL,function myFunc(rtv){lbpm.globals.updateXml(rtv,'otherCanViewCurNode');});"><bean:message key="dialog.selectOther" /></a>
										</td>
									</tr>
								</table>	
							</td>
						</tr>
						<tr LKS_LabelName="<bean:message bundle="sys-lbpmservice" key="lbpm.tab.table" />" style="display:none">
							<td id="workflowTableTD" onresize="lbpm.flow_table_load_Frame();">
								<iframe width="100%" height="100%" scrolling="no" id="${sysWfBusinessFormPrefix}WF_TableIFrame" FRAMEBORDER=0></iframe>
							</td>
						</tr>
						</c:if>
						<tr LKS_LabelName="<bean:message bundle="sys-lbpmservice" key="label.flowLog" />" style="display:none">
							<td colspan="6" id="flowLogTableTD" onresize="lbpm.flow_log_load_Frame();">
								<iframe width="100%" height="100%" scrolling="no" FRAMEBORDER=0></iframe>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	<c:if test="${requestScope.sysWfProcess_useActionView != 'true'}">
	<c:if test="${empty param.onClickSubmitButton}">
	</form>
	</c:if>
	</c:if>

</body>
</html>

<script>
//获取表单相关数据
lbpm_getApprovalInfo=function()
{
	var elems = document.getElementsByName("sysWfProcessForm")[0].elements;
	var obj = {};
	for (var j = 0, m = elems.length; j < m; j ++) {
		if (elems[j].name != null) {
			obj[elems[j].name]=$(elems[j]).val();
		}
	}
	var text = JSON.stringify(obj);

	return  text;
};
//表单校验函数
lbpm_validateProcess=function()
{
	return lbpm.globals.submitFormEvent();
}
//异构系统出发自动过滤分支
lbpm_reloadProcess = function()
{
	FlowChart_Operation_FilterNodes();
}


</script>
