<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<script>
require(['dojo/domReady!'], function() {
	lbpm.globals.getOperationParameterJson("futureNodeId:draftDecidedFactIds:dayOfNotifyDrafter:hourOfNotifyDrafter:minuteOfNotifyDrafter"); // 统一加载数据
	lbpm.globals.showHandlerIdentityRow();
	lbpm.globals.showManualBranchNodeRow();
	var dayOfNotifyDrafterObj = $("#dayOfNotifyDrafter")[0];
	if(dayOfNotifyDrafterObj != null){
		var dayOfNotifyDrafterParam=lbpm.globals.getOperationParameterJson("dayOfNotifyDrafter");
		dayOfNotifyDrafterObj.value = (!dayOfNotifyDrafterParam || dayOfNotifyDrafterParam=="")?"0":dayOfNotifyDrafterParam;
	}
	var hourOfNotifyDrafter = $("#hourOfNotifyDrafter")[0];
	if(hourOfNotifyDrafter != null){
		var hourOfNotifyDrafterParam=lbpm.globals.getOperationParameterJson("hourOfNotifyDrafter");
		hourOfNotifyDrafter.value = (!hourOfNotifyDrafterParam || hourOfNotifyDrafterParam=="")?"0":hourOfNotifyDrafterParam;
	}
	var minuteOfNotifyDrafter = $("#minuteOfNotifyDrafter")[0];
	if(dayOfNotifyDrafterObj != null){
		var minuteOfNotifyDrafterParam=lbpm.globals.getOperationParameterJson("minuteOfNotifyDrafter");
		minuteOfNotifyDrafter.value = (!minuteOfNotifyDrafterParam || minuteOfNotifyDrafterParam=="")?"0":minuteOfNotifyDrafterParam;
	}
});
//显示草稿页面－提交身份的行
lbpm.globals.showHandlerIdentityRow=function(){
	var handlerIdentityRow = document.getElementById("handlerIdentityRow");
	var handlerIdentityIdsObj = document.getElementById("sysWfBusinessForm.fdHandlerRoleInfoIds");
	var handlerIdentityNamesObj = document.getElementById("sysWfBusinessForm.fdHandlerRoleInfoNames");
	var handlerIdentityIds = handlerIdentityIdsObj.value;
	var rolesIdsArray = handlerIdentityIds.split(";");
	var rolesNamesArray = handlerIdentityNamesObj.value.split(";");
	if(rolesIdsArray.length <= 1 && handlerIdentityRow != null){
		lbpm.globals.hiddenObject(handlerIdentityRow, true);
	}else{
		lbpm.globals.hiddenObject(handlerIdentityRow, false);
	}
	require(["dijit/registry", "dojo/store/Memory", "dojo/ready"], function(registry, Memory, ready) {
		ready(function() {
			var rolesSelectObj = registry.byId('rolesSelectObj');
			if (rolesSelectObj == null) {
				return;
			}
			var data = [];
			for (var i = 0; i < rolesIdsArray.length; i++) {
				data.push({value: rolesIdsArray[i], text: rolesNamesArray[i]});
			}
			rolesSelectObj.setStore(new Memory({data: data}));
			rolesSelectObj.set('value', rolesIdsArray[0]);
		});
	});
};

