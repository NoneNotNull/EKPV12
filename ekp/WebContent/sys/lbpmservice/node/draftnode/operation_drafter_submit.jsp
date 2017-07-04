<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<script language="JavaScript">
lbpm.globals.includeFile("lbpmservice/operation/operation_common_passtype.js");
( function(operations) {
	operations['drafter_submit'] = {
			click:OperationClick,
			check:OperationCheck,
			isPassType:true,
			setOperationParam:setOperationParam
	};	

	//起草人操作：提交文档
	function OperationClick(operationName){
		var processorInfo = lbpm.globals.analysisProcessorInfoToObject();
		if(processorInfo != null) {
			var nextNodeTD = document.getElementById("nextNodeTD");
			if(nextNodeTD != null){
				var html = lbpm.globals.generateNextNodeInfo();
				lbpm.globals.innerHTMLGenerateNextNodeInfo(html, nextNodeTD);
				lbpm.globals.hiddenObject(nextNodeTD.parentNode, false);
			} else {
				// 兼容文档状态为20情况下，人工分支不能显示问题
				var operationsTDContent = document.getElementById("operationsTDContent");
				if(operationsTDContent){
					var operationsTDTitle = document.getElementById("operationsTDTitle");
					operationsTDTitle.innerHTML = '<bean:message bundle="sys-lbpmservice" key="lbpmNode.processingNode.operationsTDTitle.handlerOperationTypepass" />';
					var html = lbpm.globals.generateNextNodeInfo();
					lbpm.globals.innerHTMLGenerateNextNodeInfo(html, operationsTDContent);
					lbpm.globals.hiddenObject(operationsTDContent.parentNode, false);
				}
			}
		}
	};
	//“驳回”操作的检查
	function OperationCheck(workitemObjArray){
		if (!lbpm.globals.isSelectAllManualNode()) {
			alert("<bean:message bundle='sys-lbpmservice' key='lbpmNode.manualNodeOnDraft.noSelectAll'/>");
			return false;
		}
		return lbpm.globals.common_operationCheckForPassType(workitemObjArray);
	};	
	//"起草人提交"操作的获取参数
	function setOperationParam()
	{
		//设置起草人提交身份参数
		if (window.require) {
			var rolesSelectObj = dijit.registry.byId('rolesSelectObj');
			lbpm.globals.setOperationParameterJson(rolesSelectObj.get('value'),"identityId", "param");
		} else {
			var obj = document.getElementsByName("rolesSelectObj")[0];
			lbpm.globals.setOperationParameterJson(obj,"identityId", "param");
		}

		//流程结束后通知我
		$("#notifyDraftOnFinish").each(function(i){
			lbpm.globals.setOperationParameterJson(this,"notifyOnFinish", "param");
		});
		
		//天后仍未完成--dayOfNotifyDrafter
		$("#dayOfNotifyDrafter").each(function(i){
			lbpm.globals.setOperationParameterJson(this,"dayOfNotifyDrafter", "param");
		});
		$("#hourOfNotifyDrafter").each(function(i){
			lbpm.globals.setOperationParameterJson(this,"hourOfNotifyDrafter", "param");
		});
		$("#minuteOfNotifyDrafter").each(function(i){
			lbpm.globals.setOperationParameterJson(this,"minuteOfNotifyDrafter", "param");
		});

		//设置起草人选择人工决策节点分支参数
		var selectedManualNode = lbpm.globals.getSelectedManualNode();
		if(selectedManualNode.length>0){
			var param=lbpm.globals.objectToJSONString(selectedManualNode);
		    lbpm.globals.setOperationParameterJson(param, "draftDecidedFactIds", "param");
		}			
	};	
})(lbpm.operations);
</script>