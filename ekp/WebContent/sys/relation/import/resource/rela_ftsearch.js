/*压缩类型：标准*/
Com_IncludeFile("rela.css", Com_Parameter.ContextPath + "sys/relation/import/resource/","css",true);
//全文检索配置
function RelationFtSearchSetting(params){
	this.relationType = "1";
	this.params = params;
	this.varName = "_relationCfg";
	this.rela_tmpId = params.tempId;
	var self = this;
	window[self.varName] = self;
	if(self.params["varName"]!=null && self.params["varName"]!=''){
		window[self.params["varName"]] = self;
	}
	/*********************************对外调用函数************************************************/
	//加载
	this.onload = function(){
		//全选处理
		$("input[name='checkAll']").click(function(){
			self._rela_selectAll(this);
		});
		//搜索范围点击fdSearchScope
		$("input[name='fdSearchScope']").click(function(){
			self._rela_selectElement(this);
		});
		//清理时间操作事件rela_clear
		$("#rela_clear").click(function(){
			self._rela_clearField('fdFromCreateTime;fdToCreateTime');
		});
		//保存按钮事件
		$("#rela_config_save").click(function(){
			self.saveConfig();
		});
		//取消按钮事件
		$("#rela_config_close").click(function(){
			self.closeConfig();
		});
		//加载配置
		self._rela_ftsearch_load();
		//iframe高度调整
		self.resizeFrame();
		//检验
		this._rela_ftsearch_validator();
	};
	//保存
	this.saveConfig = function(){
		self._rela_ftsearch_save();
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
	
	/*********************************对外调用函数************************************************/
	//配置加载
	this._rela_ftsearch_load = function(){
		if(parent[self.varName]!=null && parent[self.varName].CurrentSetting){
			var setting = parent[self.varName].CurrentSetting;
			if(setting.fdId!=null){
				self.rela_tmpId = setting.fdId;
			}
			$(".rela_config_subset input,.rela_config_table input").each(function(index,elem){
				var elemObj = $(elem);
				var elemName= elemObj.attr('name');
				if(elemName!=null && setting[elemName]!=null){
					if(elemObj.is(":text") || elemObj.is(":hidden")){
						elemObj.val(setting[elemName]);
					}else if(elemObj.is(":radio")){
						if(elemObj.val()==setting[elemName]){
							elemObj.attr("checked","checked");
						}else{
							elemObj.removeAttr("checked");
						}
					}else if(elemObj.is(":checkbox")){
						var values = setting[elemName].split(";");
						$.each(values,function(index,val){
							if(elemObj.val() == val){
								elemObj.attr("checked","checked");
							}
						});
					}
				}
			});
			self._rela_selectElement();
		}
	};
	this._rela_ftsearch_validator = function(){
		if(self.S_Valudator == null)
			self.S_Valudator = $GetKMSSDefaultValidation(null,{afterElementValidate:function(){
				self.resizeFrame();
				return true;
			}});
		 $("input[name='fdModuleName']").each(function(){
			 self.S_Valudator.addElements(this);
		 });
		 $("input[name='fdKeyWord']").each(function(){
			 self.S_Valudator.addElements(this);
		 });
	};
	//配置保存
	this._rela_ftsearch_save = function(){
		//数据组装
		var setting = {};
		setting.fdId = self.rela_tmpId;
		setting.fdType = self.relationType;
		if(!self.S_Valudator.validate()){
			return ;
		}
		$(".rela_config_subset input,.rela_config_table input").each(function(index,elem){
			var elemObj = $(elem);
			var elemName= elemObj.attr('name');
			if(elemName!=null){
				var tmpVal = "";
				if(elemObj.is(":text") || elemObj.is(":hidden")){
					tmpVal = elemObj.val();
				}else if(elemObj.is(":radio") || elemObj.is(":checkbox")){
					if(elemObj.is(":checked")){
						tmpVal = elemObj.val();
					}
				}
				if(tmpVal !=""){
					if(setting[elemName]!=null){
						setting[elemName] += ";" + tmpVal;
					}else{
						setting[elemName] = tmpVal;
					}
				}
			}
		});
		//时间区间
		var fdFromCreateTime = setting['fdFromCreateTime'];
		var fdToCreateTime = setting['fdToCreateTime'];
		if(fdFromCreateTime!=null && fdToCreateTime!=null 
				&& fdFromCreateTime!="" && fdToCreateTime!="" 
					&& compareDate(fdFromCreateTime, fdFromCreateTime) > 0){
			alert(self.params['createTime.validate']);
			return ;
		}
		//搜索范围
		var fdSearchScope = setting['fdSearchScope'];
		if (fdSearchScope==null || fdSearchScope=='') {
			alert(self.params['scope.null']);
			return ;
		} else {
			if(fdSearchScope.length - 1 > 4000) {
				alert(self.params['scope.error']);
				return ;
			}
		}
		
		if(parent[self.varName]!=null){
			parent[self.varName].saveConfig(setting);
		}
		self.resizeFrame();
	};
	//全选按钮操作
	this._rela_selectAll = function(thisObj){
		if($(thisObj).is(":checked")){
			$("input[name='fdSearchScope']").attr("checked","checked");
		}else{
			$("input[name='fdSearchScope']").removeAttr("checked");
		}
	};
	//全选操作状态调整
	this._rela_selectElement = function(thisObj){
		 var jqObj = $("input[name='fdSearchScope']:first");
		if(thisObj!=null){
			jqObj = $(thisObj); 
		}
		var checkAll = $("input[name='checkAll']");
		if(jqObj.is(":checked")){
			var tmpSelectArr = $("input[name='fdSearchScope']:checked");
			var tmpAllArr= $("input[name='fdSearchScope']");
			if(tmpSelectArr.length!=tmpAllArr.length){
				checkAll.removeAttr("checked");
			}else{
				checkAll.attr("checked","checked");
			}
		}else{
			checkAll.removeAttr("checked");
		}
	};
	//清理域值
	this._rela_clearField = function(fields){
		if (!fields) {
			return;
		}
		var fieldArr = fields.split(";");
		for (var i = 0; i < fieldArr.length; i++) {
			$("input[name='"+fieldArr[i]+"']").val('');
		}
	};
	Com_AddEventListener(window, "load", function(){
		self.onload();
	});
}
