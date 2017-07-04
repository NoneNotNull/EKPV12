/**********************************************************
功能：同行内换行控件
使用：
	
作者：傅游翔
创建时间：2010-6-12
**********************************************************/

Designer_Config.controls['brcontrol'] = {
		type : "brcontrol",
		storeType : 'none',
		inherit    : 'base',
		onDraw : _Designer_Control_Brcontrol_OnDraw,
		onDrawEnd : _Designer_Control_Brcontrol_OnDrawEnd,
		drawXML : null,
		destroy : _Designer_Control_Brcontrol_Destroy,
		_destroy : Designer_Control_Destroy,
		implementDetailsTable : true,
		info : {
			name: Designer_Lang.controlBrcontrol_info_name
		},
		resizeMode : 'no',
		attrs : {
			lineHeight : {
				text: Designer_Lang.controlBrcontrol_attr_lineHeight,
				value: "0",
				show: true,
				type: 'text',
				validator: _Designer_Control_Brcontrol_Attr_Height_Validator,
				checkout: _Designer_Control_Brcontrol_Attr_Height_Checkout
			}
		}
};

function _Designer_Control_Brcontrol_Attr_Height_Validator(elem, name, attr, value, values) {
	if (value != null && value != '' && !(/^(\d+)$/.test(value.toString()))) {
		alert(Designer_Lang.controlBrcontrol_attr_valLineHeight);
		return false;
	}
	return true;
}

function _Designer_Control_Brcontrol_Attr_Height_Checkout(msg, name, attr, value, values) {
	if (value != null && value != '' && !(/^(\d+)$/.test(value.toString()))) {
		msg.push(Designer_Lang.GetMessage(Designer_Lang.controlBrcontrol_attr_chkLineHeight,attr.text));
		return false;
	}
	return true;
}

function _Designer_Control_Brcontrol_OnDraw(parentNode, childNode) {
	var domElement = _CreateDesignElement('div', this, parentNode, childNode);
	if(this.options.values.id == null)
		this.options.values.id = "fd_" + Designer.generateID();
	domElement.id = this.options.values.id;
	var label = document.createElement("span");
	//label.appendChild(document.createTextNode("BR"));
	label.title = Designer_Lang.controlBrcontrol_html_title;
	//label.setAttribute("label", _Get_Designer_Control_Label(this.options.values, this));
	
	//label.className = "button_img";
	label.style.display="inline-block";
	label.style.height = '16px';
	label.style.width = '16px';
	label.style.background = background="url(style/img/br.png) no-repeat";
	label.style.margin = '0px 4px 0 0px';
	
	domElement.appendChild(label);
}

function _Designer_Control_Brcontrol_OnDrawEnd() {
	var domElement = this.options.domElement;
	var values = this.options.values;
	var br = document.getElementById('brcontrol-' + domElement.id);
	if (br == null) {
		br = document.createElement("div");
		br.id = 'brcontrol-' + domElement.id;
	} else {
		br.parentNode.removeChild(br);
	}
	if (domElement.nextSibling != null) {
		domElement.parentNode.insertBefore(br, domElement.nextSibling);
	} else {
		domElement.parentNode.appendChild(br);
	}
	if (values.lineHeight > 0) {
		br.style.height = values.lineHeight;
	}
}

function _Designer_Control_Brcontrol_Destroy() {
	var domElement = this.options.domElement;
	var br = document.getElementById('brcontrol-' + domElement.id);
	if (br != null) {
		br.parentNode.removeChild(br);
	}
	this._destroy();
}

Designer_Config.operations['brcontrol'] = {
		lab : "2",
		imgIndex : 45,
		title : Designer_Lang.controlBrcontrol_title,
		run : function (designer) {
			designer.toolBar.selectButton('brcontrol');
		},
		type : 'cmd',
		select: true,
		cursorImg: 'style/cursor/br.cur'
	};

	Designer_Config.buttons.control.push("brcontrol");

	Designer_Menus.add.menu['brcontrol'] = Designer_Config.operations['brcontrol'];