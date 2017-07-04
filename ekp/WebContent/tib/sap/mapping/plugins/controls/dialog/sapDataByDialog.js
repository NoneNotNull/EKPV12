/**
 * 弹出框列表，调用sap数据
 * 
 * @author 邱建华 date:2013-3-4
 * @version 1.0
 * 
 */
var SapControls_Lang = {};
jQuery.ajax({
	type: "GET",
	url :Com_Parameter.ContextPath +"tib/sap/mapping/plugins/controls/common/sapControls_lang.jsp",
	dataType: "script",
	// 设置同步,待加载完成以后才往下执行
	async:false
});

Designer_Config.controls['sapDataByDialog'] = {
		type : "sapDataByDialog",
		storeType : 'field',
		inherit : 'base',
		onDraw : _Designer_Control_SapDataByDialog_OnDraw, //绘制函数
		drawXML : _Designer_Control_SapDataByDialog_DrawXML, //生成数据字典
		implementDetailsTable : true, // 是否支持明细表
		attrs : { // 这个是对话框属性配置
			label : Designer_Config.attrs.label, // 内置显示文字属性
			required: {
				text: Designer_Lang.controlAttrRequired,// 这种都能直接使用 "文字" 来替代
				value: "true",
				type: 'checkbox',
				checked: false,
				show: true
				
			},	
			width : {
				text: Designer_Lang.controlAttrWidth,
				value: "",
				type: 'text',
				show: true,
				validator: Designer_Control_Attr_Width_Validator,
				checkout: Designer_Control_Attr_Width_Checkout
			},
			multiSelect : {
				text: Designer_Lang.controlAddressAttrMultiSelect,
				value: "true",
				type: 'checkbox',
				checked: false,
				show: true
				
			},
			isLoadData : {//是否默认加载列表数据
				text: SapControls_Lang.isLoadData,
				value: "true",
				type: 'checkbox',
				checked: true,
				show: true
			},
			businessType : {
				text: Designer_Lang.controlAddressAttrBusinessType,
				value: "sapDataByDialog",
				type: 'hidden',
				show: true
			},
			dialogDataSource : {
			    text: SapControls_Lang.dataSource,
			    value: "true",
			    type:"self",
			    required: true,
			    show: true,
			    draw: _Designer_Control_SapDataByDialog_DialogDataSource_Self_Draw,
			    checkout: Designer_SapDataByDialog_Control_Attr_Required_Checkout
			    
			},
			dialogShowValue : {
			    text: SapControls_Lang.selectShowValue,
			    value: "true",
			    type:"self",
			    required: true,
			    show: true,
			    draw: _Designer_Control_SapDataByDialog_DialogShowValue_Self_Draw,
			    checkout: Designer_DialogShowValue_Control_Attr_Required_Checkout,
			    convertor: Designer_Control_Attr_HtmlQuotEscapeConvertor
			},
			dialogActualValue : {
				text: SapControls_Lang.selectActualValue,
				value: "true",
				type:"self",
				required: true,
				show: true,
			    draw: _Designer_Control_SapDataByDialog_DialogActualValue_Self_Draw,
				checkout: Designer_DialogActualValue_Control_Attr_Required_Checkout,
			    convertor: Designer_Control_Attr_HtmlQuotEscapeConvertor
			},
			dialogShowDesc : {
				text: SapControls_Lang.selectShowDesc,
				value: "true",
				type:"self",
				required: true,
				show: true,
			    draw: _Designer_Control_SapDataByDialog_DialogShowDesc_Self_Draw,
				checkout: Designer_DialogShowDesc_Control_Attr_Required_Checkout,
			    convertor: Designer_Control_Attr_HtmlQuotEscapeConvertor
			},
			inputParam : {
				text: SapControls_Lang.inputParam,
				value: "true",
				type:"self",
				required: false,
				show: true,
				draw: _Designer_Control_SapDataByDialog_InputParam_Self_Draw
			},

			formula: Designer_Config.attrs.formula,
			reCalculate: Designer_Config.attrs.reCalculate
		},
		onAttrLoad : _Designer_Control_Attr_SapDataByDialog_OnAttrLoad,
		info : {
			name: SapControls_Lang.sapDataByDialog
		},
		resizeMode : 'all'
};

Designer_Config.operations['sapDataByDialog'] = {
		imgIndex : 18,
		title : SapControls_Lang.sapDataByDialog,
		run : function (designer) {
			designer.toolBar.selectButton('sapDataByDialog');
		},
		type : 'cmd',
		shortcut : 'T',
		sampleImg : 'style/img/input.bmp',
		select: true,
		cursorImg: 'style/cursor/inputText.cur'
};
//把dialog选择控件增加到控件区
Designer_Config.buttons.control.push("sapDataByDialog");
//把dialog选择控件增加到右击菜单区
Designer_Menus.add.menu['sapDataByDialog'] = Designer_Config.operations['sapDataByDialog'];

