$(function() {
(function() {
	function checkModifyNodeAuthorization(nodeObj, allowModifyNodeId,throughNodesStr){
		var index, nodeIds;
		throughNodesStr+=",";
		//如果要修改的节点不在当前计算后应该出现的节点中（及自动决策将流向的分支）这不出现在待修改列表中
		if(throughNodesStr.indexOf(allowModifyNodeId+",") == -1){
			return false;
		}
		if(nodeObj.canModifyHandlerNodeIds != null && nodeObj.canModifyHandlerNodeIds != ""){
			nodeIds = nodeObj.canModifyHandlerNodeIds + ";";
			index = nodeIds.indexOf(allowModifyNodeId + ";");
			if(index != -1){
				return true;
			}
		}
		if(nodeObj.mustModifyHandlerNodeIds != null && nodeObj.mustModifyHandlerNodeIds != ""){
			nodeIds = nodeObj.mustModifyHandlerNodeIds + ";";
			index = nodeIds.indexOf(allowModifyNodeId + ";");
			if(index != -1){
				return true;
			}
		}
	
		return false;
	}
	
	function getAllNodeArray(){
		var rtnNodeArray = new Array();
		$.each(lbpm.nodes, function(index, node) {
			var nodeDescObj = lbpm.nodedescs[node.nodeDescType];
			if (nodeDescObj["isHandler"](node) && !nodeDescObj["isBranch"](node)) {
				rtnNodeArray.push(node);
			}
		});
		return rtnNodeArray;
	}

	function updateFutureHandlers(idField, nameFiled) {
		if (idField.indexOf('handlerIds_') == -1) {
			return;
		}
		var nodeId = idField.replace('handlerIds_', '');

		var pdaIdField = $("input[name='"+idField+"']");
		var pdaNameField = $("input[name='"+nameFiled+"']");
		
		if (lbpm.nodes[nodeId].handlerSelectType == 'formula') {
			var idValue = pdaIdField.val();
			var nameValue = pdaNameField.val();
			if (idValue == '' && nameValue == lbpm.workitem.constant.COMMONHANDLERISFORMULA) {
				return;
			}
			idValue = idValue.replace(";formula", '');
			idValue = idValue.replace("formula;", '');
			nameValue = nameValue.replace(";" + lbpm.workitem.constant.COMMONHANDLERISFORMULA, '');
			nameValue = nameValue.replace(lbpm.workitem.constant.COMMONHANDLERISFORMULA + ";", '');
			
			pdaIdField.val(idValue);
			pdaNameField.val(nameValue);
			Pda_init(idField, nameFiled, ";", true);
		}

		var param = {};
		param.sourceObj = location.href;
		param.nodeInfos = [{
				id:nodeId,
				handlerSelectType:'org',
				handlerIds:pdaIdField.val(),
				handlerNames:pdaNameField.val()
		}];
		lbpm.events.fireListener(lbpm.constant.EVENT_MODIFYNODEATTRIBUTE, param);
	}
	
	function getSelectType(node) {
		var selectType = lbpm.constant.ADDRESS_SELECT_POSTPERSONROLE;
		if (lbpm.globals.checkNodeType(lbpm.constant.NODETYPE_SEND, node)) {
			selectType = lbpm.constant.ADDRESS_SELECT_ALLROLE;
		}
		return selectType;
	}

	lbpm.globals.temp_updateFutureHandlers = updateFutureHandlers;
	
	if (window.dojo) {
		require(["dojo/topic"], function(topic) {
			topic.subscribe("/mui/category/submit", function(address, ctx) {
				var idField = ctx.key.replace('_opt_', '');
				var nameField = idField.replace('handlerIds_', 'handlerNames_');
				updateFutureHandlers(idField, nameField);
			});
		});
	}
	
	var build_change_panel = function() {

		var modelName = lbpm.modelName;
		var modelId = lbpm.modelId;
		
		lbpm.globals.getThroughNodes(function(throughtNodes){
			var throughNodesStr = lbpm.globals.getIdsByNodes(throughtNodes);
			var fieldList = lbpm.globals.getFormFieldList();
			var currentNode = lbpm.globals.getNodeObj(lbpm.nowNodeId);
			var nextNodeArray = getAllNodeArray();
			var htmls = [];
			var nodeIds = [];
			for(var i = 0; i < nextNodeArray.length; i++){
				var nextNode = nextNodeArray[i];
				var nextNodeId = nextNode.id;
				if(!(lbpm.globals.judgeIsNecessaryAlert(nextNode))) continue ;
				if(checkModifyNodeAuthorization(currentNode, nextNodeId, throughNodesStr)){
					
					var isFormulaType = (nextNode.handlerSelectType == 'formula');
					var handlerIds = (nextNode.handlerIds == null) ? "" : nextNode.handlerIds;
					var handlerNames = (nextNode.handlerNames == null) ? "" : nextNode.handlerNames;
					if (isFormulaType) {
						handlerIds = "formula";
						handlerNames = lbpm.workitem.constant.COMMONHANDLERISFORMULA;
					}
	
					var handlerIdsKey = "handlerIds_" + nextNodeId;
					var handlerNamesKey = "handlerNames_" + nextNodeId;
					
	
					var options = {
							idField: handlerIdsKey,
							nameField: handlerNamesKey,
							mulSelect: true,
							splitStr: ';',
							selectType: getSelectType(nextNode),
							addAction: 'lbpm.globals.temp_updateFutureHandlers',
							deleteAction: 'lbpm.globals.temp_updateFutureHandlers',
							idValue: handlerIds,
							nameValue: handlerNames,
							cateFieldShow: true
					};
					var html = '<div style="height:30px;clear:both;margin: 5px 0;">';
					html += "<b>" + nextNode.id + "." + Com_HtmlEscape(nextNode.name) + "</b>";
					html += "(<label id=\"_" + handlerIdsKey + "_label\" class=\"muiCateFiledShow\"></label>)";
					if (nextNode.useOptHandlerOnly == "true") { // 只有备选列表
						html += " " + Pda_selectOptFullHtml(options, nextNode.optHandlerIds, nextNode.optHandlerSelectType, modelName, modelId);
					} else {
						if (window.dojo && nextNode.optHandlerIds) {
							options["groupBtn"] = true;
							html += '<li data-dojo-type="mui/tabbar/TabBarButtonGroup" data-dojo-props="icon1:\'mui mui-org\'" style="float:right;color:#3298E0;">';
							html += lbpm.address.html_build(options);
							html += Pda_selectOptBtnHtml(options, nextNode.optHandlerIds, nextNode.optHandlerSelectType, modelName, modelId);
							html += '</li>';
						} else {
							html += " " + lbpm.address.html_build(options);
							if (nextNode.optHandlerIds)
								html += " " + Pda_selectOptBtnHtml(options, nextNode.optHandlerIds, nextNode.optHandlerSelectType, modelName, modelId);
						}
					}
					html += '</div>';
					htmls.push(html);
					nodeIds.push(nextNodeId);
				}
			}
			if (htmls.length > 0 && window.dojo) {
				require(["dojo/ready", 'dojo/query', 'dojo/NodeList-dom', 'dojo/NodeList-html'], function(ready, query) {
					ready(function() {
						query("#modifyNodeAuthorizationTr").style("display", "");
						query("#modifyNodeAuthorizationDetail").html(htmls.join(''), {parseContent: true});
					});
				});
				return;
			}
			if (htmls.length > 0) {
				$("#modifyNodeAuthorizationTr").show();
				$("#modifyNodeAuthorizationDetail").html(htmls.join(''));
				$.each(nodeIds, function(i, nextNodeId) {
					var handlerIdsKey = "handlerIds_" + nextNodeId;
					var handlerNamesKey = "handlerNames_" + nextNodeId;
					Pda_init(handlerIdsKey, handlerNamesKey, ";");
				});
			} else {
				$("#modifyNodeAuthorizationTr").hide();
				$("#modifyNodeAuthorizationDetail").html('');
			}
		});
	};
	
	/*
	var build_one_future = function(nodeObj) {
		var html = "";
		var lineName = lineObj.name == null?"":lineObj.name + " ";
		var isFormulaType = (nextNode.handlerSelectType == 'formula');
		var handlerIds = (nextNode.handlerIds == null) ? "" : nextNode.handlerIds;
		var handlerNames = (nextNode.handlerNames == null) ? "" : nextNode.handlerNames;
		html += "<label id='nextNodeName[0]'>";
		html += "<b>" + lineName + nodeObj.id + "." + nodeObj.name + "</b></label>";
		var options = {
				idField: "handlerIds[0]",
				nameField: "handlerNames[0]",
				mulSelect: true,
				splitStr: ';',
				selectType: getSelectType(nodeObj),
				addAction: 'lbpm.globals.temp_updateFutureHandlers',
				deleteAction: 'lbpm.globals.temp_updateFutureHandlers',
				idValue: handlerIds,
				nameValue: handlerNames
		};
		return html + lbpm.address.html_build(options);
	};*/
	
	// modifyNodeAuthorizationTr
	var isRootWorkitemOperationFun = function() {
		if (!lbpm.nowProcessorInfoObj)
			return false;
		var isRootWorkitemOperation = false;
		$.each(lbpm.nowProcessorInfoObj.operations, function() {
			if (lbpm.operations[this.id] && lbpm.operations[this.id].isPassType) {
				isRootWorkitemOperation = true;
				return false;
			}
		});
		return isRootWorkitemOperation;
	};
	if (!isRootWorkitemOperationFun())
		return;
	build_change_panel();
	lbpm.events.addListener(lbpm.constant.EVENT_SELECTEDFUTURENODE, build_change_panel);
	if (window._Delete_Address_dialog_Funs)
		_Delete_Address_dialog_Funs.push(lbpm.globals.temp_updateFutureHandlers);
})(lbpm);

});