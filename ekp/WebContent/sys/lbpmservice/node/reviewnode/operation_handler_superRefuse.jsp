<%@page import="com.landray.kmss.common.actions.RequestContext"%>
<%@page import="com.landray.kmss.sys.mobile.util.MobileUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<%
if (MobileUtil.getClientType(new RequestContext(request)) < 0) {
%>
<script language="JavaScript">
	/*******************************************************************************
	 * 功能：处理人“驳回”操作的审批所用JSP，此JSP路径在处理人“驳回”操作扩展点定义的reviewJs参数匹配
	  使用：
	  作者：罗荣飞
	 创建时间：2012-06-06
	 ******************************************************************************/
	( function(operations) {
		operations['handler_superRefuse'] = {
			click:OperationClick,
			check:OperationCheck,
			setOperationParam:setOperationParam
		};	

		//处理人操作：驳回
		function OperationClick(operationName){
			var operationsRow = document.getElementById("operationsRow");
			var operationsTDTitle = document.getElementById("operationsTDTitle");
			var operationsTDContent = document.getElementById("operationsTDContent");
			//var operatorInfo = lbpm.globals.getOperationParameterJson("refusePassedToThisNode:isRecoverPassedSubprocess:jumpToNodeId");
			operationsTDTitle.innerHTML = '<bean:message bundle="sys-lbpmservice" key="lbpmNode.processingNode.operationsTDTitle.handlerOperationTypeRefuse" />';
			var html = '<select name="jumpToNodeIdSelectObj" alertText="" key="jumpToNodeId"></select>';

			html += '<label style="margin-left: 8px;" id="refusePassedToThisNodeLabel"><input type="checkbox" id="refusePassedToThisNode" value="true" alertText="" key="refusePassedToThisNode"';
			if(lbpm.flowcharts["rejectReturn"] == "true"){
				html += " checked='true'";
			}
			html += '>';
			html += '<bean:message bundle="sys-lbpmservice" key="lbpmNode.processingNode.operationsTDTitle.handlerOperationTypeRefuse.returnBack" /></label>';
			
			// 驳回重新流转 html
			var isPassedSubprocessNode = lbpm.globals.isPassedSubprocessNode();
			if (isPassedSubprocessNode) {
				html += '<label style="margin-left: 8px;" id="isRecoverPassedSubprocessLabel"><input type="checkbox" id="isRecoverPassedSubprocess" value="true" alertText="" key="isRecoverPassedSubprocess"';
				/*if(operatorInfo.isRecoverPassedSubprocess == "true"){
					html += " checked='true'";
				}*/
				html += '>';
				html += '<bean:message bundle="sys-lbpmservice" key="lbpmNode.processingNode.operationsTDTitle.handlerOperationTypeRefuse.abandonSubprocess" />';
				html += '</label>';
			}

			operationsTDContent.innerHTML = html;
			lbpm.globals.hiddenObject(operationsRow, false);
			
			// 驳回重新流转 action
			if (isPassedSubprocessNode) {
				var isRecoverPassedSubprocessLabelObj = document.getElementById("isRecoverPassedSubprocessLabel");
				//isRecoverPassedSubprocessLabelObj.style.display = (operatorInfo.refusePassedToThisNode == "true") ? "none" : "";
				isRecoverPassedSubprocessLabelObj.style.display = "";
				var refusePassedToThisNodeObj = document.getElementById("refusePassedToThisNode");
				Com_AddEventListener(refusePassedToThisNodeObj, "click", function(){
					var refusePassedToThisNodeObj = document.getElementById("refusePassedToThisNode");
					if (refusePassedToThisNodeObj.checked) {
						var isRecoverPassedSubprocessObj = document.getElementById("isRecoverPassedSubprocess");
						isRecoverPassedSubprocessObj.checked = false;
					}
					var isRecoverPassedSubprocessLabelObj = document.getElementById("isRecoverPassedSubprocessLabel");
					isRecoverPassedSubprocessLabelObj.style.display = (refusePassedToThisNodeObj.checked) ? "none" : "";
				});
			}
			// 增加驳回节点重复过滤
			var currNodeInfo = lbpm.globals.getCurrentNodeObj();
			var currNodeId = currNodeInfo.id;
			
			var url = Com_Parameter.ContextPath+"sys/lbpm/engine/jsonp.jsp";
			var pjson = {"s_bean": "lbpmRefuseRuleDataBean", "processId": $("[name='sysWfBusinessForm.fdProcessId']").val(), "nodeId": currNodeId, "_d": new Date().toString(),"refuseType":"superRefuse"};
			var passNodeArray = [];
			$.ajaxSettings.async = false;
			$.getJSON(url, pjson, function(json) {
				passNodeArray = json;
			});
			//获取分之内节点
			var check_pjson = {"s_bean": "lbpmRefuseRuleDataBean", "processId": $("[name='sysWfBusinessForm.fdProcessId']").val(), "nodeId": currNodeId, "_d": new Date().toString()};
			$.getJSON(url, check_pjson, function(json) {
				check_passNodeArray = json;
			});
			
			var jumpToNodeIdSelectObj = $("select[name='jumpToNodeIdSelectObj']")[0];
			
			for(var i = 0; i < passNodeArray.length; i++){
				var nodeInfo = lbpm.nodes[passNodeArray[i]];
				
				var	option = document.createElement("option");
				var itemShowStr = nodeInfo.id + "." + nodeInfo.name;
				if(nodeInfo.handlerNames != null && nodeInfo.handlerSelectType == 'org'){
					itemShowStr += "(" + nodeInfo.handlerNames+ ")";
				} else if (nodeInfo.handlerSelectType != null)  {
					itemShowStr += "(" + lbpm.workitem.constant.COMMONLABELFORMULASHOW + ")";
				}
				option.appendChild(document.createTextNode(itemShowStr));
				option.value=passNodeArray[i];
				jumpToNodeIdSelectObj.appendChild(option); 
			}


			var refusePassedToThisNode = document.getElementById("refusePassedToThisNode");
			var refusePassedToThisNodeLabel = document.getElementById("refusePassedToThisNodeLabel");
			if(jumpToNodeIdSelectObj.options.length > 0){
				jumpToNodeIdSelectObj.selectedIndex = jumpToNodeIdSelectObj.options.length - 1;
				//默认判断是否在分之内
				var isInJoin = false;
				for(var i=0;i<check_passNodeArray.length;i++){
                     if(check_passNodeArray[i]==jumpToNodeIdSelectObj.options[jumpToNodeIdSelectObj.selectedIndex].value){
                    	 isInJoin = true;
                    	 break;
                     }     
				}
				//隐藏返回到本节点开关
				if(isInJoin == false){
					refusePassedToThisNode.checked = false;
					refusePassedToThisNodeLabel.style.display = "none";
				}
			
			}
			if (jumpToNodeIdSelectObj.options.length == 0) {
				operationsTDContent.innerHTML = '<bean:message bundle="sys-lbpmservice" key="lbpmNode.flowContent.noRefuseNode" /><input type="hidden" alertText="<bean:message bundle="sys-lbpmservice" key="lbpmNode.flowContent.noRefuseNode" />" key="jumpToNodeId">';
			}

			Com_AddEventListener(jumpToNodeIdSelectObj, "change", function(){
				var isInJoin = false;
				for(var i=0;i<check_passNodeArray.length;i++){
                     if(check_passNodeArray[i]==jumpToNodeIdSelectObj.options[jumpToNodeIdSelectObj.selectedIndex].value){
                    	 isInJoin = true;
                    	 break;
                     }     
				}
				//隐藏返回到本节点开关
				if(isInJoin == false){
					refusePassedToThisNode.checked = false;
					refusePassedToThisNodeLabel.style.display = "none";
				}else{
				//显示
					if(lbpm.flowcharts["rejectReturn"] == "true"){
						refusePassedToThisNode.checked = true;
					}
					refusePassedToThisNodeLabel.style.display = "";
				}
			});
		};
		
		//“驳回”操作的检查
		function OperationCheck(){
			var jumpToNodeIdOptionObj = $("select[name='jumpToNodeIdSelectObj']").find("option:selected");
			if (jumpToNodeIdOptionObj.length == 0) {
				alert('<bean:message bundle="sys-lbpmservice" key="lbpmNode.flowContent.noRefuseNode" />');
				return false;
			}
			return lbpm.globals.validateMustSignYourSuggestion();
		};	
		//"驳回"操作的获取参数
		function setOperationParam()
		{		
			var jumpStr=$("[key='jumpToNodeId']")[0].value;
			var jumpArr=jumpStr.split(":");	
			lbpm.globals.setOperationParameterJson(jumpArr[0],"jumpToNodeId", "param");
			if(jumpArr.length>1){
				lbpm.globals.setOperationParameterJson(jumpArr[1],"jumpToNodeInstanceId", "param");
			}else{
				lbpm.globals.setOperationParameterJson("","jumpToNodeInstanceId", "param");
			}	
			
			lbpm.globals.setOperationParameterJson($("[key='refusePassedToThisNode']")[0],"refusePassedToThisNode", "param");
			//子流程
			lbpm.globals.setOperationParameterJson($("[key='isRecoverPassedSubprocess']")[0],"isRecoverPassedSubprocess", "param");
		};	
	})(lbpm.operations);
	
</script>
<%} else {/* 移动展现 */ %>
<script>
	( function(operations) {
		operations['handler_superRefuse'] = {
			click:OperationClick,
			check:OperationCheck,
			setOperationParam:setOperationParam
		};
		function OperationClick(operationName){
			require(['dojo/query', "dojo/store/Memory", "dijit/registry", "dojo/request", "dojo/_base/array"], 
					function(query, Memory, registry, request, array) {
				var operationsRow = document.getElementById("operationsRow");
				var operationsTDTitle = document.getElementById("operationsTDTitle");
				operationsTDTitle.innerHTML = '<bean:message bundle="sys-lbpmservice" key="lbpmNode.processingNode.operationsTDTitle.handlerOperationTypeRefuse" />';
				
				// 增加驳回节点重复过滤
				var currNodeInfo = lbpm.globals.getCurrentNodeObj();
				var currNodeId = currNodeInfo.id;
				
				var url = Com_Parameter.ContextPath+"sys/lbpm/engine/jsonp.jsp";
				var pjson = {"s_bean": "lbpmRefuseRuleDataBean", "processId": query("[name='sysWfBusinessForm.fdProcessId']").val(), 
						"nodeId": currNodeId, "_d": new Date().toString(), "refuseType":"superRefuse"};
				var check_pjson = {"s_bean": "lbpmRefuseRuleDataBean", "processId": query("[name='sysWfBusinessForm.fdProcessId']").val(), 
						"nodeId": currNodeId, "_d": new Date().toString()};
				
				request.post(url, {handleAs: 'json', data: pjson}).then(function(passNodeArray) {
					return request.post(url, {handleAs: 'json', data: check_pjson}).then(function(check_passNodeArray) {
						return [passNodeArray, check_passNodeArray];
					});
				}).then(function(nodeArrays) {
					var passNodeArray = nodeArrays[0], check_passNodeArray = nodeArrays[1];
					
					if (passNodeArray && passNodeArray.length) {
						var checkIsInJoin = function(nodeValue) {
							return array.some(check_passNodeArray, function(v) {return v == nodeValue;});
						};
						var html = '<div id="jumpToNodeIdSelectObj" data-dojo-type="mui/form/Select" key="jumpToNodeId" ' 
							+ 'data-dojo-props="name:\'jumpToNodeIdSelectObj\', value:\'\', mul:false" ></div>';
							
						html += '<div id="refusePassedToThisNodePane" class="refusePassedToThisNode" style="display:none">';
						html += '<div id="refusePassedToThisNode" alertText="" key="refusePassedToThisNode" data-dojo-type="mui/form/CheckBox"';
						html += ' data-dojo-props="name:\'refusePassedToThisNode\', value:\'true\', mul:false, text:\'';
						html += '<bean:message bundle="sys-lbpmservice" key="lbpmNode.processingNode.operationsTDTitle.handlerOperationTypeRefuse.returnBack" />\'';
						html += ",checked:" + (lbpm.flowcharts["rejectReturn"] == "true");
						html += '"></div></div>';
						// 驳回重新流转 html
						var isPassedSubprocessNode = lbpm.globals.isPassedSubprocessNode();
						if (isPassedSubprocessNode) {
							html += "<div class='isRecoverPassedSubprocessLabel'>";
							html += '<div id="isRecoverPassedSubprocess" alertText="" key="isRecoverPassedSubprocess" data-dojo-type="mui/form/CheckBox"';
							html += ' data-dojo-props="name:\'isRecoverPassedSubprocess\', value:\'true\', mul:false, text:\'';
							html += '<bean:message bundle="sys-lbpmservice" key="lbpmNode.processingNode.operationsTDTitle.handlerOperationTypeRefuse.abandonSubprocess" />\'';
							html += '"></div></div>';
						}
						var data = [];
						for(var i = 0; i < passNodeArray.length; i++){
							var nodeInfo = lbpm.nodes[passNodeArray[i]];
							
							var itemShowStr = nodeInfo.id + "." + nodeInfo.name;
							if(nodeInfo.handlerNames != null && nodeInfo.handlerSelectType == 'org'){
								itemShowStr += "(" + nodeInfo.handlerNames+ ")";
							} else if (nodeInfo.handlerSelectType != null)  {
								itemShowStr += "(" + lbpm.workitem.constant.COMMONLABELFORMULASHOW + ")";
							}
							
							data.push({text:itemShowStr, value:passNodeArray[i]});
						}
						query("#operationsTDContent").html(html, {parseContent: true, onEnd: function() {
							var rtn = this.inherited("onEnd", arguments);
							var thenFun = function(results) {
								var jumpToNodeIdSelectObj = registry.byId('jumpToNodeIdSelectObj');
								jumpToNodeIdSelectObj.setStore(new Memory({
									data : data
								}));
								jumpToNodeIdSelectObj.on("attrmodified-value", function(evt) {
									var val = evt.detail.newValue;
									if (!checkIsInJoin(val)) {
										request.byId('refusePassedToThisNode').set("checked", false);
										query('#refusePassedToThisNodePane').style("display", 'none');
									} else {
										query('#refusePassedToThisNodePane').style("display", '');
									}
								});
								jumpToNodeIdSelectObj.set("value", passNodeArray[passNodeArray.length - 1]);
								var refusePassedToThisNode = registry.byId('refusePassedToThisNode');
								refusePassedToThisNode.watch('checked', function(name, old, val) {
									var isRecoverPassedSubprocess = registry.byId('isRecoverPassedSubprocess');
									if (isRecoverPassedSubprocess) {
										if (val) {
											isRecoverPassedSubprocess.set("checked", false);
											query('.isRecoverPassedSubprocessLabel').style("display", 'none');
										} else {
											isRecoverPassedSubprocess.set("checked", false);
											query('.isRecoverPassedSubprocessLabel').style('display', '');
										}
									}
								});
							};
							if (this.parseDeferred) {
								this.parseDeferred.then(thenFun);
							}
						}});
					} else {
						query("#operationsTDContent").html('<bean:message bundle="sys-lbpmservice" key="lbpmNode.flowContent.noRefuseNode" /><input type="hidden" alertText="<bean:message bundle="sys-lbpmservice" key="lbpmNode.flowContent.noRefuseNode" />" key="jumpToNodeId">');
					}
				});
				
				lbpm.globals.hiddenObject(operationsRow, false);
			});
		};
		function OperationCheck(){
			var val = dojo.query("#operationsTDContent [name='jumpToNodeIdSelectObj']").val();
			if (val == null || val == '') {
				alert('<bean:message bundle="sys-lbpmservice" key="lbpmNode.flowContent.noRefuseNode" />');
				return false;
			}
			return lbpm.globals.validateMustSignYourSuggestion();
		};	
		function setOperationParam()
		{		
			var jumpStr = dojo.query("#operationsTDContent [name='jumpToNodeIdSelectObj']").val();
			var jumpArr = jumpStr.split(":");	
			lbpm.globals.setOperationParameterJson(jumpArr[0],"jumpToNodeId", "param");
			if(jumpArr.length>1){
				lbpm.globals.setOperationParameterJson(jumpArr[1],"jumpToNodeInstanceId", "param");
			}else{
				lbpm.globals.setOperationParameterJson("","jumpToNodeInstanceId", "param");
			}
			var refusePassedToThisNode = dijit.registry.byId('refusePassedToThisNode');
			if (refusePassedToThisNode) {
				lbpm.globals.setOperationParameterJson(refusePassedToThisNode.checked, "refusePassedToThisNode", "param");
			}
			var isRecoverPassedSubprocess = dijit.registry.byId('isRecoverPassedSubprocess');
			if (isRecoverPassedSubprocess) {
				//子流程
				lbpm.globals.setOperationParameterJson(isRecoverPassedSubprocess.checked, "isRecoverPassedSubprocess", "param");
			}
		};	
	})(lbpm.operations);
</script>
<%} %>
<script>
//取得有效的上一历史节点对象
lbpm.globals.getHistoryPreviousNodeInfo=function(){
	var passNodeString = lbpm.globals.getAvailableHistoryRoute();
	var passNodeArray = passNodeString.split(";");
	for(var i = passNodeArray.length - 1; i >= 0; i--){
		var passNodeInfo = passNodeArray[i].split(":");
		var nodeInfo = lbpm.nodes[passNodeInfo[0]];
		if (lbpm.globals.checkNodeType(lbpm.constant.NODETYPE_START, nodeInfo)
				|| lbpm.globals.checkNodeType(lbpm.constant.NODETYPE_END, nodeInfo)
				|| lbpm.globals.checkNodeType(lbpm.constant.NODETYPE_AUTOBRANCH, nodeInfo)
				|| lbpm.globals.checkNodeType(lbpm.constant.NODETYPE_MANUALBRANCH, nodeInfo)
				|| lbpm.globals.checkNodeType(lbpm.constant.NODETYPE_SEND, nodeInfo)) {
			continue;
		}
		if(nodeInfo.id == lbpm.nowNodeId){
			continue;
		}
		return passNodeArray[i];
	}
};	
//取得有效的上一历史路径
lbpm.globals.getAvailableHistoryRoute=function(){
	var fdTranProcessObj = document.getElementById("sysWfBusinessForm.fdTranProcessXML");
	var statusData = WorkFlow_GetStatusObjectByXML(fdTranProcessObj.value);
	for(var i=0; i<statusData.runningNodes.length; i++){
		var nodeInfo = statusData.runningNodes[i];
		if(nodeInfo.id == lbpm.nowNodeId){
			return nodeInfo.routePath;
		}
	}
	return "";
}
</script>
