<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<script type="text/javascript">
	function searchByModel(){
		 var evalObject;
		 var _evalType = $("input[name='fdEvaluationType']");
		 for(type in _evalType){
			if(_evalType[type].checked){
				evalObject = _evalType[type].value;
			}
		 }
		 var modelName = $("select[name='modelName']").val();
		 if(evalObject == 0){
			 seajs.use('lui/topic',function(topic){
				 topic.channel('main').publish('criteria.changed',
							{'criterions':[{'key':'modelName','value':[modelName]}]});
			 });
		 }else{
			 seajs.use('lui/topic',function(topic){
				 topic.channel('notes').publish('criteria.changed',
							{'criterions':[{'key':'modelName','value':[modelName]}]});
			 });
		 }
	}

	function changeEvalType(val){
		if(val == 1){
			//刷新搜索范围
			LUI.$.ajax({
				url: Com_Parameter.ContextPath + 'sys/evaluation/sys_evaluation_main/sysEvaluationNotes.do?method=listModelNames',
				type: 'POST',
				dataType: 'json',
				async : false,
				data: "",
				success: function(data) {
					$("select[name='modelName']").empty();
					var modelNames = data['modelNames'];
					$("select[name='modelName']").append("<option value=''>${lfn:message('sys-evaluation:sysEvaluation.all.system')}</option>");
					for(var i=0;i<modelNames.length;i++){
						$("select[name='modelName']").append("<option value='" + modelNames[i].modelName 
										+ "'>" + modelNames[i].text +"</option>");
					}
				},
				error: function() {
				}
			});
			
			$("#notesView").css("display","block");
			$("#mainView").css("display","none");
			LUI("notes_overView").table.onSourceGet();//初始化段落点评列表
		} else {
			LUI.$.ajax({
				url: Com_Parameter.ContextPath + 'sys/evaluation/sys_evaluation_main/sysEvaluationMain.do?method=listModelNames',
				type: 'POST',
				dataType: 'json',
				async : false,
				data: "",
				success: function(data) {
					$("select[name='modelName']").empty();
					var modelNames = data['modelNames'];
					$("select[name='modelName']").append("<option value=''>${lfn:message('sys-evaluation:sysEvaluation.all.system')}</option>");
					for(var i=0;i<modelNames.length;i++){
						$("select[name='modelName']").append("<option value='" + modelNames[i].modelName 
										+ "'>" + modelNames[i].text +"</option>");
					}
				},
				error: function() {
				}
			});
			
			$("#notesView").css("display","none");
			$("#mainView").css("display","block");
		}
	}
	//查看被点评的文档
	function viewDoc(fdModelId,fdModelName){
		LUI.$.ajax({
			url: Com_Parameter.ContextPath + 'sys/evaluation/sys_evaluation_main/sysEvaluationMain.do?method=getEvalDocUrl',
			type: 'POST',
			dataType: 'json',
			async : false,
			data: {'fdModelId':fdModelId,
					'fdModelName':fdModelName},
			success: function(data) {
				window.open(data['docUrl'], "_blank");
			},
			error: function() {
			}
		});
	}
</script>