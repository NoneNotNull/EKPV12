/**********************************************************
功能：权限控件
使用：
	
作者：傅游翔
创建时间：2009-11-12
**********************************************************/
var Designer_Right_Scene = 'g'; // 权限模式
var Designer_Right_isDraft = false;

//============= 权限区域
Designer_Config.controls['right'] = {
		type : "right",
		container : true,
		storeType : 'layout',
		inherit : 'base',
		implementDetailsTable : true,
		onInitialize : _Designer_Control_Right_OnInitialize,
		onDraw : _Designer_Control_Right_OnDraw,
		onDrawEnd : function() {
			for (var i = this.children.length - 1; i >= 0; i--) {
				this.owner.setProperty(this.children[i]);
			}
		},
		drawXML : _Designer_Control_Right_DrawXML,
		insertCell : _Designer_Control_Right_InsertCell,
		drawReaderCell : _Designer_Control_Right_DrawReaderCell,
		drawModeCell : _Designer_Control_Right_DrawModeCell,
		drawDefaultCell : _Designer_Control_Right_DrawDefaultCell,
		change : _Designer_Control_Right_DrawDefaultCell,
		destroyMessage : Designer_Lang.controlRightDestroyMessage,
		_destroy : Designer_Control_Destroy,
		destroy : function() {
			for (var i = this.children.length - 1; i >= 0; i--) {
				this.children[i].draw(this.parent, this.options.domElement.parentNode);
			}
			this._destroy();
		},
		onSerialize : function(designer) {
			if (Designer_Control_RigthTree && !Designer_Control_RigthTree.isClosed) {
				Designer_Control_Rigth_LoopRightControls(designer.builder.controls, function(c) {
					c.showRightConfig(false);
					c.showRightDefaultCell();
				});
			}
		},
		onSerialized : function(designer) {
			if (Designer_Control_RigthTree && Designer_Control_RigthTree.isClosed) {
				Designer_Control_Rigth_LoopRightControls(designer.builder.controls, function(c) {
					c.showRightConfig(true);
					c.showRightDefaultCell();
				});
			}
		},
		$C : function (name, domElement, array, single) {
			return Designer_Control_Right_Util_FindElemByClassName.call(this, name, domElement, array, single);
		},
		_get : function(name) {
			if (this.options[name] == null) {
				this.options[name] = this.$C(name, null, null, true)[0];
			}
			return this.options[name];
		},
		// 切换权限区段上配置按钮显示还是隐藏
		showRightConfig : function(show) {
			if (show) {
				this.getRightIconBar().style.display = 'none';
				this.getRightBar().style.display = '';
			} else {
				this.getRightIconBar().style.display = '';
				this.getRightBar().style.display = 'none';
			}
		},
		// 设置起草状态显示，默认是编辑
		setDraftDefault : function() {
			if (Designer_Right_isDraft && (Designer_Right_Scene != 'd' && Designer_Right_Scene != 'g')) {
				var cell = this.getRightModeCell();
				var mode = cell.getAttribute('mode_' + Designer_Right_Scene);
				if (mode == '' || mode == null) {
					cell.setAttribute('mode_' + Designer_Right_Scene,'edit');
					cell = this.getRightDefaultCell();
					cell.setAttribute('def_' + Designer_Right_Scene,'false');
				}
			}
		},
		// 显示可阅读者配置按钮
		showReaderCell : function() {
			var modeCell = this.getRightModeCell();
			var isShow = ('g' == Designer_Right_Scene && modeCell.getAttribute('mode_g') == 'hidden');
			this.getRightReaderCell().parentNode.style.display = isShow ? '' : 'none';
		},
		// 显示权限操作主方法
		showRightDefaultCell : function() {
			this.setDraftDefault();
			
			// 选项继承默认权限按钮
			var cell = this.getRightDefaultCell();
			var show = (Designer_Right_Scene != 'g') && (Designer_Right_Scene != 'd');
			cell.style.display = show ? '' : 'none';
			cell.parentNode.style.width = show ? '36px' : '18px';
			
			// 可阅读者按钮
			this.showReaderCell();
			
			//var y = parseInt(cell.style.backgroundPositionY);
			if (show) {
				var useDef = !(cell.getAttribute('def_' + Designer_Right_Scene) == 'false');
				cell.style.backgroundPositionY = useDef ? -16 * 5 : -16 * 6;
				cell.title = useDef ? Designer_Lang.controlRightUseDefault : Designer_Lang.controlRightNotUseDefault;
			}
			this.showRightModeCell();
		},
		// 判断当前节点是否继承默认节点
		isUseDefMode : function() {
			var cell = this.getRightDefaultCell();
			return !(cell.getAttribute('def_' + Designer_Right_Scene) == 'false');
		},
		showRightModeCell : function() {
			var cell = this.getRightModeCell();
			var isdef = (Designer_Right_Scene == 'd') ? true : this.isUseDefMode();
			isdef = (isdef && Designer_Right_Scene != 'g');
			var mode = isdef ? 'mode_d' : 'mode_' + Designer_Right_Scene;
			mode = cell.getAttribute(mode);
			if (mode == null && isdef) {
				mode = cell.getAttribute('mode_g');
			}
			// 兼容并修正旧数据
			if (mode == 'edit' && Designer_Right_Scene == 'g') {
				mode = cell.getAttribute('mode_d');
				if (mode == null || mode == '') {
					cell.setAttribute('mode_d', mode);
				}
				mode = 'view';
				cell.setAttribute('mode_g', mode);
			}
			if (mode == 'hidden') {
				cell.title = Designer_Lang.controlRightModeHidden;
				cell.style.backgroundPositionY = -16 * 2 + 'px';
			}
			else if (mode == 'edit') {
				cell.title = Designer_Lang.controlRightModeEidt;
				cell.style.backgroundPositionY = -16 * 4 + 'px';
			}
			else {
				cell.title = Designer_Lang.controlRightModeView;
				cell.style.backgroundPositionY = -16 * 3 + 'px';
			}
		},
		getRightReaderCell : function() {
			return this._get('readerCell');
		},
		getRightModeCell : function() {
			return this._get('modeCell');
		},
		getRightDefaultCell : function() {
			return this._get('defaultCell');
		},
		getRightIconBar : function() {
			return this._get('rightIconBar');
		},
		getRightBar : function() {
			return this._get('righBar');
		},
		info : {
			name: Designer_Lang.controlRightInfoName
		},
		resizeMode : 'no'
};

