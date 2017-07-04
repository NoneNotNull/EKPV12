/*
执行操作
*/

function Designer_OptionRun_Alert(msg) {
	alert(msg);
}
function Designer_OptionRun_Copy(designer) {
	if (designer.control && !designer.control.container) {
		var controlstr = ['{type:"', designer.control.type, '",values:'];
		var buf = [];
		for (var name in designer.control.options.values) {
			buf.push(name + ':"' + designer.control.options.values[name] + '"');
		}
		controlstr.push('{' , buf.join(',').replace(/\r\n/ig,'\\r\\n') , '}', '}');
		designer.cache.set('control', controlstr.join(''));
	} else if (!designer.control) {
		Designer_OptionRun_Alert(Designer_Lang.buttonsCopyNotNull);
	} else if (designer.control.container) {
		Designer_OptionRun_Alert(Designer_Lang.buttonsCopyNotContainer);
	}
}

function Designer_OptionRun_Paste(designer) {
	designer.cache.get('control', function(has, val) {
		if (has) {
			var control_values = eval('(' + val + ')');
			if(!control_values){
				Designer_OptionRun_Alert(Designer_Lang.buttonsCopyNotNull);
				return;
			}
			var control = new Designer_Control(this.builder, control_values.type, false);
			//设置初始值
			control.options.values = control_values.values;
			control.options.values.id = null;
			var dom = null;
			if (this.control != null && !this.control.container) {
				dom = this.control.options.domElement.parentNode;
				this.control.destroy();
			}
			this.builder.createControl(control, dom);
		}
	}, designer);
}

function Designer_OptionRun_CallControlFunction(designer, funName, noControlMessage) {
	Designer_OptionRun_CallFunction(designer, function(control) {
		if (control[funName]) {
			control[funName]();
			return true;
		} else {
			return false;
		}
	}, noControlMessage);
}

function Designer_OptionRun_CallFunction(designer, fn, noControlMessage) {
	if (designer.controls && designer.controls.length > 0) {
		var noCallControl = true;
		for (var i = designer.controls.length - 1; i >= 0; i--) {
			if (fn(designer.controls[i])) {
				noCallControl = false;
			}
		}
		if (noCallControl) {
			Designer_OptionRun_Alert(noControlMessage ? noControlMessage : Designer_Lang.buttonsSelectControl);
		}
	} else if (designer.control) {
		if (!fn(designer.control)) {
			Designer_OptionRun_Alert(noControlMessage ? noControlMessage : Designer_Lang.buttonsSelectControl);
		}
	} else {
		Designer_OptionRun_Alert(noControlMessage ? noControlMessage : Designer_Lang.buttonsSelectOptControl);
	}
}

function Designer_OptionRun_Delete_DoDelete(control) {
	if (!control.container) {
		control.destroy();
	}
	return true;
}

function Designer_OptionRun_Delete(designer) {
	if(!designer.control){
		Designer_OptionRun_Alert(Designer_Lang.buttonsDeleteHint);
	}
	else if (designer.controls.length == 1 &&designer.control.container) {//删除容器
		var msg = designer.control.destroyMessage ? designer.control.destroyMessage : Designer_Lang.buttonsDeleteTable;
		if (confirm(msg)) {
			designer.control.destroy();
		}
	} else if (designer.controls.length > 0 && confirm(Designer_Lang.buttonsDeleteControl)) {
		Designer_OptionRun_CallFunction(designer, Designer_OptionRun_Delete_DoDelete);
		designer.builder.clearSelectedControl();
	} else if (designer.control == null) {
		Designer_OptionRun_Alert(Designer_Lang.buttonsDeleteHint);
	}
}

function Designer_OptionRun_ExpBuilder(designer) {
	if (window.parent) {
		var f = self.frameElement;
		f.style.height = f.clientHeight + 50 + 'px';
		designer.adjustBuildArea();
	}
}

function Designer_OptionRun_CutBuilder(designer) {
	if (window.parent) {
		var f = self.frameElement;
		var height = f.clientHeight - 50;
		if (height < 300) {
			height = 300;
		}
		f.style.height = height + 'px';
		designer.adjustBuildArea();
	}
}

function Designer_OptionRun_InsertRow(designer) {
	if (designer.control && designer.control.insertRow) {
		designer.control.insertRow();
	} else {
		Designer_OptionRun_Alert(Designer_Lang.buttonsInsertRowAlert);
	}
}

