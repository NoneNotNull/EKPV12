// operationButtonType为流程提交按扭的Flag值，通过"handler_pass"、驳回"handler_refuse"
lbpm.globals.simpleTagFlowSubmitEvent = function(operationButtonType,contentId) {
	$("input[name=oprGroup]").each( function() {
		var _this = $(this);
		var radioObjVal = _this.val().split(":");
		if (radioObjVal[0] == operationButtonType) {
			_this.attr("checked", "true");
			_this.trigger("click");
			return false;
		}
	});
	
	$("textarea[name=fdUsageContent]").val($("textarea[name='textareaNote_"+contentId+"']").val());
	//驳回类型
	var rejectType=$("textarea[name='textareaNote_"+contentId+"']").attr("rejectType");
	if('handler_pass'==operationButtonType){
		
	}
	else if('handler_refuse'==operationButtonType){
		//增加延时 如果驳回的节点列表没有加载，就等待加载成功再继续
		if(!$("select[name=jumpToNodeIdSelectObj]")[0]||$("select[name=jumpToNodeIdSelectObj]")[0].options.length==0){
			setTimeout(function(){
				lbpm.globals.simpleTagFlowSubmitEvent(operationButtonType,contentId);
				}
			,100);
			return;
		}
		//驳回选择节点
		if(rejectType=='1'){
			$("div[id*='refuseNodesDiv_']").each(function(){
				$(this).hide();
			});
			$("#refuseNodesDiv_"+contentId).show();
			$("#refuseNodesDiv_"+contentId).html("<a href='#' style='text-decoration:underline' onclick='$(this).parent().hide();'>关闭</a> <br/><select id='refuseNodes_"+contentId+"' style='margin-top:5px;width:140px;' onchange='$(\"select[name=jumpToNodeIdSelectObj]\").val($(this).val())'>"+$("select[name=jumpToNodeIdSelectObj]").html()+"</select>&nbsp&nbsp<a href='#' style='text-decoration:underline' tagId='"+contentId+"' onclick='rejectNode_controlSimpleTagWorkflow_ok(this)'>确定</a>");
			$("#refuseNodes_"+contentId)[0].options[$("#refuseNodes_"+contentId)[0].options.length-1].selected=true;
			return ;
		}
	}
	$("#process_review_button").trigger("click");
};
function rejectNode_controlSimpleTagWorkflow_ok(obj){
	$("textarea[name=fdUsageContent]").val($("textarea[name='textareaNote_"+$(obj).attr('tagId')+"']").val());
	$("#process_review_button").trigger("click");
}
lbpm.globals.controlSimpleTagWorkflowComponents = function(isShow,obj) {
	var tagId=$(obj).attr("tagId");
	//新建的时候不需要出现审批框
	if(!document.getElementById("process_review_button")){
		$("div[name='div_"+tagId+"']").hide();
		return;
	}
	if (isShow) {
		var nowProcessorInfoObj = lbpm.nowProcessorInfoObj;		
		var canShow=false;
		if (nowProcessorInfoObj) {
			//按节点
			if($(obj).attr('mould')=='21'){
				var setNodes=$(obj).attr('wfValue').split(";");
				var hasIn=false;
				for(var i=0;i<setNodes.length;i++){
					if(nowProcessorInfoObj['nodeId']==setNodes[i]){
						hasIn=true;
						break;
					}
				}
				canShow=hasIn;
			}
			//按人
			else{
				canShow=$(obj).attr('resValue')=='true';
			}
			if(canShow){
				
				//是否有需要显示的操作按钮
				var hasOp=false;
				if (nowProcessorInfoObj.operations) {
					for ( var i = 0; i < nowProcessorInfoObj.operations.length; i++) {
						var operation = nowProcessorInfoObj.operations[i];
						//通过或签字
						if ("handler_pass" == operation.id||'handler_sign'== operation.id) {
							$("#pass_"+tagId).html(operation.name);
							$("#pass_"+tagId).css("display","inline-block");
							hasOp=true;
						} else if ("handler_refuse" == operation.id) {
							if($(obj).attr('rejectType')=='1'){
								$("#refuse_"+tagId).html(operation.name);
							}
							else{
								$("#refuse_"+tagId).html(operation.name+'上一级');
							}
							$("#refuse_"+tagId).css("display","inline-block");
							hasOp=true;
						}
					}
				}
				//没有任何操作时直接隐藏整个控件
				if(hasOp){
					$("div[name='div_"+tagId+"']").css("display","inline-block");
				}
			}
			else{
				$("div[name='div_"+tagId+"']").hide();
			}
		}
	} else {
		$("div[name='div_"+tagId+"']").hide();
	}
};
lbpm.globals.simpleTagFlowSetCommonUsages=function(obj){
	var tagId=$(obj).attr("tagId");
	$("textarea[name ='textareaNote_"+tagId+"']").val($(obj).val());
}
// 初始化简易流程的参数
$(document).ready( function() {
	$("textarea[name *='textareaNote_']").each(function(){
			if (lbpm.nowProcessorInfoObj) {
				lbpm.globals.controlSimpleTagWorkflowComponents(true,this);
			} else {
				lbpm.globals.controlSimpleTagWorkflowComponents(false,this);
			}
	});
});
$(window).load( function() {
	// 初始化简版审批意见(详版中暂存的意见)
		//var fdUsageContent = $("textarea[name=fdUsageContent]").val();
		//$("textarea[name=fdSimpleUsageContent]").val(fdUsageContent);
	});