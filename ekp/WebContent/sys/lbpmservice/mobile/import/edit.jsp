<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>

<c:set var="sysWfBusinessForm" value="${requestScope[param.formName]}" />
<c:set var="lbpmProcessForm" value="${sysWfBusinessForm.sysWfBusinessForm.internalForm}" />
<c:if test="${sysWfBusinessForm.sysWfBusinessForm!=null && lbpmProcessForm!=null}">
<%@ include file="./head.jsp" %>

<div class="lbpmView"
<c:if test="${param.viewName != 'none'}">
data-dojo-type="dojox/mobile/ScrollableView" id="${empty param.viewName ? 'lbpmView' : param.viewName}"
</c:if>
>
<div data-dojo-type="sys/lbpmservice/mobile/OptionsPane" 
	style="border-bottom: 10px solid #f4f4f4;" fixed="top"
	<c:if test="${sysWfBusinessForm.docStatus == null || sysWfBusinessForm.docStatus<'20'}">
	data-dojo-props='oneHide:true'
	</c:if>
	>
	
</div>

		<%@ include file="./form_hidden.jsp" %>
		<div class="actionView">
		<div id="lbpmOperationTable">
				<div id="operationItemsRow">
					<div class="titleNode" >
						<bean:message bundle="sys-lbpmservice" key="lbpmNode.processingNode.operationItems" />
					</div>
					<div class="detailNode">
						<div id="operationItemsSelect" data-dojo-type="mui/form/Select" 
							data-dojo-props="name:'operationItemsSelect', value:'0', mul:false, subject: '<bean:message bundle="sys-lbpmservice" key="lbpmNode.processingNode.operationItems" />'" ></div>
					</div>
				</div>
				<c:if test="${sysWfBusinessForm.docStatus == null || sysWfBusinessForm.docStatus<'20'}">
					<div id="handlerIdentityRow" style="display:none">
						<div class="titleNode">
							<bean:message bundle="sys-lbpmservice" key="lbpmNode.currentNode.submitRole" />
						</div>
						<div class="detailNode">
							<div id="rolesSelectObj" data-dojo-type="mui/form/Select"  key="handlerId"
								data-dojo-props="name:'rolesSelectObj', value:'0', mul:false, subject: '<bean:message bundle="sys-lbpmservice" key="lbpmNode.currentNode.submitRole" />'" ></div>
						</div>
					</div>
				</c:if>
				<div id="operationMethodsRow" style="display: none;">
					<div class="titleNode">
						<bean:message bundle="sys-lbpmservice" key="lbpmNode.processingNode.handMethods" />
					</div>
					<div class="detailNode">
						<select id="operationMethodsGroup" view-type="select" alertText='' key='operationType' name='oprGroup'></select>
					</div>
				</div>
				<%-- 动态加载操作--%>
				<c:forEach items="${lbpmProcessForm.curHandlerOperationsReviewJs}" var="reviewJs" varStatus="vstatus">
					<c:import url="${reviewJs}" charEncoding="UTF-8" />
				</c:forEach>
				<%-- 用于起草节点 ,显示即将流向--%>
				<div id="manualBranchNodeRow" style="display:none">
					<div class="titleNode" >
						<bean:message bundle="sys-lbpmservice" key="lbpmNode.createDraft.manualNodeSelect" />
					</div>
					<div colspan="3" id="manualNodeSelectTD">
						&nbsp;
					</div>
				</div>
				<div style="display:none;">
					<div class="titleNode" >
						<bean:message bundle="sys-lbpmservice" key="lbpmNode.createDraft.nextNode" />
					</div>
					<div  class="detailNode" id="nextNodeTD">
						&nbsp;
					</div>
				</div>
				<div id="operationsRow" style="display:none;" lbpmMark="operation">
					<div id="operationsTDTitle" class="titleNode" lbpmDetail="operation">
						&nbsp;
					</div>
					<div id="operationsTDContent"  class="detailNode" lbpmDetail="operation">
						&nbsp;
					</div>
				</div>
				<%@ include file="/sys/lbpmservice/mobile/change_process/sysLbpmProcess_changeProcess.jsp" %>
				<%--通知紧急程度 --%>
				<div id="notifyLevelRow">
					<div class="titleNode"  width="15%">
						<bean:message bundle="sys-notify" key="sysNotifyTodo.level.title" />
					</div>
					<div class="detailNode" id="notifyLevelTD">
						<%
							//获取紧急度级别
							com.landray.kmss.sys.lbpmservice.support.service.spring.InternalLbpmProcessForm lbpmForm =  
								(com.landray.kmss.sys.lbpmservice.support.service.spring.InternalLbpmProcessForm)pageContext.getAttribute("lbpmProcessForm");
							String notifyLevel = lbpmForm.getProcessInstanceInfo().getProcessParameters().getInstanceParamValue(lbpmForm.getProcessInstanceInfo().getProcessInstance(),"notifyLevel");
						%>
						<kmss:editNotifyLevel property='sysWfBusinessForm.fdNotifyLevel' mobile='true' value='<%= notifyLevel==null?"":notifyLevel%>'/>
						<script type="text/javascript">
							Com_Parameter.event["submit"].push(function() {
								//设置选择的级别（仿PC实现）
								if (lbpm.globals.setOperationParameterJson) {
									var _notifyLevel = document.getElementsByName("sysWfBusinessForm.fdNotifyLevel")[0].value;
									lbpm.globals.setOperationParameterJson(_notifyLevel,"notifyLevel","param"); 
								}
								return true;
							});
						</script>
					</div>
				</div>
		</div>
		</div>
		<div class="optionsSplitLine"></div>
		<div class="actionView">
		<div class="lbpmAuditNoteTable">
				<%-- 审批意见扩展使用 --%>
				<c:import url="/sys/lbpmservice/support/lbpm_audit_note/lbpmAuditNote_ext.jsp" charEncoding="UTF-8">
					<c:param name="auditNoteFdId" value="${sysWfBusinessForm.sysWfBusinessForm.fdAuditNoteFdId}" />
					<c:param name="modelName" value="${sysWfBusinessForm.modelClass.name}" />
					<c:param name="modelId" value="${sysWfBusinessForm.fdId}" />
					<c:param name="formName" value="${param.formName}" />
					<c:param name="provideFor" value="mobile" />
				</c:import>
				<div id = "commonUsagesRow">
					<div id="commonUsagesDiv">
						<div class="handingWay" id="commonUsages"><div class="iconArea"><i class="mui mui-create"></i></div><span class="iconTitle">审批语</span></div>
					</div>
				</div>
				<div id="assignmentRow" style="display:none;" class="splitLine">
					<div id="descriptionDiv">
						<div id="fdUsageContent" data-dojo-type='mui/form/Textarea' 
							data-dojo-props='"placeholder":"请输入处理意见...","name":"fdUsageContent",opt:false' alertText="" key="auditNode"></div>
					</div>
					<c:import url="/sys/attachment/mobile/import/edit.jsp" charEncoding="UTF-8">
						<c:param name="fdKey" value="${sysWfBusinessForm.sysWfBusinessForm.fdAuditNoteFdId}" />
						<c:param name="formName" value="${param.formName}"/>
						<c:param name="fdModelName" value="${sysWfBusinessForm.modelClass.name}"/>
						<c:param name="fdModelId" value="${sysWfBusinessForm.fdId}"/>
					</c:import>
				</div>
		</div>
		</div>
		<c:if test="${sysWfBusinessForm.docStatus != null && sysWfBusinessForm.docStatus>='20'}">
		<div class="optionsSplitLine"></div>
		<div class="actionView">
		<div class="lbpmInfoTable">
					<div class="titleNode" >
						<bean:message bundle="sys-lbpmservice" key="lbpmNode.processingNode.currentProcessor" />
					</div>
					<div class="detailNode">
						<label id="currentHandlersLabel"></label>
					</div>
		</div>
		</div>
		</c:if>
		<c:if test="${param.viewName != 'none'}">
		<div data-dojo-type="mui/tabbar/TabBar" fixed="bottom" data-dojo-props='fill:"grid"'>
			<li data-dojo-type="mui/tabbar/TabBarButton" class="muiBtnDefault " 
				data-dojo-props='moveTo:"${param.backTo}",transition:"slide",transitionDir:-1,icon1:"mui mui-preStep"'>
				返回</li>
			<c:if test="${not empty param.onClickSubmitButton}">
			<li data-dojo-type="mui/tabbar/TabBarButton" class="muiBtnSubmit " 
				data-dojo-props='colSize:2,icon1:"mui mui-confirm"' onclick="${param.onClickSubmitButton}">
				提交</li>
			</c:if>
			<li data-dojo-type="mui/tabbar/TabBarButton" class="muiBtnDefault " 
				data-dojo-props='icon1:"mui mui-flowchart",onClick:showFlowChartView'></li>
		</div>
		</c:if>
</div>
</c:if>