function Designer_Control_Right_Util_FindElemByClassName(name, domElement, array, single) {
	var rtn = array || [];
	var dom = domElement || this.options.domElement;
	var nodes = dom.childNodes;
	if (nodes != null) {
		for (var i = 0 ; i < nodes.length; i ++) {
			var node = nodes[i];
			if (node.className && node.className.indexOf(name) > -1) {
				rtn.push(node);
				if (single) break;
			} else {
				Designer_Control_Right_Util_FindElemByClassName.call(this, name, node, rtn, single);
			}
		}
	}
	return rtn;
}

function _Designer_Control_Right_DrawXML() {
	if (this.children.length > 0) {
		var xmls = [];
		this.children = this.children.sort(Designer.SortControl);
		for (var i = 0, l = this.children.length; i < l; i ++) {
			var c = this.children[i];
			if (c.drawXML) {
				var xml = c.drawXML();
				if (xml != null)
					xmls.push(xml, '\r\n');
			}
		}
		return xmls.join('');
	}
	return '';
}

function Designer_Control_Right_BuildStopBubble(dom) {
	Designer.addEvent(dom, 'click', Designer_Control_Right_CancelBubbleFun);
	Designer.addEvent(dom, 'dblclick', Designer_Control_Right_CancelBubbleFun);
	Designer.addEvent(dom, 'keyup', Designer_Control_Right_CancelBubbleFun);
	Designer.addEvent(dom, 'keydown', Designer_Control_Right_CancelBubbleFun);
}

function Designer_Control_Right_CancelBubbleFun(event) {
	event = event || window.event;
	event.cancelBubble = true;
	if (event.stopPropagation) {
		event.stopPropagation();
	}
}