//显示草稿页面－由起草人选择人工决策节点的行
lbpm.globals.showManualBranchNodeRow=function(){
	var html = "";
	// 解析简版XML，查找由起草人决定分支的人工决策节点
	var draftParams = lbpm.globals.getOperationParameterJson("draftDecidedFactIds:toRefuseThisNodeId");
	var draftDecidedFactIds = [];
	if (draftParams['draftDecidedFactIds'] != null && draftParams['draftDecidedFactIds'] != '') {
		draftDecidedFactIds = $.parseJSON(draftParams['draftDecidedFactIds']);
	}
	var isToRefuseThis = (draftParams['toRefuseThisNodeId'] != null && draftParams['toRefuseThisNodeId'] != '');
	var isSkipUnchecked = draftDecidedFactIds.length > 0;
	$.each(lbpm.nodes, function(index, node) {
		if (lbpm.globals.checkNodeType(lbpm.constant.NODETYPE_MANUALBRANCH, node)
				&& node.decidedBranchOnDraft == "true") {
			var isUncheckedNode = true;
			$.each(draftDecidedFactIds, function(_i, decidedNode) {
				if (decidedNode.NodeName == node.id) {
					isUncheckedNode = false;
					return false;
				}
			});
			if (isSkipUnchecked && isUncheckedNode)
				return;
			// 查找该节点的分支，拼装人工决策节点radio
			html += lbpm.globals.getNodeBranchesInfo(node, draftDecidedFactIds);
		}
	});
	
	if (html == "") {
		// 不存在由起草人决定分支的人工决策节点则隐藏行
		lbpm.globals.hiddenObject(document.getElementById("manualBranchNodeRow"), true);
	} else {
		var manualNodeSelectTD = document.getElementById("manualNodeSelectTD");
		if(manualNodeSelectTD != null){
			require(['dojo/query', "dojo/ready", "dijit/registry", "dojo/_base/array"], function(query, ready, registry, array) {
				ready(function() {
					query(manualNodeSelectTD).forEach(function(node) {
						array.forEach(registry.findWidgets(node), function(widget) {
							widget.destroy && !widget._destroyed && widget.destroy();
						});
					}).html(html, {parseContent: true});
					var nextNodeTd = query("#nextNodeTD");
					if(nextNodeTd.length > 0) {
						var nextObj=lbpm.globals.getNextNodeObj(lbpm.nowNodeId);
						if(nextObj && nextObj.decidedBranchOnDraft=='true'){					
							if (lbpm.globals.destroyOperations) 
								lbpm.globals.destroyOperations();
							else
								nextNodeTd.html();
						}
					}
				});
			});
		}
		lbpm.globals.hiddenObject(document.getElementById("manualBranchNodeRow"), isToRefuseThis);
		if (isSkipUnchecked)
			lbpm.events.fireListener(lbpm.constant.EVENT_SELECTEDMANUAL, $("input[key='manualFutureNodeId']:checked").first());
	}
};

//获取人工决策节点分支信息（人工决策节点名称：分支信息1，分支信息2...）
lbpm.globals.getNodeBranchesInfo=function(nodeData, manualNodeSelect){
	// 找到这个人工决策节点选择的分支
	manualNodeSelect = manualNodeSelect || lbpm.globals.getSelectedManualNode();
	var checkedId = "";
	$.each(manualNodeSelect, function(index, json){
		if (json.NodeName == nodeData.id) {
			checkedId = json.NextRoute;
		}
	});
	var html = "<div data-dojo-type='sys.lbpmservice.mobile.node.draftworkitem.RadioGroup'"
		+ " data-dojo-props='checkedId:\"" + checkedId + "\",nodeId:\"" + nodeData.id + "\"'></div>";
	if (html != "") {
		html = "<div class='draftworkitemBranche'>" + nodeData.id + "." + nodeData.name + "：</div>" + html;
	}
	return html;
};

// 判断人工决策节点分支是否会产生闭环
lbpm.globals.isClosedLoop=function(nodeData, endline) {
	var isClosedLoop = false;
	var nodeArray = new Array();
	nodeArray.push(endline.endNode);
	// 已查找节点，避免死循环
	var searchedNodeArray = new Array();
	outer:
	while (nodeArray.length > 0) {
		for (var i = 0, size = nodeArray.length; i < size; i++) {
			var node = nodeArray[i];
			searchedNodeArray.push(node);
			if (node.id == nodeData.id) {
				isClosedLoop = true;
				break outer;
			}
		}
		nodeArray = lbpm.globals.getNextNodesByManual(nodeArray);
		// 过滤已查找节点
		nodeArray = lbpm.globals.filterSearchedNodes(nodeArray, searchedNodeArray);
	}
	return isClosedLoop;
};

