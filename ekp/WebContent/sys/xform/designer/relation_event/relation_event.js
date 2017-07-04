
// 获取所有数据源
// var relationSource = new relationSource();
Designer_Config.operations['relationEvent'] = {
	lab : "5",
	imgIndex : 52,
	title :Designer_Lang.relation_event_name,
	run : function(designer) {
		designer.toolBar.selectButton('relationEvent');
	},
	type : 'cmd',
	shortcut : '',
	isAdvanced: true,
	select : true,
	cursorImg : 'style/cursor/select.cur'
};
Designer_Config.controls.relationEvent = {
	type : "relationEvent",
	storeType : 'none',
	inherit : 'base',
	container : false,
	onDraw : _Designer_Control_RelationEvent_OnDraw,
	drawXML : _Designer_Control_RelationEvent_DrawXML,
	implementDetailsTable : true,
	//onAttrSuccess : _Designer_Control_Attr_RelationEvent_SuccessAttr,
	onAttrLoad : function(){
//		var w252="352px";
//		var w240="340px";
//		$(".panel_title").css("width",w252);
//		
//		$(".panel_main").css("width",w252);
//		$(".panel_main").css("background","");
//		
//		$(".panel_table").css("width",w240);
//		
//		$(".panel_bottom").css("width",w252);
		
	},
	attrs : {
		//label : Designer_Config.attrs.label,
		source : {
			//展示样式
			text: Designer_Lang.relation_select_source,
			value : '',
			type : 'select',
			opts:relationSource.GetOptionsArray(),
			onchange:'_Designer_Control_Event_Attr_Source_Change(this)',
			show: true
		},
		
		funName : {
			text : Designer_Lang.relation_select_busiName,//'业务名称',
			value : '',
			type : 'comText',
			readOnly : true,
			required: true,
			operate:"_Designer_Control_Attr_RelationEvent_Self_FunName_Draw",
			show : true
		},
		funKey : {
			text : '函数key',
			value : '',
			type : 'text',
			show : false
		},
		bindDom : {
			text : Designer_Lang.relation_event_trigger_dom,
			value : '',
			required: true,
			width:"75%",
			type : 'comText',
			operate:'_TrigetEventControl',
			show : true
		},
		bindEvent : {
			text : Designer_Lang.relation_event_trigger_event,
			value : '',
			type : 'select',
			opts:[{"text":Designer_Lang.relation_event_onmouseClick,'value':'click'},
			      {"text":Designer_Lang.relation_event_onchange,'value':'change'},
			      {"text":'事件控件返回事件','value':'relation_event_setvalue'}],
			show : true
		},
		listRule:{
			//意见排序	
			text: Designer_Lang.relation_event_chooseList,
			value : '10',
			type : 'select',
			opts:[{"text":Designer_Lang.relation_event_singleNoPage,'value':'00'},
			      {"text":Designer_Lang.relation_event_singlePage,'value':'01'},
			      {"text":Designer_Lang.relation_event_mutiNoPage,'value':'10'},
			      {"text":Designer_Lang.relation_event_mutiPage,'value':'11'},
			      {"text":'多行直接返回','value':'99'}],
			show : true
		},
		outputParams : {
			text : "<span style='cursor:pointer' onclick='_addOutputParams(this);'>"+Designer_Lang.relation_select_outputParams+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src='relation_event/style/icons/add.gif'></img></span>",//传出参数
			value : '',
			type : 'self',
			draw : _Designer_Control_Attr_RelationEvent_Self_Output_Draw,
			show : true
		},
		inputParams : {
			//传入参数
			text : Designer_Lang.relation_select_inputParams,//'传入参数',
			value : '',

			type : 'self',
			draw : _Designer_Control_Attr_RelationEvent_Self_Draw,
			show : true
		},
		template : {
			text : '模板',
			value : '',
			varInfo : '',
			isLock:false,
			type : 'text',
			show : false
		}
	},
	info : {
		name : Designer_Lang.relation_event_name
		//preview : "mutiTab.png"
	},
	resizeMode : 'no'
};
Designer_Config.buttons.control.push("relationEvent");
Designer_Menus.add.menu['relationEvent'] = Designer_Config.operations['relationEvent'];