function _Designer_Control_Right_InsertCell(tr) {
	var td = tr.insertCell(-1);
	td.style.border = '1px solid red';
	td.style.backgroundColor = '#FBD4B4';
	return td;
}

function Designer_Control_Right_GetControl(dom) {
	return Designer.instance.builder.getControlByDomElement(dom);
}

function _Designer_Control_Right_DrawReaderCell(td) {
	var div = '<button type="button" onmousedown="Designer_Control_Right_CancelBubbleFun(event);" class="readerCell" title="'+Designer_Lang.controlRightNotSetReader
		+'" readerIds="" readerNames="" ondblclick="Designer_Control_Right_CancelBubbleFun(event);"'
		+' style="cursor:pointer;width:16px;height:16px;background:url(style/img/right_icon.gif) no-repeat 0 -16;border:0;"'
		+' onclick="Designer_Control_Right_SetReaderCellValue(this);">'
		+'&nbsp;&nbsp;&nbsp;</button>';
	td.innerHTML = div;
}

function Designer_Control_Right_SetReaderCellValue(dom) {
	//var control = Designer_Control_Right_GetControl(dom);
	//var values = control.options.values;
	var readerIds = dom.getAttribute('readerIds');
	var readerNames = dom.getAttribute('readerNames');
	var inputIds = document.getElementsByName('_right_reader_id');
	var inputNames = document.getElementsByName('_right_reader_name');
	if (inputIds == null || inputIds.length < 1) {
		inputIds = document.createElement('<input type="hidden" name="_right_reader_id">');
		inputNames = document.createElement('<input type="hidden" name="_right_reader_name">');
		document.body.appendChild(inputIds);
		document.body.appendChild(inputNames);
	} else {
		inputIds = inputIds[0];
		inputNames = inputNames[0];
	}
	
	if (readerIds == null || readerIds == '') {
		readerIds = '';
		readerNames = '';
	}
	inputIds.value = readerIds;
	inputNames.value = readerNames;
	Dialog_Address(true,inputIds,inputNames,null,null,function(data) {
		dom.setAttribute('readerIds', inputIds.value);
		dom.setAttribute('readerNames', inputNames.value);
		if (inputIds.value == '') {
			dom.style.backgroundPositionY = -16;
			dom.title = Designer_Lang.controlRightNotSetReader;
			return;
		} else {
			dom.style.backgroundPositionY = 0;
			dom.title = inputNames.value;
		}
	});
}

function _Designer_Control_Right_DrawModeCell(td) {
	// 隐藏/只读/编辑
	var div = '<button type="button" onmousedown="Designer_Control_Right_CancelBubbleFun(event);" class="modeCell" title="'+Designer_Lang.controlRightModeView
		+'" mode_g="view" mode_d="view" ondblclick="Designer_Control_Right_CancelBubbleFun(event);"'
		+' style="float:left;cursor:pointer;width:16px;height:16px;background:url(style/img/right_icon.gif) no-repeat 0 -48;border:0;"'
		+' onclick="Designer_Control_Right_SetModeCellValue(this);">'
		+'&nbsp;&nbsp;&nbsp;</button>';
	td.innerHTML = div;
}

