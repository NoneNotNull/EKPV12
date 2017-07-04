( function(lbpm) {
//通过类型的操作的提交前检测
lbpm.globals.common_operationCheckForPassType = function() {
	if (!checkFutureNodeSelected()) {
		return false;
	} else if (!checkFutureNodeObjs()) {
		return false;
	}
	return true;
};
// 检查多个即将流向节点是否被选上
function checkFutureNodeSelected() {
	if ($("input[name='futureNode']").length == 0)
		return true;
	if ($("input[name='futureNode']:checked").length > 0)
		return true;
	alert(lbpm.constant.CHKNEXTNODENOTNULL);
	return false;
}

// 如果次值被修改，节点数小于此值，将会执行提交校验
var ASYNC_MAX = 100;

// 获得所有的节点
// startNodeId为开始查找的NodeId， endNodeId为结束查询的NodeId（若为空则为结束结点）
// exceptionXmlNodeNames:不包括的节点
function getAllNextNodeArray(startNodeId) {
	var rtnNodeArray = new Array();
	var startPush = false;
	if (!startNodeId)
		startPush = true;
	var throughtNodesFilter = function(throughtNodes) {
		$.each(throughtNodes, function(index, nodeObj) {
			if (startPush)
				rtnNodeArray.push(nodeObj.id);
			if (startNodeId && nodeObj.id == startNodeId)
				startPush = true;
		});
	};
	var nodeSize = 0;
	$.each(lbpm.nodes, function(index, nodeData) {
		nodeSize = nodeSize + 1;
	});
	if (nodeSize < ASYNC_MAX) {
		lbpm.globals.getThroughNodes(throughtNodesFilter, null, null, false);
	} else {
		lbpm.globals.getFilterInfo(0, null, throughtNodesFilter);
	}
	return rtnNodeArray;
}
// 判断节点为必须修改的节点，请设置该节点的处理人后再进行提交操作
function checkMustModifyHandlerNodeIds(nextNodeArray, operatorInfo) {
	var currentNodeObj = lbpm.globals.getCurrentNodeObj();
	var roleType = lbpm.constant.ROLETYPE;
	for (var i = 0; i < nextNodeArray.length; i++) {
		if (roleType == ''
				&& lbpm.globals.checkModifyNodeAuthorization(currentNodeObj,
						nextNodeArray[i])) {
			var nextNode = lbpm.globals.getNodeObj(nextNodeArray[i]);
			if (nextNode.handlerIds == null || nextNode.handlerIds == "") {
				if (currentNodeObj.processType == lbpm.constant.PROCESSTYPE_SERIAL) {
					var currNodeNextHandlersId = lbpm.globals.getOperationParameterJson("currNodeNextHandlersId");
					var toRefuseThisNodeId = lbpm.globals.getOperationParameterJson("toRefuseThisNodeId");
					// 节点的最后处理人、非驳回返回本节点
					if (!currNodeNextHandlersId && !toRefuseThisNodeId
							&& (lbpm.operations[lbpm.currentOperationType].isPassType)) {
						if (lbpm.globals.judgeIsNecessaryAlert(nextNode)) {
							alert(nextNode.id + "." + nextNode.name + lbpm.constant.MUSTMODIFYHANDLERNODEIDSISNULL);
							if (!lbpm.address.is_pda() && lbpm.globals.changeProcessorClick) {
								lbpm.globals.changeProcessorClick();
							}
							return false;
						}
					}
				} else if (lbpm.operations[lbpm.currentOperationType].isPassType) {
					if (lbpm.globals.judgeIsNecessaryAlert(nextNode)) {
						alert(nextNode.id + "." + nextNode.name + lbpm.constant.MUSTMODIFYHANDLERNODEIDSISNULL);
						if (!lbpm.address.is_pda() && lbpm.globals.changeProcessorClick) {
							lbpm.globals.changeProcessorClick();
						}
						return false;
					}
				}
			}
		}
	}
	return true;
}
// 获取后续非分支节点中必须修改处理人的节点（用于支持计算最后一个节点才提示必须修改处理人）
function _getLinearMustModifyHandlerNodeIds(nodeIds, nodeId, includeFirst) {
	if(!nodeId) {
		return;
	}
	var nodeObj = lbpm.globals.getNodeObj(nodeId);
	if(nodeObj) {
		if(includeFirst && nodeObj.mustModifyHandlerNodeIds != null && nodeObj.mustModifyHandlerNodeIds != ""
			&& nodeObj.ignoreOnHandlerEmpty == "false"){
			var mustModifyHandlerNodeIds = nodeObj.mustModifyHandlerNodeIds.split(";");
			for (var i = 0; i < mustModifyHandlerNodeIds.length; i++) {
				if(mustModifyHandlerNodeIds[i]) {
					nodeIds.push(mustModifyHandlerNodeIds[i]);
				}
			}
		}
		if(lbpm.globals.checkNodeType(lbpm.constant.NODETYPE_SPLIT,nodeObj) && nodeObj.relatedNodeIds) { // 并发分支
			_getLinearMustModifyHandlerNodeIds(nodeIds, nodeObj.relatedNodeIds, true);
		} else {
			var nextNodeObjs = lbpm.globals.getNextNodeObjs(nodeObj.id);
			if(nextNodeObjs.length == 1) {
				_getLinearMustModifyHandlerNodeIds(nodeIds, nextNodeObjs[0].id, true);
			}
		}
	}
}
function getAllNextNodeArrayExclude(nodeId, includeFirst) {
	var rtnNodeArray = [];
	var allNextNodeArray = getAllNextNodeArray(nodeId);
	
	var linearMustModifyHandlerNodeIds = [];
	_getLinearMustModifyHandlerNodeIds(linearMustModifyHandlerNodeIds, nodeId, includeFirst);
	
	for(var i = 0; i < allNextNodeArray.length; i++){
		var found = false;
		for(var j = 0; j < linearMustModifyHandlerNodeIds.length; j++) {
			if(allNextNodeArray[i] == linearMustModifyHandlerNodeIds[j]) {
				found = true;
				break;
			}
		}
		if(!found){
			rtnNodeArray.push(allNextNodeArray[i]);
		}
	}
	return rtnNodeArray;
}
function checkFutureNodeObjs() {
	var checkedNode = null;
	var futureNodeObjs = document.getElementsByName("futureNode");
	for (var i = 0; i < futureNodeObjs.length; i++) {
		var futureNodeObj = futureNodeObjs[i];
		if (futureNodeObj.checked) {
			checkedNode = lbpm.globals.getNodeObj(futureNodeObj.value);
			var handlerIdsObj = document.getElementsByName("handlerIds["
					+ futureNodeObj.getAttribute("index") + "]")[0];
			if (handlerIdsObj != null && handlerIdsObj.value == ""
					&& checkedNode && checkedNode.ignoreOnHandlerEmpty == "false") {
				alert(lbpm.constant.VALIDATENEXTNODEHANDLERISNULL);
				return false;
			}
			break;
		}
	}
	var allNextNodeArray = [];
	if(checkedNode && checkedNode.id) {
		if(lbpm.globals.checkNodeType(lbpm.constant.NODETYPE_END,checkedNode)) {
			return true;
		}
		allNextNodeArray = getAllNextNodeArrayExclude(checkedNode.id, true);
	} else {
		allNextNodeArray = getAllNextNodeArrayExclude(lbpm.nowNodeId, false);
	}
	
	// 检查未选中的节点是否是被选中节点的后续节点
	for (var i = 0; i < futureNodeObjs.length; i++) {
		var futureNodeObj = futureNodeObjs[i];
		if (futureNodeObj.checked) {
			continue;
		}

		for (var j = 0; j < allNextNodeArray.length; j++) {
			var furtureFromSelectedNodeId = allNextNodeArray[j];
			if (futureNodeObj.value == furtureFromSelectedNodeId) {
				var handlerIdsObj = document.getElementsByName("handlerIds["
						+ futureNodeObj.getAttribute("index") + "]")[0];
				var furtureFromSelectedNodeObj = lbpm.globals.getNodeObj(futureNodeObj.value);
				if (handlerIdsObj != null && handlerIdsObj.value == ""
						&& furtureFromSelectedNodeObj && furtureFromSelectedNodeObj.ignoreOnHandlerEmpty == "false") {
					alert(lbpm.constant.FLOWCONTENTMUSTMODIFYNODENEXTHANDLER
							.replace('{0}', furtureFromSelectedNodeObj.id)
							.replace('{1}', furtureFromSelectedNodeObj.name)
							.replace('{2}', checkedNode.id).replace('{3}', checkedNode.name));
					return false;
				}
			}
		}
	}
	
	var operatorInfo = lbpm.globals.analysisProcessorInfoToObject();
	// 判断节点为必须修改的节点
	if (!checkMustModifyHandlerNodeIds(allNextNodeArray, operatorInfo))
		return false;
	return true;
}
})(lbpm);