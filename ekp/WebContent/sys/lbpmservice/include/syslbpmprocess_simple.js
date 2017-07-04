// operationButtonType为流程提交按扭的Flag值，通过"handler_pass"、驳回"handler_refuse"
lbpm.globals.simpleFlowSubmitEvent = function(operationButtonType) {
	$("input[name=oprGroup]").each( function() {
		var _this = $(this);
		var radioObjVal = _this.val().split(":");
		if (radioObjVal[0] == operationButtonType) {
			_this.attr("checked", "true");
			_this.trigger("click");
			return false;
		}
	});
	var fdSimpleUsageContent = $("textarea[name=fdSimpleUsageContent]").val();
	$("textarea[name=fdUsageContent]").val(fdSimpleUsageContent);
	Com_Submit(document.sysWfProcessForm, 'update');
};
lbpm.globals.controlSimpleWorkflowComponents = function(isShow) {
	if (isShow) {
		var nowProcessorInfoObj = lbpm.nowProcessorInfoObj;
		if (nowProcessorInfoObj) {
			$("tr[id=simpleWorkflowRow]").show();
			if (nowProcessorInfoObj.operations) {
				for ( var i = 0; i < nowProcessorInfoObj.operations.length; i++) {
					var operation = nowProcessorInfoObj.operations[i];
					if ("handler_pass" == operation.id) {
						$("#simple_handler_pass").show();
					} else if ("handler_refuse" == operation.id) {
						$("#simple_handler_refuse").show();
					} else if ("handler_sign" == operation.id) {
						$("#simple_handler_sign").show();
					}
				}
			}
		}
	} else {
		$("tr[id=simpleWorkflowRow]").hide();
		$("#simple_handler_pass").hide();
		$("#simple_handler_refuse").hide();
		$("#simple_handler_sign").hide();
	}
};
// 初始化简易流程的参数
$(document).ready( function() {
	if (lbpm.nowProcessorInfoObj) {
		lbpm.globals.controlSimpleWorkflowComponents(true);
	} else {
		lbpm.globals.controlSimpleWorkflowComponents(false);
	}
});
$(window).load( function() {
	// 初始化简版审批意见(详版中暂存的意见)
		var fdUsageContent = $("textarea[name=fdUsageContent]").val();
		$("textarea[name=fdSimpleUsageContent]").val(fdUsageContent);
	});