// 设置权限状态( -16 * 2 = 不可见, -16 * 3 = 只读, -16 * 4 = 可编辑)
function Designer_Control_Right_SetModeCellValue(dom) {
	
	//增加对撤销功能的支持,--add by zhouzf
	if(typeof (DesignerUndoSupport)  != 'undefined'){
		var ___html=DesignerUndoSupport.getHTML();
	}
	
	var y = parseInt(dom.style.backgroundPositionY);
	y = (y <= -16 * 4) ? -16 * 2 : y - 16;
	if (Designer_Right_Scene == 'g' && y <= -16 * 4) {
		y = -16 * 2;
	}
	dom.style.backgroundPositionY = y;
	var oldMode = dom.getAttribute('mode_g');
	if (y >= -16 * 2) { // 不可见
		dom.title = Designer_Lang.controlRightModeHidden;
		dom.setAttribute('mode_' + Designer_Right_Scene, 'hidden');
	} else if (y <= -16 * 4) { // 可编辑
		dom.title = Designer_Lang.controlRightModeEidt;
		dom.setAttribute('mode_' + Designer_Right_Scene, 'edit');
	} else { // 只读
		dom.title = Designer_Lang.controlRightModeView;
		dom.setAttribute('mode_' + Designer_Right_Scene, 'view');
	}
	if (Designer_Right_Scene != 'g') {
		Designer_Control_Right_SetDefaultCellFalse(dom);
	}
	if (Designer_Right_Scene == 'g') {
		var dMode = dom.getAttribute('mode_d');
		if (dMode == null) {
			if (oldMode == null) {
				oldMode = 'view';
			}
			// 兼容旧数据设值
			dom.setAttribute('mode_d', oldMode);
		}
		var readerCell = Designer_Control_Right_Util_FindElemByClassName('readerCell', dom.parentNode.parentNode, null, true)[0];
		readerCell.parentNode.style.display = (dom.getAttribute('mode_g') == 'hidden') ? '' : 'none';
	}

	//增加对撤销功能的支持,--add by zhouzf
	if(typeof (DesignerUndoSupport)  != 'undefined'){
		var __prev=function(){
			DesignerUndoSupport.setHTML(___html);
		};
		DesignerUndoSupport.saveOperation(__prev,null);
	}

}

function Designer_Control_Right_SetDefaultCellFalse(dom) {
	var dom = Designer.getDesignElement(dom);
	dom = Designer_Control_Right_Util_FindElemByClassName('defaultCell', dom, null, true)[0];
	dom.style.backgroundPositionY = -16 * 6;
	dom.title = Designer_Lang.controlRightNotUseDefault;
	dom.setAttribute('def_' + Designer_Right_Scene, 'false');
}

function _Designer_Control_Right_DrawDefaultCell(td) {
	//默认/非默认
	var div = '<button type="button" onmousedown="Designer_Control_Right_CancelBubbleFun(event);" class="defaultCell" title="'+Designer_Lang.controlRightUseDefault
		+'" ondblclick="Designer_Control_Right_CancelBubbleFun(event);"'
		+' style="float:right;cursor:pointer;width:16px;height:16px;background:url(style/img/right_icon.gif) no-repeat 0 -80;border:0;"'
		+' onclick="Designer_Control_Right_SetDefaultCellValue(this);">'
		+'&nbsp;&nbsp;&nbsp;</button>';
	td.innerHTML = td.innerHTML + div;
}

function Designer_Control_Right_SetDefaultCellValue(dom) {
	var y = parseInt(dom.style.backgroundPositionY);
	dom.style.backgroundPositionY = y <= -16 * 6 ? -16 * 5 : y - 16;
	y = parseInt(dom.style.backgroundPositionY);
	if (y <= -16 * 6) {
		dom.title = Designer_Lang.controlRightNotUseDefault;
		dom.setAttribute('def_' + Designer_Right_Scene, 'false');
	} else {
		dom.title = Designer_Lang.controlRightUseDefault;
		dom.setAttribute('def_' + Designer_Right_Scene, 'true');
		Designer_Control_Right_SetModeCellToG(dom);
	}
}

function Designer_Control_Right_SetModeCellToG(dom) {
	var dom = Designer.getDesignElement(dom);
	dom = Designer_Control_Right_Util_FindElemByClassName('modeCell', dom, null, true)[0];
	var mode = dom.getAttribute('mode_d');
	if (mode == null) {
		mode = dom.getAttribute('mode_g');
	}
	if (mode == 'hidden') {
		dom.title = Designer_Lang.controlRightModeHidden;
		dom.style.backgroundPositionY = -16 * 2 + 'px';
	}
	else if (mode == 'edit') {
		dom.title = Designer_Lang.controlRightModeEidt;
		dom.style.backgroundPositionY = -16 * 4 + 'px';
	}
	else {
		dom.title = Designer_Lang.controlRightModeView;
		dom.style.backgroundPositionY = -16 * 3 + 'px';
	}
}