/**
 * 初始化加载
 * @param form
 * @param control
 */ 
function _Designer_Control_Attr_SapDataByDialog_OnAttrLoad(form,control){	
	_DialogGetTemplateXmlAndSetJson(form._inputParamJson);
	
};

// 获取XML模版
function _DialogGetTemplateXmlAndSetJson(formTableJson) {
	var rfcId = document.getElementById("fdRfcSettingId").value;
	if (rfcId == "") {
		return;
	}
	var data = new KMSSData();
	data.SendToBean("tibSapMappingXmlTemplateBean&rfcId="+ rfcId +"&type=func", 
			function(rtnData){_Dialog_Edit_Control_CallXml(rtnData, formTableJson);});
}

// 编辑时初始化
function _Dialog_Edit_Control_CallXml(rtnData, formTableJson) {
	SapDataDialog_FuncXml = rtnData.GetHashMapArray()[0]["funcXml"];
	if(formTableJson != "undefined" && formTableJson != null && formTableJson !=""){
//		alert("=="+formTableJson.value);
		if (formTableJson.value != "") {
			var inputParamsJson = eval('(' + formTableJson.value + ')');
			if(inputParamsJson.TABLE_DocList != null) {
				_Dialog_Edit_Control_AppendRow(inputParamsJson.TABLE_DocList);
			}
		}
	}
}

function _Dialog_Edit_Control_AppendRow(tableJson) {
	// 删除明细表行
	SapDataByDialog_DeleteTableByMxId("TABLE_DocList");
	for (var i = 0, lenI = tableJson.length; i < lenI; i++) {
		DocList_AddRow("TABLE_DocList");
		var rowJson = tableJson[i];
		// 是否必填
		var inputParamRequiredObj = document.getElementById("_inputParamRequired"+ i);
		if (rowJson.inputParamRequired == "true") {
			inputParamRequiredObj.checked = true;
		} else {
			inputParamRequiredObj.checked = false;
		}
		// 下拉选择框SAP
		var xmlObj = XML_CreateByContent(SapDataDialog_FuncXml);
		var importFields = XML_GetNodesByPath(xmlObj, "/jco/import/field");
		var selectObj = document.getElementById("_inputParamSelect"+ i);
		for (var j = 0, lenJ = importFields.length; j < lenJ; j++) {
			 var fieldObj = importFields[j];
			 var title = fieldObj.getAttribute("title");
			 selectObj.length = lenJ;
			 selectObj.options[j].value = title;
			 selectObj.options[j].text = title;
			 if (rowJson.inputParamSelect == title) {
				 selectObj.options.selectedIndex = j;
			 }
		}
		// 输入值
		document.getElementById("_inputParamId"+ i).value = rowJson.inputParamId;
		document.getElementById("_inputParamText"+ i).value = rowJson.inputParamText;
		document.getElementById("_inputParamBandId"+ i).value = rowJson.inputParamText;
	}
	
}

function SapDataByDialog_DeleteTableByMxId(mxId) {
	var table = document.getElementById(mxId);
	var rowLenth = table.rows.length;
	var tbInfo = DocList_TableInfo[mxId];
	for (var i = rowLenth - 1; i > 0; i--) {
		table.deleteRow(i);
		tbInfo.lastIndex--;
		for (var j = i; j < tbInfo.lastIndex; j++)
			DocListFunc_RefreshIndex(tbInfo, j);
	}
}

/**
 * 绘制函数
 * @param parentNode
 * @param childNode
 */ 
function _Designer_Control_SapDataByDialog_OnDraw(parentNode, childNode){
	
	// 必须要做ID设置
	if(this.options.values.id == null)
		this.options.values.id = "fd_" + Designer.generateID();	
	var domElement = _CreateDesignElement('label', this, parentNode, childNode);
	if (this.options.values.width && this.options.values.width.toString().indexOf('%') > -1) {
		domElement.style.whiteSpace = 'nowrap';
		domElement.style.width = this.options.values.width;
		domElement.style.overflow = 'visible';
	}
	var htmlCode = _Designer_Control_SapDataByDialog_DrawByType(this.parent, this.attrs, this.options.values, this);
	domElement.innerHTML = htmlCode;
};

/**
 * 生成数据字典
 */
