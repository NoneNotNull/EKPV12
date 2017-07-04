/*压缩类型：标准*/
Com_IncludeFile("tag.css",Com_Parameter.ContextPath+"sys/tag/resource/css/","css",true);
function TagOpt(modelName,modelId,key,params, afterOpt){
	this.modelName = modelName;
	this.modelId = modelId;
	this.key = key;
	this.params = params;
	var self = this;
	
	this.onload = function(){
		if(self.params['model']=='edit'){//编辑时
			//标签选择
			$("#tag_selectItem").click(function(){
						Dialog_TreeList(true,"_fdTagsIds","sysTagMainForm.fdTagNames",' ','sysZoneTagCategoryDataService&type=1&fdCategoryId=!{value}', 
								self.params['tree_title'],'sysZoneTagByCategoryDatabean&type=getTag&fdCategoryId=!{value}',self._tag_afterSelect, 'sysZoneTagByCategoryDatabean&key=!{keyword}&type=search');
			});
			//增加表单提交事件
			var events = Com_Parameter.event["submit"];
			events[events.length] = self._tag_submit;
		}
	};
	/******************************内部函数*************************************/
/*	this._tag_submit = function(){
		var queryConditionName = self.params['fdQueryCondition'];
		var queryCondition = "";
		if(queryConditionName!=null){
			var queryConditionNames = queryConditionName.split(";");
			for(var i = 0; i < queryConditionNames.length; i++){
				var condition = queryConditionNames[i];
				var conditionObj = document.getElementsByName(condition);
				if(conditionObj != null){
					queryCondition = queryCondition + conditionObj[0].value+";";
				}
			}
		}
		//$("input[name='sysTagMainForm.fdQueryCondition']").val(queryCondition);
		return true;
	};*/
	
	
	this._personTags_submit =  function (ids, names){
		 seajs.use(['lui/jquery','lui/dialog','lang!sys-zone', 'lui/util/env'], function($, dialog, lang, env){
			$.ajax({
				url : env.fn.formatUrl("/sys/zone/sys_zone_personInfo/sysZonePersonInfo.do?method=addTags"),
				async: false, 
				cache: false,
				data: $("#tagsForm").serialize(),
				type : "POST",
				dataType : "json",
				success : function(data) {
						 	var eleSelect  = params.diaEle;
							var ele = eleSelect ? $(eleSelect) : $(document.body);
							if(data.success==true){
								dialog.success(lang['sysZonePerson.addTagSuccess'], ele);
								$("input[name='sysTagMainForm.fdTagNames']").val(names);
								$("input[name='_fdTagsIds']").val(ids);
								if (params.afterOpt) {
									var ctx = params.afterOpt.ctx ? params.afterOpt.ctx : window;
									params.afterOpt.fn.apply(ctx, [ids, names]);
								}
							}else if(data.success != true){
								dialog.failure(lang['sysZonePerson.addTagFailure'], ele);
							}
				}
			  });
		});	
	};
	this._tag_afterSelect = function(rtnVal){
		if(rtnVal == null)
			return;
		var names = "" , ids = "";
		for(var i=0;i< rtnVal.GetHashMapArray().length;i++){
			var newName = rtnVal.GetHashMapArray()[i]['name'];
			var newId = rtnVal.GetHashMapArray()[i]['id'];
			names += " " + newName;
			ids += " " + newId;
		}
		self._personTags_submit(ids, names);
	};
	
	
}