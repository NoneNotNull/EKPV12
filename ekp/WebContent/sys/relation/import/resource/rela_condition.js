/*压缩类型：标准*/
var rela_type = "2";
var rela_conditions = {};
Com_IncludeFile("rela.css", Com_Parameter.ContextPath + "sys/relation/import/resource/","css",true);
//精确搜索配置

function RelationConditionSetting(params){
	this.relationType = "2";
	this.params = params;
	this.varName = "_relationCfg";
	this.rela_tmpId = params.tempId;
	this.CurrentSetting = {};
	var self = this;
	window[self.varName] = self;
	if(self.params["varName"]!=null && self.params["varName"]!=''){
		window[self.params["varName"]] = self;
	}
	/*********************************对外调用函数************************************************/
	//加载
	this.onload = function(){
		//
		var modelSel = $("#rela_module");
		if(parent[self.varName]!=null && parent[self.varName].CurrentSetting){
			var setting = parent[self.varName].CurrentSetting;
			if(setting.fdId!=null){//编辑
				self.rela_tmpId = setting.fdId;
				$("input[name='fdModuleName']").val(setting['fdModuleName']);
				modelSel.find("option[value='"+setting['fdModuleModelName']+"']").attr("selected","selected");
				self.CurrentSetting = setting.relationConditions;
			}else{//新建
				modelSel.find("option[value='"+Com_GetUrlParameter(location.href,'currModelName')+"']").attr("selected","selected");
			}
		}
		//初始选中状态页面
		self._rela_changeModule(modelSel);
		//初始化事件
		modelSel.change(function(){
			self._rela_changeModule(this);
		});
		self._rela_condition_validator();
	};
	//保存
	this.saveConfig = function(cfg){
		self._rela_condition_save(cfg);
	};
	//关闭配置
	this.closeConfig = function(){
		if(parent[self.varName]!=null){
			parent[self.varName].closeConfig();
		}
		self.resizeFrame();
	};
	//iframe高度
	this.resizeFrame = function(){
		try {
			if(window.frameElement!=null && window.frameElement.tagName=="IFRAME"){
				window.frameElement.style.height = ($(document.body).height()+10)+ "px";
				if(parent[self.varName] != null)
					parent[self.varName].resizeFrame();
			}
		} catch(e) {
		}
	};
	this.previewConfig = function(cfg){
		var setting = {};
		setting['fdModuleModelTitle'] = $("#rela_module").find("option:selected").text();
		setting.relationConditions = cfg;
		seajs.use(['lui/dialog'], function(dialog) {
			var dialogObj = dialog.build({
				config:{
					width: 600,
					height: 350,
					lock: true,
					cache: false,
					title : self.params['preview.title'],
					content : {
						id : 'relation_condition_priv_div',
						scroll : false,
						type : "iframe",
						url : '/sys/relation/import/condition/sysRelationCondition_preview.jsp',
						buttons:[{
							name : self.params['button.cancel'],
							value : false,
							styleClass : 'lui_toolbar_btn_gray',
							fn : function(value, dialog) {
								dialog.hide(value);
							}
						}  
					]
					}
				}
			});
			dialogObj.content.on("layoutDone",function(){
				var iframe = dialogObj.content.iframeObj;
				iframe.bind('load',function(){
					iframe[0].contentWindow.init(setting);
				});
			});
			dialogObj.show();
		});
	};
	/*********************************内部调用函数************************************************/
	//保存操作
	this._rela_condition_save = function(conditions){
		var setting = {};
		setting.fdId = self.rela_tmpId;
		setting.fdType = self.relationType;
		setting['fdModuleName'] = $("input[name='fdModuleName']").val();
		if(!self.S_Valudator.validate()){
			return ;
		}
		setting['fdModuleModelName'] = $("#rela_module").val();
		setting.relationConditions = conditions;
		if(parent[self.varName]!=null){
			parent[self.varName].saveConfig(setting);
		}
		self.resizeFrame();
	};
	/**
	 * 初始话校验
	 */
	this._rela_condition_validator = function(){
		if(self.S_Valudator == null)
			self.S_Valudator = $GetKMSSDefaultValidation(null,{afterElementValidate:function(){
				self.resizeFrame();
				return true;
			}});
		 $("input[name='fdModuleName']").each(function(){
			 self.S_Valudator.addElements(this);
		 });
	};
	
	this._rela_changeModule = function(thisObj){
		var selectObj = $(thisObj); 
		var fdModuleName=selectObj.find("option:selected").text();
		var fdModuleModelName = selectObj.val();
		if (fdModuleModelName != null && fdModuleModelName != "") {
			var url = Com_Parameter.ContextPath+"sys/relation/relation.do?method=selectCondition&forward=conditionUi&fdType="+rela_type
					+"&fdModuleName="+fdModuleName+"&fdModuleModelName="+fdModuleModelName
					+"&currModelName="+Com_GetUrlParameter(location.href,'currModelName');
			$("#rela_condition_iframe").attr("src",encodeURI(url));
		}
	};
	
	Com_AddEventListener(window, "load", function(){
		self.onload();
	});
}