function _Designer_Control_SapDataByDialog_DrawXML() {	
	var values = this.options.values;
	var buf = ['<extendSimpleProperty '];//mutiValueSplit	
	buf.push('name="', values.id, '" ');
	buf.push('label="', values.label, '" ');
	buf.push('type="String" ');
	if (values.required == "true") {
		buf.push('notNull="true" ');
	}
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
	
	buf.push('<extendSimpleProperty ');
	buf.push('name="', values.id+'_name', '" ');
	buf.push('label="', values.label, '" ');
	buf.push('type="String" ');
	if (values.required == "true") {
		buf.push('notNull="true" ');
	}
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
};


/*
根据ID获取table保存table对象
*/
function DialogGetInputParameterJsonByTable(id) {
	var rtnJson = new Array();
	var table = document.getElementById(id);
	//debugger;
	if(table == null || typeof table == "undefined" || table.rows.length == 1){
		return "";
	}
	for (var i = 1, length = table.rows.length; i < length; i++) {
		rtnJson.push(DialogGetInputParamterJsonByRow(id, table.rows[i]));
	}
	//return "\"" + id + "\":[" + rtnJson.join(",") + "]";
	return "'" + id + "':[" + rtnJson.join(",") + "]";
};

/*
根据table的id 保存每行的数据
*/
function DialogGetInputParamterJsonByRow(id, trElement) {
	var rtnJson = new Array();
	//debugger;
	rtnJson.push("{");
	// 是否必填
	var isRequired = DialogGetElementsByParent(trElement.cells[0], "input")[0].checked ? "true" : "false";
	rtnJson.push("'inputParamRequired':'" + isRequired + "'");
	// SAP
	var selectObjs = DialogGetElementsByParent(trElement.cells[1], "select");
	if (selectObjs.length == 0) {
		return "";
	}
	rtnJson.push(",'inputParamSelect':'" + selectObjs[0].value + "'");
	// 读取表单字段
	var inputArr = DialogGetElementsByParent(trElement.cells[2], "input");
	rtnJson.push(",'inputParamText':'" + inputArr[0].value + "'");
	rtnJson.push(",'inputParamId':'" + inputArr[1].value + "'");
	// 结束
	rtnJson.push("}");	
	return rtnJson.join('');
};

function DialogGetElementsByParent(oParent, tagName) {
	var rtnResult = new Array(), child;
//	var childNodes = oParent.childNodes;
	if (oParent != null && oParent.childNodes != null && oParent.childNodes != undefined) {
		for (var i = 0, length = oParent.childNodes.length; i < length; i++) {
			child = oParent.childNodes[i];
			if (child.tagName && child.tagName.toLowerCase() == tagName)
				rtnResult.push(child);
		}
	}
	return rtnResult;
};

/**
 * 控件  类型HTML生成基础函数
 * @param parent
 * @param attrs
 * @param values
 * @param control
 * @returns {String}
 */ 