function _Designer_Attr_AddAll_RelationEvent_Controls(controls, obj,expectId) {
	for (var i = 0, l = controls.length; i < l; i ++) {
		
		if("relationEvent"==controls[i].type&&expectId != controls[i].options.values.id){
			var temp={};
			temp.name=controls[i].options.values.id;
			temp.label='事件控件('+controls[i].options.values.id+')';
			temp.type='String';
			obj.push(temp);
		}
		_Designer_Attr_AddAll_RelationEvent_Controls(controls[i].children, obj,expectId);
	}
}
function _TrigetEventControl(a,name){
	var c=Designer.instance.getObj(false);
	_Designer_Attr_AddAll_RelationEvent_Controls(Designer.instance.builder.controls,c,Designer.instance.attrPanel.panel.control.options.values.id);
	RelatoinFormFieldChoose(document.getElementById(name),document.getElementById(name),function(rtn){
		if(rtn&&rtn.data&&rtn.data[0].id){
			document.getElementById(name).value=rtn.data[0].id;
		}
	},c);
}
function Designer_RelationEvent_Control_Source_Required_Checkout(msg, name, attr, value, values, control){
	if(values.source){
		return true;
	}
	msg.push(values.label,","+Designer_Lang.relation_select_sourceNotNull);
	return false;
}
function Designer_RelationEvent_Control_OutputParams_Required_Checkout(msg, name, attr, value, values, control){
	var val=value?value:"{}";
	
	var fieldsTemplate = attr.init;
	
	
	
	
	var outputParamsMapping = JSON.parse(val.replace(/quot;/g,"\""));
	for ( var i = 0; i < fieldsTemplate.length; i++) {
		var field = fieldsTemplate[i];
		if(!field._required){
			continue;
		}
		if (outputParamsMapping && outputParamsMapping[field.fieldIdForm]) {
			 var uuid=outputParamsMapping[field.fieldIdForm].uuId;
			 if(!uuid){
				 msg.push(values.label,","+Designer_Lang.relation_select_outputParamsNotNull);
				 return false;
			 }
		}
		else{
			msg.push(values.label,","+Designer_Lang.relation_select_outputParamsNotNull);
			return false;
		}

		
	}
	return true;
	
	
	
}

// 属性面板成功关闭时设置值
function _Designer_Control_Attr_RelationEvent_SuccessAttr() {

	//this.options.values.inputParams=JSON.stringify(_GetInsParamsMapping()).replace(/"/g,"'");
	// this.options.values.inputParams=JSON.stringify(_GetInsParamsMapping()).replace(/"/g,"'");
	// $(this.options.domElement).find("select").attr("inputParams",this.options.values.inputParams);
}

