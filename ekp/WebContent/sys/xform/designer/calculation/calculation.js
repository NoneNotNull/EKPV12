/**********************************************************
功能：前端值计算控件
使用：
	
作者：傅游翔
创建时间：2010-04-27
**********************************************************/
Com_IncludeFile("dialog.js");//对话框依赖

Designer_Config.controls['calculation'] = {
		type : "calculation",
		storeType : 'field',
		inherit    : 'base',
		implementDetailsTable : true,
		onInitialize : null,
		onDraw : _Designer_Control_Calculation_OnDraw,
		onDrawEnd : _Designer_Control_Calculation_OnDrawEnd,
		drawXML : _Designer_Control_Calculation_DrawXML,
		resizeMode : 'onlyWidth',
		attrs : {
			label : Designer_Config.attrs.label,
			canShow : {
				text: Designer_Lang.controlAttrCanShow,
				value: "true",
				type: 'hidden',
				checked: true,
				show: true
			},
			readOnly : {
				text : Designer_Lang.controlAttrReadOnly,
				value : true,
				checked: true,
				type : 'checkbox',
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
			autoCalculate : {
				text : Designer_Lang.controlCalculation_attr_autoCalculate,
				value : true,
				checked: true,
				type : 'checkbox',
				show: true
			},
			expression : {
				text : Designer_Lang.controlCalculation_attr_expression,
				type : 'self',
				show: true,
				draw: Designer_Control_Calculation_Attr_Expression_Draw
			},
			expression_id : {
				show: false,
				convertor: Designer_Control_Attr_HtmlQuotEscapeConvertor
			},
			expression_name : {
				show: false,
				convertor: Designer_Control_Attr_HtmlQuotEscapeConvertor
			},
			dataType : {
				text: Designer_Lang.controlAttrDataType,
				value: "Double",
				opts: [{text:Designer_Lang.controlAttrDataTypeNumber,value:"Double"},
						{text:Designer_Lang.controlAttrDataTypeBigNumber,value:"BigDecimal"}],
				type: 'select',
				show: true
			},
			decimal: {
				text: Designer_Lang.controlInputTextAttrDecimal,
				type: 'text',
				value: '',
				show: true,
				validator: [Designer_Control_Attr_Int_Validator],
				checkout: Designer_Control_Attr_Int_Checkout
			},
			thousandShow : {
				text: Designer_Lang.controlAttrThousandShow,
				value: "false",
				type: 'checkbox',
				checked: false,
				show: true
			},
			defaultValue: Designer_Config.attrs.defaultValue,
			formula: Designer_Config.attrs.formula,
			reCalculate: Designer_Config.attrs.reCalculate
		},
		info : {
			name: Designer_Lang.controlCalculation_info_name
		}
};

function _Designer_Control_Calculation_OnDraw(parentNode, childNode){
	var domElement = _CreateDesignElement('div', this, parentNode, childNode);
	if(this.options.values.id == null)
		this.options.values.id = "fd_" + Designer.generateID();
	domElement.id = this.options.values.id;
	_Get_Designer_Control_Label(this.options.values, this);
	if (this.options.values.width == null) {
		this.options.values.width = '200';
	}
	if (this.options.values.width != null && this.options.values.width != '') {
		domElement.style.width = this.options.values.width;
	}
	var thousandShow=' thousandShow="false"';
	if (this.options.values.thousandShow == 'true') {
		thousandShow = ' thousandShow="true"';
	}
	
	var html = '<input type=text class=inputsgl title="'
		+Designer_Lang.controlCalculation_html_alt+'" style="width:'
		+(domElement.offsetWidth - 30)+'px"   '+thousandShow+'>';
	html += ' <a href="javascript:void(0);">'+Designer_Lang.controlCalculation_html_button+'</a>';
	domElement.innerHTML = html;
}

function _Designer_Control_Calculation_OnDrawEnd() {
	var domElement = this.options.domElement;
	var values = this.options.values;
	//values.dataType = 'Double';
	if (values.dataType == null) {
		values.dataType = 'Double';
	}
	_Designer_Control_Calculation_OnDrawEnd_SetValue(values, 'label', domElement);
	_Designer_Control_Calculation_OnDrawEnd_SetValue(values, 'canShow', domElement);
	_Designer_Control_Calculation_OnDrawEnd_SetValue(values, 'readOnly', domElement);
	_Designer_Control_Calculation_OnDrawEnd_SetValue(values, 'dataType', domElement);
	if (values['readOnly'] != null && values['readOnly'] != '') {
		domElement.setAttribute('_readOnly', values['readOnly']);
	}
	_Designer_Control_Calculation_OnDrawEnd_SetValue(values, 'expression_id', domElement);
	_Designer_Control_Calculation_OnDrawEnd_SetValue(values, 'autoCalculate', domElement);
	//_Designer_Control_Calculation_OnDrawEnd_SetValue(values, 'expression_mode', domElement);
	if (values['expression_name'] != null && values['expression_name'] != '') {
		domElement.children[0].value = values['expression_name'];
	}
	var isRow = false;
	for (var parent = domElement.parentNode; parent != null; parent = parent.parentNode) {
		if (parent.tagName == 'TR') {
			if (parent.type == 'templateRow') {
				domElement.expression_mode = 'isRow';
				isRow = true;
				break;
			}
		}
	}
	if (!isRow) {
		domElement.expression_mode = 'notRow';
	}

	if (this.options.values.decimal != null) {
		domElement.scale = this.options.values.decimal;
	}
	domElement.thousandShow='false';
	if(this.options.values.thousandShow=='true'){
		domElement.thousandShow='true';
	}
}

function _Designer_Control_Calculation_OnDrawEnd_SetValue(values, name, domElement) {
	if (values[name] != null && values[name] != '') {
		domElement.setAttribute(name, values[name]);
	}
}

function Designer_Control_Calculation_Dialog(dom) {
	var dialog = new KMSSDialog();
	dialog.formulaParameter = {varInfo: Designer.instance.getObj(), funcInfo : Designer_Control_Calculation_FuncInfo};
	dialog.BindingField('expression_id', 'expression_name');
	dialog.SetAfterShow(function(){Designer_AttrPanel.showButtons(dom)});
	dialog.URL = Com_Parameter.ContextPath + "sys/xform/designer/calculation/calculation_edit.jsp";
	dialog.Show(780, 480);
}

function Designer_Control_Calculation_Attr_Expression_Draw(name, attr, value, form, attrs, values, control) {
	var buff = [];
	buff.push('<nobr><input type="hidden" name="expression_id"');
	if (values.expression_id != null) {
		buff.push(' value="' , values.expression_id, '"');
	}
	buff.push('>');
	buff.push('<input type="text" name="expression_name" style="width:78%" readOnly ');
	if (values.expression_name != null) {
		buff.push(' value="' , values.expression_name, '"');
	}
	buff.push('>');
	buff.push('<input type=button onclick="Designer_Control_Calculation_Dialog(this);" class="btnopt" value="..."></nobr>');
	return Designer_AttrPanel.wrapTitle(name, attr, value, buff.join(''));
}

function _Designer_Control_Calculation_DrawXML() {
	var values = this.options.values;
	var buf = ['<extendSimpleProperty '];
	buf.push('name="', values.id, '" ');
	buf.push('label="', values.label, '" ');
	buf.push('type="', values.dataType ? values.dataType : "Double", '" ');
	if (values.formula != '' && values.formula != null) {
		buf.push('formula="true" ');
		buf.push('defaultValue="', values.formula, '" ');
		if (values.reCalculate == 'true') {
			buf.push('recalculateOnSave="true" ');
		}
	} else if (values.defaultValue != '' && values.defaultValue != null) {
		buf.push('defaultValue="', values.defaultValue, '" ');
	}
	if (values.decimal != '' || values.decimal != null) {
		buf.push('scale="', values.decimal, '" ');
	}
	buf.push('/>');
	return buf.join('');
}

Designer_Config.operations['calculation'] = {
		lab : "2",
		imgIndex : 44,
		title : Designer_Lang.controlCalculation_btn_title,
		run : function (designer) {
			designer.toolBar.selectButton('calculation');
		},
		type : 'cmd',
		select: true,
		cursorImg: 'style/cursor/calculation.cur',
		isAdvanced: false
	};

Designer_Config.buttons.control.push('calculation');
Designer_Menus.add.menu['calculation'] = Designer_Config.operations['calculation'];

var Designer_Control_Calculation_FuncInfo = [
{text:Designer_Lang.controlCalculation_func_sum_text, value: Designer_Lang.controlCalculation_func_sum_value, title:Designer_Lang.controlCalculation_func_sum_title, fun: 'XForm_CalculatioFuns_Sum'},
{text:Designer_Lang.controlCalculation_func_avg_text, value: Designer_Lang.controlCalculation_func_avg_value, title:Designer_Lang.controlCalculation_func_avg_title, fun: 'XForm_CalculatioFuns_Avg'},
{text:Designer_Lang.controlCalculation_func_count_text, value: Designer_Lang.controlCalculation_func_count_value, title:Designer_Lang.controlCalculation_func_count_title, fun: 'XForm_CalculatioFuns_Count'},
{text:Designer_Lang.controlCalculation_func_defaultValue_text, value: Designer_Lang.controlCalculation_func_defaultValue_value, title:Designer_Lang.controlCalculation_func_defaultValue_title, fun: 'XForm_CalculatioFuns_DefaultValue'}
];