function _Designer_Control_SapDataByDialog_DrawByType(parent, attrs, values, control) {
	var htmlCode = '<input id="'+values.id+'" class="' + (values.canShow=='false'?'inputhidden':'inputsgl');
	if (values.canShow == 'false') {
		htmlCode += '" canShow="false"';
	}else {
		htmlCode += '" canShow="true"';
	}
	if (values.readOnly == 'true') {
		htmlCode += '" _readOnly="true"';
	}else {
		htmlCode += '" _readOnly="false"';
	}
	// 数据来源
	if(values._dialogDataSource !=null ||  values._dialogDataSource!=''){
      	htmlCode += " _dialogDataSource='"+values._dialogDataSource+"' ";
	} 
	// 函数ID
	if(values.fdRfcSettingId !=null ||  values.fdRfcSettingId!=''){
		htmlCode += " fdRfcSettingId='"+values.fdRfcSettingId+"' ";
	} 
	// 弹出框显示值
	if (values.dialogShowValue != null || values.dialogShowValue != '') {
		htmlCode += " dialogShowValue='"+ values.dialogShowValue +"'";
	}
	
	// 弹出框描述值
	if (values.dialogShowDesc != null || values.dialogShowDesc != '') {
		htmlCode += " dialogShowDesc='"+ values.dialogShowDesc +"'";
	}

	// 弹出框实际值
	if (values.dialogActualValue != null || values.dialogActualValue != '') {
		htmlCode += " dialogActualValue='"+ values.dialogActualValue +"'";
	}
	
	// 输入参数
	if(values._inputParamJson!=null || values._inputParamJson!=''){		
		var rtnJson = new Array();			
		rtnJson.push("{");
		// 输入参数
		rtnJson.push(DialogGetInputParameterJsonByTable("TABLE_DocList"));
		// 结束
		rtnJson.push("}");
		values._inputParamJson = rtnJson.join('');		
		htmlCode += " inputParams=\""+values._inputParamJson+"\" ";
	}
	
	if(values.width==null || values.width==''){
		values.width = "120";
	}
	if (values.width.toString().indexOf('%') > -1) {
		htmlCode += ' style="width:100%"';
	} else {
		htmlCode += ' style="width:'+values.width+'px"';
	}
	if (values.required == "true") {
		htmlCode += ' required="true"';
		htmlCode += ' _required="true"';
	} else {
		htmlCode += ' required="false"';
		htmlCode += ' _required="false"';
	}
	if (parent != null) {
		htmlCode += ' tableName="' + _Get_Designer_Control_TableName(parent) + '"';
	}
	if (values.description != null) {
		htmlCode += ' description="' + values.description + '"';
	}
	htmlCode += ' label="' + _Get_Designer_Control_Label(values, control) + '"';
	if (values.validate != null && values.validate != 'false') {
		htmlCode += ' dataType="' + values.validate + '"';
		if (values.validate == 'string') {
			htmlCode += ' maxlength="' + values.maxlength + '"';
			htmlCode += ' validate="{dataType:\'string\'';
			if ( values.maxlength != null &&  values.maxlength != '') {
				htmlCode += ',maxlength:' + values.maxlength;
			}
			htmlCode += '}"';
		} else if (values.validate == 'number') {
			htmlCode += ' scale="' + values.decimal + '"'; // 小数位
			htmlCode += ' beginNum="' +  values.begin + '"';
			htmlCode += ' endNum="' +  values.end + '"';
			htmlCode += ' validate="{dataType:\'number\',decimal:' + values.decimal; // 小数位
			if (values.begin != null && values.begin != '')
				htmlCode += ',begin:' + values.begin;
			if (values.end != null && values.end != '')
				htmlCode += ',end:' + values.end;
			htmlCode += '}"';
		} else if (values.validate == 'email') {
			htmlCode += ' validate="{dataType:\'email\'}"';
		}
	}
	if (values.defaultValue != null && values.defaultValue != '') {
		htmlCode += ' defaultValue="' + values.defaultValue + '"';
		if (!attrs.businessType) {
			htmlCode += ' value="' + values.defaultValue + '"';
		}
	}
	if (attrs.businessType) {
		htmlCode += ' businessType="' + (values.businessType == null ? attrs.businessType.value : values.businessType) + '"';
		if ((values.businessType == 'dateDialog' ||  values.businessType == 'timeDialog' ||  values.businessType == 'datetimeDialog')) {
			if (values.defaultValue == 'select') {
				htmlCode += ' selectedValue="' + values._selectValue + '"';
				htmlCode += ' value="' + values._selectValue + '"';
			} else if (values.defaultValue == 'nowTime') {
				htmlCode += ' value="' + attrs.defaultValue.opts[1].text + '"';
			}
		} else if (values.businessType == "addressDialog") {
			if (values.defaultValue == 'select') {
				htmlCode += ' selectedValue="' + values._selectValue + '"';
				htmlCode += ' selectedName="' + values._selectName + '"';
				htmlCode += ' value="' + values._selectName + '"';
			} else if (values.defaultValue != 'null') {
				for (var jj = 0, l = attrs.defaultValue.opts.length; jj < l; jj ++) {
					if (attrs.defaultValue.opts[jj].value == values.defaultValue) {
						htmlCode += ' value="' + attrs.defaultValue.opts[jj].text + '"';
						break;
					}
				}
			}
		}
	}
	if (attrs.multiSelect) {
		htmlCode += ' multiSelect="' + (values.multiSelect == 'true' ? 'true' : 'false') + '"';
	}
	if (attrs.isLoadData) {
		htmlCode += ' isLoadData="' + (values.isLoadData == 'true' ? 'true' : 'false') + '"';
	}
	
	if (attrs.history) {
		htmlCode += ' history="' + (values.history == "true" ? 'true' : 'false') + '"';
	}
	htmlCode += ' readOnly >';
	
	if(values.required == 'true') {
		htmlCode += '<span class=txtstrong>*</span>';
	}
	
	if (attrs.businessType && values.readOnly != 'true') {
		htmlCode += '<label>&nbsp;<a>'+ SapControls_Lang.choose +'</a></label>';
	}	
	return htmlCode;
};

/**
 * 判断列表不能为空
 * @param msg
 * @param name
 * @param attr
 * @param value
 * @param values
 * @param control
 * @returns {Boolean}
 */ 
function Designer_SapDataByDialog_Control_Attr_Required_Checkout(msg, name, attr, value, values, control) {
	if (values._dialogDataSource ==null || values._dialogDataSource == "" || values._dialogDataSource == "") {
		msg.push(SapControls_Lang.mappingTip, SapControls_Lang.mustSelect);
		return false;
	}
	return true;
}

