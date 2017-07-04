
require(["dojo/_base/lang", 
         "dojo/_base/array",
         "dojo/topic",
         "dojo/ready", 
         "mui/util",
         'dojo/query', 
         'dojo/NodeList-dom', 
         'dojo/NodeList-html', 
         "dojo/domReady!"], function(lang, array, topic, ready, util, query) {

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
		for (var key in lbpm.nodes) {
			var node = lbpm.nodes[key];
			var nodeDescObj = lbpm.nodedescs[node.nodeDescType];
			if (nodeDescObj["isHandler"](node) && !nodeDescObj["isBranch"](node)) {
				rtnNodeArray.push(node);
			}
		}
		return rtnNodeArray;
	}

	function updateFutureHandlers(key, idValue, nameValue) {
		if (key.indexOf('handlerIds_') == -1) {
			return;
		}
		var nodeId = key.replace('handlerIds_', '');

		var param = {};
		param.sourceObj = location.href;
		param.nodeInfos = [{
				id:nodeId,
				handlerSelectType:'org',
				handlerIds:idValue,
				handlerNames:nameValue
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
	
	topic.subscribe("/mui/category/submit,/mui/Category/valueChange", function(address, ctx) {
		var key = ctx.key || address.key;
		//key = key.replace('_opt_', '');
		updateFutureHandlers(key, ctx.curIds, ctx.curNames);
	});
	
	function build_change_panel() {

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
					var html = '<div class="modifyNodeAuthorizationSelector">';
					html += "<b>" + nextNode.id + "." + Com_HtmlEscape(nextNode.name) + "</b>";
					html += "(<label id=\"_" + handlerIdsKey + "_label\" class=\"muiCateFiledShow\"></label>)";
					html += HandlerHiddenInput(options);
					if (nextNode.useOptHandlerOnly == "true") { // 只有备选列表
						html += " " + OptHandlerWidget(options, nextNode.optHandlerIds, nextNode.optHandlerSelectType, modelName, modelId);
					} else {
						if (nextNode.optHandlerIds) {
							options["groupBtn"] = true;
							html += '<div data-dojo-type="mui/tabbar/TabBarButtonGroup" data-dojo-props="icon1:\'mui mui-address\'" style="float:right;color:#3298E0;">';
							html += MobileAddress(options);
							html += OptHandlerWidget(options, nextNode.optHandlerIds, nextNode.optHandlerSelectType, modelName, modelId);
							html += '</div>';
						} else {
							html += " " + MobileAddress(options);
						}
					}
					html += '</div>';
					htmls.push(html);
					nodeIds.push(nextNodeId);
				}
			}
			if (htmls.length > 0) {
				ready(function() {
					query("#modifyNodeAuthorizationTr").style("display", "");
					query("#modifyNodeAuthorizationDetail").html(htmls.join(''), {parseContent: true});
				});
			} else {
				query("#modifyNodeAuthorizationTr").style("display", "none");
				query("#modifyNodeAuthorizationDetail").html();
			}
		});
	};

	function alertText(options) {
		return options.alertText ? options.alertText : "";
	}

	function idNameKeyHtml(field) {
		return "id=" + field + " name=" + field +" key="+field+"";
	}
	
	function HandlerHiddenInput(options) {
		var idValue = options['idValue'] || '';
		var nameValue = options['nameValue'] || '';
		var html = "<input type='hidden' alertText='" + alertText(options) + "' value='" + util.formatText(idValue) + "' " + idNameKeyHtml(options.idField) + ">"
			+ "<input type='hidden' " + idNameKeyHtml(options.nameField) + " alertText='' value='" + util.formatText(nameValue) + "'>";
		return html;
	}
	
	function OptHandlerWidget(options, optHandlerIds, optHandlerSelectType, modelName, modelId) {
		var idValue = options['idValue'] || '';
		var nameValue = options['nameValue'] || '';
		var mixin = "";
		if (options.groupBtn) {
			mixin += dojoConfig.baseUrl + "sys/lbpmservice/mobile/change_process/GroupButtonMixin.js";
		}
		
		var html = '<div data-dojo-type="sys/lbpmservice/mobile/opthandler/OptHandler"'
			+ ' data-dojo-mixins="' + mixin + '"'
			+ ' data-dojo-props="idField:\''+util.formatText(options.idField)+'\','
			+ 'optHandlerIds:\'' + util.formatText(optHandlerIds) + '\','
			+ 'optHandlerSelectType:\'' + optHandlerSelectType + '\','
			+ 'fdModelName:\'' + modelName + '\','
			+ 'fdModelId:\'' + modelId + '\','
			+ 'curIds:\'' + util.formatText(idValue) + '\','
			+ 'curNames:\'' + util.formatText(nameValue) + '\','
			+ 'nameField:\''+options.nameField+'\','
			+ 'cateFieldShow:\'#_'+options.idField+'_label\'" style="float:right;width:35px;height:30px;margin:0;"></div>';
		return html;
	}
	
	function MobileAddress(options) {
		var cateFieldShow = ', cateFieldShow:\'#_'+options.idField+'_label\'" style="float:right;width:35px;height:30px;margin:0 5px 0 0;';

		var idValue = options['idValue'] || '';
		var nameValue = options['nameValue'] || '';
		var mixin = "";
		if (options.groupBtn) {
			mixin += dojoConfig.baseUrl + "sys/lbpmservice/mobile/change_process/GroupButtonMixin.js";
		}
		var html = '<div data-dojo-type="mui/form/Address" data-dojo-mixins="' + mixin + '"'
			+' data-dojo-props="type: ORG_TYPE_POSTORPERSON,idField:\''+options.idField+'\','
			+ 'nameField:\''+options.nameField+'\','
			+ 'isMul:'+options.mulSelect+','
			+ 'curIds:\'' + util.formatText(idValue) + '\','
			+ 'curNames:\'' + util.formatText(nameValue) + '\''
			+ cateFieldShow
			+'"></div>';
		return html;
	}
	
	// modifyNodeAuthorizationTr
	var isRootWorkitemOperationFun = function() {
		if (!lbpm.nowProcessorInfoObj)
			return false;
		return array.some(lbpm.nowProcessorInfoObj.operations, function(opt) {
			return (lbpm.operations[opt.id] && lbpm.operations[opt.id].isPassType);}
		);
	};
	if (!isRootWorkitemOperationFun())
		return;
	build_change_panel();
	lbpm.events.addListener(lbpm.constant.EVENT_SELECTEDFUTURENODE, build_change_panel);
});