function Designer_OptionRun_InsertLabelRow(designer) {
	if (designer.control && designer.control.insertLabelRow) {
		designer.control.insertLabelRow();
	} else {
		Designer_OptionRun_Alert(Designer_Lang.buttonsInsertRowAlert);
	}
}

function Designer_OptionRun_AppendRow(designer) {
	if (designer.control && designer.control.appendRow) {
		designer.control.appendRow();
	} else {
		Designer_OptionRun_Alert(Designer_Lang.buttonsAppendRowAlert);
	}
}

function Designer_OptionRun_AppendLabelRow(designer) {
	if (designer.control && designer.control.appendLabelRow) {
		designer.control.appendLabelRow();
	} else {
		Designer_OptionRun_Alert(Designer_Lang.buttonsAppendRowAlert);
	}
}

function Designer_OptionRun_DeleteRow(designer) {
	if (designer.control && designer.control.deleteRow) {
		designer.control.deleteRow();
	} else if (designer.control == null) {
		Designer_OptionRun_Alert(Designer_Lang.buttonsDeleteRowAlert);
	}
}

function Designer_OptionRun_DeleteLabelRow(designer) {
	if (designer.control && designer.control.deleteLabelRow) {
		designer.control.deleteLabelRow();
	} else if (designer.control == null) {
		Designer_OptionRun_Alert(Designer_Lang.buttonsDeleteRowAlert);
	}
}

function Designer_OptionRun_ModifyLabelTitle(designer) {
	if (designer.control && designer.control.modifyLabelTitle) {
		designer.control.modifyLabelTitle();
	} else if (designer.control == null) {
		Designer_OptionRun_Alert(Designer_Lang.buttonsDeleteRowAlert);
	}
}

function Designer_OptionRun_InsertCol(designer) {
	if (designer.control && designer.control.insertColumn) {
		designer.control.insertColumn();
	} else {
		Designer_OptionRun_Alert(Designer_Lang.buttonsInsertColAlert);
	}
}

function Designer_OptionRun_AppendCol(designer) {
	if (designer.control && designer.control.appendColumn) {
		designer.control.appendColumn();
	} else {
		Designer_OptionRun_Alert(Designer_Lang.buttonsAppendColAlert);
	}
}

function Designer_OptionRun_DeleteCol(designer) {
	if (designer.control && designer.control.deleteColumn) {
		designer.control.deleteColumn();
	} else if (designer.control == null) {
		Designer_OptionRun_Alert(Designer_Lang.buttonsDeleteColAlert);
	}
}

function Designer_OptionRun_UniteCell(designer) {
	if (designer.control && designer.control.merge) {
		designer.control.merge();
	} else {
		Designer_OptionRun_Alert(Designer_Lang.buttonsUniteCellAlert);
	}
}

function Designer_OptionRun_SplitCell(designer) {
	if (designer.control && designer.control.split) {
		designer.control.split();
	} else {
		Designer_OptionRun_Alert(Designer_Lang.buttonsSplitCellAlert);
	}
}

function Designer_OptionRun_OpenFontColor(designer, obj) {
	if (designer.control == null) {
		Designer_OptionRun_Alert(Designer_Lang.buttonsOpenFontColorAlert);
		return;
	}
	var ps = Designer.absPosition(obj.domElement);
	var color = designer.control.getColor ? designer.control.getColor() : false;
	Designer_AttrPanel.colorPanelInit();
	Designer_AttrPanel.colorPanel.open(
			(color ? color : '#000'),
			function(value, designer) {
				Designer_OptionRun_CallFunction(designer, function(control) {
					if (control.setColor) {
						control.setColor(value);
						return true;
					}
					return false;
				});
			},
			designer, 
			ps.x , ps.y + obj.domElement.offsetHeight
	);
}

function Designer_OptionRun_SetAlign(designer, value) {
	if (designer.control) {
		if (designer.control.selectedDomElement.length > 0) {
			for (var i = 0, l = designer.control.selectedDomElement.length; i < l; i++) {
				designer.control.selectedDomElement[i].align = value;
			}
		} else if (designer.controls.length > 0) {
			for (var i = 0, l = designer.controls.length; i < l; i++) {
				var c = designer.controls[i];
				if (c.options.domElement.parentNode && c.options.domElement.parentNode.tagName == 'TD') {
					c.options.domElement.parentNode.align = value;
				}
			}
		}
		designer.builder.resetDashBoxPos();
	} else {
		Designer_OptionRun_Alert(Designer_Lang.buttonsSetAlignAlert);
	}
}

