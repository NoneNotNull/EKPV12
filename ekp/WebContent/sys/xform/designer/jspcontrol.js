/**********************************************************
功能：JSP控件
使用：
	
作者：傅游翔
创建时间：2009-06-26
**********************************************************/

Designer_Config.controls.jsp = {
	dragRedraw : false,
	type : "jsp",
	storeType : 'none',
	inherit    : 'base',
	onDraw : _Designer_Control_JSP_OnDraw,
	onDrawEnd : null,
	implementDetailsTable : true,
	info : {
		name: Designer_Lang.controlJspInfoName
	},
	resizeMode : 'no',
	blockDom: null,
	showDom: null,
	valueDom: null
};

function Get_Designer_Control_JSP_BlockDom() {
	var dom = document.createElement('div');
	with(document.body.appendChild(dom).style) {
		position = 'absolute'; filter = 'alpha(opacity=80)'; opacity = '0.8';
		border = '1px'; background = '#EAEFF3'; display = 'none';
		width = document.body.scrollWidth + 'px';
		height = document.body.scrollHeight + 'px';
		top = '0'; left = '0';
		zIndex = '999';
	}
	return dom;
}

function Get_Designer_Control_JSP_ShowDom() {
	var domElement = document.createElement('div');
	document.body.appendChild(domElement);
	domElement.className= 'panel_jsp_panel';
	var html = [];
	html.push('<div class="resize_panel">', 
			'<div class="resize_panel_top"><table class="resize_panel_top_panel"><tr>', 
			'<td class="resize_panel_top_left"></td>', 
			'<td class="resize_panel_top_center">', Designer_Lang.controlJspInfoName, '</td>',
			'<td class="resize_panel_top_right"></td></tr></table></div>');
	html.push('<div class="resize_panel_main">',
			'<table class="resize_panel_main_panel"><tr>',
			'<td class="resize_panel_main_left"></td>',
			'<td class="resize_panel_main_center">',
			'<textarea id="Designer_Control_JSP_Value" style="width:100%;height:200px;" wrap="off"></textarea>',
			'<div><label>' + Designer_Lang.jspControlName + '</label><input type="text" name="Designer_Control_JSP_Name" style="width:60%;" ></div>',
			'</td><td class="resize_panel_main_right"></td></tr></table></div>');
	html.push('<div class="resize_panel_bottom">', 
			'<table class="resize_panel_bottom_panel">',
			'<tr><td class="resize_panel_bottom_panel_left"></td>',
			'<td class="resize_panel_bottom_panel_center"><div>',
			'<button class="panel_success" title="',Designer_Lang.controlJspSuccess,'" ',
			' onclick="Designer_Control_JSP_SuccessEditFrame();">&nbsp;</button>',
			'&nbsp;&nbsp;',
			'<button class="panel_cancel" title="',Designer_Lang.controlJspCancel,'" ',
			' onclick="Designer_Control_JSP_CloseEditFrame();">&nbsp;</button>',
			'&nbsp;&nbsp;',
			'<button class="panel_help" title="',Designer_Lang.controlJspHelp,'" ',
			' onclick="Com_OpenWindow(\'jspcontrol_help.jsp\', \'_blank\');">&nbsp;</button>',
			'</div></td><td class="resize_panel_bottom_panel_right"></td>',
			'</tr></table>',
			'<table class="resize_panel_bottom_border">',
			'<tr><td class="resize_panel_bottom_border_left"></td>', 
			'<td class="resize_panel_bottom_border_center">&nbsp;</td>',
			'<td class="resize_panel_bottom_border_right"></td></tr></table>',
			'</div></div>');
	domElement.innerHTML = html.join('');
	with(domElement.style) {
		position = 'absolute'; zIndex = '1000'; display = 'none';
	}
	Designer.addEvent(window , 'scroll' , function() {
		if (domElement.style.display != '') return;
		Set_Designer_Control_JSP_ShowDomNeedPostion(domElement);
	});
	return domElement;
}

