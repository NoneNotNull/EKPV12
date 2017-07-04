<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
	/*******************************************************************************
	 * 功能：处理人“前后跳转”操作的审批所用JSP，此JSP路径在处理人“驳回”操作扩展点定义的reviewJs参数匹配
	  使用：
	  作者：罗荣飞
	 创建时间：2012-06-06
	 ******************************************************************************/
	( function(operations) {
		operations['admin_jump'] = {
			click:OperationClick,
			check:OperationCheck,
			setOperationParam:setOperationParam
		};	
		//特权人操作：前后跳转
		function OperationClick(operationName){
			var operationsRow = document.getElementById("operationsRow");
			var operationsTDTitle = document.getElementById("operationsTDTitle");
			var operationsTDContent = document.getElementById("operationsTDContent");
			operationsTDTitle.innerHTML = '<bean:message bundle="sys-lbpmservice" key="lbpmNode.processingNode.operationsTDTitle.adminOperationTypeJump" />';
			var operatorInfo = lbpm.globals.getOperationParameterJson("isRecoverPassedSubprocess:jumpToNodeId");
			var html = '<select name="jumpToNodeIdSelectObj" alertText="" key="jumpToNodeId"></select>';
			// 跳转重新流转 html
			var isPassedSubprocessNode = lbpm.globals.isPassedSubprocessNode();
			if (isPassedSubprocessNode) {
				html += '<label id="isRecoverPassedSubprocessLabel">';
				html += '<'+'input type="checkbox" id="isRecoverPassedSubprocess" value="true" alertText="" key="isRecoverPassedSubprocess"';
				if(operatorInfo.isRecoverPassedSubprocess == "true"){
					html += " checked='true'";
				}
				html += '>';
				html += '<bean:message bundle="sys-lbpmservice" key="lbpmNode.processingNode.operationsTDTitle.adminOperationTypeJump.abandonSubprocess" />';
				html += '</label>';
			}
			var availableNodes = getAvailableNodes();
			operationsTDContent.innerHTML = html;
			lbpm.globals.hiddenObject(operationsRow, false);
			
			var jumpToNodeIdSelectObj = $("select[name='jumpToNodeIdSelectObj']")[0];
			var currNode = lbpm.globals.getNodeObj(lbpm.nowNodeId);
			var jumpNodes = getJumpNodes(currNode);
			
			for(var i = 0; i < availableNodes.length; i++){
				var nodeInfo = availableNodes[i];
				// 过滤并行分支中的节点
				if (!containNode(jumpNodes, nodeInfo))
					continue;
				var	option = document.createElement("option");
				var itemShowStr = nodeInfo.id + "." + nodeInfo.name;
				if(nodeInfo.handlerSelectType == 'org'){
					if(nodeInfo.handlerNames) {
						itemShowStr += "(" + nodeInfo.handlerNames+ ")";
					} else {
						itemShowStr += "(" + lbpm.workitem.constant.COMMONNODEHANDLERORGEMPTY+ ")";
					}
				} else if (nodeInfo.handlerSelectType != null)  {
					itemShowStr += "(" + lbpm.workitem.constant.COMMONLABELFORMULASHOW + ")";
				}
				option.appendChild(document.createTextNode(itemShowStr));
				option.value=nodeInfo.id;
				if(operatorInfo.jumpToNodeId == nodeInfo.id){
					option.checked = true;
				}
				jumpToNodeIdSelectObj.appendChild(option); 
			}
			if(operatorInfo.jumpToNodeId == ""){
				jumpToNodeIdSelectObj.selectedIndex = jumpToNodeIdSelectObj.options.length - 1;
			}
			if (jumpToNodeIdSelectObj.options.length == 0) {
				operationsTDContent.innerHTML = '<bean:message bundle="sys-lbpmservice" key="lbpmNode.flowContent.noJumpNode" /><input type="hidden" alertText="<bean:message bundle="sys-lbpmservice" key="lbpmNode.flowContent.noJumpNode" />" key="jumpToNodeId">';
				$("#rerunIfErrorRow").hide();
			} else {
				$("#rerunIfErrorRow").show();
			}
		};
		//“前后跳转”操作的检查
		function OperationCheck(){
			var jumpToNodeIdSelectObj = $("select[name='jumpToNodeIdSelectObj']")[0];
			if(jumpToNodeIdSelectObj){
				if (jumpToNodeIdSelectObj.options.length == 0) {
					alert('<bean:message bundle="sys-lbpmservice" key="lbpmNode.flowContent.noJumpNode" />');
					return false;
				}
				var node = lbpm.globals.getNodeObj(jumpToNodeIdSelectObj.options[jumpToNodeIdSelectObj.selectedIndex].value);
				if(node && node.handlerIds == "") {
					if (!confirm('<bean:message key="lbpmNode.validate.hanlderEmpty.jump.confirm" bundle="sys-lbpmservice" />')) {
						return false;
					}
				}
			}
			return true;
		};	
		//"前后跳转"操作的获取参数
		function setOperationParam()
		{			
			var input = $("[name='jumpToNodeIdSelectObj']")[0];
			if (input){
				lbpm.globals.setOperationParameterJson(input.options[input.selectedIndex].value, "jumpToNodeId", "param");
				var nodeName=lbpm.nodes[input.options[input.selectedIndex].value].name;
				lbpm.globals.setOperationParameterJson(nodeName, "jumpToNodeName", "param");
				if ($('#rerunIfError').length > 0) {
					lbpm.globals.setOperationParameterJson($("#rerunIfError").attr("checked"), "rerunIfError", "param");
				}
				//子流程
				lbpm.globals.setOperationParameterJson($("[key='isRecoverPassedSubprocess']")[0],"isRecoverPassedSubprocess", "param");
			};	
		};	


		//取得有效的节点
		function getAvailableNodes(){
			var availableNodes = [];
			$.each(lbpm.nodes, function(index, nodeObj) {
				if(lbpm.globals.checkNodeType(lbpm.constant.NODETYPE_START,nodeObj) 
						|| lbpm.globals.checkNodeType(lbpm.constant.NODETYPE_END,nodeObj) 
						|| lbpm.nowNodeId == nodeObj.id 
						|| lbpm.globals.checkNodeType(lbpm.constant.NODETYPE_AUTOBRANCH,nodeObj) 
						|| lbpm.globals.checkNodeType(lbpm.constant.NODETYPE_MANUALBRANCH,nodeObj)
						|| lbpm.globals.checkNodeType(lbpm.constant.NODETYPE_SPLIT,nodeObj)
						|| lbpm.globals.checkNodeType(lbpm.constant.NODETYPE_JOIN,nodeObj)){
					;
				} else {
					availableNodes.push(nodeObj);
				}
			});
			return availableNodes;
		}
		
		function getJumpNodes(curr) {
			var nodes = [];
			nodes = _findNextNodes(curr, nodes);
			nodes = _findPreNodes(curr, nodes);
			return nodes;
		}
		
		function _findPreNodes(curr, nodes) {
			var pres = lbpm.globals.getPreviousNodeObjs(curr.id);
			for (var i = 0; i < pres.length; i ++) {
				var pNode = pres[i];
				if (lbpm.globals.checkNodeType(lbpm.constant.NODETYPE_START,pNode)) {
				    break;
				}
				if (containNode(nodes, pNode)) {
					continue;
				}
				nodes.push(pNode);
				
				_findPreNodes(pNode, nodes);
				
				if(isCommonDecisionNode(pNode)){// 可以跳到非并发分支
					_findNextNodes(pNode, nodes);
				}
			}
			return nodes;
		}
		
		function _findNextNodes(curr, nodes) {
			var nexts = lbpm.globals.getNextNodeObjs(curr.id);
			for (var i = 0; i < nexts.length; i ++) {
				var nNode = nexts[i];
				if (lbpm.globals.checkNodeType(lbpm.constant.NODETYPE_END,nNode)) {
					break;
				}
				if (containNode(nodes, nNode)) {
					continue;
				}
				nodes.push(nNode);
				_findNextNodes(nNode, nodes);
			}
			return nodes;
		}
		
		function containNode(nodes, node) {
			for (var n = 0; n < nodes.length; n ++) {
				if (node.id == nodes[n].id) {
					return true;
				}
			}
			return false;
		}
		
		function isCommonDecisionNode(node) {
			var nodeDesc = lbpm.nodedescs[node.nodeDescType];
			return nodeDesc.isBranch(node) && !nodeDesc.isConcurrent(node);
		}
		
	})(lbpm.operations);
		