function Designer_DialogShowValue_Control_Attr_Required_Checkout(msg, name, attr, value, values, control) {
	if (values.dialogShowValue ==null || values.dialogShowValue == "") {
		msg.push(SapControls_Lang.showTip, SapControls_Lang.mustSelect);
		return false;
	}
	return true;
}
function Designer_DialogShowDesc_Control_Attr_Required_Checkout(msg, name, attr, value, values, control) {
	if (values.dialogShowDesc ==null || values.dialogShowDesc == "") {
		msg.push(SapControls_Lang.descTip, SapControls_Lang.mustSelect);
		return false;
	}
	return true;
}
function Designer_DialogActualValue_Control_Attr_Required_Checkout(msg, name, attr, value, values, control) {
	if (values.dialogActualValue ==null || values.dialogActualValue == "") {
		msg.push(SapControls_Lang.actualTip, SapControls_Lang.mustSelect);
		return false;
	}
	return true;
}


// 数据来源   自绘函数
function _Designer_Control_SapDataByDialog_DialogDataSource_Self_Draw(name, attr, value, form, attrs, values) {
	// 实际数据来源名称
	var html = "<input type='text' name='_dialogDataSource'  class='inputsgl'  id='_dialogDataSource' readonly  style='width: 86%'";	
	html += " value=\"" + (values._dialogDataSource != "undefined" && values._dialogDataSource != null ? values._dialogDataSource : "") + "\">";	
	// 隐藏ID
	html += "<input type='hidden' class='inputsgl'  id='fdRfcSettingId'  name='fdRfcSettingId'";	
	html += " value=\"" + (values.fdRfcSettingId != "undefined" && values.fdRfcSettingId != null ? values.fdRfcSettingId : "") + "\">";	
	html += "<img src='"+ Com_Parameter.StylePath +"icons/edit.gif' alt='"+ SapControls_Lang.chooseFunc 
			+"' onclick='DoDialog_TreeList_DialogDataSource()' style='cursor: hand'>";
	return Designer_AttrPanel.wrapTitle(name, attr, value, html);
};

function DoDialog_TreeList_DialogDataSource(){
	var rfcId = document.getElementById("fdRfcSettingId").value;
	// 显示确定按钮
	Designer_AttrPanel.showButtons(document.getElementById("_dialogDataSource"));
	Dialog_TreeList(false, 'fdRfcSettingId', '_dialogDataSource', ';', 
			'tibSapMappingFuncTreeListService&selectId=!{value}&type=cate',
			SapControls_Lang.funcType,
			'tibSapMappingFuncTreeListService&selectId=!{value}&type=func',
			Call_DialogDataSource,
			'tibSapMappingFuncTreeListService&type=search&keyword=!{keyword}',
			null,null,null,
			SapControls_Lang.chooseFunc
	);
}

function Call_DialogDataSource(rtnData) {
	if (rtnData == undefined || rtnData == "") {
		return;
	}
	// 重新选择数据来源后，要把全局的XML模版定义为Null
	SapDataDialog_FuncXml = null;
	var rfcId = rtnData.GetHashMapArray()[0]["id"];
	var data = new KMSSData();
	data.SendToBean("tibSapMappingXmlTemplateBean&rfcId="+ rfcId, Call_SapDataDialog_FuncXml);
}

// 全局存放的XML模版赋值
var SapDataDialog_FuncXml;
function Call_SapDataDialog_FuncXml(rtnData) {
	SapDataDialog_FuncXml = rtnData.GetHashMapArray()[0]["funcXml"];
}

// 显示值   自绘函数
function _Designer_Control_SapDataByDialog_DialogShowValue_Self_Draw(name, attr, value, form, attrs, values) {
	//alert("values.dialogShowValue="+values.dialogShowValue);
	var html = "<input type='text' name='dialogShowValue'  class='inputsgl'  id='dialogShowValue'  style='width: 86%'";	
	html += " value='" + (values.dialogShowValue != "undefined" && values.dialogShowValue != null ? values.dialogShowValue : "") + "'>";	
	html += "<img src='"+ Com_Parameter.StylePath +"icons/edit.gif' alt='"+ SapControls_Lang.chooseField 
			+"' onclick=\"DoDialog_TreeList_Common('dialogShowValue', 'dialogShowValue')\" style='cursor: hand'>";
	return Designer_AttrPanel.wrapTitle(name, attr, value, html);
};


