/*压缩类型：标准*/
Com_IncludeFile("rela.css", Com_Parameter.ContextPath + "sys/relation/import/resource/","css",true);
//精确搜索配置
function RelationConditionCfgSetting(params){
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
		//保存按钮事件
		$("#rela_config_save").click(function(){
			self.saveConfig();
		});
		//取消按钮事件
		$("#rela_config_close").click(function(){
			self.closeConfig();
		});
		//预览配置条件
		$("#rela_config_preview").click(function(){
			self.previewConfig();
		});
		//加载配置
		self._rela_condition_cfg_load();
		
		if($("#rela_condition>tbody>tr").size()>=20){
			$("#viewAllP").show();
		}
	};
	//预览
	this.previewConfig = function(){
		var confgData = self._rela_get_condition_cfg();
		if(confgData!=null){
			if(parent[self.varName]!=null)
				parent[self.varName].previewConfig(confgData);
		}
	};
	//保存
	this.saveConfig = function(){
		var confgData = self._rela_get_condition_cfg();
		if(confgData!=null){
			if(parent[self.varName]!=null)
				parent[self.varName].saveConfig(confgData);
		}
	};
	//关闭配置
	this.closeConfig = function(){
		if(parent[self.varName]!=null)
			parent[self.varName].closeConfig();
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
	//逻辑运算联动，大于小于等于
	this.refreshLogicDisplay = function(obj , id){
		self._rela_condition_refreshLogicDisplay(obj,id);
	};
	//自动匹配
	this.refreshRelationDisplay = function(index , trObj){
		self._rela_condition_refreshRelationDisplay(index , trObj);
	};
	//模糊匹配
	this.refreshMatchDisplay = function(index , trObj){
		self._rela_condition_refreshMatchDisplay(index , trObj);
	};
	/*********************************内部调用函数************************************************/
	//condition详细配置加载
	this._rela_condition_cfg_load = function(){
		if(parent[self.varName]!=null && parent[self.varName].CurrentSetting){
			var relationConditions = parent[self.varName].CurrentSetting;
			var trList = $("#rela_condition tr[kmss_type]");
			for(var i=0; i<trList.length; i++){
				var trObj = $(trList[i]);
				var fdItemName = $("input[name='fdItemName_"+i+"']").val();
				var relationCondition = relationConditions[fdItemName];
				if(relationCondition==null) continue;
				//模糊搜索
				if(relationCondition.fdBlurSearch=="1"){
					$("input[name='fdBlurSearch_"+i+"']").attr("checked","checked");
				}
				//关联搜索
				if(relationCondition.fdVarName!="" && relationCondition.fdVarName==fdItemName){
					$("input[name='fdVarName_"+i+"']").attr("checked","checked");
				}
				var type = trObj.attr("kmss_type");
				var fdParameter1_ = $("[name='fdParameter1_"+i+"']:input");
				var fdParameter2_ = $("[name='fdParameter2_"+i+"']:input");
				var fdParameter3_ = $("[name='fdParameter3_"+i+"']:input");
				var values = relationCondition.fdParameter1.split(";");
				switch(type){
					case "string":
						self._rela_setFieldValue(fdParameter1_,relationCondition.fdParameter1);
						break;
					case "date":
					case "number":
						self._rela_setFieldValue(fdParameter1_,relationCondition.fdParameter1);
						self._rela_setFieldValue(fdParameter2_,relationCondition.fdParameter2);
						self._rela_setFieldValue(fdParameter3_,relationCondition.fdParameter3);
						if(type=='date'){
							self._rela_condition_refreshLogicDisplay(fdParameter1_,"span_fdParameter3_"+i);
						}
						break;
					case "foreign":
						if(fdItemName=="docKeyword"){
							self._rela_setFieldValue(fdParameter2_,relationCondition.fdParameter2);
						}else{
							//一般查询
							if(relationCondition.fdParameter1!=""){
								self._rela_setFieldValue(fdParameter1_,relationCondition.fdParameter1);
								self._rela_setFieldValue($("input[name='t0_"+i+"']"),relationCondition.fdParameter2);
								break;
							}
							//是否模糊查询
							if(relationCondition.fdBlurSearch=="1"){
								self._rela_setFieldValue(fdParameter2_,relationCondition.fdParameter2);
								break;
							}
							//是否包含子节点
							if(relationCondition.fdParameter3!=""){
								$("input[name='t1_"+i+"']").attr("checked","checked");
								self._rela_setFieldValue(fdParameter1_,relationCondition.fdParameter3);
								self._rela_setFieldValue($("input[name='t0_"+i+"']"),relationCondition.fdVarName);
							}
						}
						break;
					case "enum":
						self._rela_setFieldValue(fdParameter1_,relationCondition.fdParameter1);
						break;
				}
				self._rela_condition_refreshMatchDisplay(i,trObj);
				self._rela_condition_refreshRelationDisplay(i,trObj);
			}
		}
		self.resizeFrame();
	};
	this._rela_get_condition_cfg = function(){
		var trList = $("#rela_condition tr[kmss_type]");
		var relationConditions = {};
		for(var i=0; i<trList.length; i++){
			var trObj = $(trList[i]);
			var relationCondition = self._rela_condition_createNewCondition();
			var fdItemName = $("input[name='fdItemName_"+i+"']").val();
			if(fdItemName == null)
				continue;
			var spanTile = $.trim(trObj.find(">td:first").text());
			relationCondition['fdTitle'] = spanTile;   		//用于条件预览
			relationCondition['fdItemName'] = fdItemName;
			//模糊搜索
			if($('input[name="fdBlurSearch_' + i +'"]').is(":checked"))
				 relationCondition['fdBlurSearch'] = "1";
			//关联搜索(自动匹配)
			if($('input[name="fdVarName_' + i +'"]').is(":checked"))
				relationCondition['fdVarName'] = $('input[name="fdVarName_' + i +'"]').val();
			
			var type = trObj.attr("kmss_type");
			relationCondition['fdType'] = type;  			//用于条件预览
			var  fdParameter1_ = self._rela_getFiledValue("fdParameter1_"+ i );
			var fdParameter2_ = self._rela_getFiledValue("fdParameter2_" + i );
			var fdParameter3_ = self._rela_getFiledValue("fdParameter3_" + i );
			var isIgnore = relationCondition['fdVarName'] == null || relationCondition['fdVarName']=='';
			if(type=="string"){
				relationCondition["fdParameter1"] = fdParameter1_;
				if(fdParameter1_=='' && isIgnore)
					continue;
			}else if(type=="date"){
				if(fdParameter1_=="bt"){
					if(fdParameter2_=="" && fdParameter3_=="" && isIgnore) continue;
					if(!(fdParameter2_!= "" && fdParameter3_ != "")){
						alert('<kmss:message key="errors.required" />'.replace("{0}", spanTile));
						return null;
					}else{
						if(!(self._rela_isDate(fdParameter2_,spanTile) && self._rela_isDate(fdParameter3_,spanTile))){
							return null;
						}
					}
				}else{
					if(fdParameter2_=="" && isIgnore) continue;
					if(!(self._rela_isDate(fdParameter2_,spanTile))) return null;
				}
				
				relationCondition["fdParameter1"] = fdParameter1_;
				relationCondition["fdParameter2"] = fdParameter2_;
				if(fdParameter1_=="bt"){
					relationCondition.fdParameter3 = fdParameter3_;
				}
				if(fdParameter1_=='' && isIgnore)
					continue;
			}else if(type=="number"){
				var spanTile = trObj.find(">td:first").text();
				if(fdParameter1_=="bt"){
					if(fdParameter2_=="" && fdParameter3_=="" && isIgnore) continue;
					if(!(fdParameter2_!= "" && fdParameter3_ != "")){
						alert('<kmss:message key="errors.required" />'.replace("{0}", spanTile));
						return null;
					}else{
						if(!(self._rela_isNumber(fdParameter2_,spanTile) && self._rela_isNumber(fdParameter3_,spanTile))){
							return null;
						}
					}
				}else{
					if(fdParameter2_=="" && isIgnore) continue;
					if(!(self._rela_isNumber(fdParameter2_,spanTile))) return null;
				}
				relationCondition["fdParameter1"] = fdParameter1_;
				relationCondition["fdParameter2"] = fdParameter2_;
				if(fdParameter1_=="bt"){
					relationCondition.fdParameter3 = fdParameter3_;
				}
				if(fdParameter1_=='' && isIgnore)
					continue;
			}else if(type=="foreign"){
				if(fdItemName=="docKeyword"){
					if(fdParameter2_!=""){
						relationCondition["fdParameter2"] = fdParameter2_;
					}else{
						if(fdParameter2_=='' && isIgnore)
							continue;
					}
				}else{
					var fdBlurSearch_ = relationCondition['fdBlurSearch'];
					//是否模糊查询
					if(fdBlurSearch_ == "1"){
						relationCondition['fdParameter2'] = fdParameter2_;
					}else{
						if(fdParameter1_!=""){
							var t1Obj = $("input[name='t1_"+i+"']");
							if(t1Obj.is(":checked")){//包含子节点
								relationCondition['fdParameter3'] = fdParameter1_;
								relationCondition['fdVarName'] =  $("input[name='t0_"+i+"']").val();
							}else{		//一般查询
								relationCondition['fdParameter1'] = fdParameter1_;
								relationCondition['fdParameter2'] = $("input[name='t0_"+i+"']").val();
							}
						}else{
							if(fdParameter1_=='' && isIgnore)
								continue;
						}
					}
				}
			}else if(type=="enum"){
				if(fdParameter1_=='' && isIgnore)
					continue;
				relationCondition["fdParameter1"] = fdParameter1_;
				relationCondition["fdParameter1Title"] = self._rela_getFiledText("fdParameter1_"+ i);//用于条件预览
			}
			relationConditions[relationCondition.fdItemName] = relationCondition;		
		}
		return relationConditions;
	};
	//设置域对应值
	this._rela_setFieldValue = function(elemObj , value){
		var values = value.split(";"); 
		if(elemObj.is(":text")){
			elemObj.val(value);
		}else if(elemObj.is(":radio")||elemObj.is(":checkbox")){
			elemObj.each(function(index,tmpEle){
				var tmpObj = $(tmpEle);
				if(Com_ArrayGetIndex(values,tmpObj.val())>-1){
					tmpObj.attr("checked","checked");
				}
			});
		}else{
			elemObj.val(value);
		}
	};
	
	//获取域值
	this._rela_getFiledValue = function(elemName){
		var elemObj = $("[name='"+elemName+"']:input");
		if(elemObj.is(":text")){
			return elemObj.val();
		}else if(elemObj.is(":radio")||elemObj.is(":checkbox")){
			var rtnStr = "";
			elemObj.each(function(index,ele){
				var tmpObj = $(ele);
				if(tmpObj.is(":checked")){
					rtnStr += ";" + tmpObj.val();
				}
			});
			return rtnStr!=""?rtnStr.substring(1):"";
		}else{
			return elemObj.val();
		}
		return "";
	};
	
	//获取域表述
	this._rela_getFiledText = function(elemName){
		var elemObj = $("[name='"+elemName+"']:input");
		if(elemObj.is(":text")){
			return elemObj.val();
		}else if(elemObj.is(":radio")||elemObj.is(":checkbox")){
			var rtnStr = "";
			elemObj.each(function(index,ele){
				var tmpObj = $(ele);
				if(tmpObj.is(":checked")){
					rtnStr += ";" + tmpObj.parent().text();
				}
			});
			return rtnStr!=""?rtnStr.substring(1):"";
		}else{
			if(elemObj.attr("tabName")=='SELECT'){
				return elemObj.find("option:selected").text();
			}else{
				return elemObj.val();
			}
		}
		return "";
	};
	
	//模糊查询时联动
	this._rela_condition_refreshMatchDisplay = function(index , trObj){
		if(trObj==null){
			trObj = $("#rela_condition tr[kmss_type]:nth-child("+(index + 1)+")");
		}
		var obj = $("input[name='fdBlurSearch_"+index+"']");
		if(obj.length<=0) return;
		var type = trObj.attr("kmss_type");
		if(type=="foreign"){
			if($("input[name='fdItemName_"+index+"']").val()=="docKeyword"){
				return ;
			}
			var detailTr = trObj.find("table[rela_Detail='1'] tr");
			if(obj.is(":checked")){
				detailTr.find("td:nth-child(1)").hide();
				detailTr.find("td:nth-child(2)").show();
			}else{
				detailTr.find("td:nth-child(1)").show();
				detailTr.find("td:nth-child(2)").hide();
			}
		}
	};
	
	//自动关联设置时联动
	this._rela_condition_refreshRelationDisplay = function(index , trObj){
		if(trObj==null){
			trObj = $("#rela_condition tr[kmss_type]:nth-child("+(index + 1)+")");
		}
		var obj =  $("input[name='fdVarName_"+index+"']");
		if(obj.length<=0) return;
		if(obj.is(":checked")){
			trObj.find(">td:nth-child(2)").hide();
			trObj.find(">td:nth-child(3)").show();
			$("#tipDiv_"+index).show();
		}else{
			trObj.find(">td:nth-child(2)").show();
			trObj.find(">td:nth-child(3)").hide();
			$("#tipDiv_"+index).hide();
		}
	};
	
	//用于大于等运算符处理显示逻辑
	this._rela_condition_refreshLogicDisplay = function(obj , id){
		if(obj==null){
			return ;
		}
		var spanObj = $("#" + id);
		var selectObj = $(obj);
		if(selectObj.val() == "bt"){
			spanObj.show();
		}else{
			spanObj.hide();
		}
	};
	
	//建立一个新的配置
	this._rela_condition_createNewCondition = function(){
		return {fdId:"",fdTitle:"",fdItemName:"",fdParameter1:"",fdParameter2:"",fdParameter3:"",fdBlurSearch:"",fdVarName:""};
	};

	//数字校验
	this._rela_isNumber = function(value, message){
		if(value.split(".").length<3)
			if(!(/[^\d\.]/gi).test(value))
				return true;
		alert('<bean:message key="errors.number" />'.replace("{0}", message));
		return false;
	};
	//TODO 日期校验
	this._rela_isDate = function(value, message){
		return true;
	};
	
	Com_AddEventListener(window, "load", function(){
		self.onload();
	});
	
	//显示全部条件,当条件超过20个时，后面的条件隐藏，点击“显示全部”，可以显示所有条件。
}
function viewAllConditions(){
	var trObj = $("#rela_condition tr").show();
	$("#viewAllP").hide();
	window["_relationCfg"].resizeFrame();
}

