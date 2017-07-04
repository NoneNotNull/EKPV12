/*压缩类型：标准*/
Com_IncludeFile("tag.css",Com_Parameter.ContextPath+"sys/tag/resource/css/","css",true);
function TagOpt(modelName,modelId,key,params){
	this.modelName = modelName;
	this.modelId = modelId;
	this.key = key;
	this.params = params;
	var self = this;
	
	this.onload = function(){
		if(self.params['model']=='view'){//阅读时
			var tagNames = $.trim(self.params['fdTagNames']);
			if(tagNames!=null && tagNames!=''){
				var href = Com_Parameter.ContextPath + "sys/ftsearch/searchBuilder.do?method=search&searchFields=tag&newLUI=true";
				if (this.modelName)
					href += ('&modelName=' + self.modelName);
				var tags = tagNames.split(" ");
				var container = $("div.tag_content");
				$.each(tags,function(key,value){
					if(value!=""){
						var tagDom = $("<div/>");
						tagDom.addClass("tag_tagSign");
						tagDom.text(value);
						tagDom.click(function(){
							window.open(href + "&queryString=" + encodeURIComponent(value),"_blank");
						});
						container.append(tagDom);
					}
				}); 
			}
		}
		if(self.params['model']=='edit'){//编辑时
			//初始化
			$("input[name='sysTagMainForm.fdTagNames']").bind("focus",function(){
				self._tag_showTagApplication(true);
			});
			$("input[name='sysTagMainForm.fdTagNames']").bind("click",function(evt){
				evt.stopPropagation();
			});
			$(document.body).bind('click',function(){
				self._tag_showTagApplication(false);
			});
			//提示关闭
//			$("#a_close").click(function(){
//				self._tag_showTagApplication(false);
//			});
			//标签选择
			$("#tag_selectItem").click(function(){
				 //          Dialog_Tree( true , null , null , ' ' ,
                //                        'sysTagCategorApplicationTreeService&fdCategoryId=!{value}',self.params['tree_title' ],
                //                       false ,self._tag_afterSelect, null, false, true ,null );
                var tags = $( "input[name='sysTagMainForm.fdTagNames']").val();
                $( "input[name='sysTagMainForm.fdTagIds']").val(tags);
                Dialog_TreeList( true, "sysTagMainForm.fdTagIds" , "sysTagMainForm.fdTagNames" , ' ' ,
                                  'sysTagCategorTreeService&type=1&fdCategoryId=!{value}' ,
                                  self.params[ 'tree_title' ],'sysTagByCategoryDatabean&type=getTag&fdCategoryId=!{value}' ,
                                  null , 'sysTagByCategoryDatabean&key=!{keyword}&type=search' );

			});
			//标签直接选择
			$("#id_application_div").bind("click", function(evt) {
				var $target = $(evt.target);
				if ($target.attr('name') == 'tag_hot_tag'
						|| $target.attr('name') == 'tag_used_tag')
					self._tag_onSelectValue($target);
				evt.stopPropagation();
			});
			//增加表单提交事件
			var events = Com_Parameter.event["submit"];
			events[events.length] = self._tag_submit;
		}
	};
	/******************************内部函数*************************************/
	this._tag_submit = function(){
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
		$("input[name='sysTagMainForm.fdQueryCondition']").val(queryCondition);
		return true;
	};
	
	this._tag_afterSelect = function(rtnVal){
		if(rtnVal == null)
			return;
		var names = $.trim($("input[name='sysTagMainForm.fdTagNames']").val());
		var ids = $.trim($("input[name='sysTagMainForm.fdTagIds']").val());	
		var nameOldArr = null;
		var idOldArr = null;
		if(names!=null && names!='' ){
			nameOldArr = names.split(' ');
			idOldArr = ids.split(' ');
		}else{
			nameOldArr = [];
			idOldArr = [];
		}
		var nameArr = nameOldArr;
		var idArr = idOldArr;
		for(var i=0;i< rtnVal.GetHashMapArray().length;i++){
			var newName = rtnVal.GetHashMapArray()[i]['name'];
			var newId = rtnVal.GetHashMapArray()[i]['id'];
			var hasCfg = false;
			$.each(nameOldArr,function(index,value){
				if(value == newName){
					hasCfg = true;
				}
			});
			if(!hasCfg){
				nameArr.push(newName);
				idArr.push(newId);
			}
		}
		$("input[name='sysTagMainForm.fdTagNames']").val(nameArr.join(' '));
		$("input[name='sysTagMainForm.fdTagIds']").val(idArr.join(' '));
	};
	
	this._tag_showTagApplication = function(isShow){
		var divObj = $("#id_application_div");
		if(isShow == true){
			var queryCondition = '';
			var queryConditionName = self.params['fdQueryCondition'];
			if(queryConditionName!=null){
				var queryConditionNames = queryConditionName.split(";");
				for(var i = 0; i < queryConditionNames.length; i++){
					var condition = queryConditionNames[i];
					var conditionObj = document.getElementsByName(condition);
					if(conditionObj != null){
						queryCondition = queryCondition + conditionObj[0].value+";";
					}
				}
				$("input[name='sysTagMainForm.fdQueryCondition']").val(queryCondition);
				var kmssData = new KMSSData(); 
				kmssData.AddBeanData("sysTagApplicationLogSupplyService&queryCondition="+queryCondition+"&modelName="+self.modelName);
				var templetData=kmssData.GetHashMapArray();		
				if(templetData.length > 0){	
					var hotTitle = templetData[0]['hotTitle'];
					$("#hot_id").html(self.params['tag_msg1']+hotTitle);
					var usedTitle = templetData[1]['usedTitle'];
					$("#used_id").html( self.params['tag_msg2']+usedTitle);
				}
			}
			divObj.show();
		}else{
			divObj.hide();
		}
	};
	//选择已有标签
	this._tag_onSelectValue = function(obj){
		var tagObj = $("input[name='sysTagMainForm.fdTagNames']");
		var obj_value = $.trim(tagObj.val());
		var selectVal = $(obj).text();
		var position = obj_value.indexOf(selectVal);
		if(obj_value==""){
			obj_value = selectVal;
		}else{
			var values = obj_value.split(" ");
			var hasVal = false;
			for(var i=0;i<values.length;i++){
				if(values[i]==selectVal){
					hasVal = true;
					break;
				}
			}
			if(!hasVal){
				values.push(selectVal);
			}
			obj_value = values.join(" ");
		}
		tagObj.val(obj_value);
	};
}