function _Designer_Control_RelationEvent_OnDraw(parentNode, childNode) {
	if (this.options.values.id == null){
		this.options.values.id = "fd_" + Designer.generateID();
		
	}
	var domElement = _CreateDesignElement('div', this, parentNode, childNode);
	//domElement.label=_Get_Designer_Control_Label(this.options.values, this);
	domElement.style.width='16px';
	//domElement.style.height='30px';
	var values = this.options.values;
	var inputDom = document.createElement('input');
	inputDom.type='hidden';
	domElement.appendChild(inputDom);
	//domElement.style.display="inline";
	
	// selectDom.style.width = values.width;
	inputDom.id = this.options.values.id;
	
	if (values.outputParams) {
		inputDom.outputParams = values.outputParams;
	}
	if (values.inputParams) {
		inputDom.inputParams = values.inputParams;
	}
	if (values.source) {
		inputDom.source = values.source;
	}
	if (values.funKey) {
		inputDom.funKey = values.funKey;
	}
	if (values.bindDom) {
		inputDom.bindDom = values.bindDom;
	}
	if (values.bindEvent) {
		inputDom.bindEvent = values.bindEvent;
	}
	if(values.listRule){
		inputDom.listRule = values.listRule;
	}
	var label = document.createElement("span");
	//label.appendChild(document.createTextNode("JSP"));
	label.className = "button_img";
	label.style.backgroundPosition = "center " + (- 52 * 16) + "px";
	label.style.margin = '0px 0px 0px 0px';
	label.style.display = 'inline-block';
	label.style.width='16px';
	label.style.height='16px';
	domElement.appendChild(label);
	//$(domElement).html("<span style='font-style:italic;font-weight:bold;background-color:#FFC125;'>EVENT</span>");
	//$(domElement).html("<img src='relation_event/style/icons/event.png' width='16px' height='16px'></img>");
	

	//alert(domElement.innerHTML);
}
function _Designer_Control_Attr_RelationEvent_Self_FunName_Draw(){
	_Designer_Control_Event_Attr_Source_Change(document.getElementsByName("source")[0],true);
}
function _Designer_Control_Event_Attr_Source_Change(obj,choose) {
	var control = Designer.instance.attrPanel.panel.control;
	// 选择“--请选择---” 后无需处理业务
	if (!obj.value) {
		_Clear_Relation_Event_Attrs(control);
		control.options.values.source_oldValue='';
		control.options.values.source='';
		return;
	}

	var source = relationSource.GetSourceByUUID(obj.value);
	
	control.options.values.funName=source.sourceName;
	// 如果扩展点中 paramsURL为空，数据源即业务
	var rtnVal = {
		"_source" : obj.value,
		"_key" : obj.value,
		"_keyName" : control.options.values.funName
	};
	
	if (source.paramsURL) {
		
	    new ModelDialog_Show(Com_Parameter.ContextPath+source.paramsURL,rtnVal,function(rtnVal){
	    	// 没有选择函数
			if(!rtnVal||!rtnVal._key||rtnVal._key=='undefined'){
				//新数据源没有选择业务函数时 回退选择源数据源
				$("#relation_event_source").val(control.options.values.source_oldValue);
				
				return ;
			}
			_Clear_Relation_Event_Attrs(control);
			
			

			control.options.values.source_oldValue=obj.value;
			// 设置业务名称
			document.getElementsByName("funName")[0].value = rtnVal._keyName;
			control.options.values.funName = rtnVal._keyName;
			control.options.values.funKey = rtnVal._key;
			control.options.values.source=obj.value;
			
			LoadEventInputParamsTemplate(control, obj.value, rtnVal._key );
	    	
	    }).show();
	}
	//直接选择业务 
	else{
		
		if(choose){
			alert('该业务没有更多可选项');
			return;
		}
		_Clear_Relation_Event_Attrs(control);
		

		control.options.values.source_oldValue=obj.value;
		// 设置业务名称
		document.getElementsByName("funName")[0].value = rtnVal._keyName;
		control.options.values.funName = rtnVal._keyName;
		control.options.values.funKey = rtnVal._key;
		control.options.values.source=obj.value;
		
		LoadEventInputParamsTemplate(control, obj.value, rtnVal._key );
	}
	
}
function _Clear_Relation_Event_Attrs(control){

	$('#relation_event_inputs').html(Designer_Lang.relation_select_chooseSource);
	$('#relation_event_outputs').html(Designer_Lang.relation_event_noOutputParams);
	// 清空输出
	control.options.values.outputParams = "";
	
	control.options.values.inputParams = "";

	// 清空业务
	document.getElementsByName("funName")[0].value = "";
	control.options.values.funName = "";
	control.options.values.funKey = "";
}
/**
 * 
 * @param control
 * @param source 选择的数据源，如TIB 或是其他
 * @param key    函数key
 * @param beanName 业务bean的id
 * @param mapping 
 * @return
 */