//实际值   自绘函数
function _Designer_Control_SapDataByDialog_DialogActualValue_Self_Draw(name, attr, value, form, attrs, values) {
	var html = "<input type='text' name='dialogActualValue'  class='inputsgl'  id='dialogActualValue' readonly  style='width: 86%'";	
	html += " value='" + (values.dialogActualValue != "undefined" && values.dialogActualValue != null ? values.dialogActualValue : "") + "' />";	
	html += "<img src='"+ Com_Parameter.StylePath +"icons/edit.gif' alt='"+ SapControls_Lang.chooseField 
	+"' onclick=\"DoDialog_TreeList_Common('dialogActualValue', 'dialogActualValue')\" style='cursor: hand'>";
	return Designer_AttrPanel.wrapTitle(name, attr, value, html);
};

//描述值   自绘函数
function _Designer_Control_SapDataByDialog_DialogShowDesc_Self_Draw(name, attr, value, form, attrs, values) {
	var html = "<input type='text' name='dialogShowDesc'  class='inputsgl'  id='dialogShowDesc' readonly  style='width: 86%'";	
	html += " value='" + (values.dialogShowDesc != "undefined" && values.dialogShowDesc != null ? values.dialogShowDesc : "") + "' />";	
	html += "<img src='"+ Com_Parameter.StylePath +"icons/edit.gif' alt='"+ SapControls_Lang.chooseField 
		+"' onclick=\"DoDialog_TreeList_Common('dialogShowDesc', 'dialogShowDesc')\" style='cursor: hand'>";
	return Designer_AttrPanel.wrapTitle(name, attr, value, html);
};

/**
 * 公式定义器弹出框
 * @param {} events {data:{bindId:绑定的id,bindName：绑定的名字,varInfo:公式定义弹出框树的值}}
 */
function DoDialog_TreeList_Common(bindId, bindName) {
	// 如果xml为null,则弹出正在加载XML模版或者未加载
	if (!Checked_DialogDataSource()) {
		return;
	}
	// 显示确定按钮
	Designer_AttrPanel.showButtons(document.getElementById("dialogShowValue"));
	// XML字符串转为XML对象
	var funcXmlObj = XML_CreateByContent(SapDataDialog_FuncXml);
	var xpath = "/jco/export/structure/field|/jco/tables/table[@isin='0']/records/field";
	var fieldInfo = _DialogGetFieldValues(funcXmlObj, xpath);
	var varInfo = _DialogParseVarInfo(fieldInfo, "name", "val");
	var dialog = new KMSSDialog();
	dialog.formulaParameter = {
		varInfo : varInfo,
		returnType : "Object"
	};
	dialog.BindingField(bindId, bindName);
	dialog.URL = Com_Parameter.ContextPath
			+ "tib/sap/mapping/plugins/controls/common/sapMappingControls_dialog.jsp";
	dialog.Show(800, 550);
}

/**
 * 找出当前节点下的所有field标签的node,并且返回对应的name 跟title属性数组
 * @param {} node
 * @return {} [{name:node的name值-node的title值  val:node的name值 }]
 */
function _DialogGetFieldValues(node, xpath) {
	var fields = XML_GetNodesByPath(node, xpath);
	var options = [];
	for (var i = 0, len = fields.length; i < len; i++) {
		var val = {};
		// node, parentXpath, index,defAttrs 得出的xpath是不准确的,只要数据
		var nodeJs = _DialogParseNode4Json(fields[i], "", i, null);
		val.name = nodeJs["attr"]["title"] + "-(" + nodeJs["attr"]["name"]
				+ ")";
		val.val = nodeJs["attr"]["title"];
		options.push(val);
	}
	return options;
}

// 解析为Json
function _DialogParseNode4Json (node, parentXpath, index, defAttrs) {
	var nodeInfo = {};
	if (!node)
		return null;

	nodeInfo.nodeName = node.nodeName;
	nodeInfo.nodeValue = node.text;// 取得文本值;
	nodeInfo.nodeType = node.nodeType;
	nodeInfo.xpath = _DialogAddXpath(parentXpath, node.nodeName, index);
	if (node.attributes.length > 0) {
		nodeInfo["attr"] = defAttrs || {};
		for (var j = 0; j < node.attributes.length; j++) {
			var attribute = node.attributes.item(j);
			nodeInfo["attr"][attribute.nodeName] = attribute.nodeValue;
		}
	}
	return nodeInfo;
}

function _DialogAddXpath(xpath, nodeName, index) {
	if (index || index == 0) {
		xpath = [xpath, "/", nodeName, "[", index, "]"].join("")
	} else {
		xpath = [xpath, "/", nodeName].join("");
	}
	return xpath;
}
 
/**
 * 适应公式定义器校验 {name:val:} -->{name: label ：text：}
 * @param {}    varInfo
 */
