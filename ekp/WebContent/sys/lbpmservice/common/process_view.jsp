<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<c:set var="sysWfBusinessForm" value="${requestScope[param.formName]}" />
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
		<input type="hidden" id="sysWfBusinessForm.fdProcessStatus" name="sysWfBusinessForm.fdProcessStatus" value='<c:out value="${sysWfBusinessForm.sysWfBusinessForm.fdProcessStatus}" />' >
		
		<table class="tb_normal process_review_panel" width="100%">
			<c:if test="${not empty param.historyPrePage}">
				<c:import url="${param.historyPrePage}" charEncoding="UTF-8"/>
			</c:if>
			<c:if test="${(sysWfBusinessForm.docStatus>='20' && sysWfBusinessForm.docStatus<'30') || sysWfBusinessForm.docStatus == '11'}">
				<c:if test="${requestScope.sysWfProcess_useActionView != 'true'}">
				<tr class="tr_normal_title" id="extendRoleOptRow">
					<td align="right" colspan="4">
						<c:if test="${sysWfBusinessForm.docStatus!='21'}">
						<span id="historyhandlerOpt" style="display:none;"></span>
						<a href="javascript:void(0);" id="drafterOptButton" class="com_btn_link" style="display:none; margin: 0 10px 0 0;"
							onclick="lbpm.globals.openExtendRoleOptWindow('drafter');">
							<bean:message key="lbpmNode.processingNode.identifyRole.button.drafter" bundle="sys-lbpmservice" />
						</a>
						</c:if>
						<a href="javascript:void(0);" id="authorityOptButton" class="com_btn_link" style="display:none; margin: 0 10px 0 0;"
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
				<td colspan="3">
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
				<td colspan="4" id="historyInfoTableTD" ${resize_prefix}onresize="lbpm.load_Frame();" style="padding: 0;">
					<iframe id="historyInfoTableIframe" width="100%" style="margin-bottom: -4px;border: none;" scrolling="no" FRAMEBORDER=0></iframe>
				</td>
			</tr>
			</c:if>
			<c:if test="${(sysWfBusinessForm.docStatus>='20' && sysWfBusinessForm.docStatus<'30') || sysWfBusinessForm.docStatus == '11'}">
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

				<!--通知紧急程度 -->
				<tr id="notifyLevelRow">
					<td class="td_normal_title"  width="15%">
						<bean:message bundle="sys-notify" key="sysNotifyTodo.level.title" />
					</td>
					<td colspan="3" id="notifyLevelTD">
						<c:if test="${sysWfBusinessForm.docStatus=='11'}">
						<!--文档驳回后，起草人的重新提交页面 紧急度和提交选项 请左对齐-->
						<nobr></nobr> 
						</c:if>
						<kmss:editNotifyLevel property="sysWfBusinessForm.fdNotifyLevel" value="" htmlElementProperties="onclick='_selectNotifyType();'"/> 
					</td>
				</tr>									
				<script>
				<%
				String emergencyDefaultNotifyType = new com.landray.kmss.sys.notify.model.SysNotifyConfig().getEmergencyDefaultNotifyType();
				String urgencyDefaultNotifyType = new com.landray.kmss.sys.notify.model.SysNotifyConfig().getUrgencyDefaultNotifyType();
				String generalDefaultNotifyType = new com.landray.kmss.sys.notify.model.SysNotifyConfig().getGeneralDefaultNotifyType();
				if(StringUtil.isNull(emergencyDefaultNotifyType)){
					emergencyDefaultNotifyType="todo;email;mobile";
				}
				if(StringUtil.isNull(urgencyDefaultNotifyType)){
					urgencyDefaultNotifyType="todo;email";
				}
				if(StringUtil.isNull(generalDefaultNotifyType)){
					generalDefaultNotifyType="todo";
				}
				%>
				function _selectNotifyType(){
					var notifyLevel = 3;
					$("input[name='sysWfBusinessForm.fdNotifyLevel']:checked").each(function(i){
						notifyLevel = this.value;
					});
					var notifyTypes=["","<%=emergencyDefaultNotifyType%>","<%=urgencyDefaultNotifyType%>","<%=generalDefaultNotifyType%>"];
					var systemNotifyTypeTD = document.getElementById("systemNotifyTypeTD");
					if(systemNotifyTypeTD != null){
						WorkFlow_RefreshNotifyType("systemNotifyTypeTD",notifyTypes[notifyLevel]);
						var systemNotifyTypeObj = document.getElementsByName("sysWfBusinessForm.fdSystemNotifyType")[0];
						if(systemNotifyTypeObj != null){
							systemNotifyTypeObj.value =notifyTypes[notifyLevel];
						}
					}	
				}

				$(document).ready( function() {
					 _selectNotifyType();
				});
				</script>

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
				<tr id="descriptionRow">
					<td class="td_normal_title" width="15%">
						<bean:message bundle="sys-lbpmservice" key="lbpmNode.createDraft.opinion" />
					</td>
					<td colspan="3">
						<table width=100% border=0 class="tb_noborder">
							<tr>
								<td id="optionButtons" colspan="2">
									<bean:message bundle="sys-lbpmservice" key="lbpmNode.createDraft.commonUsages" />:&nbsp;&nbsp;
									<select name="commonUsages" onchange="lbpm.globals.setUsages(this);" style="width: 120px; overflow-x: hidden">
										<option value="">
											<bean:message key="page.firstOption" />
										</option>
									</select>
									<a href="javascript:;" class="com_btn_link" style="margin: 0 10px;" onclick="Com_EventPreventDefault();lbpm.globals.openDefiniateUsageWindow();">
										<bean:message bundle="sys-lbpmservice" key="lbpmNode.createDraft.commonUsages.definite" />
									</a>
									<c:if test="${sysWfBusinessForm.docStatus>='20'}">
										<a href="javascript:;" class="com_btn_link" id="saveDraftButton" onclick="lbpm.globals.saveDraftAction(this);">
											<bean:message key="button.saveDraft" bundle="sys-lbpmservice" />
										</a>
									</c:if>
								</td>
							</tr>
							<tr>
								<td width="85%">
									<textarea name="fdUsageContent" class="process_review_content" key="auditNode" subject="${lfn:message('sys-lbpmservice:lbpmNode.createDraft.opinion')}" validate="maxLength(2000)"></textarea>
								</td>
								<td width="15%">
									<input id="process_review_button" style="margin-left: 8px;" class="process_review_button" type=button value="<bean:message key="button.submit"/>"
										onclick="<%String onClickSubmitButton = request.getParameter("onClickSubmitButton");
										if (onClickSubmitButton == null || onClickSubmitButton.length() == 0) {
											out.print("Com_Submit(document.sysWfProcessForm, 'update');");
										} else {
											out.print(onClickSubmitButton);
										}%>"/>
										
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
							<tr>
								<td colspan="2"><label id="currentNodeDescription"></label></td>
							</tr>
						</table>
					</td>
				</tr>
				<c:import url="/sys/lbpmservice/support/lbpm_audit_note/lbpmAuditNote_ext.jsp" charEncoding="UTF-8">
					<c:param name="auditNoteFdId" value="${sysWfBusinessForm.sysWfBusinessForm.fdAuditNoteFdId}" />
					<c:param name="modelName" value="${sysWfBusinessForm.modelClass.name}" />
					<c:param name="modelId" value="${sysWfBusinessForm.fdId}" />
					<c:param name="formName" value="${param.formName}" />
					<c:param name="provideFor" value="pc" />
				</c:import>
				<tr id="assignmentRow" style="display:none;">
					<td class="td_normal_title" width="15%">
						<bean:message bundle="sys-lbpmservice" key="lbpmNode.processingNode.assignment" />
					</td>
					<td colspan="3">
						<!-- Attachments -->
						<table class="tb_noborder" width="100%">
							<tr>
								<td>
									<c:import
										url="/sys/attachment/sys_att_main/sysAttMain_edit.jsp"
										charEncoding="UTF-8">
										<c:param
											name="fdKey"
											value="${sysWfBusinessForm.sysWfBusinessForm.fdAuditNoteFdId}" />
										<c:param
											name="formBeanName"
											value="${param.formName}"/>
										<c:param
											name="fdModelName"
											value="${sysWfBusinessForm.modelClass.name}"/>
										<c:param
											name="fdModelId"
											value="${sysWfBusinessForm.fdId}"/>
									</c:import>
								</td>
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
			<%-- 
			<c:import url="/sys/lbpmservice/common/process_ext.jsp" charEncoding="UTF-8">
				<c:param name="modelName" value="${sysWfBusinessForm.modelClass.name}" />
				<c:param name="modelId" value="${sysWfBusinessForm.fdId}" />
				<c:param name="formName" value="${param.formName}" />
			</c:import> 
			--%>
			
			<c:if test="${sysWfBusinessForm.sysWfBusinessForm.fdFlowContent != null && sysWfBusinessForm.sysWfBusinessForm.fdFlowContent != ''}">
			<tr class="tr_normal_title">
				<td align="left" colspan="4">
					<label><input type="checkbox" id="flowGraphicShowCheckbox" value="true" onclick="this.checked ? $('#flowGraphic').show() : $('#flowGraphic').hide();">
					<bean:message bundle="sys-lbpmservice" key="lbpm.tab.graphic" /></label>
				</td>
			</tr>
			<tr id="flowGraphic" style="display:none">
				<td id="workflowInfoTD" ${resize_prefix}onresize="lbpm.flow_chart_load_Frame();" colspan="4">
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
					$('#flowGraphicShowCheckbox').bind('click', function() {
						$('#workflowInfoTD').each(function() {
							var str = this.getAttribute('onresize');
							if (str) {
								(new Function(str))();
							}
						});
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
												<a href="javascript:;" class="com_btn_link" onclick="Com_EventPreventDefault();lbpm.globals.changeProcessorClick();">
													<bean:message bundle="sys-lbpmservice" key="lbpmNode.processingNode.changeProcessor.button" />
												</a>&nbsp;&nbsp;
											</label>
											<label id="modifyFlowDIV" style="display:none;">
												<a class="com_btn_link" href="javascript:lbpm.globals.modifyProcess('sysWfBusinessForm.fdFlowContent','sysWfBusinessForm.fdTranProcessXML');">
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
											<a href="javascript:;" class="com_btn_link" onclick="lbpm.globals.selectNotionNodes();"><bean:message key="dialog.selectOther" /></a>
										</td>
									</tr>
									<tr id="otherCanViewCurNodeTR" style="display:none;">
										<td class="td_normal_title" width="15%"><bean:message bundle="sys-lbpmservice" key="lbpmSupport.curNodeotherCanViewCurNode" /></td>
										<td>
											<input type="hidden" name="wf_otherCanViewCurNodeIds">
											<textarea name="wf_otherCanViewCurNodeNames" style="width:85%" readonly></textarea>
											<a href="javascript:;" class="com_btn_link" onclick="Dialog_Address(true,'wf_otherCanViewCurNodeIds','wf_otherCanViewCurNodeNames', ';',ORG_TYPE_ALL,function myFunc(rtv){lbpm.globals.updateXml(rtv,'otherCanViewCurNode');});"><bean:message key="dialog.selectOther" /></a>
										</td>
									</tr>
								</table>	
							</td>
						</tr>
						<tr LKS_LabelName="<bean:message bundle="sys-lbpmservice" key="lbpm.tab.table" />" style="display:none">
							<td id="workflowTableTD" ${resize_prefix}onresize="lbpm.flow_table_load_Frame();">
								<iframe width="100%" height="100%" scrolling="no" id="${sysWfBusinessFormPrefix}WF_TableIFrame" FRAMEBORDER=0></iframe>
							</td>
						</tr>
						</c:if>
						<tr LKS_LabelName="<bean:message bundle="sys-lbpmservice" key="label.flowLog" />" style="display:none">
							<td  id="flowLogTableTD" ${resize_prefix}onresize="lbpm.flow_log_load_Frame();">
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


