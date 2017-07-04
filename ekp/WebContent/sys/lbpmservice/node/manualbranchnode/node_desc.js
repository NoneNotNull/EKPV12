	/*******************************************************************************
	 * 功能：人工决策节点的节点描述（节点扩展点的nodeJsType项配置此文件的路径）
	  使用：
	  作者：罗荣飞
	 创建时间：2012-06-06
	 ******************************************************************************/
( function(nodedescs) {
	nodedescs['manualBranchNodeDesc'].getLines = getLines;
	//获取即将流向的连线(nodeObj为当前节点对象，nextNodeObj为下一节点对象,disFilter是否禁用计算流出连线)
	function getLines(nodeObj,nextNodeObj,disFilter){
		if(nextNodeObj.decidedBranchOnDraft=='true'){
			// 由起草人决定人工分支
			var jsonObj = _getOperationParameterJson(nextNodeObj);
			var lines = _getLines(jsonObj, nextNodeObj);
			if(lines) {
				return lines;
			}
		} else {
			if(disFilter) {
				// 暂存情况下
				return nextNodeObj.endLines;
			}
			if(nodeObj && nodeObj.Status == lbpm.constant.STATUS_RUNNING) {
				if(lbpm.globals.getSelectedFurtureNode) {
					var jsonObj = lbpm.globals.getSelectedFurtureNode();
					var lines = _getLines(jsonObj, nextNodeObj);
					if(lines) {
						return lines;
					}
				}
				// 暂存情况，从后端获取
				var futureNodeId = lbpm.globals.getOperationParameterJson("futureNodeId", false, nodeObj);
				if(futureNodeId && lbpm.nodes[futureNodeId]) {
					var startLines=lbpm.nodes[futureNodeId].startLines;
					var lineArr=[];
					for(var i=0,size=startLines.length;i<size;i++){
						if(startLines[i].startNode.id==nextNodeObj.id){
							lineArr[0]=startLines[i];
							return lineArr;
						}
					}
				}
			}
		}
		return nextNodeObj.endLines;
	};
	
	function _getOperationParameterJson(nodeObj) {
		if (lbpm.globals.getSelectedManualNode) {
			// 先从页面获取
			var selectedManualNode = lbpm.globals.getSelectedManualNode();
			if(selectedManualNode && selectedManualNode.length > 0) {
				return selectedManualNode;
			}
		}
		// 人工决策节点的上一节点(当前节点)的节点参数查找
		var result = lbpm.globals.getOperationParameterJson("draftDecidedFactIds", false, nodeObj);
		if (result == null) {
			// 非当前节点后端查找
			if(lbpm.globals.draftDecidedFactIds != null) {
				result = lbpm.globals.draftDecidedFactIds;
			} else {
				var jsonObj={
						nodeId: nodeObj.id,
						nodeType: nodeObj.XMLNODENAME,
						params: 'draftDecidedFactIds'
				};
				var json = lbpm.globals._getOperationParameterFromAjax(jsonObj);
				if (json && json.draftDecidedFactIds) {
					result = lbpm.globals.draftDecidedFactIds = json.draftDecidedFactIds;
				} else {
					result = lbpm.globals.draftDecidedFactIds = "";
				}
			}
		}
		if(result) {
			return $.parseJSON(result);
		}
		return null;
	}
	
	function _getLines(jsonObj, nextNodeObj) {
		if(jsonObj != null){
			var nodeId = "";
			for(var i=0,size=jsonObj.length;i<size;i++){
				if(jsonObj[i].NodeName==nextNodeObj.id){
					nodeId=jsonObj[i].NextRoute;
					break;
				}
			};
			if(nodeId!=""){
				var lineArr=[];
				var startLines=lbpm.nodes[nodeId].startLines;
				for(var i=0,size=startLines.length;i<size;i++){
					if(startLines[i].startNode.id==nextNodeObj.id){
						lineArr[0]=startLines[i];
						return lineArr;
					}
				}
			}
		}
		return null;
	}
})(lbpm.nodedescs);