function LoadEventInputParamsTemplate(control, source, key) {

	 loadTemplate(key,source,function(data){
			var insStr = "";
			if(data&&data.ins){
				for ( var i = 0; i < data.ins.length; i++) {
					var field = data.ins[i];
					insStr += _CreateEventInputParams(field) + "<br/>";
				}
			}
			$("#relation_event_inputs").html(insStr);
		
	 },true);
}

//构建每个参数项
function _CreateEventInputParams(field) {
	
	var html = [];
	var paramName = field.fieldName ? field.fieldName : field.fieldId;
		paramName=paramName?paramName:field.uuId;
	html.push("<label>" + paramName + "</lable>");
	// 必填
	if(field._required=="1"){
		html.push("<span class='txtstrong'>*</span>");
	}
	html.push("<br/>");
	
	html.push("<input type='hidden' id='" + field.uuId + "_required' value='"
			+ field._required + "' />");
	// html.push("<input type='hidden' name='insParams' value='"+field.uuId+"'
	// />");
	html.push("<input type='hidden' id='" + field.uuId + "_formId' value='"
			+ field.fieldIdForm + "' />");
	html.push("<input id='" + field.uuId + "_formName' value='"
			+ field.fieldNameForm + "' readOnly=true />");
	html.push(" <a href='#' onclick='RelatoinEventOpenExpressionEditor(this,\""
			+ field.uuId + "\");'>"+Designer_Lang.relation_select_choose+"</a>");
	return html.join("");
}
function _addOutputParams(obj){
	
	if(!Designer.instance.attrPanel.panel.control.options.values.funKey){
		alert('请先选择数据源');
		return ;
	}
	//显示按钮面板
	Relation_ShowButton();

	var field={
			"fieldIdForm" : "",
			"fieldNameForm" : Designer_Lang.relation_event_formField,
			"fieldName" : Designer_Lang.relation_event_templateField,
			"fieldId" : "",
			"_required":false
		}; 
	//随机产生一个唯一标识
	field.fid="fm_"+Designer.generateID();
	var isFirst=false;
	//清空初始值                          
	if($("#relation_event_outputs").html()==Designer_Lang.relation_event_noOutputParams){
		$("#relation_event_outputs").html("");
		isFirst=true;
	}
	$("#relation_event_outputs").append(_CreateEventOutParams(field,isFirst));                
//}
}
function _delEventOutputParams(obj){
	//显示按钮面板
	Relation_ShowButton();
	var control = Designer.instance.attrPanel.panel.control;
	
	var fid=$(obj).parent().attr("id");
	
	control.options.values.outputParams = control.options.values.outputParams ? control.options.values.outputParams
			: "{}";
	var outputParamsJSON = JSON
			.parse(control.options.values.outputParams.replace(/quot;/g,"\""));
	if(outputParamsJSON[fid]){
		//删除掉 这个对象的映射值 
		delete outputParamsJSON[fid];
	}
	control.options.values.outputParams=JSON.stringify(
			outputParamsJSON).replace(/"/g,"quot;");
	$(obj).parent().remove();
	//清空到最后一条的时候需要 加上初始值
	if(!$("#relation_event_outputs").html()){
		$("#relation_event_outputs").html(Designer_Lang.relation_event_noOutputParams);
	}
}
function _CreateEventOutParams(field,isFirst) {
	var html = [];

	var fid=field.fid;
	html.push("<span id='"+fid+"'>");
	//第一个元素不需要分隔符
	if(!isFirst){
		html.push("<hr />");
	}
	
	
	html.push(" <img src='relation_event/style/icons/delete.gif' onclick='_delEventOutputParams(this);' style='cursor:pointer;vertical-align:middle;'></img>");
	
	html.push("<input type='hidden' id='" + fid + "_fieldIdForm' value='" + field.fieldIdForm + "' />");
	html.push("<input id='" + fid + "_fieldNameForm' value='"+ field.fieldNameForm + "' readOnly=true  style='width:58px;vertical-align:middle;'/>");
	
	
	html.push(" <img src='relation_event/style/icons/edit.gif' onclick='RelatoinEventOpenOutExpressEditor(this,\""+fid+"\");' style='cursor:pointer;vertical-align:middle;'></img>");
	
	// html.push("<input type='hidden' name='insParams' value='"+field.uuId+"'
	// />");
	var uuid = field.uuId ? field.uuId : field.fieldId;
	html.push("<input type='hidden' id='" + fid
			+ "_fieldId' value='" + uuid + "' />");
	html.push("<input id='" + fid + "_fieldName' value='"
			+ field.fieldName + "' readOnly=true  style='width:58px;vertical-align:middle;'/>");
	html.push(" <img src='relation_event/style/icons/edit.gif' onclick='Open_Relation_Event_Tree_Dialog(this,\""
			+ fid + "\");' style='cursor:pointer;vertical-align:middle;'></img>");
	
	if(field._required){
		//html.push("<span class='txtstrong'>*</span>");
	}
	html.push("</span>");
	return html.join("");
}
function _Designer_Control_Attr_RelationEvent_Self_Draw(name, attr, value,
		form, attrs, values, control) {
	var val = value;

	html = "";

	if (values.funKey) {
		if (!val) {
			val = "{}";
		}
		var mapping = JSON.parse(val.replace(/quot;/g,"\""));
		 
		 loadTemplate(values.funKey,values.source,function(data){
			 
			 
			// var template = JSON.parse(JSON.stringify(data).replace(/"/g,"quot;"));
			 
			 var insStr = "";
			if(data&&data.ins){
				for ( var i = 0; i < data.ins.length; i++) {
					var fieldTemp = data.ins[i];
					var field={};
					// 克隆一个对象，防止模板被修改
					$.extend(true,field, fieldTemp);
					if (mapping && mapping[field.uuId]) {
						field.fieldIdForm = mapping[field.uuId].fieldIdForm;
						field.fieldNameForm = mapping[field.uuId].fieldNameForm;
					}
					insStr += _CreateEventInputParams(field) + "<br/>";
				}
			}
			html += "<div id='relation_event_inputs'> " + insStr + "</div>";
			 
		 });
		// _LoadTemplate("","","",mapping);
	} else {
		html += "<div id='relation_event_inputs'>"+Designer_Lang.relation_select_chooseSource+"</div>";
	}
	return Designer_AttrPanel.wrapTitle(name, attr, value, html);
}
function _Designer_Control_Attr_RelationEvent_Self_Output_Draw(name, attr,
		value, form, attrs, values, control) {
	if (!control.options.values.funKey) {
		var html = "<div id='relation_event_outputs'>"+Designer_Lang.relation_event_noOutputParams+"</div>";
		return Designer_AttrPanel.wrapTitle(name, attr, value, html);
	}
	var html = "<div id='relation_event_outputs'>";

	var val = value ? value : "{}";
	var outputParamsMapping = JSON.parse(val.replace(/quot;/g,"\""));
	var i=0;
	for(var fid in outputParamsMapping){
		var param = outputParamsMapping[fid];
		param.fid=fid;
		html += _CreateEventOutParams(param,i==0);
		i++;
	}
	html+="</div>";
	return Designer_AttrPanel.wrapTitle(name, attr, value, html);
}
function _Designer_Control_RelationEvent_DrawXML() {

}

function Open_Relation_Event_Tree_Dialog(a, fid) {

	var control = Designer.instance.attrPanel.panel.control;
    var values=control.options.values;
	if (!control.options.values.funKey) {
		alert(Designer_Lang.relation_select_chooseSource);
		return;
	}	
	loadTemplate(values.funKey,values.source,function(data,varInfo){
		
		Open_Relation_Fields_Tree(document.getElementById(fid + "_fieldId"),
				document.getElementById(fid + "_fieldName"),
				varInfo,function(rtn){
			if(!rtn){
				return;
			}
			Relation_ShowButton();
			var control = Designer.instance.attrPanel.panel.control;
			control.options.values.outputParams = control.options.values.outputParams ? control.options.values.outputParams
					: "{}";
			var outputParamsJSON = JSON
					.parse(control.options.values.outputParams.replace(/quot;/g,"\""));
			if(!outputParamsJSON[fid]){
				outputParamsJSON[fid]={};
			}
			outputParamsJSON[fid].fieldId=rtn.data[0].id;
			outputParamsJSON[fid].fieldName=rtn.data[0].name;
			
			if(data&&data.outs){
				for ( var i = 0; i < data.outs.length; i++) {
					var field = data.outs[i];
					var uuid = field.uuId ? field.uuId : field.fieldId;
					if(uuid==rtn.data[0].id){
						outputParamsJSON[fid].canSearch=field.canSearch;
						break;
					}
				}
			}
			control.options.values.outputParams = JSON.stringify(
					outputParamsJSON).replace(/"/g,"quot;");
		});
		 /******
		 Relation_Formula_Dialog(
					document.getElementById(uuid + "_fieldId"),
					document.getElementById(uuid + "_fieldName"),
					varInfo,
					"String",
					function(rtn){
						if(!rtn){
							return;
						}
						Designer.instance.attrPanel.panel._changed = true;
						Designer.instance.attrPanel.panel.showBottom();
						
						var control = Designer.instance.attrPanel.panel.control;
						control.options.values.outputParams = control.options.values.outputParams ? control.options.values.outputParams
								: "{}";
						var outputParamsJSON = JSON
								.parse(control.options.values.outputParams.replace(/quot;/g,"\""));
						if(!outputParamsJSON[uuid]){
							outputParamsJSON[uuid]={};
						}
						outputParamsJSON[uuid].fieldId=rtn.data[0].id;
						outputParamsJSON[uuid].fieldName=rtn.data[0].name;
				
						control.options.values.outputParams = JSON.stringify(
								outputParamsJSON).replace(/"/g,"quot;");
						
					});
			**************/
	 });
}
//设定输出参数
function RelatoinEventOpenOutExpressEditor(obj, uuid, action){
	var idField, nameField;
	idField = document.getElementById(uuid + "_fieldIdForm");
	nameField = document.getElementById(uuid + "_fieldNameForm");

	RelatoinFormFieldChoose(idField,nameField,function(rtn){
			if(!rtn){
				return;
			}
			Relation_ShowButton();
			
			var control = Designer.instance.attrPanel.panel.control;
	
			control.options.values.outputParams = control.options.values.outputParams ? control.options.values.outputParams
					: "{}";
			var outputParamsJSON = JSON
					.parse(control.options.values.outputParams.replace(/quot;/g,"\""));
	
			if(rtn&&rtn.data&&rtn.data[0].id){
				if(!outputParamsJSON[uuid]){
					outputParamsJSON[uuid]={};
				}
				outputParamsJSON[uuid].fieldIdForm=rtn.data[0].id;
				outputParamsJSON[uuid].fieldNameForm=rtn.data[0].name;
				control.options.values.outputParams = JSON.stringify(
						outputParamsJSON).replace(/"/g,"quot;");
			}
	},Designer.instance.getObj(false));
	/****************
	var dialog = new KMSSDialog();
	dialog.BindingField(idField, nameField);
	dialog.Parameters = {
		varInfo : Designer.instance.getObj(true)
	};

	dialog
			.SetAfterShow( function(rtn) {
				Designer.instance.attrPanel.panel._changed = true;
				Designer.instance.attrPanel.panel.showBottom();
				
				var control = Designer.instance.attrPanel.panel.control;

				control.options.values.outputParams = control.options.values.outputParams ? control.options.values.outputParams
						: "{}";
				var outputParamsJSON = JSON
						.parse(control.options.values.outputParams.replace(/quot;/g,"\""));

				if(rtn&&rtn.data&&rtn.data[0].id){
					if(!outputParamsJSON[uuid]){
						outputParamsJSON[uuid]={};
					}
					outputParamsJSON[uuid].fieldIdForm=rtn.data[0].id;
					outputParamsJSON[uuid].fieldNameForm=rtn.data[0].name;
					control.options.values.outputParams = JSON.stringify(
							outputParamsJSON).replace(/"/g,"quot;");
				}
			});

	dialog.URL = Com_Parameter.ContextPath
			+ "sys/xform/designer/relation/relation_formfields_tree.jsp?t="+(new Date());
	dialog.Show(380, 480);
	*****************/
}
function RelatoinEventOpenExpressionEditor(obj, uuid, action) {
	var idField, nameField;
	idField = document.getElementById(uuid + "_formId");
	nameField = document.getElementById(uuid + "_formName");
	var _requiredValue="";
	if(document.getElementById(uuid + "_required"))
		_requiredValue=document.getElementById(uuid + "_required").value;
	
	RelatoinFormFieldChoose(idField,nameField, function(rtn){
		
		Relation_ShowButton();
		
		var control = Designer.instance.attrPanel.panel.control;

		control.options.values.inputParams = control.options.values.inputParams ? control.options.values.inputParams
				: "{}";
		var inputParamsJSON = JSON
				.parse(control.options.values.inputParams.replace(/quot;/g,"\""));
		if(rtn&&rtn.data&&rtn.data[0].id){
			var t = {};
			t.fieldIdForm = rtn.data[0].id;
			t.fieldNameForm = rtn.data[0].name;
			t._required=_requiredValue;
			inputParamsJSON[uuid] = t;
			control.options.values.inputParams = JSON.stringify(
					inputParamsJSON).replace(/"/g,"quot;");
		}
		else{
			//清空选择时，需要取消映射
			delete inputParamsJSON[uuid];
			
			/**
			//清空选择时，需要取消映射
			var temp={};
			for(var param in inputParamsJSON){
				if(param==uuid){
					continue;
				}
				temp[param]=inputParamsJSON[param];
				
			}
			**/
			control.options.values.inputParams = JSON.stringify(
					inputParamsJSON).replace(/"/g,"quot;");
		}
		 
		 
		 
	 });
	/**************
	var dialog = new KMSSDialog();
	dialog.BindingField(idField, nameField);
	dialog.Parameters = {
		varInfo : Designer.instance.getObj(true)
	};

	// dialog.SetAfterShow(function(){Designer_AttrPanel.showButtons(obj);});

	dialog
			.SetAfterShow( function(rtn) {
				
				
				
				Designer.instance.attrPanel.panel._changed = true;
				Designer.instance.attrPanel.panel.showBottom();
				
				var control = Designer.instance.attrPanel.panel.control;

				control.options.values.inputParams = control.options.values.inputParams ? control.options.values.inputParams
						: "{}";
				var inputParamsJSON = JSON
						.parse(control.options.values.inputParams.replace(/quot;/g,"\""));
				if(rtn&&rtn.data&&rtn.data[0].id){
					var t = {};
					t.fieldIdForm = rtn.data[0].id;
					t.fieldNameForm = rtn.data[0].name;
					t._required=_requiredValue;
					inputParamsJSON[uuid] = t;
					control.options.values.inputParams = JSON.stringify(
							inputParamsJSON).replace(/"/g,"quot;");
				}
				else{
					//清空选择时，需要取消映射
					var temp={};
					for(var param in inputParamsJSON){
						if(param==uuid){
							continue;
						}
						temp[param]=inputParamsJSON[param];
						
					}
					control.options.values.inputParams = JSON.stringify(
							temp).replace(/"/g,"quot;");
				}
			});

	dialog.URL = Com_Parameter.ContextPath
			+ "sys/xform/designer/relation/relation_formfields_tree.jsp?t="+(new Date());
	dialog.Show(380, 480);
*******************/
};