function _DialogParseVarInfo(varInfo, text, value) {
	var parseRtn = [];
	if (varInfo) {
		for ( var i = 0, len = varInfo.length; i < len; i++) {
			parseRtn.push( {
				name : varInfo[i][value],
				label : varInfo[i][value],
				text : varInfo[i][text]
			});
		}
	}
	return parseRtn;
}
 
 /**
  * 适应公式定义器校验 {name:val:} -->{name: label ：text：}
  * @param {}    varInfo
  */
 function _DialogParseVarInputParamInfo(varInfo) {
 	var parseRtn = [];
 	if (varInfo) {
 		for ( var i = 0, len = varInfo.length; i < len; i++) {
 			parseRtn.push( {
 				tibEkpId : varInfo[i]["name"],
 				name : varInfo[i]["label"],
 				label : varInfo[i]["label"],
 				text : varInfo[i]["label"],
 				type : "String"
 			});
 		}
 	}
 	return parseRtn;
 }

/**
 * 判断是否选择数据来源，或者是否还在加载
 * @param rfcId
 * @return
 */
function Checked_DialogDataSource() {
	var rfcId = document.getElementById("fdRfcSettingId").value;
	if (rfcId == "") {
		alert(SapControls_Lang.pleaseChooseDataSource);
		return false;
	}
	if (SapDataDialog_FuncXml == null) {
		alert(SapControls_Lang.loadingXmlTemplate);
		return false;
	}
	return true;
}
 
/**
 * 传入参数  自绘函数
 */
function _Designer_Control_SapDataByDialog_InputParam_Self_Draw(name, attr, value, form, attrs, values) {
 	var html = "<table id='TABLE_DocList' class='tb_normal' width='99%'>";
 	html += "<tr><td class='td_normal_title' width='10%' align='center'>必填</td>";
 	html += "<td class='td_normal_title' width='37%' align='center'>SAP</td>";
 	html += "<td class='td_normal_title' width='53%'>";
 	html += "<span style='position:absolute; margin-top:-16px;'>&nbsp;&nbsp;传入值&nbsp;&nbsp;";
 	html += "<img src='"+ Com_Parameter.StylePath +"icons/add.gif' alt='"+ SapControls_Lang.add +"' "+
					"onclick='_DialogAddInputParam();' style='cursor: hand'></span>";
 	html += "</td></tr>";
 	// 基准行
 	html += "<tr KMSS_IsReferRow='1' style='display:none'>";
 	html += "<td><input type='checkbox' checked name='_inputParamRequired' id='_inputParamRequired!{index}'" +
 			"value='1' ></td>";
 	html += "<td><select name='_inputParamSelect' id='_inputParamSelect!{index}' style='width=50px'><option value=''>"+ SapControls_Lang.select +"</option></select>";
 	html += "</td><td><input type='text' name='_inputParamText' readonly class='inputsgl'  id='_inputParamText!{index}' style='width: 45px;'";
 	html += " value=''/>";
 	html += "<input type='hidden' name='_inputParamId' id='_inputParamId!{index}' value=''>";
 	html += "<input type='hidden' name='_inputParamBandId' id='_inputParamBandId!{index}' value=''>";
 	html += "<img src='"+ Com_Parameter.StylePath +"icons/edit.gif' alt='edit' ";
 	html += "onclick=\"DoDialog_TreeList_InputParam('_inputParamBandId!{index}', '_inputParamText!{index}', '!{index}', '_inputParamId!{index}')\" style='cursor: hand'>";
 	html += "<img src='"+ Com_Parameter.StylePath +"icons/delete.gif' alt='del'";
 	html += "onclick=\"Designer_AttrPanel.showButtons(document.getElementById('_inputParamBandId!{index}'));Dialog_DocList_DeleteRow();\" style='cursor: hand'>";
 	html += "</td></tr>";
 	html += "</table>";
 	html += "<input type='hidden' name='_inputParamJson' id='_inputParamJson' " +
 			"value=\"" + (values._inputParamJson != "undefined" && values._inputParamJson != null ? values._inputParamJson : "") + "\" />";
 	return Designer_AttrPanel.wrapTitle(name, attr, value, html);
};
 
 // 添加一行映射输入参数
function _DialogAddInputParam() {
	 if (!Checked_DialogDataSource()) {
		 return;
	 }
	 DocList_AddRow();
	 var rows = document.getElementById("TABLE_DocList").rows;
	 var index = rows.length - 2;
	 var xmlObj = XML_CreateByContent(SapDataDialog_FuncXml);
	 var importFields = XML_GetNodesByPath(xmlObj, "/jco/import/field");
	 for (var i = 0, len = importFields.length; i < len; i++) {
		 var fieldObj = importFields[i];
		 var title = fieldObj.getAttribute("title");
		 document.getElementById("_inputParamSelect"+ index).length = len;
		 document.getElementById("_inputParamSelect"+ index).options[i].value = title;
		 document.getElementById("_inputParamSelect"+ index).options[i].text = title;
	 }
	
 }
 