function Set_Designer_Control_JSP_ShowDomNeedPostion(domElement) {
	var p = Get_Designer_Control_JSP_ShowDomNeedPostion(domElement);
	domElement.style.top = p.y + 'px';
	domElement.style.left = p.x + 'px';
}

function Get_Designer_Control_JSP_ShowDomNeedPostion(domElement) {
	return ({
		x : document.body.offsetWidth / 2 + document.body.scrollLeft - domElement.offsetWidth / 2,
		y : document.body.offsetHeight / 2 + document.body.scrollTop - domElement.offsetHeight / 2
	});
}

function Designer_Control_JSP_ShowEditFrame(event, dom) {
	event = event || window.event;
	event.cancelBubble = true;
	if (event.stopPropagation) {event.stopPropagation();}
	dom = dom ? dom : this;
	Designer_Config.controls.jsp.valueDom = dom.firstChild;
	var valueDom = Designer_Config.controls.jsp.valueDom;
	var value = valueDom.value ? valueDom.value : "<%\n%>";
	if (Designer_Config.controls.jsp.blockDom == null)  {
		Designer_Config.controls.jsp.blockDom = Get_Designer_Control_JSP_BlockDom();
	}
	if (Designer_Config.controls.jsp.showDom == null) {
		Designer_Config.controls.jsp.showDom = Get_Designer_Control_JSP_ShowDom();
		Designer.instance.shortcuts.add('tab', function() {
			document.selection.createRange().text = '\t';
		}, {'target':Designer_Config.controls.jsp.showDom});
	}
	var valueDom = document.getElementById("Designer_Control_JSP_Value");
	valueDom.value = value;
	document.getElementsByName("Designer_Control_JSP_Name")[0].value = dom.parentNode.title;
	Designer_Config.controls.jsp.blockDom.style.display = '';
	Designer_Config.controls.jsp.showDom.style.display = '';
	Set_Designer_Control_JSP_ShowDomNeedPostion(Designer_Config.controls.jsp.showDom);
}

function Designer_Control_JSP_CloseEditFrame() {
	Designer_Config.controls.jsp.blockDom.style.display = 'none';
	Designer_Config.controls.jsp.showDom.style.display = 'none';
	Designer_Config.controls.jsp.valueDom = null;
}

function Designer_Control_JSP_SuccessEditFrame() {
	var valueDom = Designer_Config.controls.jsp.valueDom;
	valueDom.value = document.getElementById("Designer_Control_JSP_Value").value;
	valueDom.parentNode.parentNode.title = 
		document.getElementsByName("Designer_Control_JSP_Name")[0].value || Designer_Lang.controlJspInfoName;
	Designer_Control_JSP_CloseEditFrame();
	
	//增加对撤销功能的支持,--add by zhouzf
	if(typeof (DesignerUndoSupport)  != 'undefined'){
		DesignerUndoSupport.saveOperation();
	}
	
}

function _Designer_Control_JSP_OnDraw(parentNode, childNode) {
	var domElement = _CreateDesignElement('div', this, parentNode, childNode);
	if(this.options.values.id == null)
		this.options.values.id = "fd_" + Designer.generateID();
	domElement.id = this.options.values.id;
	domElement.style.display="inline-block";
	domElement.style.width='16px';
	var div = document.createElement("label");
	var label = document.createElement("span");
	var jspcontent = document.createElement("input");
	jspcontent.type = 'hidden';
	label.appendChild(jspcontent);
	//label.appendChild(document.createTextNode("JSP"));
	label.className = "button_img";
	label.style.backgroundPosition = "center " + (- 30 * 16) + "px";
	label.style.margin = '0px 3px 3px 0px';
	label.style.width='16px';
	label.style.height='16px';
	label.style.display="inline-block";
	label.ondblclick = "Designer_Control_JSP_ShowEditFrame(event, this);";
	div.appendChild(label);
	domElement.innerHTML = div.innerHTML;
	domElement.title = Designer_Lang.controlJspInfoName;
}
