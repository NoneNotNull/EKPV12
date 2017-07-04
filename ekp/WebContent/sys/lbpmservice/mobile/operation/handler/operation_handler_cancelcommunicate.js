(function(operations) {
	operations['handler_cancelCommunicate'] = {
		click : OperationClick,
		check : OperationCheck,
		setOperationParam : setOperationParam
	};
	function OperationClick(operationName) {
		lbpm.globals.getOperationParameterJson("relationWorkitemId:relationScope:relations:isMutiCommunicate",true); // 加载后端数据
		var operationsRow = document.getElementById("operationsRow");
		var relationInfoObj = lbpm.globals.getCurrRelationInfo();
		if (relationInfoObj.length > 0) {
			var operationsTDTitle = document.getElementById("operationsTDTitle");
			operationsTDTitle.innerHTML = lbpm.constant.opt.CommunicatePeople;
			var html = '<div data-dojo-type="mui/form/CheckBoxGroup" id="WorkFlow_CelRelationWorkitemsGroup" '
					+ 'data-dojo-props="name:\'WorkFlow_CelRelationWorkitemsGroup\'"></div>';
			var data = [];
			for ( var i = 0; i < relationInfoObj.length; i++) {
				data.push({value: relationInfoObj[i].itemId, text: relationInfoObj[i].userName});
			}
			require(['dojo/ready', 'dojo/query', "dijit/registry", "dojo/store/Memory"], function(ready, query, registry, Memory) {
				ready(function() {
					query('#operationsTDContent').html(html, {parseContent: true, onEnd: function() {
						this.inherited("onEnd", arguments);
						if (this.parseDeferred) {
							this.parseDeferred.then(function() {
								var WorkFlow_CelRelationWorkitemsGroup = registry.byId('WorkFlow_CelRelationWorkitemsGroup');
								WorkFlow_CelRelationWorkitemsGroup.setStore(new Memory({
									data : data
								}));
							});
						}
					}});
					lbpm.globals.hiddenObject(operationsRow, false);
				});
			});
		} else {
			lbpm.globals.hiddenObject(operationsRow, true);
		}
	}

	// “取消沟通”操作的检查
	function OperationCheck() {
		var WorkFlow_CelRelationWorkitemsGroup = dijit.registry.byId('WorkFlow_CelRelationWorkitemsGroup');
		var val = WorkFlow_CelRelationWorkitemsGroup.get('value');
		if(val == null || val == '') {
			alert(lbpm.constant.opt.CommunicateNeedSelectCanceler);
			return false;
		}
		return true;

	}
	function setOperationParam() {
		var WorkFlow_CelRelationWorkitemsGroup = dijit.registry.byId('WorkFlow_CelRelationWorkitemsGroup');
		var val = WorkFlow_CelRelationWorkitemsGroup.get('value');
		lbpm.globals.setOperationParameterJson(val, "cancelHandlerIds", "param");
	}

})(lbpm.operations);
