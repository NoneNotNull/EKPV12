document.write("<script>Com_IncludeFile('json2.js');</script>");
document
		.write('<script>Com_IncludeFile("relationFormula.js","../sys/xform/designer/relation/formula/");</script>');

Designer_AttrPanel.comTextDraw = function(name, attr, value, form, attrs,
		values, control) {
	var width = "95%";
	if (attr.operate) {
		width = "auto";
	}
	var html = " <input type='text' style='width:" + width
			+ "' class='attr_td_text' id='" + name + "' name='" + name;
	if (attr.value != value && value != null) {
		html += "' value='" + value;
	} else {
		html += "' value='" + attr.value;
	}
	if (attr.readOnly) {
		html += "' readOnly='" + attr.value;
	}

	html += "'>";
	// html+="<input type='hidden' name='"+name+"_id' id='"+name+"_id'/>"
	if (attr.operate) {
		//Designer_Lang.relation_select_choose 选择
		html += "&nbsp;<a href='#' onclick='" + attr.operate + "(this,\""
				+ name + "\");'>"+Designer_Lang.relation_select_choose+"</a>";
	}
	return Designer_AttrPanel.wrapTitle(name, attr, value, html);
}
Designer_Config.operations['relationSelect'] = {
	lab : "5",
	imgIndex : 51,
	title : Designer_Lang.relation_select_name,
	run : function(designer) {
		designer.toolBar.selectButton('relationSelect');
	},
	type : 'cmd',
	shortcut : '',
	sampleImg : 'style/img/relation_select.png',
	select : true,
	isAdvanced: true,
	cursorImg : 'style/cursor/select.cur'
};
Designer_Config.controls.relationSelect = {
	type : "relationSelect",
	storeType : 'field',
	inherit : 'base',
	container : false,
	onDraw : _Designer_Control_RelationSelect_OnDraw,
	drawXML : _Designer_Control_RelationSelect_DrawXML,
	implementDetailsTable : true,
	//onAttrSuccess : _Designer_Control_Attr_RelationSelect_SuccessAttr,
	attrs : {
		label : Designer_Config.attrs.label,
		required : {
			text : Designer_Lang.controlAttrRequired,
			value : "true",
			type : 'checkbox',
			checked : false,
			show : true
		},
		source : {
			//展示样式
			text: Designer_Lang.relation_select_source,
			value : '',
			type : 'select',
			opts:relationSource.GetOptionsArray(),
			onchange:'_Designer_Control_Attr_Source_Change(this)',
			show: true
		},
		
		funName : {
			text : Designer_Lang.relation_select_busiName,//'业务名称',
			value : '',
			type : 'comText',
			readOnly : true,
			required: true,
			operate:"_Designer_Control_Attr_RelationSelect_Self_FunName_Draw",
			show : true
		},
		funKey : {
			text : '函数key',
			value : '',
			type : 'text',
			show : false
		},
		outputParams : {
			text : Designer_Lang.relation_select_outputParams,//传出参数
			value : '',
			type : 'self',
			init : [ {
				"fieldIdForm" : "textValue",
				"fieldNameForm" : Designer_Lang.relation_select_showText,//"显示值",
				"fieldName" : "",
				"fieldId" : "",
				"_required":true
			}, {
				"fieldIdForm" : "hiddenValue",
				"fieldNameForm" : Designer_Lang.relation_select_hiddeValue,//"隐藏值",
				"fieldName" : "",
				"fieldId" : "",
				"_required":true
			} ],
			checkout: Designer_RelationSelect_Control_OutputParams_Required_Checkout,
			draw : _Designer_Control_Attr_RelationSelect_Self_Output_Draw,
			show : true
		},
		inputParams : {
			//传入参数
			text : Designer_Lang.relation_select_inputParams,//'传入参数',
			value : '',

			type : 'self',
			draw : _Designer_Control_Attr_RelationSelect_Self_Draw,
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
		name : Designer_Lang.relation_select_name
		//preview : "mutiTab.png"
	},
	resizeMode : 'no'
};
Designer_Config.buttons.control.push("relationSelect");
Designer_Menus.add.menu['relationSelect'] = Designer_Config.operations['relationSelect'];

function GetVarInfoByControl(control,template) {
	//var template = JSON.parse(control.attrs.template.value.replace(/quot;/g,"\""));
	//var template =control.attrs.template.value;// JSON.parse(control.attrs.template.value.replace(/quot;/g,"\""));
	var varInfo = [];
	for ( var i = 0; i < template.outs.length; i++) {
		var field = template.outs[i];

		var fieldName = field.fieldName ? field.fieldName : field.fieldId;
		fieldName = fieldName ? fieldName : field.uuId;

		var fieldId = field.uuId;

		varInfo.push( {
			"name" : fieldId,
			"label" : fieldName,
			"type" : 'String'
		});
	}
	control.attrs.template.varInfo=varInfo;
	return varInfo;
}
function Designer_RelationSelect_Control_Source_Required_Checkout(msg, name, attr, value, values, control){
	if(values.source){
		return true;
	}
	msg.push(values.label,","+Designer_Lang.relation_select_sourceNotNull);
	return false;
}
function Designer_RelationSelect_Control_OutputParams_Required_Checkout(msg, name, attr, value, values, control){
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
function _Designer_Control_Attr_RelationSelect_SuccessAttr() {

	//this.options.values.inputParams=JSON.stringify(_GetInsParamsMapping()).replace(/"/g,"'");
	// this.options.values.inputParams=JSON.stringify(_GetInsParamsMapping()).replace(/"/g,"'");
	// $(this.options.domElement).find("select").attr("inputParams",this.options.values.inputParams);
}

function _Designer_Control_RelationSelect_OnDraw(parentNode, childNode) {
	if (this.options.values.id == null){
		this.options.values.id = "fd_" + Designer.generateID();
		
	}
	var domElement = _CreateDesignElement('div', this, parentNode, childNode);
	domElement.label=_Get_Designer_Control_Label(this.options.values, this);
	
	var values = this.options.values;

	
	// end 设置宽度
	var selectDom = document.createElement('select');

	selectDom.required = (this.options.values.required == 'true' ? 'true'
			: 'false');
	selectDom._required = (this.options.values.required == 'true' ? 'true'
			: 'false');

	// selectDom.style.width = values.width;
	
	selectDom.id = this.options.values.id;
	selectDom.label=domElement.label;
	selectDom.idText=this.options.values.idText;
	if (values.outputParams) {
		selectDom.outputParams = values.outputParams;
	}
	if (values.inputParams) {
		selectDom.inputParams = values.inputParams;
	}
	if (values.source) {
		selectDom.source = values.source;
	}
	if (values.funKey) {
		selectDom.funKey = values.funKey;
	}

	$(selectDom).html("<option>"+Designer_Lang.relation_select_pleaseChoose+"</option>");
	domElement.appendChild(selectDom);
	// 设置必填
	if (this.options.values.required == 'true') {
		domElement.innerHTML += '<span class=txtstrong>*</span>';
	}

	//alert(domElement.innerHTML);
}
function _Designer_Control_Attr_RelationSelect_Self_FunName_Draw(){
	_Designer_Control_Attr_Source_Change(document.getElementsByName("source")[0],true);
}
function _Designer_Control_Attr_Source_Change(obj,choose) {
	var control = Designer.instance.attrPanel.panel.control;
	
	// 选择“--请选择---” 后无需处理业务
	if (!obj.value) {
		
		_Clear_Relation_Select_Attrs(control);
		
		control.options.values.source_oldValue='';
		control.options.values.source='';
		return;
	}

	var source = relationSource.GetSourceByUUID(obj.value);
	control.options.values.funName=source.sourceName;
	// 如果扩展点钟 paramsURL为空，数据源即业务
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
					$("#relation_select_source").val(control.options.values.source_oldValue);
					
					return ;
				}
				_Clear_Relation_Select_Attrs(control);
				control.options.values.source_oldValue=obj.value;
				// 设置业务名称
				document.getElementsByName("funName")[0].value = rtnVal._keyName;
				control.options.values.funName = rtnVal._keyName;
				control.options.values.funKey = rtnVal._key;
				control.options.values.source=obj.value;
				_LoadInputParamsTemplate(control, obj.value, rtnVal._key );
				_LoadOutPutParamsTemplate(control, obj.value, rtnVal._key);
				
		 }).show();
	
	}
	//直接选择业务 
	else{
		
		if(choose){
			alert('该业务没有更多可选项');
			return;
		}
		_Clear_Relation_Select_Attrs(control);
		
		control.options.values.source_oldValue=obj.value;
		// 设置业务名称
		document.getElementsByName("funName")[0].value = rtnVal._keyName;
		control.options.values.funName = rtnVal._keyName;
		control.options.values.funKey = rtnVal._key;
		control.options.values.source=obj.value;
		_LoadInputParamsTemplate(control, obj.value, rtnVal._key );
		_LoadOutPutParamsTemplate(control, obj.value, rtnVal._key);
	}
}
function _Clear_Relation_Select_Attrs(control){

	$('#relation_select_inputs').html(Designer_Lang.relation_select_chooseSource);
	$('#relation_select_outputs').html(Designer_Lang.relation_select_chooseSource);
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
function _LoadOutPutParamsTemplate(control, source, key, beanName, outputParamsMapping) {
	var html = "";
	var fieldsTemplate = control.attrs.outputParams.init;

	for ( var i = 0; i < fieldsTemplate.length; i++) {
		var field = fieldsTemplate[i];
		
		html += _CreateOutParams(field) + "<br/>";
	}
	
	$("#relation_select_outputs").html(html);
}
//isMast 是否强制加载
function loadTemplate(key, source,callBack,isMast){
	
	var control = Designer.instance.attrPanel.panel.control;
	if(!isMast){
		
		if(control.attrs.template.value){
			if(!control.attrs.template.varInfo){
				control.attrs.template.varInfo=GetVarInfoByControl(control,control.attrs.template.value);
			}
			callBack(control.attrs.template.value,control.attrs.template.varInfo);
			return;
		}
	}
	
	$.ajax( {
		type : "post",
		async : false,//是否异步
		url : Com_Parameter.ContextPath
				+ "sys/xform/controls/relation.do?method=template",
		data : {
			"_source" : source,
			"key" : key
		},
		dataType : "json",
		success : function(data) {
			
			if(!data){
				alert('业务函数模板不能为空');
				return ;
			}
			if(!data.outs||data.outs.length==0){
				alert("函数模板中输出参数不能为空");
				return;
			}
			
			control.attrs.template.value =data;// JSON.stringify(data).replace(/"/g,"quot;");
			control.attrs.template.varInfo=GetVarInfoByControl(control,data);
			
			callBack(data,control.attrs.template.varInfo);
		},
	error : function(msg) {
		alert('加载模板出错');
		
	}
	});
	
}

function _LoadInputParamsTemplate(control, source, key) {

	 loadTemplate(key,source,function(data){
			var insStr = "";
			if(data&&data.ins){
				for ( var i = 0; i < data.ins.length; i++) {
					var field = data.ins[i];
					insStr += _CreateSelectInputParams(field) + "<br/>";
				}
			}
			$("#relation_select_inputs").html(insStr);
		
	 },true);
}

//构建每个参数项
function _CreateSelectInputParams(field) {
	
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
	html.push(" <a href='#' onclick='RelatoinOpenExpressionEditor(this,\""
			+ field.uuId + "\");'>"+Designer_Lang.relation_select_choose+"</a>");
	return html.join("");
}

function _CreateOutParams(field) {
	
	var html = [];
	var paramName = field.fieldNameForm ? field.fieldNameForm
			: field.fieldIdForm;
	var uuid = field.uuId ? field.uuId : field.fieldId;
	html.push("<label>" + paramName + "</lable><br/>");
	// html.push("<input type='hidden' name='insParams' value='"+field.uuId+"'
	// />");
	html.push("<input type='hidden' id='" + field.fieldIdForm
			+ "_fieldId' value='" + uuid + "' />");
	html.push("<input id='" + field.fieldIdForm + "_fieldName' value='"
			+ field.fieldName + "' readOnly=true />");
	html.push(" <a href='#' onclick='Open_Relation_Formula_Dialog(this,\""
			+ field.fieldIdForm + "\");'>"+Designer_Lang.relation_select_choose+"</a>");
	if(field._required){
		html.push("<span class='txtstrong'>*</span>");
	}
	return html.join("");
}
function Open_Relation_Formula_Dialog(a, fieldIdForm) {

	var control = Designer.instance.attrPanel.panel.control;
	var domElement = control.options.domElement;
    var values=control.options.values;
	if (!control.options.values.funKey) {
		alert(Designer_Lang.relation_select_chooseSource);
		return;
	}	
	loadTemplate(values.funKey,values.source,function(data,varInfo){
		
		 
		 Relation_Formula_Dialog(
					document.getElementById(fieldIdForm + "_fieldId"),
					document.getElementById(fieldIdForm + "_fieldName"),
					varInfo,
					"String",
					function(rtn){
						if(!rtn){
							return;
						}
						var control = Designer.instance.attrPanel.panel.control;

						control.options.values.outputParams = control.options.values.outputParams ? control.options.values.outputParams
								: "{}";
						var outputParamsJSON = JSON
								.parse(control.options.values.outputParams.replace(/quot;/g,"\""));

						var t = {};
						t.uuId = rtn.data[0].id;
						t.fieldName = rtn.data[0].name;
						outputParamsJSON[fieldIdForm] = t;

						control.options.values.outputParams = JSON.stringify(
								outputParamsJSON).replace(/"/g,"quot;");
						
						
					});
	 });
}
function _Designer_Control_Attr_RelationSelect_Self_Draw(name, attr, value,
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
					insStr += _CreateSelectInputParams(field) + "<br/>";
				}
			}
			html += "<div id='relation_select_inputs'> " + insStr + "</div>";
			 
		 });
		// _LoadTemplate("","","",mapping);
	} else {
		html += "<div id='relation_select_inputs'>"+Designer_Lang.relation_select_chooseSource+"</div>";
	}
	return Designer_AttrPanel.wrapTitle(name, attr, value, html);
}
function _Designer_Control_Attr_RelationSelect_Self_Output_Draw(name, attr,
		value, form, attrs, values, control) {
	if (!control.options.values.funKey) {
		var html = "<div id='relation_select_outputs'>"+Designer_Lang.relation_select_chooseSource+"</div>";
		return Designer_AttrPanel.wrapTitle(name, attr, value, html);
	}
	var html = "<div id='relation_select_outputs'>";
	var fieldsTemplate = attr.init;
	
	var val = value ? value : "{}";
	var outputParamsMapping = JSON.parse(val.replace(/quot;/g,"\""));
	for ( var i = 0; i < fieldsTemplate.length; i++) {
		var fieldTemp = fieldsTemplate[i];
		var field={};
		// 克隆一个对象，防止模板被修改
		$.extend(true,field, fieldTemp);
		if (outputParamsMapping && outputParamsMapping[field.fieldIdForm]) {
			field.uuId = outputParamsMapping[field.fieldIdForm].uuId;
			field.fieldName = outputParamsMapping[field.fieldIdForm].fieldName;
		}

		html += _CreateOutParams(field) + "<br/>";
	}
	html+="</div>";
	return Designer_AttrPanel.wrapTitle(name, attr, value, html);
}
function _Designer_Control_RelationSelect_DrawXML() {

	var values = this.options.values;

	buf=[];
	
	buf.push( '<extendSimpleProperty ');
	buf.push('name="', values.id, '" ');
	buf.push('label="', values.label, '" ');
	buf.push('type="', values.dataType ? values.dataType : 'String', '" ');
	if (values.formula != '' && values.formula != null) {
		buf.push('formula="true" ');
		buf.push('defaultValue="', values.formula, '" ');
		if (values.reCalculate == 'true') {
			buf.push('recalculateOnSave="true" ');
		}
	} else if (values.defaultValue != '' && values.defaultValue != null) {
		buf.push('defaultValue="', values.defaultValue, '" ');
	}
	
	buf.push('/>');
	
	
	buf.push( '<extendSimpleProperty ');
	buf.push('name="', values.id+"_text", '" ');
	buf.push('label="', values.label, '" ');
	buf.push('type="', values.dataType ? values.dataType : 'String', '" ');
	if (values.formula != '' && values.formula != null) {
		buf.push('formula="true" ');
		buf.push('defaultValue="', values.formula, '" ');
		if (values.reCalculate == 'true') {
			buf.push('recalculateOnSave="true" ');
		}
	} else if (values.defaultValue != '' && values.defaultValue != null) {
		buf.push('defaultValue="', values.defaultValue, '" ');
	}
	buf.push('/>');
	
	
	return buf.join('');

}
function RelatoinOpenExpressionEditor(obj, uuid, action) {

	var idField, nameField;
	idField = document.getElementById(uuid + "_formId");
	nameField = document.getElementById(uuid + "_formName");
	_requiredValue=document.getElementById(uuid + "_required").value;
	
	RelatoinFormFieldChoose(idField,nameField, function(rtn){
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
			control.options.values.inputParams = JSON.stringify(
					inputParamsJSON).replace(/"/g,"quot;");
		}
		
		
	});
};