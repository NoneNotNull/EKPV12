//"回复沟通"操作类
( function(operations) {
	operations['handler_returnCommunicate'] = {
		click : OperationClick,
		check : OperationCheck,
		setOperationParam : setOperationParam
	};

	// 处理人操作：回复沟通
	function OperationClick(operationName) {
	}

	// “回复沟通”操作的检查
	function OperationCheck() {
		return lbpm.globals.validateMustSignYourSuggestion();
	}
	
	// 设置"回复沟通"操作的参数
	function setOperationParam() {

	}
})(lbpm.operations);