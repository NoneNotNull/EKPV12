/**********************************************************
功能：大小写转换控件，主要用于财务等金额的填写。
使用：
	
**********************************************************/
Com_IncludeFile("dialog.js");//对话框依赖
// 1 描述控件
Designer_Config.controls['chinaValue'] = {
	type : "chinaValue", //根据控件进行命名，与上面sqlselect保持一致
	storeType : 'field', // 需要值保存，使用此属性
	inherit : 'base', // 继承控件，base控件具有拖拽功能
	onDraw : _Designer_Control_ChinaValue_OnDraw, //绘制函数，注意命名不要把原有函数覆盖
	drawXML : _Designer_Control_ChinaValue_DrawXML, //生成数据字典，注意命名不要把原有函数覆盖
	implementDetailsTable : true, // 是否支持明细表
	attrs : { // 这个是属性对话框配置，这里需要根据需求来配置
		label : Designer_Config.attrs.label, // 内置显示文字属性
		canShow : {
			text: Designer_Lang.controlAttrCanShow,
			value: "true",
			type: 'checkbox',
			checked: true,
			show: true
		},//是否显示
		width : {
			text: Designer_Lang.controlAttrWidth,
			value: "",
			type: 'text',
			show: true,
			validator: Designer_Control_Attr_Width_Validator,
			checkout: Designer_Control_Attr_Width_Checkout
		},
		relatedid:{
			text : Designer_Lang.controlChinaValue_attr_relatedControl,
			type : 'self',
			show: true,
			draw: Designer_Control_ChinaValue_Attr_RelatedId_Draw
		},
		dataType : {
			text: Designer_Lang.controlAttrDataType,
			value: "String",
			type : "hidden",
			show: true
		},
		//defaultValue: Designer_Config.attrs.defaultValue,
		formula: Designer_Config.attrs.formula,
		reCalculate: Designer_Config.attrs.reCalculate
	},
	info : {
		name: Designer_Lang.controlChinaValue_info_controlName // 控件描述
	},
	resizeMode : 'no' // 是否可修改大小还有其他属性，可参考 config.js里的内容
};

//2 描述按钮
Designer_Config.operations['chinaValue'] = {
		imgIndex : 50, // 按钮图片, 直接通过css背景图定位方式来实现，图片是icon.gif
		cursorImg: 'style/cursor/chinaValue.cur',
		title : Designer_Lang.controlChinaValue_operations_title,
		type : 'cmd',
		shortcut : '',
		run : function (designer) {
			designer.toolBar.selectButton('chinaValue');
		},
		//sampleImg : 'style/img/chinaValue.jpg', // 提示图片
		select: true
		//cursorImg: 'style/cursor/select.cur' // 鼠标手势
};

//3 添加按钮到工具栏
Designer_Config.buttons.control.push("chinaValue");
 
// 4 添加按钮到右键菜单
Designer_Menus.add.menu['chinaValue'] = Designer_Config.operations['chinaValue'];

//5 绘制HTML函数，注意命名不要把原有函数覆盖
function _Designer_Control_ChinaValue_OnDraw(parentNode, childNode){
	// 必须要做ID设置
	if(this.options.values.id == null)
		this.options.values.id = "fd_" + Designer.generateID();
	// 调用内建方法创建dom对象，由于有一些内置属性需要添加，建议使用此方法
	var domElement = _CreateDesignElement('div', this, parentNode, childNode);
	//domElement.id=this.options.values.id ;
	if (this.options.values.width && this.options.values.width.toString().indexOf('%') > -1) {
		domElement.style.whiteSpace = 'nowrap';
		domElement.style.width = this.options.values.width;
	}
	// 以下是绘制，这个根据需求自己定义
	var htmlCode = _Designer_Control_ChinaValue_DrawByType(domElement,this.options.values, this,this.parent);
	domElement.innerHTML = htmlCode;
	
}