function Designer_Control_Right_ShowLabelEditor(dom) {
	dom = dom || this;
	var control = Designer_Control_Right_GetControl(dom);
	var pos = Designer.absPosition(dom);
	var input = document.createElement('<input type="text">');
	input.style.zIndex = '9900';
	input.style.width = '150px';
	input.style.heigth = '30px';
	input.style.position = 'absolute';
	input.style.top = pos.y + 'px';
	input.style.left = pos.x + 'px';
	input.value = control.options.values.rightName ? control.options.values.rightName : Designer_Lang.controlRightPleaseInputName;
	input.onkeyup = function(event) {
		event = event || window.event;
		Designer_Control_Right_CancelBubbleFun(event);
		if (event.keyCode == 13) {
			if (this.value == '') {
				alert(Designer_Lang.controlRightInputNameNotNull);
				return;
			}
			control.options.values.rightName = this.value;
			dom.innerHTML = this.value;
			this.style.display = 'none';
			document.body.removeChild(this);
		}
	};
	document.body.appendChild(input);
	input.focus();
	input.select();
	input.onblur = function() {
		this.style.display = 'none';
		document.body.removeChild(this);
	};
}

function _Designer_Control_Right_OnDraw(parentNode, childNode) {
	if(this.options.values.id == null)
		this.options.values.id = "fd_" + Designer.generateID();
	var domElement = _CreateDesignElement('div', this, parentNode, childNode);
	domElement.id = this.options.values.id;
	domElement.style.cssText = "border:1px dotted orange;width:100%;height:auto !important;height: 18px;min-height:18px;padding:1px;";
	
	var bar = document.createElement("div");
	domElement.appendChild(bar);
	bar.className = 'rightIconBar';
	bar.style.backgroundColor = 'red';
	bar.style.height = '10px';
	bar.style.width = '10px';
	bar.style.position = 'absolute';
	bar.style.cursor = 'move';
	
	var rightBar = document.createElement("table");
	domElement.appendChild(rightBar);
	rightBar.className = 'righBar';
	rightBar.style.borderCollapse = 'collapse';
	rightBar.cellPadding = '1';
	rightBar.style.border = 'none';
	var rightBarRow = rightBar.insertRow(-1);
	rightBarRow.style.height = '18px';
	
	var td;
	
	td = this.insertCell(rightBarRow);
	td.style.width = '36px';
	this.drawModeCell(td);
	this.drawDefaultCell(td);
	
	td = this.insertCell(rightBarRow);
	this.drawReaderCell(td);
	
	var _self = this;
	var label = '&nbsp;<span'
		+' ondblclick="Designer_Control_Right_CancelBubbleFun(event); Designer_Control_Right_ShowLabelEditor(this);"'
		+' style="padding:0;margin:0;border:0;line-height:16px;">'+Designer_Lang.controlRightInfoName+(_Designer_Index_Object.rightName ++)+'</span>';

	td = rightBarRow.insertCell(-1);
	td.innerHTML = label;
	td.style.border = 'none';
	td.style.padding = '0 2px 0 0';
	
	this.showRightConfig(Designer_Control_RigthTree ? !Designer_Control_RigthTree.isClosed : false);
	this.showRightDefaultCell();
}

function _Designer_Control_Right_OnInitialize() {
	var dom = Designer_Control_Right_Util_FindElemByClassName('rightIconBar', this.options.domElement, null, true)[0];
	// 暂时未实现移除方法，IE8下未发现内存遗漏。
	Designer.addEvent(document, 'mouseup', function() {// 解决拖动单元格高度后位置未跟随移动问题
		if (dom.style.display != 'none') {
			dom.style.display = 'none';
			dom.style.display = '';
		}
	});
}

// ================== 按钮
Designer_Config.operations['right'] = {
		lab : "2",
		imgIndex : 41,
		title : Designer_Lang.buttonsRight,
		run : function (designer) {
			designer.toolBar.selectButton('right');
		},
		type : 'cmd',
		shortcut : 'R',
		select: true,
		cursorImg: 'style/cursor/right.cur',
		isAdvanced: false
	};

