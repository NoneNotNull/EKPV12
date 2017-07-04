<%@page import="com.landray.kmss.common.actions.RequestContext"%>
<%@page import="com.landray.kmss.sys.mobile.util.MobileUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<%@ include file="/sys/lbpmservice/workitem/workitem_common.jsp"%>
<%-- 
<%@ include file="/sys/lbpmservice/node/draftnode/operation_drafter_submit.jsp"%>
<%@ include file="/sys/lbpmservice/operation/drafter/operation_drafter_common.jsp"%>
--%>
<%
if (MobileUtil.getClientType(new RequestContext(request)) > -1) {
	%>
	<%@ include file="/sys/lbpmservice/mobile/node/draftnode/workitem_draftworkitem.jsp"%>
	<%
} else {
%>
<script language="JavaScript">
$(document).ready(function(){
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
	var rolesSelectObj = document.getElementsByName("rolesSelectObj")[0];
	if(rolesSelectObj != null){
		var fdIdentityId = document.getElementById("sysWfBusinessForm.fdIdentityId");
		var option = null;
	 	for(var i = 0; i < rolesIdsArray.length; i++){
			option = document.createElement("option");
			var rolesName = rolesNamesArray[i];
			var rolesId = rolesIdsArray[i];
			option.appendChild(document.createTextNode(rolesName));
			option.value=rolesId;
			if(fdIdentityId != null && fdIdentityId.value == rolesId) {
				option.selected = true;
			}
			rolesSelectObj.appendChild(option);
	 	}
	}
};

//显示草稿页面－由起草人选择人工决策节点的行
lbpm.globals.showManualBranchNodeRow=function(){
	//alert("showManualBranchNodeRow");
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
			html += lbpm.globals.getNodeBranchesInfo(node, draftDecidedFactIds) + "<br/>";
		}
	});
	
	if (html == "") {
		// 不存在由起草人决定分支的人工决策节点则隐藏行
		lbpm.globals.hiddenObject(document.getElementById("manualBranchNodeRow"), true);
	} else {
		// 去除最后的<br/>
		html = html.substring(0, html.length - 5);
		var manualNodeSelectTD = document.getElementById("manualNodeSelectTD");
		if(manualNodeSelectTD != null){
			manualNodeSelectTD.innerHTML = html;
			var nextNodeTd=$("#nextNodeTD");
			if(nextNodeTd.length>0){
				var nextObj=lbpm.globals.getNextNodeObj(lbpm.nowNodeId);
				if(nextObj && nextObj.decidedBranchOnDraft=='true'){					
					$("#nextNodeTD")[0].innerHTML="";
				}
			}
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
	var html = "";
	// 循环人工决策节点的每条分支
	$.each(nodeData.endLines, function(index, endLine) {
		// 过滤掉产生闭环的节点分支
		if (lbpm.globals.isClosedLoop(nodeData, endLine)) {
			return;
		}
		var radioName = endLine.name;
		if (radioName == null) {
			radioName = endLine.endNode.id + "." + endLine.endNode.name;
		} else {
			radioName = radioName + "(" + endLine.endNode.id + "." + endLine.endNode.name + ")";
		}
		html += "<label><input type='radio' manualBranchNodeId='"+nodeData.id+"' key='manualFutureNodeId' name='manualFutureNodeId_"+nodeData.id+"'" 
			+ " value='" + endLine.endNode.id + "' "
		 	+ " onclick='lbpm.globals.setNextBranchNodes(this)'" 
			+ (checkedId == endLine.endNode.id ? 'checked' : '') + " />";
	    html += "<b>" + radioName + "</b></label>";
	});
	if (html != "") {
		html = "<b>" + nodeData.id + "." + nodeData.name + "：</b>" + html;
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
		html += lbpm.globals.getNodeBranchesInfo(nodeData) + "<br/>";
	});
	html = html.substring(0, html.length - 5);
	document.getElementById("manualNodeSelectTD").innerHTML = html;
	lbpm.events.fireListener(lbpm.constant.EVENT_SELECTEDMANUAL,curObj);
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
</script>
<%
}
%>