// 根据选择过滤不会走到的人工决策节点
lbpm.globals.setNextBranchNodes=function(curObj){
	var html = "";
	var manualNodeArray = lbpm.globals.getManualNodeArray();
	$.each(manualNodeArray, function(index, nodeData) {
		html += lbpm.globals.getNodeBranchesInfo(nodeData);
	});
	require(["dojo/query", "dojo/_base/array", "dijit/registry"], function(query, array, registry) {
		query(manualNodeSelectTD).forEach(function(node) {
			array.forEach(registry.findWidgets(node), function(widget) {
				widget.destroy && !widget._destroyed && widget.destroy();
			});
		}).html(html, {parseContent: true});
		lbpm.events.fireListener(lbpm.constant.EVENT_SELECTEDMANUAL,curObj);
	});
};

//遍历流程图找到会走到的人工决策节点
lbpm.globals.getManualNodeArray=function(){
	var manualNodeArray = new Array();
	// 开始节点
	var nodeArray = new Array();
	nodeArray.push(lbpm.nodes['N1']);
	// 已查找节点，避免死循环
	var searchedNodeArray = new Array();
	// 遍历流程图
	while (nodeArray.length > 0) {
		$.each(nodeArray, function(index, node) {
			searchedNodeArray.push(node);
			if (lbpm.globals.checkNodeType(lbpm.constant.NODETYPE_MANUALBRANCH, node)
					&& node.decidedBranchOnDraft == "true") {
				manualNodeArray.push(node);
			}
		});
		nodeArray = lbpm.globals.getNextNodesByManual(nodeArray);
		// 过滤已查找节点
		nodeArray = lbpm.globals.filterSearchedNodes(nodeArray, searchedNodeArray);
	}
	return manualNodeArray;
};

//过滤已查找节点
lbpm.globals.filterSearchedNodes=function(nodeArray, searchedNodeArray) {
	var filterNodes = new Array();
	$.each(nodeArray, function(i, node) {
		var searchedFlag = false;
		$.each(searchedNodeArray, function(j, searchedNode){
			if (node.id == searchedNode.id) {
				searchedFlag = true;
				return false;
			}
		});
		if (!searchedFlag) {
			filterNodes.push(node);
		}
	});
	return filterNodes;
};


// 获取节点的可以走到的下一个节点
lbpm.globals.getNextNodesByManual=function(nodeArray) {
	var manualNodeSelect = lbpm.globals.getSelectedManualNode();
	var nextNodes = new Array();
	$.each(nodeArray, function(i, node) {
		// 人工决策节点过滤分支
		if (lbpm.globals.checkNodeType(lbpm.constant.NODETYPE_MANUALBRANCH, node)
				&& node.decidedBranchOnDraft == "true") {
			var nextRoute = "";
		    // 查找该人工决策节点是否决定走哪条分支
			$.each(manualNodeSelect, function(j, json){
				if (json.NodeName == node.id) {
					nextRoute = json.NextRoute;
					return false;
				}
			});
			// 遍历连线，过滤分支
			$.each(node.endLines, function(k, line) {
				// 决定走哪条分支
				if (nextRoute != "") {
					if (line.endNode.id == nextRoute) {
						lbpm.globals.pushNode(nextNodes, line.endNode);
						return false;
					}
				} else {
					lbpm.globals.pushNode(nextNodes, line.endNode);
				}
			});
		} else {
			$.each(node.endLines, function(k, line) {
				lbpm.globals.pushNode(nextNodes, line.endNode);
			});
		}
	});
	return nextNodes;
};

