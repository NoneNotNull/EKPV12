// 移动终端控件属性配置扩展

Designer_Config.attrs.layout2col = {
		text : Designer_Lang.layout2colName,
		opts: [
		       {text:Designer_Lang.layout2colValDefault, value:'default'}, 
		       {text:Designer_Lang.layout2colDesktop, value:'desktop'}, 
		       {text:Designer_Lang.layout2colMobile, value:'mobile'}],
		value: "default",
		type: 'radio',
		show: true,
		required: false
	};

function default_layout2col_attr(control, fn) {
	if (control == null) {
		return;
	}
	control.attrs.layout2col = Designer_Config.attrs.layout2col;
	fn.call(this, control);
}

default_layout2col_attr(Designer_Config.controls.standardTable, function(standardTable) {
	var old = standardTable.onDrawEnd;
	var attrsetter = function() {
		old.call(this);
		var values = this.options.values;
		var domElement = this.options.domElement;
		if (values)
			domElement.setAttribute("layout2col", values['layout2col']);
	};
	standardTable.onDrawEnd = attrsetter;
});

default_layout2col_attr(Designer_Config.controls.detailsTable, function(detailsTable) {
	var old = detailsTable.onDrawEnd;
	var attrsetter = function() {
		old.call(this);
		var values = this.options.values;
		var domElement = this.options.domElement;
		if (values)
			domElement.setAttribute("layout2col", values['layout2col']);
	};
	detailsTable.onDrawEnd = attrsetter;
});

(function(jsp) {
	if (jsp == null) {
		return;
	}
	var html = Designer_Lang.jspIsInMobileEnable 
		+ " <label><input type='radio' value='default' name='Designer_Control_JSP_MobileView'>"
		+ Designer_Lang.jspMobileDefault +"</label>";
	html += "<label><input type='radio' value='enable' name='Designer_Control_JSP_MobileView'>"+Designer_Lang.jspMobileEnable+"</label>";
	html += "<label><input type='radio' value='disable' name='Designer_Control_JSP_MobileView'>"+Designer_Lang.jspMobileDisable+"</label>";
	
	// 绘制选项
	var oldShowDom = window.Get_Designer_Control_JSP_ShowDom;
	var newShowDom = function() {
		var dom = oldShowDom.call(this);
		var child = document.createElement('div');
		child.innerHTML = html;
		document.getElementById('Designer_Control_JSP_Value').parentNode.appendChild(child);
		return dom;
	};
	window.Get_Designer_Control_JSP_ShowDom = newShowDom;
	
	// 编辑框赋值
	var oldShowEditFrame = window.Designer_Control_JSP_ShowEditFrame;
	var newShowEditFrame = function(event, dom) {
		oldShowEditFrame.call(this, event, dom);
		var jspDom = dom.parentNode;
		var mobileViewVal = jspDom.getAttribute('mobileView');
		var mobileView = document.getElementsByName('Designer_Control_JSP_MobileView');
		for (var i = 0; i < mobileView.length; i ++) {
			if (mobileView[i].value == mobileViewVal) {
				mobileView[i].checked = true;
				return;
			}
		}
		mobileView[0].checked = true;
	};
	window.Designer_Control_JSP_ShowEditFrame = newShowEditFrame;
	
	// 编辑数据回写
	var oldSuccessEditFrame = window.Designer_Control_JSP_SuccessEditFrame;
	var newSuccessEditFrame = function() {
		var dom = Designer_Config.controls.jsp.valueDom;
		var jspDom = dom.parentNode.parentNode;
		var mobileView = document.getElementsByName('Designer_Control_JSP_MobileView');
		for (var i = 0; i < mobileView.length; i ++) {
			if (mobileView[i].checked) {
				jspDom.setAttribute('mobileView', mobileView[i].value);
				break;
			}
		}
		oldSuccessEditFrame.call(this);
	};
	window.Designer_Control_JSP_SuccessEditFrame = newSuccessEditFrame;
	
})(Designer_Config.controls.jsp);