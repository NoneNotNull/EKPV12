<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>

<c:set var="sysWfBusinessForm" value="${requestScope[param.formName]}" />
<c:set var="lbpmProcessForm" value="${sysWfBusinessForm.sysWfBusinessForm.internalForm}" />
<c:if test="${sysWfBusinessForm.sysWfBusinessForm!=null}">

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
	</c:if>>
	
</div>
<div class="optionsSplitLine"></div>

		<c:if test="${empty param.onClickSubmitButton}">
		<form name="sysWfProcessForm" method="POST"
				action="<c:url value="/sys/lbpmservice/support/lbpm_process/lbpmProcess.do" />" autocomplete="off">
		</c:if>
		<%@ include file="./form_hidden.jsp" %>
		<c:if test="${(sysWfBusinessForm.docStatus>='20' && sysWfBusinessForm.docStatus<'30') || sysWfBusinessForm.docStatus == '11'}">
		<c:if test="${sysWfBusinessForm.sysWfBusinessForm.fdIsHander == 'true'}"><%-- start action --%>
		<div class="actionView">
		<div id="lbpmOperationTable">
				<div id="operationItemsRow">
					<div class="titleNode">
						<bean:message bundle="sys-lbpmservice" key="lbpmNode.processingNode.operationItems" />
					</div>
					<div class="detailNode">
						<!-- <select name="operationItemsSelect" style="max-width: 200px;" onchange="lbpm.globals.operationItemsChanged(this);">
						</select> -->
						<div id="operationItemsSelect" data-dojo-type="mui/form/Select" 
							data-dojo-props="name:'operationItemsSelect', value:'0', mul:false, subject: '<bean:message bundle="sys-lbpmservice" key="lbpmNode.processingNode.operationItems" />'" ></div>
					</div>
				</div>
				<div id="operationMethodsRow" style="display: none;">
					<div class="titleNode" >
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
				<c:if test="${sysWfBusinessForm.docStatus == null || sysWfBusinessForm.docStatus<'20'}">
					<div style="display:none;" class="splitLine">
						<div class="titleNode" >
							<bean:message bundle="sys-lbpmservice" key="lbpmNode.createDraft.manualNodeSelect" />
						</div>
						<div class="detailNode" id="manualNodeSelectTD">
							&nbsp;
						</div>
					</div>
					<div style="display:none;">
						<div class="titleNode" >
							<bean:message bundle="sys-lbpmservice" key="lbpmNode.createDraft.nextNode" />
						</div>
						<div class="detailNode" id="nextNodeTD">
							&nbsp;
						</div>
					</div>
				</c:if>
				<div id="operationsRow" style="display:none;" lbpmMark="operation" class="splitLine">
					<div id="operationsTDTitle" class="titleNode" lbpmDetail="operation" >
						&nbsp;
					</div>
					<div id="operationsTDContent" class="detailNode" lbpmDetail="operation">
						&nbsp;
					</div>
				</div>
				<div id="operationsRow_Scope" style="display:none;" lbpmMark="operation" class="splitLine">
					<div id="operationsTDTitle_Scope" class="titleNode" lbpmDetail="operation" >
						&nbsp;
					</div>
					<div id="operationsTDContent_Scope" class="detailNode" lbpmDetail="operation">
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
						<kmss:editNotifyLevel property='sysWfBusinessForm.fdNotifyLevel' mobile='true' value='<%= notifyLevel==null?"":notifyLevel %>'/>
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
							data-dojo-props='"placeholder":"请输入处理意见...","name":"fdUsageContent",opt:false' alertText="" key="auditNode">
						</div>
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
		</c:if><%-- end action --%>
		</c:if>
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
	<c:if test="${empty param.onClickSubmitButton}">
	<script>
	require(["mui/form/ajax-form!sysWfProcessForm"]);
	</script>
	</form>
	</c:if>
	
	<c:if test="${param.viewName != 'none'}">
	<div data-dojo-type="mui/tabbar/TabBar" fixed="bottom" data-dojo-props='fill:"grid"'>
		<li data-dojo-type="mui/tabbar/TabBarButton" class="muiBtnDefault " 
			data-dojo-props='moveTo:"${param.backTo}",transitionDir:-1,icon1:"mui mui-cancel"'>
			取消
		</li>
		<c:if test="${sysWfBusinessForm.docStatus<'30'}">
		<li data-dojo-type="mui/tabbar/TabBarButton" class="muiBtnSubmit " data-dojo-props='colSize:2,icon1:"mui mui-confirm"' 
			onclick="${empty param.onClickSubmitButton ? "Com_Submit(document.sysWfProcessForm, 'update');" : param.onClickSubmitButton}">
			确定</li>
		</c:if>
		<c:if test="${sysWfBusinessForm.docStatus>='30'}">
		<li data-dojo-type="mui/tabbar/TabBarButton" data-dojo-props='colSize:2'></li>
		</c:if>
		<li data-dojo-type="mui/tabbar/TabBarButton" class="muiBtnDefault " data-dojo-props='icon1:"mui mui-flowchart",onClick:showFlowChartView'></li>
	</div>
	</c:if>
</div>
</c:if>