/**
* 	生成大写控件HTML片段
*/
function _Designer_Control_ChinaValue_DrawByType(dom,values, control,parent){
	
	_Designer_Control_ChindValue_OnDrawEnd_SetValue("id",values.id,dom);
	_Designer_Control_ChindValue_OnDrawEnd_SetValue("relatedid",values.relatedid,dom);
	
	if (values.canShow == 'false') {
		_Designer_Control_ChindValue_OnDrawEnd_SetValue("canShow","false",dom);
		//htmlCode += '" canShow="false"';
	} else {
		_Designer_Control_ChindValue_OnDrawEnd_SetValue("canShow","true",dom);
		//htmlCode += '" canShow="true"';
	}
	if(values.width==null || values.width==''){
		values.width = "200";
	}
		//htmlCode += ' style="width:'+values.width+'px"';
	dom.style.width = values.width;
	if (parent != null) {
		_Designer_Control_ChindValue_OnDrawEnd_SetValue("tableName",_Get_Designer_Control_TableName(parent),dom);
		//htmlCode += ' tableName="' + _Get_Designer_Control_TableName(parent) + '"';
	}
	if (values.description != null) {
		_Designer_Control_ChindValue_OnDrawEnd_SetValue("description",values.description,dom);
		//htmlCode += ' description="' + values.description + '"';
	}
	//htmlCode += ' label="' + _Get_Designer_Control_Label(values, control) + '"';
	_Designer_Control_ChindValue_OnDrawEnd_SetValue("label",_Get_Designer_Control_Label(values, control),dom);
	
	var isRow = false;
	for (var p = dom.parentNode; p != null; p = p.parentNode) {
		if (p.tagName == 'TR') {
			if (p.type == 'templateRow') {
				_Designer_Control_ChindValue_OnDrawEnd_SetValue("chinavalue_mode","isRow",dom);
				//htmlCode += ' chinavalue_mode="isRow"' ;
				isRow = true;
				break;
			}
		}
	}
	if (!isRow) {
		_Designer_Control_ChindValue_OnDrawEnd_SetValue("chinavalue_mode","notRow",dom);
		//htmlCode += ' chinavalue_mode="notRow"' ;
	}
	
	var htmlCode = '<input type=text class=inputsgl  style="width:'
		+values.width+'px">';
	
	return htmlCode;
	
}

function _Designer_Control_ChindValue_OnDrawEnd_SetValue(name, value, domElement) {
	if (value != null && name != null && name != '' ) {
		domElement.setAttribute(name, value);
	}
}

//6 绘制数据字典，必须按照标准的数据字典格式来。注意命名不要把原有函数覆盖
//具体属性参考 com/landray/kmss/sys/metadata/dict 包下内容
function _Designer_Control_ChinaValue_DrawXML(){
	var values = this.options.values;
	var buf = ['<extendSimpleProperty '];
	buf.push('name="', values.id, '" ');
	buf.push('label="', values.label, '" ');
	buf.push('type="String" ');
	if (values.relatedid != null && values.relatedid !='') {
		buf.push('relatedid="', values.relatedid, '" ');
	}
	buf.push('/>');
	return buf.join('');
}

//关联控件属性绘制
function Designer_Control_ChinaValue_Attr_RelatedId_Draw(name, attr, value, form, attrs, values, control){
	var buff = [];
	buff.push('<input type="hidden" name="relatedid"');
	if (values.relatedid != null) {
		buff.push(' value="' , values.relatedid, '"');
	}
	buff.push('>');
	buff.push('<input type="text" name="relatedname" style="width:85%"  readOnly');
	if (values.relatedname != null) {
		buff.push(' value="' , values.relatedname, '"');
	}
	buff.push('>');
	buff.push('<input type=button onclick="Designer_Control_ChinaValue_Dialog(this);" class="btnopt" value="...">');
	return Designer_AttrPanel.wrapTitle(name, attr, value, buff.join(''));
}

//弹出关联控件选择树
function Designer_Control_ChinaValue_Dialog(dom){
	var dialog = new KMSSDialog();
	dialog.BindingField('relatedid','relatedname');
	dialog.Parameters = {varInfo: Designer.instance.getObj(true)};
	dialog.SetAfterShow(function(){Designer_AttrPanel.showButtons(dom);});
	dialog.URL = Com_Parameter.ContextPath + "sys/xform/designer/chinaValue/chinaValue_tree.jsp";
	dialog.Show(380, 480);
}