function DoDialog_TreeList_InputParam(bindId, bindName, index, ekpId) {
	// 把是否必填的值带过去
	var imputParamTextObj = document.getElementById("_inputParamRequired"+ index);
	var isRequired = "0";
	if (imputParamTextObj.checked) {
		isRequired = "1";
	}
	// 如果xml为null,则弹出正在加载XML模版或者未加载
	if (!Checked_DialogDataSource()) {
		return;
	}
	// 显示确定按钮
	Designer_AttrPanel.showButtons(document.getElementById(bindId));
	// 获取varInfo，调用公式定义器
	var obj = Designer.instance.getObj(true);
	var varInfo = _DialogParseVarInputParamInfo(Designer.instance.getObj(true));
	var dialog = new KMSSDialog();
	dialog.SetAfterShow(function(rtnData){Call_InputParamDialog(rtnData, index);});
	dialog.formulaParameter = {
		varInfo : varInfo,
		returnType : "Object",
		tibEkpId : document.getElementById(ekpId).value
	};
	dialog.BindingField(bindId, bindName);
	dialog.URL = Com_Parameter.ContextPath
			+ "tib/sap/mapping/plugins/controls/common/sapMappingControlsCustom_dialog.jsp?isRequired="
			+ isRequired;
	dialog.Show(800, 550);
}

// 特殊公式定义器后回调
function Call_InputParamDialog(rtnData, index) {
	if (rtnData != "" && rtnData != null) {
		var id = rtnData.GetHashMapArray()[0]["id"];
		if (id == null || id == "") {
			return;
		}
		var inputParams = id.split("|");
		var idField = inputParams[0];
		if (idField != "") {
			document.getElementById("_inputParamId"+ index).value = idField;
		}
		document.getElementById("_inputParamBandId"+ index).value = inputParams[1];
		document.getElementById("_inputParamText"+ index).value = inputParams[1];
		var inputParamRequiredObj = document.getElementById("_inputParamRequired"+ index);
		var isRequired = inputParams[2];
		if (isRequired == "1") {
			inputParamRequiredObj.checked = true;
			inputParamRequiredObj.value = 1;
		} else {
			inputParamRequiredObj.checked = false;
			inputParamRequiredObj.value = 0;
		}
	}
	
}

/***********************************************
功能：删除行
参数：
	optTR：
		可选，操作行对象，默认取当前操作的当前行
***********************************************/
function Dialog_DocList_DeleteRow(optTR){
	if(optTR==null)
		optTR = DocListFunc_GetParentByTagName("TR");
	var optTB = DocListFunc_GetParentByTagName("TABLE", optTR);
	var tbInfo = DocList_TableInfo[optTB.id];
	var rowIndex = Com_ArrayGetIndex(optTB.rows, optTR);
	optTB.deleteRow(rowIndex);
	
	
	tbInfo.lastIndex--;
	for(var i = rowIndex; i<tbInfo.lastIndex; i++)
		Dialog_DocListFunc_RefreshIndex(tbInfo, i);
}

function Dialog_DocListFunc_RefreshIndex(tbInfo, index){
	for (var n = 0; n < tbInfo.cells.length; n ++) {
		if (tbInfo.cells[n].isIndex) {
			tbInfo.DOMElement.rows[index].cells[n].innerHTML = index;
		}
	}
	Dialog_DocListFunc_RefreshFieldIndex(tbInfo, index, "INPUT");
	Dialog_DocListFunc_RefreshFieldIndex(tbInfo, index, "SELECT");
	Dialog_DocListFunc_RefreshFieldIndex(tbInfo, index, "IMG");
}

function Dialog_DocListFunc_RefreshFieldIndex(tbInfo, index, tagName){
	var optTR = tbInfo.DOMElement.rows[index];
	var fields = optTR.getElementsByTagName(tagName);
	for(var i=0; i<fields.length; i++){
		var fieldId = fields[i].id.replace(/\d+/g, "!{index}");
		fieldId = fieldId.replace(/!\{index\}/g, index - 1);
		if(Com_Parameter.IE) {
			fields[i].outerHTML = fields[i].outerHTML.replace("id=" + fields[i].id, "id="+fieldId);
		} else {
			fields[i].id = fieldId;
		}
		var clickNodeValue = fields[i].attributes["onclick"].nodeValue;
		if (clickNodeValue != null) {
			var clickStrValue = clickNodeValue.replace(/\d+/g, "!{index}");
			clickStrValue = clickStrValue.replace(/!\{index\}/g, index - 1);
			fields[i].outerHTML = fields[i].outerHTML.replace("onclick=\"" + clickNodeValue, "onclick=\""+ clickStrValue);
		}
	}
}
