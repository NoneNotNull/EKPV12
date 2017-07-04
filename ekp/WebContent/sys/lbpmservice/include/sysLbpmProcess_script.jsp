<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.landray.kmss.sys.lbpm.engine.manager.node.NodeDescTypeManager" %>
<%@ page import="com.landray.kmss.sys.lbpm.engine.manager.node.NodeTypeManager" %>
<%@ page import="com.landray.kmss.sys.lbpm.engine.manager.node.NodeType" %>
<%@ page import="com.landray.kmss.sys.lbpm.engine.manager.node.NodeDescType" %>
<%@ page import="com.landray.kmss.util.SpringBeanUtil"%>
<%@ page import="java.util.*" %>
<c:set var="modelClassName" value="${sysWfBusinessForm.sysWfBusinessForm.fdModelName}" />
<c:set var="modeId" value="${sysWfBusinessForm.fdId}" />
<script type="text/javascript">	
Com_IncludeFile("jquery.js|json2.js");
Com_IncludeFile("docutil.js|optbar.js|validator.jsp|validation.js|plugin.js|validation.jsp|xform.js", null, "js");
</script>
<link rel="stylesheet" type="text/css" href="<c:url value="/sys/lbpmservice/resource/jNotify.jquery.css?s_cache=${LUI_Cache}"/>" media="screen" />
<script type="text/javascript" src="<c:url value="/sys/lbpmservice/resource/jNotify.jquery.js?s_cache=${LUI_Cache}"/>"></script>
<%@ include file="/sys/lbpmservice/include/sysLbpmProcessConstant.jsp"%>
<script src="<c:url value="/sys/lbpm/flowchart/js/workflow.js?s_cache=${LUI_Cache}"/>"></script>
<script src="<c:url value="/sys/lbpmservice/include/syslbpmprocess.js?s_cache=${LUI_Cache}"/>"></script>
<script src="<c:url value="/sys/lbpmservice/resource/address_builder.js?s_cache=${LUI_Cache}"/>"></script>
<link rel="stylesheet" type="text/css" href="<c:url value="/sys/lbpmservice/resource/review.css?s_cache=${LUI_Cache}"/>" />

<c:forEach items="${lbpmProcessForm.curNodesReviewJs}" var="reviewJs"
			varStatus="vstatus">
	<c:import url="${reviewJs}" charEncoding="UTF-8" />
</c:forEach>
<c:forEach items="${lbpmProcessForm.curTasksReviewJs}" var="reviewJs"
			varStatus="vstatus">
	<c:import url="${reviewJs}" charEncoding="UTF-8" />
</c:forEach>
<script type="text/javascript">	
	lbpm.drafterOperationsReviewJs=new Array();
	lbpm.adminOperationsReviewJs=new Array();
	lbpm.historyhandlerOperationsReviewJs=new Array();
	<c:forEach items="${lbpmProcessForm.curDrafterOperationsReviewJs}" var="reviewJs" varStatus="vstatus">
		lbpm.drafterOperationsReviewJs.push("${reviewJs}");
	</c:forEach>
	<c:forEach items="${lbpmProcessForm.curAdminOperationsReviewJs}" var="reviewJs" varStatus="vstatus">
		lbpm.adminOperationsReviewJs.push("${reviewJs}");
	</c:forEach>
	<c:forEach items="${lbpmProcessForm.curHistoryhandlerOperationsReviewJs}" var="reviewJs" varStatus="vstatus">
		lbpm.historyhandlerOperationsReviewJs.push("${reviewJs}");
	</c:forEach>
</script>
<script type="text/javascript">	
	lbpm.load_Frame=function(){
		// 审批日志
		lbpm.globals.load_Frame('historyInfoTableTD', '<c:url value="/sys/lbpmservice/support/lbpm_audit_note/lbpmAuditNote.do?method=listNote" />'
			+'&fdModelId=${sysWfBusinessForm.fdId}&fdModelName=${modelClassName}&formBeanName=${param.formName}');
	};
	lbpm.flow_chart_load_Frame=function(){
		lbpm.globals.load_Frame('workflowInfoTD', '<c:url value="/sys/lbpm/flowchart/page/panel.html">'
			+'<c:param name="edit" value="false" />'
			+'<c:param name="extend" value="oa" />'
			+'<c:param name="template" value="false" />'
			+'<c:param name="contentField" value="sysWfBusinessForm.fdFlowContent" />'
			+'<c:param name="statusField" value="sysWfBusinessForm.fdTranProcessXML" />'
			+'<c:param name="modelName" value="${modelClassName}" />'
			+'<c:param name="modelId" value="${sysWfBusinessForm.fdId}" />'
			+'<c:param name="hasParentProcess" value="${lbpmProcessForm.hasParentProcess}" />'
			+'<c:param name="hasSubProcesses" value="${lbpmProcessForm.hasSubProcesses}" />'
		+'</c:url>');
	};
	lbpm.flow_table_load_Frame=function(){
		lbpm.globals.load_Frame('workflowTableTD', '<c:url value="/sys/lbpmservice/include/sysLbpmTable_view.jsp" />'
			+'?edit=false&extend=oa&template=false&contentField=sysWfBusinessForm.fdFlowContent&statusField=sysWfBusinessForm.fdTranProcessXML&modelName=${modelClassName}&modelId=${sysWfBusinessForm.fdId}&IdPre=${sysWfBusinessFormPrefix}&fdKey=${param.fdKey}');
	};
	lbpm.flow_log_load_Frame=function(){
		lbpm.globals.load_Frame('flowLogTableTD', '<c:url value="/sys/lbpmservice/support/lbpm_audit_note/lbpmAuditNote.do?method=listFlowLog" />'
			+'&fdModelId=${sysWfBusinessForm.fdId}&fdModelName=${modelClassName}&formBeanName=${param.formName}');
	};
	
