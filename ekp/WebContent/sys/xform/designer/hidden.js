/**********************************************************
功能：完全隐藏控件
使用：
	
作者：傅游翔
创建时间：2009-11-12
**********************************************************/

Designer_Config.controls['hidden'] = {
	type : "hidden",
	storeType : 'field',
	inherit    : 'base',
	onDraw : _Designer_Control_Hidden_OnDraw,
	drawXML : _Designer_Control_Hidden_DrawXML,
	implementDetailsTable : true,
	info : {
		name: Designer_Lang.controlHiddenInfoName
	},
	resizeMode : 'no',
	attrs : {
		label : Designer_Config.attrs.label,
		dataType : {
			text: Designer_Lang.controlAttrDataType,
			value: "String",
			opts: [{text:Designer_Lang.controlAttrDataTypeText,value:"String"},
				{text:Designer_Lang.controlAttrDataTypeNumber,value:"Double"},
				{text:Designer_Lang.controlAttrDataTypeBigNumber,value:"BigDecimal"},
				{text:Designer_Lang.controlDatetimeAttrBusinessTypeDatetime,value:"DateTime"}],
			show: true,
			type: 'select'
		},
		defaultValue: Designer_Config.attrs.defaultValue,
		formula: Designer_Config.attrs.formula,
		reCalculate: Designer_Config.attrs.reCalculate
	}
};

function _Designer_Control_Hidden_OnDraw(parentNode, childNode) {
	var domElement = _CreateDesignElement('div', this, parentNode, childNode);
	if(this.options.values.id == null)
		this.options.values.id = "fd_" + Designer.generateID();
	domElement.id = this.options.values.id;
	var label = document.createElement("label");
	//label.appendChild(document.createTextNode(Designer_Lang.controlHiddenInfoName));
	label.title = Designer_Lang.controlHiddenInfoName;
	label.setAttribute("label", _Get_Designer_Control_Label(this.options.values, this));
	
	label.className = "button_img";
	label.style.backgroundPosition = "center " + (- 40 * 16) + "px";
	label.style.margin = '2px 3px 3px 2px';
	
	domElement.appendChild(label);
}

function _Designer_Control_Hidden_DrawXML() {
	var values = this.options.values;
	var buf = ['<extendSimpleProperty '];
	buf.push('name="', values.id, '" ');
	buf.push('label="', values.label, '" ');
	buf.push('type="', values.dataType ? values.dataType : "String", '" ');
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

Designer_Config.operations['hidden'] = {
	lab : "2",
	imgIndex : 40,
	title : Designer_Lang.buttonsHidden,
	run : function (designer) {
		designer.toolBar.selectButton('hidden');
	},
	type : 'cmd',
	shortcut : 'D',
	select: true,
	cursorImg: 'style/cursor/hidden.cur',
	isAdvanced: true,
	validate : function(designer) {
		return designer.toolBar.isShowAdvancedButton;
	}
};

Designer_Config.buttons.control.push("hidden");

Designer_Menus.add.menu['hidden'] = Designer_Config.operations['hidden'];