// 不加入相同的节点
lbpm.globals.pushNode=function(nextNodes, nodeToPush) {
	var flag = true;
	$.each(nextNodes, function(i, node) {
		if (node.id == nodeToPush.id) {
			flag = false;
			return false;
		}
	});
	if (flag) {
		nextNodes.push(nodeToPush);
	}
};

//获取已经选择了分支的人工决策节点（[{NodeName:N3, NextRoute:N4},{NodeName:N9, NextRoute:N11}]）
lbpm.globals.getSelectedManualNode=function(){
	var manualNodeSelect = new Array();
	$("input[key='manualFutureNodeId']:checked").each(function(index, input){
    	var json = {};
    	input = $(input);
		json.NodeName = input.attr('manualBranchNodeId');
		json.NextRoute = input.val();
		manualNodeSelect.push(json);
    });
	return manualNodeSelect;
};

//判断是否所有的人工决策节点都选择了要走的分支
lbpm.globals.isSelectAllManualNode=function(){
	var isSelectAll = true;
	$.each($("input[key='manualFutureNodeId']"), function(index, input){
		isSelectAll = false;
		var radioes = $("input[manualBranchNodeId='"+$(input).attr('manualBranchNodeId')+"']");
		$.each(radioes, function(j, radio){
    		if(radio.checked) {
        		isSelectAll = true;
        		return false;
    		}
    	});
    	if(!isSelectAll) {
        	return false;
        }
    });
	return isSelectAll;
};

require(["dojo/_base/declare",
         "dojo/_base/lang",
         "mui/form/RadioGroup",
         "mui/form/Radio",
         "dojo/_base/array",
         "mui/util",
         "dojo/dom-construct"], function(declare, lang, _RadioGroup, _Radio, array, util, domConstruct) {
	var Radio = declare("sys.lbpmservice.mobile.node.draftworkitem.Radio", [_Radio], {
		
		_onClick: function() {
			this.inherited(arguments);
			lbpm.globals.setNextBranchNodes(this.domNode);
		}
	});
	
	var RadioGroup = declare("sys.lbpmservice.mobile.node.draftworkitem.RadioGroup", [_RadioGroup], {
		
		checkedId: null,
		
		nodeId: null,
		
		tmpl : '<input type="radio" id="manualFutureNodeId_!{manualBranchNodeId}_!{value}" data-dojo-type="sys.lbpmservice.mobile.node.draftworkitem.Radio"'
			+ ' manualBranchNodeId="!{manualBranchNodeId}" key="manualFutureNodeId"'
			+ ' data-dojo-props="checked:!{checked},showStatus:\'edit\',name:\'manualFutureNodeId_!{manualBranchNodeId}\',text:\'!{text}\',value:\'!{value}\'">',
			
		startup: function() {
			var nodeData = lbpm.nodes[this.nodeId];
			if (this.checkedId){
				this.set("value", this.checkedId);
			}
			var _self = this;
			this.store = array.map(nodeData.endLines, function(endLine, i) {
				// 过滤掉产生闭环的节点分支
				if (lbpm.globals.isClosedLoop(nodeData, endLine)) {
					return false;
				}
				var radioName = endLine.name || (endLine.endNode.id + "." + endLine.endNode.name);
				return {
					text:util.formatText(radioName) , 
					checked: _self.checkedId == endLine.endNode.id, 
					value: endLine.endNode.id,
					manualBranchNodeId: nodeData.id
				};
			});
			this.store = array.filter(this.store, function(v) {
				return !(v === false);
			});
			this.inherited(arguments);
		},
		
		createListItem : function(props) {
			if (this.isConcentrate(props))
				return null;
			var tmpl = this.tmpl.replace(/!{value}/g, props.value)
							.replace(/!{text}/g, props.text)
							.replace(/!{manualBranchNodeId}/g, props.manualBranchNodeId)
							.replace('!{checked}', props.checked ? true : false);
			var item = domConstruct.toDom(tmpl);
			return item;
		}
	});
});
</script>