</script>
<%@ include file="/sys/lbpmservice/include/sysLbpmPluginLoad.jsp"%>
<c:if test="${lbpmProcessForm.fdIsError == 'true'}">
<%
com.landray.kmss.sys.lbpmservice.support.service.spring.ErrorQueueDataBean errorDataBean = 
	(com.landray.kmss.sys.lbpmservice.support.service.spring.ErrorQueueDataBean) SpringBeanUtil.getBean("lbpmErrorQueueDataBean");
Object msg = errorDataBean.getErrorJsonData((String) pageContext.getAttribute("modeId"));
%>
<script>
$(document).ready(function() {
	var get_node_txt = function(nodeId) {
		var n = lbpm.nodes[nodeId];
		return (n ? (n.id + "." + n.name) : "");
	};
	lbpm.globals.isError = true;
	jError('<kmss:message key="sys-lbpm-engine:lbpm.process.exception.notify.all" />', {
		TimeShown: 5000,
		VerticalPosition: 'top',
		HorizontalPosition: 'right',
		ShowOverlay: false
	});
	var tmpFull = '<kmss:message key="sys-lbpm-engine:lbpm.process.exception.notify.full" />';
	var tmpMsg = '<kmss:message key="sys-lbpm-engine:lbpm.process.exception.notify.msg" />';
	var tmpDef = '<kmss:message key="sys-lbpm-engine:lbpm.process.exception.notify.def" />';
	var msg = <%=msg%>;
	var text = [];
	$.each(msg, function(index, row) {
		var errorNode = get_node_txt(row['errorId']);
		var errorType = row['errorType'];
		var errorMsg = row['errorMessage'];
		var errorText = null;
		if (errorType != null && errorType != '' && errorMsg != null && errorMsg != '') {
			errorText = tmpFull.replace("{node}", errorNode).replace("{type}", errorType).replace("{msg}", errorMsg);
		}
		else if (errorMsg != null && errorMsg != '') {
			errorText = (tmpMsg.replace("{node}", errorNode).replace("{msg}", errorMsg));
		}
		else {
			errorText = (tmpDef.replace("{node}", errorNode));
		}
		row['errorText'] = errorText;
		row['errorNodeName'] = errorNode;
		row['sourceNodeName'] = get_node_txt(row['sourceId']);

		var tmp = '<kmss:message key="sys-lbpmservice-operation-admin:lbpmOperations.fdOperType.processor.retry.queueTemp" />';
		tmp = tmp.replace('{user}', row['user']).replace('{node}', row['sourceNodeName']).replace('{opr}', row['operationName']);
		text.push(tmp + ", " + errorText);
	});
	$("#currentHandlersLabel").after("<div class='lbpm_error_info_div'></div>");
	$(".lbpm_error_info_div").text(text.join(""));
	lbpm.globals.errorMessages = msg;
});
</script>
</c:if>

<c:if test="${(sysWfBusinessForm.docStatus>='20' && sysWfBusinessForm.docStatus<'30') || sysWfBusinessForm.docStatus == '11'}">
<c:if test="${sysWfBusinessForm.sysWfBusinessForm.fdIsHander == 'true'}">
<script>
$(document).ready(function() {
	if (!window.LUI) {
		return;
	}
	if ("true" != "${lbpmProcessForm.fdIsHander}") {
		return;
	}
	if ("true" == "${param.isSimpleWorkflow}") {
		return;
	}
	lbpm.globals.initShortReview('<kmss:message key="sys-lbpmservice:lbpm.operation.shortcut" />');
});

$(document).ready(function() {
	function autoSaveDraftAction() {
		var oldValue = "", timer = null;
		var doSave = function() {
			try {
				$("[name='fdUsageContent']").each(function(i, fdUsageContent) {
					if (oldValue != fdUsageContent.value) {
						oldValue = fdUsageContent.value;
						lbpm.globals.saveDraftAction();
					}
				});
			} catch (e) {}
			timer = setTimeout(doSave, 8000);
		};
		timer = setTimeout(doSave, 8000);
	}
	autoSaveDraftAction();
});
</script>
</c:if>
</c:if>