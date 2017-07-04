//"取消沟通"操作类
( function(operations) {
	operations['handler_cancelCommunicate'] = {
		click : OperationClick,
		check : OperationCheck,
		setOperationParam : setOperationParam
	};

	// 处理人操作：取消沟通
	function OperationClick(operationName) {
		lbpm.globals.getOperationParameterJson("relationWorkitemId:relationScope:relations:isMutiCommunicate",true); // 加载后端数据
		var operationsRow = document.getElementById("operationsRow");
		var relationInfoObj = lbpm.globals.getCurrRelationInfo();
		if (relationInfoObj.length > 0) {
			var operationsTDTitle = document.getElementById("operationsTDTitle");
			var operationsTDContent = document
					.getElementById("operationsTDContent");
			operationsTDTitle.innerHTML = lbpm.constant.opt.CommunicatePeople;
			var html = [];
			for ( var i = 0; i < relationInfoObj.length; i++) {
				html
						.push('<label><input type="checkbox" name="WorkFlow_CelRelationWorkitems" checked value="'
								+ relationInfoObj[i].itemId
								+ '">'
								+ relationInfoObj[i].userName + '</label>');
			}
			operationsTDContent.innerHTML = html.join('');
			lbpm.globals.hiddenObject(operationsRow, false);
		} else {
			lbpm.globals.hiddenObject(operationsRow, true);
		}
	}

	// “取消沟通”操作的检查
	function OperationCheck() {
		var arr=$("[name='WorkFlow_CelRelationWorkitems']:checked");
		if(arr.length==0) {
			alert(lbpm.constant.opt.CommunicateNeedSelectCanceler);
			return false;
		}
		return true;

	}
	// 设置"取消沟通"操作的参数
	function setOperationParam() {
		//要取消的沟通人员ID
		var cancelHandlerIds="";
		$("[name='WorkFlow_CelRelationWorkitems']:checked").each(function(i){
			if(cancelHandlerIds=='')
				cancelHandlerIds=this.value;
			else
				cancelHandlerIds+=";"+this.value;
		});
		lbpm.globals.setOperationParameterJson(cancelHandlerIds, "cancelHandlerIds", "param");
	}

})(lbpm.operations);