var Designer_Control_RigthTree = null;
function Designer_Control_Rigth_LoopRightControls(controls, action) {
	if (controls == null) return;
	for (var i = 0; i < controls.length; i ++) {
		var c = controls[i];
		if (c.type == 'right') {
			action(c);
		}
		Designer_Control_Rigth_LoopRightControls(c.children, action);
	}
}
Designer_Config.operations['rightTree'] = {
		lab : "2",
		imgIndex : 42,
		title : Designer_Lang.buttonsRightTree,
		run : function (designer,button) {
			// 显示树|隐藏树
			if (Designer_Control_RigthTree == null) {
				Designer_Control_RigthTree = new Designer_Panel(designer, new Designer_RightTreePanel());
				designer.builderLeftDomElement.appendChild(Designer_Control_RigthTree.domElement);
			}
			if (Designer_Control_RigthTree.isClosed) {
				Designer_Control_RigthTree.open();
				Designer_Control_Rigth_LoopRightControls(designer.builder.controls, function(c) {
					c.showRightConfig(true);
					c.showRightDefaultCell();
				});
				button.setAsSelectd(true);
			} else {
				Designer_Control_RigthTree.close();
				Designer_Control_Rigth_LoopRightControls(designer.builder.controls, function(c) {
					c.showRightConfig(false);
					c.showRightDefaultCell();
				});
				button.setAsSelectd(false);
			}
			designer.builder.resetDashBoxPos(); // 展现隐藏树后调整虚线框位置
		},
		type : 'cmd',
		shortcut : 'R',
		select: true,
		isAdvanced: false
	};
_Designer_Index_Object['rightName'] = 1;
Designer_Config.buttons.control.push("right");
Designer_Config.buttons.tree.push("rightTree");

Designer_Menus.add.menu['right'] = Designer_Config.operations['right'];

// ===================== 权限树
Designer_RightTreePanel = function() {
	this.domElement = document.createElement('div');
}

function Designer_RightTreePanel_SetRightScene(value, designerId, isDraft) {
	Designer_Right_Scene = value;
	Designer_Right_isDraft = isDraft ? true : false;
	var designer = typeof designerId == 'string' ? (new Function('return ' + designerId))() : designerId;
	Designer_Control_Rigth_LoopRightControls(designer.builder.controls, function(c) {
		c.showRightDefaultCell();
	});
}

function Designer_RightTreePanel_EnableNodeSelect(value, designerId) {
	Designer_Right_Scene = (value == '0' ? 'g' : value);
	Designer_RightTreePanel_SetRightScene(Designer_Right_Scene, designerId, false);
}

function Designer_RightTreePanel_HiddenTreePanel(designer) {
	designer.toolBar.cancelSelect();
	var bts = designer.toolBar.buttons;
	for (var i = 0; i < bts.length; i ++) {
		if ('rightTree' == bts[i].name) {
			bts[i].setAsSelectd(false);
		}
	}
	Designer_Control_RigthTree.close();
	Designer_Control_Rigth_LoopRightControls(designer.builder.controls, function(c) {
		c.showRightConfig(false);
		c.showRightDefaultCell();
	});
	designer.builder.resetDashBoxPos(); // 展现隐藏树后调整虚线框位置
}

