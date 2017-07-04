define([
    "dojo/_base/declare",
    "dojo/_base/lang",
    "dojo/query",
    "dojo/_base/array",
	"dojo/dom-class",
	"dojo/dom-construct",
	"dojo/dom-style",
	"mui/form/RadioGroup",
	"mui/form/Radio",
	"mui/util",
	"dijit/registry"
	], function(declare, lang, query, array, domClass, domConstruct, domStyle, _RadioGroup, _Radio, util, registry) {
	
	var Radio = declare("sys.lbpmservice.mobile.workitem.Radio", [_Radio], {
		
		rightText: null,
		
		handlerIds: null,
		
		handlerSelectType: null,
		
		isManualBranch: true,
		
		buildRendering : function() {
			this.inherited(arguments);
			if (this.rightText != null && this.rightText != 'none') {
				var noSet = this.rightText == '';
				var self = this;
				var action = function(data) {
					var text = self.rightText, result = data.GetHashMapArray();
					if (result.length > 0 && result[0].name) {
						text = result[0].name
					}
					self.rightTextNode = domConstruct.create('div', {
						className : noSet ? 'handlerNamesLabel noHandlerNamesLabel' : 'handlerNamesLabel' ,
						innerHTML : noSet ? "未设置" : util.formatText(text),
						id: "handlerShowNames[" + self.index + "]"
					}, self.fieldOptions, 'last');
				};
				if(this.handlerSelectType=="formula"){
					lbpm.globals.formulaNextNodeHandler(this.handlerIds,true,this.distinct, action);
				}else{
					lbpm.globals.parseNextNodeHandler(this.handlerIds,true,this.distinct, action);
				}
			}
			if (!this.isManualBranch) {
				this.domNode.removeAttribute('key');
			}
		},
		
		_onClick: function() {
			if (!this.isManualBranch) {
				this.set("checked", false);
				return;
			}
			this.inherited(arguments);
			lbpm.events.fireListener(lbpm.constant.EVENT_SELECTEDFUTURENODE,null);
		}
	});
	
	//解析节点处理人详细信息（组织架构配置）
	lbpm.globals.parseNextNodeHandler=function(ids, analysis4View, distinct, action) {
		if (ids == '' || ids == null) {
			return [{name: lbpm.constant.COMMONNODEHANDLERORGEMPTY}];
		}
		ids = encodeURIComponent(ids);
		var other = "&modelId=" + lbpm.globals.getWfBusinessFormModelId();
		var rolesSelectObj = document.getElementsByName('rolesSelectObj');
		if (rolesSelectObj != null && rolesSelectObj.length > 0) {
			other += "&drafterId=" + rolesSelectObj[0].value;
		}
		var url = "lbpmHandlerParseService&handlerIds=" + ids + other+"&analysis4View="+analysis4View;
		if(distinct) {
			url += "&distinct=true";
		}
		var data = new KMSSData(); 
		if(action) {
			data.SendToBean(url, action);
		} else {
			return data.AddBeanData(url).GetHashMapArray();
		}
	}

	// 解析节点处理人详细信息（公式配置）
	lbpm.globals.formulaNextNodeHandler=function(formula, analysis4View, distinct, action) {
		if (formula == '' || formula == null) {
			return [{name: '('+lbpm.constant.COMMONNODEHANDLERORGEMPTY+')'}];
		}
		formula = encodeURIComponent(formula);
		var other = "&modelId=" + lbpm.globals.getWfBusinessFormModelId() + "&modelName=" + lbpm.globals.getWfBusinessFormModelName();
		var rolesSelectObj = document.getElementsByName('rolesSelectObj');
		if (rolesSelectObj != null && rolesSelectObj.length > 0) {
			other += "&drafterId=" + rolesSelectObj[0].value;
		}
		var url = "lbpmHandlerParseService&formula=" + formula + other+"&analysis4View="+analysis4View;
		if(distinct) {
			url += "&distinct=true";
		}
		var data = new KMSSData();
		if(action) {
			data.SendToBean(url, action);
		} else {
			return data.AddBeanData(url).GetHashMapArray();
		}
	}
	
	return declare("sys.lbpmservice.mobile.workitem.FutureNodes", [_RadioGroup], {
		
			tmpl : '<input type="radio" id="futureNodeId[!{index}]" data-dojo-type="sys.lbpmservice.mobile.workitem.Radio"'
				+ ' manualBranchNodeId="!{manualBranchNodeId}" key="futureNodeId" index="!{index}"'
				+ 'data-dojo-props="checked:!{checked},showStatus:\'edit\',name:\'!{name}\',text:\'!{text}\',value:\'!{value}\''
				+ ',rightText:\'!{rightText}\',index:\'!{index}\',handlerSelectType:\'!{handlerSelectType}\',distinct:!{distinct},handlerIds:\'!{handlerIds}\',isManualBranch:!{isManualBranch}">',

			onComplete : function(items) {
				var g = this.generateList(items);
				var self = this;
				if (g && g.then) {
					g.then(function() {
						if (items && items.length == 1) {
							query('.muiFieldText', self.domNode).style({'margin-left': '0', 'padding-left': '5px'});
							query('.muiFormRadio', self.domNode).style('display', 'none');
						}
					});
				}
			},
			
			startup: function() {
				var nextNodeObj = lbpm.globals.getNextNodeObj(lbpm.nowNodeId);
				var routeLines=lbpm.nodedescs[nextNodeObj.nodeDescType].getLines(lbpm.globals.getCurrentNodeObj(),nextNodeObj, true);
				if(routeLines.length==1 && lbpm.globals.checkNodeType(lbpm.constant.NODETYPE_MANUALBRANCH,routeLines[0].startNode)){
					this.set("value",routeLines[0].endNode.id);
				}
				var _self = this;
				this.store = array.map(routeLines, function(lineObj, i) {
					var nodeObj = lineObj.endNode;
					var lineName = lineObj.name == null ? "" : lineObj.name + ' ';
					var isManualBranch = lbpm.globals.checkNodeType(lbpm.constant.NODETYPE_MANUALBRANCH,lineObj.startNode);
					return {
						text:util.formatText(lineName + nodeObj.id + "." + nodeObj.name) , 
						checked: isManualBranch && _self.value == nodeObj.id, 
						value: nodeObj.id,
						manualBranchNodeId: lineObj.startNode.id,
						index: i,
						rightText: nodeObj.handlerNames == null ? "none" : util.formatText(nodeObj.handlerNames),
						handlerIds: nodeObj.handlerIds == null ? "none" : util.formatText(nodeObj.handlerIds),
						distinct: lbpm.globals.checkNodeType(lbpm.constant.NODETYPE_SEND,nodeObj),
						handlerSelectType: nodeObj.handlerSelectType,
						isManualBranch: isManualBranch,
						name: isManualBranch ? 'futureNode' : '__futureNode__'
					};
				});
				this.inherited(arguments);
			},
			
			createListItem : function(props) {
				if (this.isConcentrate(props))
					return null;
				var tmpl = this.tmpl.replace('!{value}', props.value)
								.replace('!{text}', props.text)
								.replace('!{manualBranchNodeId}', props.manualBranchNodeId)
								.replace(/!{index}/g, props.index)
								.replace('!{checked}', props.checked ? true : false)
								.replace('!{distinct}', props.distinct)
								.replace('!{handlerIds}', props.handlerIds)
								.replace('!{handlerSelectType}', props.handlerSelectType)
								.replace('!{isManualBranch}', props.isManualBranch)
								.replace('!{name}', props.name)
								.replace('!{rightText}', props.rightText);
				var item = domConstruct.toDom(tmpl);
				return item;
			}
	});
});