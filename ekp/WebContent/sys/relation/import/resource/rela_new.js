/*压缩类型：标准*/
//关联配置按钮对应动作
function RelationOpt(modelName,modelId,key,params){
	this.modelName = modelName;
	this.modelId = modelId;
	this.key = key;
	this.varName = "_relationCfg";
	this.params = params;
	var self = this;
	window[self.varName] = self;
	if(self.params["varName"]!=null && self.params["varName"]!=''){
		window[self.params["varName"]] = self;
	}
	/*********************外部调用函数****************************/
	//关联机制加载
	this.onload = function(){
		$("#rela_config_btn").click(function(){
			self.editConfig();
		});
		Com_Parameter.event["submit"][Com_Parameter.event["submit"].length] = self._rela_bulidFormInfo;
		
	};
	//增加关联配置按钮
	this.addButton = function(){
		
	};
	//关联配置
	//添加关联机制关闭回调函数
	this.editConfig = function(__func){
		self._rela_addCfg(__func);
	};
	//保存关联配置
	this.saveConfig = function(cfgNar){
		self._rela_saveCfg(cfgNar);
	};
	//关闭关联配置
	this.closeConfig = function(){
		self.dialogObj.hide();
	};
	
	this.refreshConfig = function(){
		self._rela_saveCfg();
	};
	/***********************内部调用函数*************************************/
	//构造关联机制表单存储字段
	this._rela_bulidFormInfo = function(){
		var formObj = $(document.forms[self.params['rela.mainform.name']]); 
		$("input[name='fdId']").appendTo(formObj);
		$("input[name='fdKey']").appendTo(formObj);
		$("input[name='fdModelName']").appendTo(formObj);
		$("input[name='fdModelId']").appendTo(formObj);
		$("input[name='fdParameter']").appendTo(formObj);
		if(window.relationEntrys!=null){
			var i = 0;
			var entryPrefix = 'sysRelationEntryFormList';
			for(var tmpKey in window.relationEntrys){
				var entry =  window.relationEntrys[tmpKey];
				for(var tmpField in entry){
					if(tmpField == 'relationConditions'){
						var count = 0;
						var conditions = entry.relationConditions;
						for(var condition in conditions){
							var conditionPrefix = entryPrefix +"[" + i + "].sysRelationConditionFormList";
							for(var condProp in conditions[condition]){
								var condFileName = conditionPrefix+ "[" + count + "]." + condProp;
								var condFiledObj = $("input[name='"+ condFileName +"']");
								if(condFiledObj.length<=0){
									condFiledObj = $("<input type='hidden' name='" + condFileName+ "'/>");
								}
								condFiledObj.val(conditions[condition][condProp]);
								condFiledObj.appendTo(formObj);
							}
							count++;
						}
					}else if(tmpField == 'staticInfos'){
						var cnt = 0;
						var staticInfos = entry.staticInfos;
						for(var staticInfo in staticInfos){
							var staticPrefix = entryPrefix +"[" + i + "].sysRelationStaticNewFormList";
							for(var index in staticInfos[staticInfo]){
								for(var condProp in staticInfos[staticInfo][index]){
									var condFileName = staticPrefix+ "[" + count + "]." + condProp;
									var condFiledObj = $("input[name='"+ condFileName +"']");
									if(condFiledObj.length<=0){
										condFiledObj = $("<input type='hidden' name='" + condFileName+ "'/>");
									}
									condFiledObj.val(staticInfos[staticInfo][index][condProp]);
									condFiledObj.appendTo(formObj);
								}
								count++;
							}
						}
						
					}else{
						var filedName = entryPrefix + "[" + i + "]." + tmpField;
						var filedObj = $("input[name='"+filedName+"']");
						if(filedObj.length<=0){
							filedObj = $("<input type='hidden' name='" + filedName + "'/>");
						}
						filedObj.val(entry[tmpField]);
						filedObj.appendTo(formObj);
					}
				}
				i++;
			}
		}
		return true;
	};
	//打开关联配置
	this._rela_addCfg = function(__func){
		seajs.use(['sys/ui/js/dialog'], function(dialog) {
			self.dialogObj = dialog.build({
				config:{
					width: 980,
					height: 500,
					lock: true,
					cache: false,
					title : rela_params['rela.setting.title'],
					content : {
						id : 'relation_div',
						scroll : false,
						type : "iframe",
						url : '/sys/relation/import/sysRelationMain_setting.jsp?LUIElementId=relation_div&currModelName='+self.modelName+'&key='+self.key
					}
				},
				callback:__func||new Function()
			}).show();
		});
	};
	this._rela_saveCfg = function(cfgVar){
		seajs.use(['lui/topic','lui/view/render','lui/data/source','lui/base'],function(topic , render , source , base){
			//先删除现有配置
			if(cfgVar!=null && cfgVar!={}){
				for(var tmpKey in window.relationEntrys){
					var contentId = 'rela_' + tmpKey;
					topic.group("relation").publish('removeContent',
						{"data":{'target':{"id":contentId}}});
				}
				//获取修改后的配置
				window.relationEntrys = cfgVar;
				
				// 用于一页面多关联--暂时知识地图使用
				if(self.key && window.relationMains){
					window.relationMains[self.key] = {};
					window.relationMains[self.key].fdKey = self.key;
					window.relationMains[self.key].fdModelName = self.modelName;
					window.relationMains[self.key].fdModelId = self.modelId;
					window.relationMains[self.key].relationEntrys = window.relationEntrys;
				}
					
			}
			if(!self.key){
				//构建content/dataview预览修改后的配置
				var i = 0;
				for(var tmpKey in window.relationEntrys){
					var relationEntry = window.relationEntrys[tmpKey];
					//构造预览参数
					var params = {};
					params['fdId'] = $("input[name='sysRelationMainForm.fdId']").val();
					params['fdKey'] = $("input[name='sysRelationMainForm.fdKey']").val();
					params['fdModelName'] = $("input[name='sysRelationMainForm.fdModelName']").val();
					params['fdModelId'] = $("input[name='sysRelationMainForm.fdModelId']").val();
					params['fdParameter'] = $("input[name='sysRelationMainForm.fdParameter']").val();
					params['loadIndex'] = i;
					var moduleModelName = null;
					for(var tmpField in relationEntry){
						params['entry['+i+'].'+tmpField] = relationEntry[tmpField];
						if(tmpField == "fdModuleModelName")
							moduleModelName = relationEntry[tmpField];;
					}
					if(relationEntry.relationConditions!=null){
						var count = 0;
						var conditions = relationEntry.relationConditions;
						for(var condition in conditions){
							for(var condProp in conditions[condition]){
								params["entry["+i+"].condition["+(count)+"]."+condProp] = conditions[condition][condProp];
							}
							count++;
						}
						params["entry["+i+"].count"] = count;
					}
					if(relationEntry.staticInfos!=null){
						var staticCount = 0;
						var staticInfos = relationEntry.staticInfos;
						for(var _staticInfo in staticInfos){
							for(var index in staticInfos[_staticInfo]){
								for(var infoProp in staticInfos[_staticInfo][index]){
									if(infoProp == "fdRelatedName" || infoProp == "fdRelatedUrl"){
										params["entry["+i+"].static["+(staticCount)+"]."+infoProp] = staticInfos[_staticInfo][index][infoProp];
									}
								}
								staticCount++;
							}
						}
						params["entry["+i+"].staticCount"] = staticCount;
						params["entry["+i+"].staticInfos"] = null;
					}
					params["&moduleModelName"] = moduleModelName;
					//构造预览source
					var sourceObj = new source.AjaxJson({
						"url":"/sys/relation/sys_relation_main/sysRelationMain.do?method=preview&forward=listUi",
						"params":params
					});
					//构造预览render
					var renderObj = new render.Javascript({
						"src":'/sys/ui/extend/dataview/render/classic.js',
						"vars":{"showCreator":"true","showCreated":"true","ellipsis":"false"},
						"param":{"extend":"tile"}
						});
					//构造dataview
					var dataView = new base.DataView();
					dataView.addChild(renderObj);
					dataView.addChild(sourceObj);
					renderObj.setParent(dataView);
					renderObj.startup();
					dataView.startup();
					dataView.draw();
					//发布事件，新增content展示
					topic.group("relation").publish('addContent',{"data":{
								"id":"rela_"+relationEntry['fdId'],
								"title":relationEntry['fdModuleName'],
								"child":[dataView]
							}});
					i++;
				}
			}
			if(window.Sidebar_Refresh){
				Sidebar_Refresh();
			}
			if(self.dialogObj!=null)
				self.dialogObj.hide();
		});
		
		
		if(cfgVar!=null && cfgVar!={}){
			 setTimeout(function(){ 
		var obj=	parent.document.getElementById("relaChange");
		obj.click();
			 },100);
		}
		
//		seajs.use(['lui/jquery'],function($) {
//			$.ajax(
//					{
//					    type: 'post',
//					    data: {cfgVar: cfgVar},
//						url: Com_Parameter.ContextPath+"sys/relation/sys_relation_main/sysRelationMain.do?method=changeRela",
//						success: function(data) {
//						}
//					}
//				);
//		});
		
	};
	
	Com_AddEventListener(window, "load", function(){
		self.onload();
	});
}
