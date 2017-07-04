<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<c:set var="sysWfBusinessForm" value="${requestScope[param.formName]}" />
<c:set var="lbpmProcessForm" value="${sysWfBusinessForm.sysWfBusinessForm.internalForm}" />

<%@ include file="/sys/lbpmservice/include/sysLbpmProcess_script.jsp"%>
<input type="hidden" name="sysWfBusinessForm.fdParameterJson" value="" id="sysWfBusinessForm.fdParameterJson">
<input type="hidden" name="sysWfBusinessForm.fdAdditionsParameterJson" value="" id="sysWfBusinessForm.fdAdditionsParameterJson">
<input type="hidden" name="sysWfBusinessForm.fdIsModify" value='' id="sysWfBusinessForm.fdIsModify">
<html:hidden property="sysWfBusinessForm.fdCurHanderId"  styleId="sysWfBusinessForm.fdCurHanderId" />
<html:hidden property="sysWfBusinessForm.fdCurNodeSavedXML"  styleId="sysWfBusinessForm.fdCurNodeSavedXML" />
<html:hidden property="sysWfBusinessForm.fdFlowContent"  styleId="sysWfBusinessForm.fdFlowContent"  />
<html:hidden property="sysWfBusinessForm.fdProcessId"  styleId="sysWfBusinessForm.fdProcessId"  />
<html:hidden property="sysWfBusinessForm.fdKey"  styleId="sysWfBusinessForm.fdKey" />
<input type="hidden" name="sysWfBusinessForm.fdModelId" id="sysWfBusinessForm.fdModelId" value='<c:out value="${sysWfBusinessForm.fdId}" />' >
<input type="hidden" name="sysWfBusinessForm.fdModelName" id="sysWfBusinessForm.fdModelName" value='<c:out value="${sysWfBusinessForm.modelClass.name}" />' >
<html:hidden property="sysWfBusinessForm.fdCurNodeXML"  styleId="sysWfBusinessForm.fdCurNodeXML" />
<html:hidden property="sysWfBusinessForm.fdTemplateModelName"  styleId="sysWfBusinessForm.fdTemplateModelName"/>
<html:hidden property="sysWfBusinessForm.fdTemplateKey" styleId="sysWfBusinessForm.fdTemplateKey"/>
<input type="hidden" name="sysWfBusinessForm.canStartProcess" id="sysWfBusinessForm.canStartProcess" value='' >
<html:hidden property="sysWfBusinessForm.fdTranProcessXML" styleId="sysWfBusinessForm.fdTranProcessXML"/>
<html:hidden property="sysWfBusinessForm.fdFinishedNames" styleId="sysWfBusinessForm.fdFinishedNames"/>
<html:hidden property="sysWfBusinessForm.fdDraftorId" styleId="sysWfBusinessForm.fdDraftorId"/>
<html:hidden property="sysWfBusinessForm.fdDraftorName" styleId="sysWfBusinessForm.fdDraftorName"/>
<html:hidden property="sysWfBusinessForm.fdCurHanderNames" styleId="sysWfBusinessForm.fdCurHanderNames"/>
<html:hidden property="sysWfBusinessForm.fdHandlerRoleInfoIds"  styleId="sysWfBusinessForm.fdHandlerRoleInfoIds"/>
<html:hidden property="sysWfBusinessForm.fdHandlerRoleInfoNames"  styleId="sysWfBusinessForm.fdHandlerRoleInfoNames" />
<html:hidden property="sysWfBusinessForm.fdAuditNoteFdId"  styleId="sysWfBusinessForm.fdAuditNoteFdId" />
<html:hidden property="sysWfBusinessForm.fdIdentityId"  styleId="sysWfBusinessForm.fdIdentityId" />
<html:hidden property="sysWfBusinessForm.fdProcessStatus" styleId="sysWfBusinessForm.fdProcessStatus" />

		<table class="tb_normal process_review_panel" width="100%">
			<c:if test="${not empty param.historyPrePage}">
				<c:import url="${param.historyPrePage}" charEncoding="UTF-8"/>
			</c:if>
			<%--
			<c:if test="${sysWfBusinessForm.docStatus>='20' && sysWfBusinessForm.docStatus<'30'}">
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
			--%>
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
					<label><input type="checkbox" value="true" checked="checked" onclick="lbpm.globals.showHistoryDisplay(this);">
					<bean:message bundle="sys-lbpmservice" key="lbpmProcess.history.description.show" /></label>
				</td>
			</tr>
			<tr id="historyTableTR" style="padding: 0;display: none;">
				<td colspan=4 id="historyInfoTableTD" ${resize_prefix}onresize="lbpm.load_Frame();" style="padding: 0;">
					<iframe width="100%" style="margin-bottom: -4px;border: none;" scrolling="no" FRAMEBORDER=0></iframe>
				</td>
			</tr>
			</c:if>
			<%-- 动态加载操作--%>
			<c:forEach items="${lbpmProcessForm.curHandlerOperationsReviewJs}" var="reviewJs" varStatus="vstatus">
				<c:import url="${reviewJs}" charEncoding="UTF-8" />
			</c:forEach>
			<c:if test="${sysWfBusinessForm.docStatus == null || sysWfBusinessForm.docStatus<'20'}">
				<%-- 起草人选择人工分支节点 --%>
				<tr id="manualBranchNodeRow" style="display:none">
					<td class="td_normal_title" width="15%">
						<bean:message bundle="sys-lbpmservice" key="lbpmNode.createDraft.manualNodeSelect" />
					</td>
					<td colspan="3" id="manualNodeSelectTD">

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
				
				<!--通知紧急程度 -->
				<tr id="notifyLevelRow">
					<td class="td_normal_title"  width="15%">
						<bean:message bundle="sys-notify" key="sysNotifyTodo.level.title" />
					</td>
					<td colspan="3" id="notifyLevelTD">
						<c:if test="${sysWfBusinessForm.docStatus=='11'}">
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

				<tr>
					<td class="td_normal_title" width="15%">
						<bean:message bundle="sys-lbpmservice" key="lbpmNode.createDraft.nextNode" />
					</td>
					<td colspan="3" id="nextNodeTD">
						&nbsp;
					</td>
				</tr>
			</c:if>
			<c:if test="${sysWfBusinessForm.docStatus>='20' && sysWfBusinessForm.docStatus!='21' && sysWfBusinessForm.docStatus<'30'}">
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
			</c:if>
			<tr id="descriptionRow">
				<td class="td_normal_title" width="15%">
					<bean:message bundle="sys-lbpmservice" key="lbpmNode.createDraft.opinion" />
				</td>
				<td colspan="3">
					<table width=100% border=0 class="tb_noborder">
						<tr>
							<td>
								<bean:message bundle="sys-lbpmservice" key="lbpmNode.createDraft.commonUsages" />:&nbsp;&nbsp;
								<select name="commonUsages" onchange="lbpm.globals.setUsages(this);" style="width: 120px; overflow-x: hidden">
								<option value=""><bean:message key="page.firstOption" /></option>
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
							<td>
								<textarea name="fdUsageContent" class="inputMul" style="width:97%;padding: 0;" key="auditNode" subject="${lfn:message('sys-lbpmservice:lbpmNode.createDraft.opinion')}" validate="maxLength(2000)"></textarea>
							</td>
							<%-- <td width="15%">&nbsp;</td> --%>
						</tr>
						<tr>
							<td><label id="currentNodeDescription"></label></td>
						</tr>
					</table>
				</td>
			</tr>
			<c:if test="${sysWfBusinessForm.docStatus>='20' && sysWfBusinessForm.docStatus<'30'}">
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
											value="${param.formName}" />
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
			</c:if>
			<c:if test="${sysWfBusinessForm.docStatus == null || sysWfBusinessForm.docStatus<'20'}">
				<tr id="handlerIdentityRow" style="display:none">
					<td class="td_normal_title"  width="15%">
						<bean:message bundle="sys-lbpmservice" key="lbpmNode.currentNode.submitRole" />
					</td>
					<td colspan="3">
						<%-- 删除onchange事件中的WorkFlow_GetFlowContent(this); 2009-09-01 by fuyx --%>
						<select name="rolesSelectObj" key="handlerId">
						</select>
					</td>
				</tr>
			</c:if>
			<c:if test="${sysWfBusinessForm.docStatus>='20' && sysWfBusinessForm.docStatus<'30'}">
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
			</c:import>
			
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
								<table class="tb_normal" width=100% >
									<tr id="notifyTypeRow">
										<td class="td_normal_title"  width="15%">
											<bean:message bundle="sys-lbpmservice" key="lbpmNode.currentNode.notify.type" />
										</td>
										<td colspan="3" id="systemNotifyTypeTD">
											<kmss:editNotifyType property="sysWfBusinessForm.fdSystemNotifyType" value=""/> 
										</td>
									</tr>									
									<c:if test="${sysWfBusinessForm.docStatus>='20' && sysWfBusinessForm.docStatus<'30'}">
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
									<c:if test="${sysWfBusinessForm.docStatus == null || sysWfBusinessForm.docStatus<'20'}">
									<tr>
										<td class="td_normal_title" width="15%">
											<bean:message bundle="sys-lbpmservice" key="lbpmNode.currentNode.notifyToDraft" />
										</td>
										<td colspan="3">
											<bean:message bundle="sys-lbpmservice" key="lbpmNode.currentNode.notifyToDraft.message1" />
											<input type="text" class="inputSgl" style="width:30px;" id="dayOfNotifyDrafter" key="dayOfNotifyDrafter" validate="digits,min(0)"><bean:message bundle="sys-lbpmservice" key="FlowChartObject.Lang.Node.day" />
											<input type="text" class="inputSgl" style="width:30px;" id="hourOfNotifyDrafter" key="hourOfNotifyDrafter" validate="digits,min(0)"><bean:message bundle="sys-lbpmservice" key="FlowChartObject.Lang.Node.hour" />
											<input type="text" class="inputSgl" style="width:30px;" id="minuteOfNotifyDrafter" key="minuteOfNotifyDrafter" validate="digits,min(0)"><bean:message bundle="sys-lbpmservice" key="FlowChartObject.Lang.Node.minute" /><bean:message bundle="sys-lbpmservice" key="lbpmNode.currentNode.notifyToDraft.message2" />
											&nbsp;&nbsp;&nbsp;&nbsp;
											<label>
											<input type="checkbox" id="notifyDraftOnFinish" value="true" alertText="" key="notifyOnFinish">
											<bean:message bundle="sys-lbpmservice" key="lbpmNode.currentNode.notifyToDraft.message3" />
											</label>
										</td>
									</tr>
									</c:if>
									<c:if test="${sysWfBusinessForm.docStatus == null || sysWfBusinessForm.docStatus<'30'}">
									<tr id="checkChangeFlowTR">
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
												<a class="com_btn_link" href="javascript:lbpm.globals.modifyProcess('sysWfBusinessForm.fdFlowContent', 'sysWfBusinessForm.fdTranProcessXML');">
													<bean:message bundle="sys-lbpmservice" key="lbpmNode.currentNode.modifyFlow" />
												</a>
											</label>
										</td>
									</tr>
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
