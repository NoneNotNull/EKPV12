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
	lbpm.flow_chart_load_Frame=function(){
		require(["dojo/query"], function(query) {
			query("#workflowInfoTD iframe").forEach(function(iframe) {
				if (iframe.src == '' || iframe.src == null) {
					iframe.src = '<c:url value="/sys/lbpm/flowchart/page/panel.html">
						<c:param name="edit" value="false" />
						<c:param name="extend" value="oa" />
						<c:param name="template" value="false" />
						<c:param name="contentField" value="sysWfBusinessForm.fdFlowContent" />
						<c:param name="statusField" value="sysWfBusinessForm.fdTranProcessXML" />
						<c:param name="modelName" value="${modelClassName}" />
						<c:param name="modelId" value="${sysWfBusinessForm.fdId}" />
						<c:param name="hasParentProcess" value="${lbpmProcessForm.hasParentProcess}" />
						<c:param name="hasSubProcesses" value="${lbpmProcessForm.hasSubProcesses}" />
						<c:param name="zoom" value="-25" />
					</c:url>';
				}
			});
		});
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
	require(["mui/dialog/Tip", "dojo/query", "dojo/ready"], function(Tip, query, ready) {
		ready(function(){
			Tip.fail({text: '<kmss:message key="sys-lbpm-engine:lbpm.process.exception.notify.all" />', time: 6000});
		});
		lbpm.globals.isError = true;
		lbpm.globals.errorMessages = '${msg}';
	});
</script>
</c:if>
<script>
require(["dojo/query", "dojo/ready", "dijit/registry", "dojo/dom-class", "dojo/domReady!"], function(query, ready, registry, domClass) {
	
	function autoSaveDraftAction() {
		var oldValue = "", timer = null;
		var doSave = function() {
			query("[name='fdUsageContent']").forEach(function(fdUsageContent) {
				if (oldValue != fdUsageContent.value) {
					oldValue = fdUsageContent.value;
					lbpm.globals.saveDraftAction();
				}
			});
			timer = null;
		};
		var timeToSave = function() {
			if (timer) {
				clearTimeout(timer);
				timer = null;
			}
			timer = setTimeout(doSave, 10000);
		};
		query("[name='fdUsageContent']").on("input", timeToSave);
		Com_Parameter.event["submit"].push(function() {
			if (timer) {
				clearTimeout(timer);
				timer = null;
			}
			return true;
		});
	}
	ready(autoSaveDraftAction);
	ready(function() { // fix android
		/* query('#lbpmOperationTable').forEach(function(node) {
			node.dojoClick = false;
		}); */
	
		query('.handingWay').on('click', function(e) {
			var self = this;
			domClass.add(self, 'selected');
			setTimeout(function() {domClass.remove(self, 'selected');}, 1000);
		});
	});
});

require(["dijit/registry", "dojox/mobile/ViewController", 
         "dojox/mobile/viewRegistry", "dojo/ready", "dojox/mobile/View", "dojox/mobile/Heading",
         "dojo/dom-construct", "dojo/query", "mui/util", "dojo/dom-style"], 
		function(registry, ViewController, viewRegistry, ready, View, Heading, domCtr, query, util, domStyle) {
	
	ready(function() {
		//alert(query("#content .mblView").length);
		var parent = query("#content .mblView")[0].parentNode;
		var flowView = new View({id: "flowchart_container"}, domCtr.create("div", {}, parent));
		var heading = new Heading({id: "lbpmFlowChartBack", "back": "返回", moveTo: "lbpmView"}, domCtr.create("h1", {innerHTML:"流程图"}));
		flowView.addChild(heading);
		heading.startup();
		flowView.startup();
		
		domStyle.set(flowView.domNode, "height", util.getScreenSize().h + "px");
	});
	
	var vc = ViewController.getInstance();
	
	showFlowChartView = function(e){
		var view = viewRegistry.getEnclosingView(e.target);
    	vc.openExternalView({
            url:"<c:url value='/sys/lbpmservice/mobile/import/flowchart.jsp' />",
            transition: "slide"
        }, registry.byId("flowchart_container").containerNode).then(lbpm.flow_chart_load_Frame).then(function() {
        	if (view)
        		registry.byId("lbpmFlowChartBack").backButton.moveTo = view.id;
        });
    };
});
</script>
<c:if test="${(sysWfBusinessForm.docStatus == '11' || (sysWfBusinessForm.docStatus >='20' && sysWfBusinessForm.docStatus<'30')) && sysWfBusinessForm.sysWfBusinessForm.fdIsHander != 'true'}">
<script>
require(["mui/dialog/BarTip", "dojo/ready"], function(BarTip, ready, query) {
	ready(function() {BarTip.tip({text: lbpm.currentHandlers});});
});
</script>
</c:if>