/**
 * 操作配置
 */
Designer_Config.operations = {
	copy: {
		imgIndex : 24,
		title : Designer_Lang.buttonsCopy,
		run : Designer_OptionRun_Copy,
		type : 'cmd',
		hotkey : 'ctrl+c',
		hotkeyName : 'Ctrl + C',
		validate : function(designer) {
			return designer.control != null;
		}
	},
	paste: {
		imgIndex : 25,
		title : Designer_Lang.buttonsPaste,
		run : Designer_OptionRun_Paste,
		type : 'cmd',
		hotkey : 'ctrl+v',
		hotkeyName : 'Ctrl + V',
		validate : function(designer) {
			var rtn = false;
			designer.cache.get('control', function(has, val) {
				rtn = has;
			}, designer);
			rtn = rtn && designer.control && designer.control.container && designer.control.selectedDomElement;
			return rtn;
		}
	},
	deleteElem: {
		imgIndex : 10,
		title : Designer_Lang.buttonsDeleteElem,
		run : Designer_OptionRun_Delete,
		type : 'cmd',
		hotkey : 'delete',
		hotkeyName : 'Delete',
		validate : function(designer) {
			return designer.control || (designer.controls.length > 0);
		}
	},
	attribute : {
		imgIndex : 12,
		title : Designer_Lang.buttonsAttribute,
		run : function (designer) {
			designer.attrPanel.show();
		},
		type : 'cmd',
		hotkey : 'shift+r',
		hotkeyName : 'Shift + R'
	},
	tree: {
		imgIndex : 11,
		title : Designer_Lang.buttonsTree,
		run : function (designer) {
			designer.treePanel.open();
		},
		type : 'cmd',
		hotkey : 'shift+t',
		hotkeyName : 'Shift + T'
	},
	table : {
		imgIndex : 1,
		title : Designer_Lang.buttonsTable,
		run : function (designer) {
			designer.builder.createControl('standardTable');
		},
		type : 'cmd',
		shortcut : 'T'
	},
	textLabel : {
		imgIndex : 9,
		title : Designer_Lang.buttonsTextLabel,
		run : function (designer) {
			designer.toolBar.selectButton('textLabel');
		},
		type : 'cmd',
		shortcut : 'L',
		select: true,
		cursorImg: 'style/cursor/textLabel.cur'
	},
	linkLabel : {
		imgIndex : 38,
		title : Designer_Lang.buttonsLinkLabel,
		run : function (designer) {
			designer.toolBar.selectButton('linkLabel');
		},
		type : 'cmd',
		shortcut : 'K',
		select: true,
		cursorImg: 'style/cursor/linkLabel.cur'
	},
	inputText: {
		imgIndex : 14,
		title : Designer_Lang.buttonsInputText,
		run : function (designer) {
			designer.toolBar.selectButton('inputText');
		},
		type : 'cmd',
		shortcut : 'I',
		sampleImg : 'style/img/input.bmp',
		select: true,
		cursorImg: 'style/cursor/inputText.cur'
	},
	textarea: {
		imgIndex : 15,
		title : Designer_Lang.buttonsTextarea,
		run : function (designer) {
			designer.toolBar.selectButton('textarea');
		},
		type : 'cmd',
		shortcut : 'E',
		sampleImg : 'style/img/textarea.bmp',
		select: true,
		cursorImg: 'style/cursor/textarea.cur'
	},
	inputRadio: {
		lab : "2",
		imgIndex : 16,
		title : Designer_Lang.buttonsInputRadio,
		run : function (designer) {
			designer.toolBar.selectButton('inputRadio');
		},
		type : 'cmd',
		shortcut : 'R',
		sampleImg : 'style/img/radio.jpg',
		select: true,
		cursorImg: 'style/cursor/inputRadio.cur'
	},
	inputCheckbox: {
		lab : "2",
		imgIndex : 17,
		title : Designer_Lang.buttonsInputCheckbox,
		run : function (designer) {
			designer.toolBar.selectButton('inputCheckbox');
		},
		type : 'cmd',
		shortcut : 'C',
		sampleImg : 'style/img/checkbox.jpg',
		select: true,
		cursorImg: 'style/cursor/inputCheckbox.cur'
	},
	select : {
		lab : "2",
		imgIndex : 18,
		title : Designer_Lang.buttonsSelect,
		run : function (designer) {
			designer.toolBar.selectButton('select');
		},
		type : 'cmd',
		shortcut : 'S',
		sampleImg : 'style/img/select.jpg',
		select: true,
		cursorImg: 'style/cursor/select.cur'
	},
	rtf: {
		lab : "2",
		imgIndex : 19,
		title : Designer_Lang.buttonsRtf,
		run : function (designer) {
			designer.toolBar.selectButton('rtf');
		},
		type : 'cmd',
		shortcut : 'F',
		sampleImg : 'style/img/rtf.jpg',
		select: true,
		cursorImg: 'style/cursor/rtf.cur'
	},
	attachment: {
		lab : "2",
		imgIndex : 20,
		title : Designer_Lang.buttonsAttachment,
		run : function (designer) {
			designer.toolBar.selectButton('attachment');
		},
		type : 'cmd',
		shortcut : 'H',
		sampleImg : 'style/img/attachment.bmp',
		cursorImg: 'style/cursor/rtf.cur',
		select: true
	},
	address : {
		lab : "2",
		imgIndex : 21,
		title : Designer_Lang.buttonsAddress,
		run : function (designer) {
			designer.toolBar.selectButton('address');
		},
		type : 'cmd',
		shortcut : 'A',
		sampleImg : 'style/img/address.bmp',
		select: true,
		cursorImg: 'style/cursor/address.cur'
	},
	datetime: {
		lab : "2",
		imgIndex : 22,
		title : Designer_Lang.buttonsDatetime,
		run : function (designer) {
			designer.toolBar.selectButton('datetime');
		},
		type : 'cmd',
		shortcut : 'D',
		sampleImg : 'style/img/date.jpg',
		select: true,
		cursorImg: 'style/cursor/datetime.cur'
	},
	jsp: {
		lab : "2",
		imgIndex : 30,
		title : Designer_Lang.buttonsJsp,
		run : function (designer) {
			designer.toolBar.selectButton('jsp');
		},
		type : 'cmd',
		shortcut : 'J',
		select: true,
		cursorImg: 'style/cursor/jsp.cur',
		isAdvanced: true,
		validate : function(designer) {
			return designer.toolBar.isShowAdvancedButton;
		}
	},
	insertRow : {
		lab : "3",
		imgIndex : 3,
		title : Designer_Lang.buttonsInsertRow,
		run : Designer_OptionRun_InsertRow,
		type : 'cmd',
		shortcut : 'I'
	},
	appendRow : {
		lab : "3",
		imgIndex : 28,
		title : Designer_Lang.buttonsAppendRow,
		run : Designer_OptionRun_AppendRow,
		type : 'cmd',
		shortcut : 'A'
	},
	deleteRow: {
		lab : "3",
		imgIndex : 4,
		title : Designer_Lang.buttonsDeleteRow,
		run : Designer_OptionRun_DeleteRow,
		type : 'cmd',
		shortcut : 'D'
	},
	insertCol: {
		lab : "3",
		imgIndex : 5,
		title : Designer_Lang.buttonsInsertCol,
		run : Designer_OptionRun_InsertCol,
		type : 'cmd',
		shortcut : 'J'
	},
	appendCol : {
		lab : "3",
		imgIndex : 29,
		title : Designer_Lang.buttonsAppendCol,
		run : Designer_OptionRun_AppendCol,
		type : 'cmd',
		shortcut : 'B'
	},
	deleteCol : {
		lab : "3",
		imgIndex : 6,
		title : Designer_Lang.buttonsDeleteCol,
		run : Designer_OptionRun_DeleteCol,
		type : 'cmd',
		shortcut : 'E'
	},
	uniteCell: {
		lab : "3",
		imgIndex : 7,
		title : Designer_Lang.buttonsUniteCell,
		run : Designer_OptionRun_UniteCell,
		type : 'cmd',
		shortcut : 'U'
	},
	splitCell: {
		lab : "3",
		imgIndex : 8,
		title : Designer_Lang.buttonsSplitCell,
		run : Designer_OptionRun_SplitCell,
		type : 'cmd',
		shortcut : 'S'
	},
	bold: {
		lab : "4",
		imgIndex : 31,
		title : Designer_Lang.buttonsBold,
		run : function (designer) {
			Designer_OptionRun_CallControlFunction(designer, 'setBold', Designer_Lang.buttonsTextMSelectAlert);
		}
	},
	italic: {
		lab : "4",
		imgIndex : 32,
		title : Designer_Lang.buttonsItalic,
		run : function (designer) {
			Designer_OptionRun_CallControlFunction(designer, 'setItalic', Designer_Lang.buttonsTextMSelectAlert);
		}
	},
	underline: {
		lab : "4",
		imgIndex : 34,
		title : Designer_Lang.buttonsUnderline,
		run : function (designer) {
			Designer_OptionRun_CallControlFunction(designer, 'setUnderline', Designer_Lang.buttonsTextMSelectAlert);
		}
	},
	fontColor : {
		lab : "4",
		imgIndex : 33,
		title : Designer_Lang.buttonsFontColor,
		run : Designer_OptionRun_OpenFontColor
	},
	fontStyle : {
		lab : "4",
		imgIndex : 33,
		//多浏览器支持 控制工具按钮栏宽度 作者 曹映辉 #日期 2014年9月22日
		domWidth:'auto',
		title : Designer_Lang.buttonsFontStyle,
		childElem : function(designer) {
			var rtn = document.createElement('div');
			var select = document.createElement('select');
			select.id = '_designer_font_style_';
			var fontStyle = Designer_Config.font.style;
			for (var i = 0, l = fontStyle.length; i < l; i ++) {
				select.add(new Option(fontStyle[i].text, fontStyle[i].value));
			}
			rtn.appendChild(select);
			rtn.style.padding = '2px';
			select.onchange = function() {
				Designer_OptionRun_CallFunction(designer, function(control) {
					if (control.setFontStyle) {
						control.setFontStyle(select.value);
						return true;
					}
					return false;
				}, Designer_Lang.buttonsTextSelectAlert);
			}
			return rtn;
		},
		onSelectControl : function(designer) {
			var select = document.getElementById('_designer_font_style_');
			if (designer.control && designer.control.getFontStyle) {
				var fontStyle = designer.control.getFontStyle();
				select.value = fontStyle ? fontStyle : '';
			} else {
				select.value = '';
			}
		}
	},
	fontSize : {
		lab : "4",
		imgIndex : 33,
		//多浏览器支持 控制工具按钮栏宽度 作者 曹映辉 #日期 2014年9月22日
		domWidth:'auto',
		title : Designer_Lang.buttonsFontSize,
		childElem : function(designer) {
			var rtn = document.createElement('div');
			var select = document.createElement('select');
			select.id = '_designer_font_size_';
			var fontSize = Designer_Config.font.size;
			for (var i = 0, l = fontSize.length; i < l; i ++) {
				select.add(new Option(fontSize[i].text, fontSize[i].value));
			}
			rtn.appendChild(select);
			rtn.style.padding = '2px';
			select.onchange = function() {
				Designer_OptionRun_CallFunction(designer, function(control) {
					if (control.setFontSize) {
						control.setFontSize(select.value);
						return true;
					}
					return false;
				}, Designer_Lang.buttonsTextSelectAlert);
			}
			return rtn;
		},
		onSelectControl : function(designer) {
			var select = document.getElementById('_designer_font_size_');
			if (designer.control && designer.control.getFontSize) {
				var fontSize = designer.control.getFontSize();
				select.value = fontSize ? fontSize : '';
			} else {
				select.value = '';
			}
		}
	},
	alignLeft : {
		lab : "4",
		imgIndex : 35,
		title : Designer_Lang.buttonsAlignLeft,
		run : function (designer) {
			Designer_OptionRun_SetAlign(designer, "left");
		}
	},
	alignCenter : {
		lab : "4",
		imgIndex : 36,
		title : Designer_Lang.buttonsAlignCenter,
		run : function (designer) {
			Designer_OptionRun_SetAlign(designer, "center");
		}
	},
	alignRight : {
		lab : "4",
		imgIndex : 37,
		title : Designer_Lang.buttonsAlignRight,
		run : function (designer) {
			Designer_OptionRun_SetAlign(designer, "right");
		}
	},
	expBuilder: {
		lab : "5",
		imgIndex : 26,
		title : Designer_Lang.buttonsExpBuilder,
		run : Designer_OptionRun_ExpBuilder,
		type : 'cmd',
		hotkey : 'shift+down',
		hotkeyName : 'Shift + &darr;'
	},
	cutBuilder: {
		lab : "5",
		imgIndex : 27,
		title : Designer_Lang.buttonsCutBuilder,
		run : Designer_OptionRun_CutBuilder,
		type : 'cmd',
		hotkey : 'shift+up',
		hotkeyName : 'Shift + &uarr;'
	},
	showAdvanced: {
		lab : "5",
		imgIndex : 39,
		title : Designer_Lang.buttonsShowAdvanced,
		run : function(designer, button) {
			button.setAsSelectd(!button.selected);
			if (button.selected)
				designer.toolBar.showAdvancedButton();
			else
				designer.toolBar.hideAdvancedButton();
			designer.adjustBuildArea();
		}
	},
	fullSreen: {
		lab : "5",
		imgIndex : -1,
		title : Designer_Lang.button_fullScreen,
		run : function(designer, button) {
			if (window.parentIframe == null) { return; }
			button.setAsSelectd(!button.selected);
			if (button.selected) {
				button.oldHeight = parentIframe.height;
				button.oldWidth = parentIframe.width;
				parentIframe.style.position = "absolute";
				parentIframe.style.zIndex = "9999";
				parentIframe.style.top = '0px';
				parentIframe.style.left = '0px';
				parentIframe.width = parent.document.body.clientWidth;
				parentIframe.height = parent.document.body.clientHeight;
				Designer.addEvent(parent, 'resize', Designer_Config.operations.fullSreen.onResizeFun);
			} else {
				Designer.removeEvent(parent, 'resize', Designer_Config.operations.fullSreen.onResizeFun);
				parentIframe.style.position = "";
				parentIframe.style.zIndex = "1";
				parentIframe.height = button.oldHeight;
				parentIframe.width = button.oldWidth;
			}
			designer.adjustBuildArea();
		},
		onResizeFun : function() {
			parentIframe.width = parent.document.body.clientWidth;
			parentIframe.height = parent.document.body.clientHeight;
		}
	}
 };


