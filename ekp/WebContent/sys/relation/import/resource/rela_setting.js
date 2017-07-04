/*压缩类型：标准*/
Com_IncludeFile("rela.css", Com_Parameter.ContextPath + "sys/relation/import/resource/","css",true);

//关联配置对象
function RelationSetting(params){
	this.params = params;
	this.CurrentSetting = {};
	this.varName = "_relationCfg";
	var self = this;
	window[self.varName] = self;
	if(self.params["varName"]!=null && self.params["varName"]!=''){
		window[self.params["varName"]] = self;
	}
	/*********************************对外调用函数************************************************/
	this.onload = function(){
		//新增按钮
		$("#rela_add_btn").click(function(){
			self.addConfig();
		});
		$("#rela_save_btn").click(function(){
			var frameObj = $("#rela_search_config");
			if(frameObj.is(":visible")){
				alert(self.params["submit.prompt"]);
			}else{
				if(parent[self.varName]!=null)
					parent[self.varName].saveConfig(self._rela_GetRelationInfo());
			}
		});
		//关闭按钮
		$("#rela_close_btn").click(function(){
			//弹出确认款，调用父的保存方法，及关闭按钮
			if(parent[self.varName]!=null)
				parent[self.varName].closeConfig();
		});
		//选择栏
		$("input[name='fdRelaType']").click(function(){
			var domObj = $(this);
			if(domObj.val()=="1"){
				self._rela_changeRelationType(this,'ftsearch');
			}else if(domObj.val()=="2"){
				self._rela_changeRelationType(this,'condition');
			}else{
				self._rela_changeRelationType(this,'static');
			}
		});
		//收起展开
		$(".rela_config_inline_txt").click(function(){
			self._rela_expandConfig();
		});
		//加载配置信息
		self._rela_LoadRelation();
		
		//iframe高度调整
		self.resizeFrame();
	};
	
	//iframe高度
	this.resizeFrame = function(){
		if(window.frameElement!=null && window.frameElement.tagName=="IFRAME"){
			window.frameElement.style.height = ($(document.body).height()+10)+ "px";
		}
	};
	
	//新增关联配置
	this.addConfig = function(){
		self._rela_AddConfig();
	};
	
	//编辑某项关联配置
	this.editConfig = function(){
		self._rela_EditConfig();
	};
	
	//保存关联配置
	this.saveConfig = function(cfgNar){
		self._rela_save(cfgNar);
	};
	
	//关闭关联配置
	this.closeConfig = function(){
		self._rela_close();
	};
	
	//删除关联配置
	this.deleteConfig = function(){
		self._rela_DelConfig();
	};
	/*********************************内部调用函数************************************************/
	//关联配置信息加载
	this._rela_LoadRelation = function(){
		var dataInfo = {};
		if (self.params.key && parent.relationMains) {
			if (parent.relationMains[self.params.key])
				dataInfo = parent.relationMains[self.params.key].relationEntrys;
		} else
			dataInfo = parent.relationEntrys
		if(dataInfo!=null){
			for(var tmpkey in dataInfo){
				var newRow = $(DocList_AddRow('TABLE_DocList'));
				var data = dataInfo[tmpkey];
				for(var tmpField in data){
					if(tmpField.toLowerCase()=='fdid'){
						newRow.attr("rela_dataRow",data[tmpField]);
					}
					var tmpFild = newRow.find('input[name="'+tmpField+'"]');
					if(tmpFild.length>0)
						tmpFild.val(data[tmpField]);
					tmpFild = newRow.find('span[name="'+tmpField+'"]');
					if(tmpFild.length>0)
						tmpFild.text(data[tmpField]);
				}
				self._rela_loadRelationConditions(tmpkey,data.relationConditions);
				self._rela_loadStaticInfos(tmpkey,data.staticInfos);
			}
		}
	};
	
	//关联配置信息获取（json）
	this._rela_GetRelationInfo = function(){
		var relations = {};
		$("#TABLE_DocList tr[rela_dataRow]").each(function(index,domElem){
			var tmpRow = $(domElem);
			var relation = self._rela_getRowConfig(tmpRow);
			relations[tmpRow.attr("rela_dataRow")] =  relation;
		});
		return relations;
	};
	
	//关联配置某项信息获取（json）
	this._rela_getRowConfig = function(rowObj){
		var rtnCfg = {};
		rowObj.find("input[name]").each(function(index,elem){
			var elmObj = $(elem);
			rtnCfg[elmObj.attr('name')] = elmObj.val();
		});
		if(rtnCfg.fdId!=null){
			rtnCfg.relationConditions = self._rela_getRelationConditions(rtnCfg.fdId);
			//静态网页
			rtnCfg.staticInfos = self._rela_getStaticInfos(rtnCfg.fdId);
		}
		return rtnCfg;
	};
	//展开折叠
	this._rela_expandConfig = function(expand){
		var thisObj = $(".rela_config_inline_txt");
		if(expand == null)
			expand = thisObj.attr("rela_expand");
		else{
			expand = expand=="true"? "0":"1";
		}
		//隐藏
		if(expand==null || expand=="1"){
			$("#TABLE_DocList").hide();
			$('.rela_conf_tab').hide();
			thisObj.text(self.params['operation.exp']);
			thisObj.attr("rela_expand","0");
		}else{
			$("#TABLE_DocList").show();
			$('.rela_conf_tab').show();
			thisObj.text(self.params['operation.coll']);
			thisObj.attr("rela_expand","1");
		}
	};
	//关联配置新增
	this._rela_AddConfig = function(){
		self._rela_clearSelected();
		self.CurrentSetting = {};
		$('#rela_config_detail').show();
		$(".rela_config_inline").show();
		self._rela_expandConfig(false);
		$('.rela_conf_tab').hide();
		$('.rela_opt_tb_area').hide();
		$('input[name="fdRelaType"]:first').click();
	};
	
	//关联配置编辑
	this._rela_EditConfig = function(){
		self._rela_clearSelected();
		var trObj = $(DocListFunc_GetParentByTagName("TR"));
		trObj.addClass("rela_conf_tr_selected");
		self.CurrentSetting = self._rela_getRowConfig(trObj);
		$('#rela_config_detail').show();
		$(".rela_config_inline").show();
		self._rela_expandConfig(false);
		$('.rela_conf_tab').hide();
		$('.rela_opt_tb_area').hide();
		$('input[name="fdRelaType"][value="'+self.CurrentSetting['fdType']+'"]').click();
	};
	
	//子层iframe配置保存
	this._rela_save = function(setting){
		var newRow = $("tr[rela_dataRow='" + setting.fdId + "']");;
		if(newRow==null || newRow.length<=0){
			newRow = $(DocList_AddRow('TABLE_DocList'));
			newRow.attr("rela_dataRow",setting.fdId);
			self.resizeFrame();
		}
		//配置赋值
		newRow.find('input').val('');
		for(var tmpField in setting){
			newRow.find('input[name="'+tmpField+'"]').val(setting[tmpField]);
			newRow.find('span[name="'+tmpField+'"]').text(setting[tmpField]);
		}
		//条件关系信息清理
		this._rela_delRelationConditions(setting.fdId);
		this._rela_loadRelationConditions(setting.fdId,setting.relationConditions);
		//静态网页数据清理
		this._rela_delStaticInfos(setting.fdId);
		//加载静态网页数据
		this._rela_loadStaticInfos(setting.fdId,setting.staticInfos);
		
		this._rela_close();
	};
	
	//关联配置关闭
	this._rela_close = function(){
		self.CurrentSetting = {};
		self._rela_clearSelected();
		$('#rela_config_detail').hide();
		$(".rela_config_inline").hide();
		self._rela_expandConfig(false);
		$('.rela_conf_tab').show();
		$('.rela_opt_tb_area').show();
		$("#TABLE_DocList").show();
	};
	
	//关联配置删除
	this._rela_DelConfig = function(){
		var trObj = $(DocListFunc_GetParentByTagName("TR"));
		var tmpFdId = trObj.find("input[name='fdId']").val();
		self._rela_delRelationConditions(tmpFdId);
		self._rela_delStaticInfos(tmpFdId);
		DocList_DeleteRow();
		if(self.CurrentSetting.fdId == tmpFdId)
			self._rela_close();
	};

	//清理选中状态
	this._rela_clearSelected = function(){
		$("#TABLE_DocList tr").removeClass("rela_conf_tr_selected");
	};
	
	//关联配置类型更改
	this._rela_changeRelationType = function(thisObj,value){
		var url = Com_Parameter.ContextPath+"sys/relation/import/"+value+"/sysRelationMain_setting_" + value + ".jsp?currModelName=" 
					+ Com_GetUrlParameter(location.href,'currModelName');
		var iframe = document.getElementById("rela_search_config");
		iframe.setAttribute("src",encodeURI(url));
	};
	
	//condition信息加载
	this._rela_loadRelationConditions = function(key,conditions){
		if(conditions!=null){
			var doc = $(document.body);
			var prifix  = "rela_conditions[" + key + "]";
			for(var tmpKey in conditions){
				var condition = conditions[tmpKey];
				for(var tmpField in condition){
					var filedName = prifix+"."+tmpField;
					var tmpInput = $("input[name='"+filedName+"'][rela_condtionGroup='"+tmpKey+"']");
					if(tmpInput.length<=0){
						tmpInput = $("<input type='hidden' name='"+filedName+"'/>");
					}
					tmpInput.attr('rela_condtionGroup',tmpKey);
					tmpInput.val(condition[tmpField]);
					doc.append(tmpInput);
				}
			}
		}
	};
	//静态网页信息加载
	this._rela_loadStaticInfos = function(key,staticInfos){
		if(staticInfos!=null){
			var doc = $(document.body);
			var prifix  = "static_info[" + key + "]";
			for(var tmpKey in staticInfos){
				var condition = staticInfos[tmpKey];
				for(var index in condition){
					for(var tmpField in condition[index]){
						var filedName = prifix+"["+index+"]"+"."+tmpField;
						var tmpInput = $("input[name='"+filedName+"'][static_infosGroup='"+tmpKey+"']");
						if(tmpInput.length<=0){
							tmpInput = $("<input type='hidden' name='"+filedName+"'/>");
						}
						tmpInput.attr('static_infosGroup',tmpKey);
						tmpInput.val(condition[index][tmpField]);
						doc.append(tmpInput);
					}
				}
			}
		}
	};
	//condition配置信息获取
	this._rela_getRelationConditions = function(key){
		var prifix  = "rela_conditions[" + key + "]";
		var conditions = {};
		$("input[name^='" + prifix + "']").each(function(index,domEle){
			var dom$ = $(domEle);
			var name = dom$.attr('name');
			var group = dom$.attr('rela_condtionGroup');
			if(name.indexOf(".")>-1){
				name = name.substring(name.lastIndexOf(".")+1);
			}
			if(conditions[group]==null){
				conditions[group] = {};
			}
			conditions[group][name] = dom$.val();
		});
		return conditions;
	};
	
	//静态网页配置信息获取
	this._rela_getStaticInfos = function(key){
		var prifix  = "static_info[" + key + "]";
		var staticInfos = {};
		$("input[name^='" + prifix + "']").each(function(index,domEle){
			var dom$ = $(domEle);
			var name = dom$.attr('name');
			var index = name.substring(prifix.length+1,name.lastIndexOf(".")-1);
			var group = dom$.attr('static_infosGroup');
			if(name.indexOf(".")>-1){
				name = name.substring(name.lastIndexOf(".")+1);
			}
			if(staticInfos[group]==null){
				staticInfos[group] = [];
			}
			if(staticInfos[group][index]==null){
				staticInfos[group][index] = {};
			}
			staticInfos[group][index][name] = dom$.val();
		});
		return staticInfos;
	};
	
	//condition配置删除
	this._rela_delRelationConditions = function(key){
		var prifix  = "rela_conditions[" + key + "]";
		$("input[name^='" + prifix + "']").remove();
	};
	
	//静态网页数据清理
	this._rela_delStaticInfos = function(key){
		var prifix  = "static_info[" + key + "]";
		$("input[name^='" + prifix + "']").remove();
	};
	
	Com_AddEventListener(window, "load", function(){
		var onloadFun = function(){
			if(window.DocList_TableInfo['TABLE_DocList']!=null){
				try{
					self.onload();
				}catch(e){}
				window.clearInterval(window.onloadCalc);
			}
		};  
		window.onloadCalc = setInterval(onloadFun, 200);
	});
}

function rela_resizeFrameHeight(){
	if(window.frameElement!=null && window.frameElement.tagName=="IFRAME"){
		LUI.fire({
			"type":"event",
			"name":"resize",
			"target":Com_GetUrlParameter(location.href,"LUIElementId"),
			"data":{
				"height":($(document.body).height()+10)
			}
		}, parent);
	}
}