Designer_RightTreePanel_Prototype = {
	init : function(panel) {
		this._init(panel);
		this.setTitle(Designer_Lang.treeRightTreeTitle);
		//panel.canHidden = false;
		//panel.canDrag = false;
		//panel.domElement.style.position = 'static';
		//panel.domElement.style.top = '0';
		//panel.domElement.style.marginTop = document.body.scrollTop + 'px';
		
		// 浮动定位
		panel.domElement.style.left = document.body.scrollLeft + 'px';
		panel.domElement.style.right = 'auto';
		
		var _domElement = panel.domElement;
		/*
		Designer.addEvent(window , 'scroll' , function() {
			//_domElement.style.marginTop = document.body.scrollTop + 'px';
			// 浮动定位
			if  (_domElement._clientTop != null) {
				_domElement.style.top = parseInt(_domElement._clientTop) + document.body.scrollTop + 'px';
			}
		});
		*/
		var designer = panel.owner;
		designer.addListener('setHtml', Designer_RightTreePanel_HiddenTreePanel);
		designer.addListener('designerBlur', Designer_RightTreePanel_HiddenTreePanel);
	},
	initTitle : function() {
		this.title = document.createElement('div');
		this.title.className = 'panel_title';
		var html = '<div class="panel_title_left"><div class="panel_title_right"></div><div class="panel_title_center">'
			+ '<div class="panel_title_text"><div></div></div>';
		this.panel.drawTitle(this.title);
		this.title.innerHTML = html;
	},
	draw : function(panel) {
		if (this.panel.isClosed) return; // 不执行操作
		_right_tree_panel = new dTree('_right_tree_panel');
		this.tree = _right_tree_panel;
		this.buildTree(this.getWfNodes(), -1);
		this.mainBox.innerHTML = '<div>'+ this.tree.toString()+'</div>';
		if (this.mainBox.offsetHeight > 300) {
			this.mainBox.style.height = '300px';
			this.mainBox.style.overflow = 'auto';
		}
		this.mainBox.style.position = 'relative'
		this.mainWrap.style.height = this.mainBox.offsetHeight + 'px';
		Designer_RightTreePanel_EnableNodeSelect('0', this.panel.owner.id);
	},
	addNode : function(pid, name, title, action) {
		var nodeId = this.getNodeId();
		var onclick = action ? 'javascript:' + action : 'javascript:void(0)';
		var node = this.tree.add(
			nodeId, // id
			pid, // pid
			name, // name
			onclick,
			title, // title
			null, // target
			null, // icon
			null, // iconOpen
			true, // iconOpen
			null // dbclick
		);
		node.iconDraw = function(node) {
			return '<span style="background:url(style/img/icon.gif) no-repeat 0 -656;width:16px;height:16px;"></span>';
		};
		return nodeId;
	},
	buildTree : function(nodes, pid) {//Designer_RightTreePanel_HighLightNode(this);
		this.addNode(pid, 
				'<input type="radio" name="_c" value="0" checked '
				+'onclick="Designer_RightTreePanel_EnableNodeSelect(this.value,'+
				this.panel.owner.id+');"><label onclick="this.previousSibling.click();">'+Designer_Lang.treeRightTreeDefaultText+'</label>', 
				Designer_Lang.treeRightTreeDefaultAlt);
		
		if (nodes != null && nodes.length > 0) {
			var nid = this.addNode(pid, 
					'<input type="radio" name="_c" value="d" '
					+'onclick="Designer_RightTreePanel_EnableNodeSelect(this.value,'+
					this.panel.owner.id+');"><label onclick="this.previousSibling.click();">'+Designer_Lang.treeRightTreeWfText+'</label>', 
					Designer_Lang.treeRightTreeWfAlt);
			
			for (var i = 0; i < nodes.length; i ++) {
				var node = nodes[i];
				this.addNode(nid, 
						'<input type="radio" name="_c" value="'+node.value
						+'" onclick="Designer_RightTreePanel_SetRightScene(this.value,'+
						this.panel.owner.id+','+(node.type.indexOf('draft') > -1)+');" '
						//+(i == 0 ? ' checked ' : '')
						+'><label onclick="this.previousSibling.click();">' + node.name + '</label>', 
						node.value + ':' + node.name + ' - ' + Designer_Lang.treeRightTreeHandlerAlt);
			}
		}
	},
	getWfNodes : function() { // 调用流程方法
		if (window.XForm_GetWfAuditNodes == null) {
			return [];
		}
		return XForm_GetWfAuditNodes();
	}
}

Com_AddEventListener(window, 'load', function() {
	Designer.extend(Designer_RightTreePanel.prototype, Designer_TreePanel.prototype);
	Designer_RightTreePanel.prototype._init = Designer_RightTreePanel.prototype.init;
	Designer.extend(Designer_RightTreePanel.prototype, Designer_RightTreePanel_Prototype);
});