/**
 * 按钮
 */
Designer_Config.buttons = {
	common : ['copy', 'paste', 'deleteElem', 'attribute'],
	control : ['table', 'textLabel', 'linkLabel', 'inputText', 'textarea', 'inputRadio', 'inputCheckbox', 'select', 'rtf', 'attachment', 'address', 'datetime', 'jsp'],
	table : ['insertRow', 'appendRow', 'deleteRow', 'insertCol', 'appendCol', 'deleteCol', 'uniteCell', 'splitCell'],
	font : ['bold', 'italic', 'underline', 'fontColor', 'fontStyle', 'fontSize', 'alignLeft', 'alignCenter', 'alignRight'],
	builder : ['expBuilder', 'cutBuilder'],
	tree : ['tree'],
	more: ['showAdvanced']
};


/**
 * 菜单
 */
Designer_Menus = {
	add : {
		title : Designer_Lang.menusAdd,
		type : 'menu',
		menu : {
			textLabel : Designer_Config.operations.textLabel,
			inputText : Designer_Config.operations.inputText,
			textarea : Designer_Config.operations.textarea,
			inputRadio: Designer_Config.operations.inputRadio,
			inputCheckbox: Designer_Config.operations.inputCheckbox,
			select : Designer_Config.operations.select,
			rtf: Designer_Config.operations.rtf,
			attachment: Designer_Config.operations.attachment,
			address : Designer_Config.operations.address,
			datetime: Designer_Config.operations.datetime,
			jsp: Designer_Config.operations.jsp
		}
	},
	line1 : {type:'line'},
	attribute : Designer_Config.operations.attribute,
	tree: Designer_Config.operations.tree,
	copy : Designer_Config.operations.copy,
	paste : Designer_Config.operations.paste,
	deleteElem: Designer_Config.operations.deleteElem,
	show: {
		title : Designer_Lang.menusShow,
		type : 'menu',
		menu : {
			expBuilder : Designer_Config.operations.expBuilder,
			cutBuilder : Designer_Config.operations.cutBuilder
		}
	},
	line2 : {type:'line'},
	table: {
		title : Designer_Lang.menusTable,
		type : 'menu',
		validate : function(designer) {
			return designer.control && designer.control.options.domElement&&designer.control.options.domElement.tagName == 'TABLE';
		},
		menu : {
			insertRow : Designer_Config.operations.insertRow,
			appendRow : Designer_Config.operations.appendRow,
			deleteRow: Designer_Config.operations.deleteRow,
			insertCol: Designer_Config.operations.insertCol,
			appendCol : Designer_Config.operations.appendCol,
			deleteCol : Designer_Config.operations.deleteCol,
			uniteCell: Designer_Config.operations.uniteCell,
			splitCell: Designer_Config.operations.splitCell
		}
	}
};