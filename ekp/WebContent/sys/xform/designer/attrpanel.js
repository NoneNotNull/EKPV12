/**
 * 属性面板
 */

var Designer_AttrPanel = function() {
	this.domElement = document.createElement('div');
}

Designer_AttrPanel.prototype = {
	
	init : function(panel) {
		this.textIndex = 1;
		this.isControl = true;
		this.panel = panel;
		this.initTitle();
		this.initMain();
		this.initBottom();
		this.initFormChange();
		
		this.setNoSelectInfo();
		var self = this;
		this.panel.draw = function(c) {
			self.draw(c);
			
		};
		
		this.panel.focusPanel = function() {
			self.focusPanel();
		};
		Designer.addEvent(this.panel.domElement, 'mousedown', function(event) {
			event = event ? event : window.event;
			event.cancelBubble = true; // ==========防止传递到设计区
			self.panel.owner._doFocus(self);
		});
	},

	initTitle : Designer_Panel_Default_TitleDraw,
	
	initMain : function() {
		var self = this;
		this.mainWrap = document.createElement('div');
		this.mainWrap.className = 'panel_main';
		this.mainBox = document.createElement('div');
		this.mainBox.className = 'panel_main_box';
		with((this.panelForm = document.createElement('form')).style) {
			margin = '0'; padding = '0';
		}
		this.panelForm.designerId = this.panel.owner.id;
		this.mainWrap.appendChild(this.mainBox);
		this.panelForm.appendChild(this.mainWrap);
		this.domElement.appendChild(this.panelForm);

		Designer.addEvent(this.panelForm, 'keyup', function(event) {
			event.cancelBubble = true;
			var dom = event.srcElement || event.target;
			if (event.keyCode == 13 && dom.tagName.toLowerCase() != 'textarea') {
				if (self.resetValues()) {
					self.hideBottom();
				}
			}
		});
	},

	initBottom : function() {
		var bottom = document.createElement('div');
		bottom.className = 'panel_bottom';
		var bottom_top = document.createElement('div');
		this.bottomBar = bottom_top;
		bottom_top.className = "panel_bottom_main";

		this.success = document.createElement('button');
		this.success.className = 'panel_success';
		this.success.style.margin = '2px 8px 0 0';
		this.success.title = Designer_Lang.attrpanelSuccess;
		this.success.value = "&nbsp;";
		
		this.apply = document.createElement('button');
		this.apply.className = 'panel_apply';
		this.apply.style.margin = '2px 8px 0 8px';
		this.apply.title = Designer_Lang.attrpanelApply;
		this.apply.value = "&nbsp;";

		this.cancel = document.createElement('button');
		this.cancel.className = 'panel_cancel';
		this.cancel.style.margin = '2px 0 0 8px';
		this.cancel.title = Designer_Lang.attrpanelCancel;
		this.cancel.value = "&nbsp;";

		var warpBox = document.createElement('div');
		warpBox.className = "panel_bottom_for_ie6"; // in ie6.css
		warpBox.appendChild(this.success);
		warpBox.appendChild(this.apply);
		warpBox.appendChild(this.cancel);
		bottom_top.appendChild(warpBox);

		bottom.appendChild(bottom_top);
		this.domElement.appendChild(bottom);
		this.initBottomBorder();
		this.initButtons();
	},

	initBottomBorder : Designer_Panel_Default_BottomDraw,

	initButtons : function() {
		var self = this;
		this.success.onclick = function() {
			
			if (self.resetValues()) {
				//增加属性面板成功关闭时的回调函数 作者 曹映辉 #日期 2014年5月15日
				var control = self.panel.owner.control;
				if(control&&control.onAttrSuccess){
					control.onAttrSuccess();
				}
				self.panel.close();
			}
		};

		this.apply.onclick = function() {
			if (self.resetValues()) {
				self.hideBottom();
			}
		};

		this.cancel.onclick = function() {
			self.reDraw();
		};
	},

	initFormChange : function() {
		var self = this;
		this._changed = false;
		Designer.addEvent(this.panelForm, 'keyup', function(event) {
			event.cancelBubble = true;
			if (self._changed) return;
			var dom = event.srcElement || event.target;
			var tagName = dom.tagName.toLowerCase();
			if (((tagName == 'input' && dom.type == 'text') || tagName == 'textarea')
				&& (dom.defaultValue != dom.value)) {
				self.showBottom();
				self._changed = true;
			}
		});
		Designer.addEvent(this.panelForm, 'mouseup', function(event) {
			event.cancelBubble = true;
			if (self._changed) return;
			var dom = event.srcElement || event.target;
			var tagName = dom.tagName.toLowerCase();
			if ((tagName == 'input' && (dom.type == 'checkbox' || dom.type == 'radio')) || tagName == 'a') {
				self.showBottom();
				self._changed = true;
			} else if (tagName == 'label' && dom['isfor'] == 'true') {
				self.showBottom();
				self._changed = true;
			}
		});
		var changeFun = function(event) {
			event = event || window.event;
			self.showBottom();
			self._changed = true;
			Designer.removeEvent(event.srcElement || event.target, "change", changeFun);
		}
		Designer.addEvent(this.panelForm, 'mousedown', function(event) {
//			event.cancelBubble = true;
			if (self._changed) return;
			var dom = event.srcElement || event.target;
			var tagName = dom.tagName.toLowerCase();
			if (tagName == 'select') {
				Designer.removeEvent(dom, "change", changeFun);
				Designer.addEvent(dom, "change", changeFun);
			}
		});
	},

	showMain : function() {
		this.domElement.style.display = '';
	},

	hideMain : function() {
		this.domElement.style.display = 'none';
	},

	showBottom : function() {
		this.bottomBar.style.display = '';
	},

	hideBottom : function() {
		this._changed = false;
		this.bottomBar.style.display = 'none';
		Designer_AttrPanel.colorPanelClose();
	},

	setMainInfo : function(info) {
		this.mainBox.innerHTML = '<div>' + info + '</div>';		
		//未开放标签表格前暂时屏蔽
		//增加 明细表初始化 add by limh 2011年1月24日
		DocListFunc_Init();
	},
	
	setTitle : Designer_Panel_Default_SetTitle,

	setNoSelectInfo : function() {
		this.setTitle(Designer_Lang.attrpanelTitle);
		this.setMainInfo(
			'<table class="panel_table_info"><tr><td style="text-align:center;">'+Designer_Lang.attrpanelNoSelect+'</td></tr></table>'
		);
		this.hideBottom();
	},

	setSuccessInfo : function() {
		this.setMainInfo(
			'<table class="panel_table_info"><tr><td style="text-align:center;">'+Designer_Lang.attrpanelSuccessUpdate+'</td></tr></table>'
		);
	},

	focusPanel : function() {
		var elems = this.panelForm.elements;
		if (elems && elems.length > 0) elems[0].focus();
	},
	
	onClosed: function() {
		Designer_AttrPanel.colorPanelClose();
	},

	reDraw : function() {
		this.draw(this.control);
	},

	draw : function() {
		var control = this.panel.owner.control;
		if (this.panel.isClosed) return; // 不执行操作
		if (control == null) {
			this.setNoSelectInfo();
		}
		else if (control.options.showAttr == null && control.selectedDomElement.length > 0) {
			if (control.domAttrs == null) return;
			this.isControl = false;
			this.setMainInfo(this.drawDomAttrs(control));
		}
		else {
			if (control.attrs == null) return;
			this.isControl = true;
			this.control = control;
			this.attrs = control.attrs;
			this.values = control.options.values || {};
			this.showAttr = control.options.showAttr ? control.options.showAttr : 'default';
			if (control.info) {
				this.setTitle(Designer_Lang.attrpanelTitlePrefix + control.info.name);
			}
			if (this.attrs.label && (this.values.label == null)) {
				this.values.label = this.textLabel ? this.textLabel : (control.info ? control.info.name + this.textIndex++ : "");
				this.panel.owner.treePanel.draw();
			}
			this.setMainInfo(this.drawAttrs());
			
		}
		if (control && control.onAttrLoad) control.onAttrLoad(this.panelForm, control);
		this.hideBottom();
		
	},

	drawDomAttrs : function(control) {
		var hasAttr = false;
		this.control = control;
		var dom = control.selectedDomElement[0];
		var tagName = dom.tagName.toLowerCase();
		this.attrs = control.domAttrs[tagName];
		if (control.info) {
			this.setTitle(Designer_Lang.attrpanelTitlePrefix + control.info.name + " - " + control.info[tagName]);
		}
		var html = '<table class="panel_table">';
		
		var domValues = {};
		for (var i = 0; i < control.selectedDomElement.length; i ++) {
			var _dom = control.selectedDomElement[i];
			if (i == 0) {
				for (var _name in this.attrs) {
					var domAttrName = (_name == 'className' ? "oldClassName" : _name);
					domValues[domAttrName] = _dom[domAttrName] == '' ? this.attrs[_name].value : _dom[domAttrName];
				}
			} else {
				for (var _name in this.attrs) {
					var domAttrName = (_name == 'className' ? "oldClassName" : _name);
					var _value = _dom[domAttrName] == '' ? this.attrs[_name].value : _dom[domAttrName];
					if (domValues[domAttrName] != _value) {
						domValues[domAttrName] = "$M$";
					}
				}
			}
		}

		for (var name in this.attrs) {
			var attr = this.attrs[name];
			var domAttrName = (name == 'className' ? "oldClassName" : name);
			html += Designer_AttrPanel[attr.type + 'Draw'](name, attr, domValues[domAttrName]);
			hasAttr = true;
		}
		if (!hasAttr) {
			html = Designer_AttrPanel.noAttrDraw();
		} else {
			html += '</table>';
		}
		dom = null;
		return html;
	},

	drawAttrs : function() {
		var html = '<table class="panel_table">';
		var hasAttr = false;
		for (var name in this.attrs) {
			var attr = this.attrs[name];
			var sa = attr.showAttr ? attr.showAttr : 'default';
			if (attr.show && (this.showAttr == 'all' || sa == this.showAttr)) {
				if (attr.type == 'self') {
					html += attr.draw(name, attr, this.values[name], this.panelForm, this.attrs, this.values, this.control);
				} else {
					html += Designer_AttrPanel[attr.type + 'Draw'](name, attr, this.values[name], this.panelForm, this.attrs, this.values, this.control);
				}
				hasAttr = true;
			}
		}
		if (this.values.id != null) {
			html += Designer_AttrPanel.idDraw(this.values.id, this.attrs);
			hasAttr = true;
		}
		if (!hasAttr) {
			html = Designer_AttrPanel.noAttrDraw();
		} else {
			html += '</table>';
		}
		return html;
	},

	onLeave : function() {
		return this.resetValues();
	},

	resetValues : function() {
		if (!this._changed) return true; // == 无修改不重设
		var elems = this.panelForm.elements;
		var setNewValues = false;
		var newValues = {};
		for (var i=0; i< elems.length;i++) {
			setNewValues = true;
			var elem = elems[i];
			var value = elem.value;
			var controls = [];
			if (elem.name == 'id') {
				if (typeof _Designer_Attr_AddAll_Controls != 'undefined' 
					&& typeof Designer_Attr_Id_ValidateValid != 'undefined') {
					_Designer_Attr_AddAll_Controls(this.panel.owner.builder.controls, controls);
	
					if (!Designer_Attr_Id_ValidateValid(elem.value, this.control, controls)) {
						alert(Designer_Lang.GetMessage(Designer_Lang.controlAttrValChkId,this.control.options.values.label));
						return false;
					}
					newValues[elem.name] = value;
					continue;
				} else {
					continue;
				}
			}
			if (elem.type == 'checkbox' && !elem.checked) {
				value = "false";
			}
			if (elem.type == 'radio' && !elem.checked) {
				continue;
			}
			else if (elem.multiple == true) {
				var _values = [];
				for (var j = 0; j < elem.options.length; j ++) {
					if (elem.options[j].selected) {
						_values.push(elem.options[j].value);
					}
				}
				if (_values.length > 0) {
					var splitStr = this.attrs[elem.name].splitStr;
					splitStr = splitStr ? splitStr : ';';
					value = _values.join(splitStr);
				}
			}
			if (elem.name != null && elem.name != "" && !elem.disabled) {
				if (elem.name.substr(0,1) == '_') {
					newValues[elem.name] = value;
					continue;
				}
				var attr = this.attrs[elem.name];
				if (attr && attr.validator) {
					if (attr.validator instanceof Array) {
						for (var ii = 0; ii < attr.validator.length; ii ++) {
							if (attr.validator[ii](elem, elem.name, attr, value, newValues, this.control)) {
								newValues[elem.name] = (attr.convertor) ?
									attr.convertor(elem.name, attr, value, newValues) : value;
							} else {
								return false; // === 不允许设值
							}
						}
					} else {
						if (attr.validator(elem, elem.name, attr, value, newValues, this.control)) {
							newValues[elem.name] = (attr.convertor) ?
								attr.convertor(elem.name, attr, value, newValues) : value;
						} else {
							return false; // === 不允许设值
						}
					}
				} else if(attr&&attr.convertor){
					newValues[elem.name] = attr.convertor(elem.name, attr, value, newValues) ;
				}
				else{
					newValues[elem.name] = value;
				}
			}
		}

		if (!this.isControl) {
			var doms = this.control.selectedDomElement;
			for (var i = 0; i < doms.length; i ++) {
				var dom = doms[i];
				for (var name in newValues) {
					// 空值不更新
					if (newValues[name] != '' && newValues[name] != null) {
						if (name != 'className'){
							
							if(name.indexOf('style_')>=0){
								if(newValues[name]=='null'){
									$(dom).css(name.replace("style_",""),"");
								}
								else{
									dom.style[name.replace("style_","")]=newValues[name];
								}
							}
							dom[name] = newValues[name];
						}
						else {
							dom["oldClassName"] = newValues[name];
						}
					}
				}
			}
			this._changed = false;
			return true;
		}

		//  === 修改控件属性
		for (var _name in newValues) {
			this.values[_name] = newValues[_name];
		}

		if (this.control != null && this.control.type == 'textLabel') {
			this.textLabel = this.values.content;
		}
		if (setNewValues) {
			this.control.options.values = this.values;
			this.panel.owner.builder.setProperty(this.control);
		}
		this._changed = false;
		return true;
	}
}

// ************* 属性静态绘制方法 ************

Designer_AttrPanel.idDraw = function(value, attrs) {
	return ('<tr><td width="25%" class="panel_td_title">ID</td><td>'
			//+'<label class="id_label" style="width:80%;background:#fff;height:20px;line-height:20px">'+ value + '</label>'
			+'<nobr><input style="width:78%;" class="inputread" readonly type="text" name="id" value="' + value + '" style="width:95%">'
			+'<input type="button" class="btnopt" onclick="Designer_AttrPanel_ShowIdEdit(this);" value="..."></nobr></td></tr>');
}

function Designer_AttrPanel_ShowIdEdit(dom) {
	if (confirm(Designer_Lang.modifyAttr)) {
		dom.style.display = 'none';
		var input = dom.previousSibling;
		input.style.width = '95%';
		input.className = '';
		input.readOnly = false;
	}
}

Designer_AttrPanel.noAttrDraw = function() {
	return '<table class="panel_table_info"><tr><td style="text-align:center;">'+Designer_Lang.attrpanelNoAttrs+'</td></tr>';
}

Designer_AttrPanel.wrapTitle = function(name, attr, value, html) {
	if (attr.required == true) {
		html += '<span class="txtstrong">*</span>';
	}
	if (attr.hint) {
		html = '<div id="attrHint_' + name + '">' + attr.hint + '</div>' + html;
	}
	return ('<tr><td width="25%" class="panel_td_title">' + attr.text + '</td><td>' + html + '</td></tr>');
}
//扩增帮助
Designer_AttrPanel.helpDraw = function(name, attr, value) {
	return ('<tr><td width="95%" class="panel_td_title" colspan=\'2\' align=\''+attr.align+'\'>' + attr.text + '</td></tr>');
}
Designer_AttrPanel.textDraw = function(name, attr, value) {
	var html = "<input type='text' style='width:95%' class='attr_td_text' name='" + name;
	if (attr.value != value && value != null) {
		html += "' value='" + value;
	} else {
		html += "' value='" + attr.value;
	}
	html += "'>";
	return Designer_AttrPanel.wrapTitle(name, attr, value, html);
}


Designer_AttrPanel.checkboxDraw = function(name, attr, value) {
	var html = "<input class='attr_td_checkbox' type='checkbox' name='" + name;
	html += "' value='true";
	if (value == null && attr.checked) {
			html += "' checked='checked";
	} else if (value == "true") {
			html += "' checked='checked";
	}
	if (attr.onclick) {
		html += "' onclick='" + attr.onclick;
	}
	html += "'>";
	return Designer_AttrPanel.wrapTitle(name, attr, value, html);
}

Designer_AttrPanel.checkGroupDraw = function(name, attr, value, form, attrs, values) {
	var html = '<input type="hidden" value="" name="' + name + '">';
	for (var i = 0, l = attr.opts.length; i < l; i ++) {
		var opt = attr.opts[i];
		html += '<label isfor="true"><input type="checkbox" value="true" name="' + opt.name + '"';
		if ((values[opt.name] == null && opt.checked) || values[opt.name] == "true") {
			html += ' checked="checked"';
		}
		if (opt.onclick != null) {
			html += ' onclick="' + opt.onclick + '"';
		}
		html += '>' + attr.opts[i].text + '</label><br>';
	}
	return Designer_AttrPanel.wrapTitle(name, attr, value, html);
}

Designer_AttrPanel.selectDraw = function(name, attr, value) {
	var html = "<select name='" + name +"'";
	if (attr.multi == true) {
		html += "' multiple='multiple' size='" + attr.size +"'";
	}
	if (attr.onchange) {
		html += " onchange=\"" + attr.onchange + "\"";
	}
	html += " class='attr_td_select' style='width:95%'>";
	if (attr.opts) {
		for (var i = 0; i < attr.opts.length; i ++) {
			var opt = attr.opts[i];
			html += "<option value='" + opt.value;
			if (opt.style) {
				html += "' style='" + opt.style;
			}
			if (opt.value == value) {
				html += "' selected='selected";
			} else if (value == null && attr.value == opt.value) {
				html += "' selected='selected";
			}
			html += "'>" + opt.text + "</option>";
		}
	}
	html += "</select>";
	return Designer_AttrPanel.wrapTitle(name, attr, value, html);
}

Designer_AttrPanel.radioDraw = function(name, attr, value) {
	var buff = [];
	if (attr.opts) {
		for (var i = 0; i < attr.opts.length; i ++) {
			var opt = attr.opts[i];
			buff.push('<label isfor="true"><input type="radio" name="', name, '"');
			if (opt.value == value) {
				buff.push(' checked="checked" ');
			} else if ((value == null || value == '') && attr.value == opt.value) {
				buff.push(' checked="checked" ');
			}
			buff.push(' value="', opt.value, '">', opt.text, '</label><br>');
		}
	}
	return Designer_AttrPanel.wrapTitle(name, attr, value, buff.join(''));
}

Designer_AttrPanel.textareaDraw = function(name, attr, value) {
	var html = "<textarea style='width:170px;' name='" + name + "' title='" + (attr.hint ? attr.hint : "")
		+ "' class='attr_td_textarea'>";
	if (value != null && value.length > 0) {
		html += value;
	}
	html += "</textarea>";
	return Designer_AttrPanel.wrapTitle(name, attr, value, html);
}

Designer_AttrPanel.hiddenDraw = function(name, attr, value) {
	return "<input type='hidden' name='" + name + "' value='" + attr.value + "'>";
}

Designer_AttrPanel.dateDraw = function(name, attr, value) {
	var html = (attr.hint ? (attr.hint + "<br>") : "");
	html += "<input type='text' style='width:85%' class='attr_td_text' readonly name='" + name;
	if (attr.value != value && value != null) {
		html += "' value='" + value;
	} else {
		html += "' value='";
	}
	html += "'><a href='#' onclick='selectDate(\"" + name + "\");return false;'>"+Designer_Lang.attrpanelSelect+"</a>";
	return Designer_AttrPanel.wrapTitle(name, attr, value, html);
}

Designer_AttrPanel.labelDraw = function(name, attr, value, form, attrs, values, control) {
	attr.required = false;
	var buff = [];
	buff.push('<input type="text" style="width:95%" class="attr_td_text" name="', name, '"');
	if (attr.value != value && value != null) {
		buff.push(' value="' , value, '"');
	}
	if (value == null || value == '') { // 为空时，取消绑定
		values._label_bind = 'false';
	}
	if (values._label_bind == 'true') {
		buff.push(' readonly ');
	}
	buff.push( '><span class="txtstrong">*</span><br><label onclick="Designer_AttrPanel.Label_Onclick(this);" isfor="true">',
			'<input type="checkbox" name="_label_bind" value="true" ');
	if (values._label_bind == 'true') {
		buff.push(' checked ');
	}
	var labelText = Designer_AttrPanel.GetParentRelateWay(control);
	switch (labelText) {
		case 'left' : labelText = Designer_Lang.attrpanelLeftLabel; break;
		case 'up' : labelText = Designer_Lang.attrpanelUpLabel; break;
		case 'right' : labelText = Designer_Lang.attrpanelRightLabel; break;
		case 'down' : labelText = Designer_Lang.attrpanelDownLabel; break;
		case 'self' : labelText = Designer_Lang.attrpanelSelfLabel; break;
	}
	buff.push('>',labelText,'</label>');
	return Designer_AttrPanel.wrapTitle(name, attr, value, buff.join(''));
}

//新增明细表类型属性绘画方法 lmh 2011年3月1日 
Designer_AttrPanel.tabledoclistDraw = function(name, attr, value,panelForm,attrs,values,control) {
	var tableId = "TABLE_DocList_XForm"+control.options.domElement.id;
	var isFoundTable = false;
	var i = DocList_Info.length;
	while (i--) {
        if (DocList_Info[i] === tableId) {
        	isFoundTable =  true;
        }
    }
	if(!isFoundTable){
		DocList_Info[DocList_Info.length] = tableId;
	}
	var html = "";	
	html += "<table id=\""+tableId+"\" class=\"tb_normal\" width=\"90%\">";
	html += "<tr>";
	html += "<td>"+Designer_Lang.attrPanelSerialNumber+"</td>";
	html += "<td>"+Designer_Lang.attrPanelInputTypeText+"</td>";
	html += "<td>";
	html += "<a href=\"#\" onclick=\"DocList_AddRow();\">"+Designer_Lang.attrPanelAddBtn+"</a>";
	html += "</td>";
	html += "</tr>";
	html += "<!--基准行-->";
	html += "<tr KMSS_IsReferRow=\"1\" style=\"display:none\">";
	html += "<td KMSS_IsRowIndex=\"1\"></td>";
	html += "<td><input class=\"inputSgl\"  name=\"labelTextField"+control.options.domElement.id+"\" value=\"\"><label id=\"LKS_LabelIndexField"+control.options.domElement.id+"\" style=\"display:none\">new</label></td>";
	html += "<td>";
	html += "<a href=\"#\" onclick=\"DocList_DeleteRow();\">"+Designer_Lang.attrPanelDelBtn+"</a>";
	html += "<a href=\"#\" onclick=\"DocList_MoveRow(-1);\">"+Designer_Lang.attrPanelMoveUp+"</a>";
	html += "<a href=\"#\" onclick=\"DocList_MoveRow(1);\">"+Designer_Lang.attrPanelMoveDown+"</a>";
	html += "</td>";
	html += "</tr>";
	html += "<!--内容行-->";
		for(var i=0;i<control.labelTextArray.length;i++){
			
			html += "<tr KMSS_IsContentRow=\"1\">";
			html += "<td KMSS_IsRowIndex=\"1\">"+ (i+1) +"</td>";
			html += "<td><input class=\"inputSgl\" name=\"labelTextField"+control.options.domElement.id+"\" value=\""+control.labelTextArray[i]+"\"><label id=\"LKS_LabelIndexField"+control.options.domElement.id+"\" style=\"display:none\">"+control.labelIndexArray[i]+"</label></td>";
			html += "<td>";
			html += "<a href=\"#\" onclick=\"DocList_DeleteRow();\">"+Designer_Lang.attrPanelDelBtn+"</a>";
			html += "	<a href=\"#\" onclick=\"DocList_MoveRow(-1);\">"+Designer_Lang.attrPanelMoveUp+"</a>";
			html += "<a href=\"#\" onclick=\"DocList_MoveRow(1);\">"+Designer_Lang.attrPanelMoveDown+"</a>";
			html += "</td>";
			html += "</tr>";
		}
	html += "</table>";
			//标明开始用属性面板修改标签页 limh 2011年3月3日 
	control.isAttrPanel = true;
	return Designer_AttrPanel.wrapTitle(name, attr, value, html);
}

Designer_AttrPanel.GetParentRelateWay = function(control) {
	var parent = control.parent;
	if (parent && parent.getTagName() == 'table') {
		return parent.getRelateWay ? parent.getRelateWay(control) : (parent.relatedWay ? parent.relatedWay : 'left');
	} else if (parent && parent.getTagName() == 'div') {
		return Designer_AttrPanel.GetParentRelateWay(parent);
	}
	return 'self';
};

Designer_AttrPanel.showButtons = function(dom) {
	var designer = (new Function('return ' + dom.form.designerId))();
	designer.attrPanel.panel._changed = true;
	designer.attrPanel.panel.showBottom();
}
Designer_AttrPanel.resetValues = function(dom) {
	var designer = (new Function('return ' + dom.form.designerId))();
	return designer.attrPanel.panel.resetValues();
}

Designer_AttrPanel.Label_Onclick = function(dom) {
	if (dom.firstChild.checked) {
		dom.parentNode.firstChild.readOnly = true;
		var text = "";
		var designer = (new Function('return ' + dom.form.designerId))();
		if (designer && designer.attrPanel && designer.attrPanel.panel.control) {
			var textLabel = designer.attrPanel.panel.control.getRelatedTextControl();
			text = textLabel ? textLabel.options.values.content : '';
		}
		dom.parentNode.firstChild.value = text;
	} else {
		dom.parentNode.firstChild.readOnly = false;
	}
}

Designer_AttrPanel.colorDraw = function(name, attr, value, form, attrs, values) {
	var buff = [];
	buff.push('<input type="text" style="width:85%" disabled style="border:solid 1px #000000;background-color:', value ? value : '#000','">');
	buff.push('<input type="hidden" name="', name, '" value="', value ? value : '','" >');
	buff.push('<input type="button" class="btnopt" value="..." onclick="Designer_AttrPanel.colorPanelOpen(event);">');
	return Designer_AttrPanel.wrapTitle(name, attr, value, buff.join(''));
}
Designer_AttrPanel.colorPanel = null;
Designer_AttrPanel.colorPanelInit = function() {
	if (Designer_AttrPanel.colorPanel == null) {
		Designer_AttrPanel.colorPanel = new Designer_AttrPanel.Color_Panel();
	}
}
Designer_AttrPanel.colorPanelOpen = function(event) {
	var obj = event.target ? event.target : event.srcElement;
	var ps = Designer.absPosition(obj);
	Designer_AttrPanel.colorPanelInit();
	Designer_AttrPanel.colorPanel.open(
			obj.previousSibling.value,
			Designer_AttrPanel.colorPanelCallBack,
			obj.previousSibling, ps.x , ps.y + obj.offsetHeight
	);
}
Designer_AttrPanel.colorPanelClose = function() {
	if (Designer_AttrPanel.colorPanel) {
		Designer_AttrPanel.colorPanel.close();
	}
}
Designer_AttrPanel.colorPanelCallBack = function(value, arg) {
	if (arg.form && arg.previousSibling) {
		arg.value = value;
		arg.previousSibling.style.backgroundColor = value;
		Designer_AttrPanel.showButtons(arg);
	}
	arg = null;
}
Designer_AttrPanel.Color_Panel = function() {
	this.domElement = document.createElement('div');
	document.body.appendChild(this.domElement);
	with(this.domElement.style) {
		position = 'absolute'; display='none'; width = '253px'; height = '177px'; zIndex = '200';
	}
	this.colorHex = ['00','33','66','99','CC','FF'];
	this.spColorHex = ['FF0000','00FF00','0000FF','FFFF00','00FFFF','FF00FF'];
	this.current = null;
	this.disColor = null;
	this.hexColor = null;
	var colorTable = [
		'<table width=253 border="0" cellspacing="0" cellpadding="0" bordercolor="000000" ',
		'style="border:1px #000000 solid;border-bottom:none;border-collapse: collapse">',
		'<tr height=30><td colspan=21 bgcolor=#cccccc>',
		'<table cellpadding="0" cellspacing="1" border="0" style="border-collapse: collapse">',
		'<tr><td width="3"><td><input type="text" name="DisColor" size="6" disabled style="border:solid 1px #000000;background-color:#ffff00"></td>',
		'<td width="3"><td><input type="text" name="HexColor" size="7" style="border:inset 1px;font-family:Arial;" value="#000000"></td>',
		'</tr></table></td></table>',
		'<table border="1" cellspacing="0" cellpadding="0" style="border-collapse: collapse;cursor:pointer;" bordercolor="000000"',
		' onmouseover="Designer_AttrPanel.colorPanel.onOver(event);" onmouseout="Designer_AttrPanel.colorPanel.onOut();"',
		' onclick="Designer_AttrPanel.colorPanel.onClick(event);">'
	];
	for (var i = 0; i < 2; i ++) {
		for (var j = 0; j < 6; j ++) {
			colorTable.push('<tr height=12>');
			colorTable.push('<td width=11 style="background-color:#000000">');
			if ( i == 0 ){
				colorTable.push('<td width=11 style="background-color:#', this.colorHex[j], this.colorHex[j], this.colorHex[j], '">');
			} else {
				colorTable.push('<td width=11 style="background-color:#', this.spColorHex[j], '">');
			}
			colorTable.push('<td width=11 style="background-color:#000000">');
			for (var k = 0; k < 3; k ++) {
				for ( var l = 0; l < 6; l ++) {
					colorTable.push('<td width=11 style="background-color:#', this.colorHex[k + i*3], this.colorHex[l], this.colorHex[j], '">');
				}
			}
		}
	}
	colorTable.push('</table>');
	this.domElement.innerHTML = colorTable.join('');
	this.disColor = this.domElement.getElementsByTagName('input')[0];
	this.hexColor = this.domElement.getElementsByTagName('input')[1];
	
	Designer.addEvent(this.domElement, 'blur', function() {
		if (Designer_AttrPanel.colorPanel.canClose)
			Designer_AttrPanel.colorPanel.close();
	});
	Designer.addEvent(this.domElement, 'mouseout', function() {
		Designer_AttrPanel.colorPanel.canClose = true;
	});
	Designer.addEvent(this.domElement, 'mouseover', function() {
		Designer_AttrPanel.colorPanel.canClose = false;
	});
}
Designer_AttrPanel.Color_Panel.prototype = {
	canClose : true,
	open: function(defValue, fn, arg, x, y) {
		this._setColor(defValue);
		this._arg = arg;
		this.targetFn = fn;
		this.domElement.style.display = '';
		// 修正 x 轴超出问题
		var p_size = 20;
		var right_x_pos = x + this.domElement.offsetWidth;
		if (right_x_pos > document.body.offsetWidth - p_size) {
			x = document.body.offsetWidth - this.domElement.offsetWidth - p_size;
		}
		// 定位
		this.domElement.style.left = x ? x : 0 + 'px';
		this.domElement.style.top = y ? y : 0 + 'px';
		
		this.domElement.focus();
	},
	_setColor : function(value) {
		this.disColor.style.backgroundColor = value;
		this.hexColor.value = value.toUpperCase();
	},
	close : function() {
		this.domElement.style.display = 'none';
	},
	onOver : function (event) {
		var obj = event.target ? event.target : event.srcElement;
		if ((obj.tagName == "TD") && (this.current != obj)) {
			if (this.current != null) {
				this.current.style.backgroundColor = this.current._background;
			}
			obj._background = obj.style.backgroundColor;
			this._setColor(obj.style.backgroundColor);
			obj.style.backgroundColor = "white";
			this.current = obj;
		}
	},
	onOut : function() {
		if (this.current!=null)
			this.current.style.backgroundColor = this.current._background.toUpperCase();
	},
	onClick : function(event) {
		var obj = event.target ? event.target : event.srcElement;
		if (obj.tagName == "TD") {
			var clr = obj._background;
			clr = clr.toUpperCase();
			if (this.targetFn) {
				this.targetFn(clr, this._arg);
			}
			this.close();
		}
	}
}

Designer_AttrPanel.defaultValueDraw = function(name, attr, value, form, attrs, values, control) {
	var buff = [];
	var isFormula = (values.formula != null && values.formula != '');
	if (attr.defaultValueHint) {
		buff.push('<div id="attrDefaultValueHint" ', 
			(isFormula ? 'style="display:none"' : ''),'>', attr.defaultValueHint, '</div>');
	}
	buff.push('<input type="hidden" name="formula"');
	if (isFormula) {
		buff.push(' value="' , values.formula, '"');
	}
	buff.push('><input type="text" style="width:95%" name="defaultValue"');
	if (value != null) {
		buff.push(' value="' , value, '"');
	}
	if (isFormula) {
		buff.push(' class="inputread"');
		buff.push(' readOnly ');
	} else {
		buff.push(' class="attr_td_text"');
	}
	buff.push('><br>');
	buff.push('<button onclick="Designer_AttrPanel.openFormulaDialog(this,\'', control.owner.owner._modelName, '\');" class="btnopt">');
	buff.push(Designer_Lang.attrpanelDefaultValueFormula);
	buff.push('</button>');
	buff.push('<div id="reCalculate_field" ',
		(isFormula ? '' : 'style="display:none"')
		,'><label><input type="checkbox" value="true" name="reCalculate" ', 
		(values.reCalculate == 'true' ? 'checked' : ''),'>',Designer_Lang.attrpanelDefaultValueReCalculate,'</label><div>');
	return Designer_AttrPanel.wrapTitle(name, attr, value, buff.join(''));
}

Designer_AttrPanel.openFormulaDialog = function(dom, modelName) {
	var defValue = null;
	if (dom.form['formula'].value == '') {
		defValue = dom.form['defaultValue'].value;
	}
	if (Designer_AttrPanel.resetValues(dom)) {
		Formula_Dialog('formula', 'defaultValue', Designer.instance.getObj(true), dom.form['dataType'].value, function() {
			if (dom.form['formula'].value != '') {
				dom.form['defaultValue'].readOnly = true;
				dom.form['defaultValue'].className = 'inputread';
				document.getElementById('reCalculate_field').style.display = '';
				var hint = document.getElementById('attrDefaultValueHint');
				if (hint) hint.style.display = 'none';
			} else {
				dom.form['defaultValue'].readOnly = false;
				dom.form['defaultValue'].className = 'attr_td_text';
				dom.form['reCalculate'].checked = false;
				document.getElementById('reCalculate_field').style.display = 'none';
				if (defValue != null) {dom.form['defaultValue'].value = defValue;}
				var hint = document.getElementById('attrDefaultValueHint');
				if (hint) hint.style.display = '';
			}
			if (dom.form['formula'].value != dom.form['formula'].defaultValue) {
				Designer_AttrPanel.showButtons(dom);
			}
		}, null, modelName);
	}
}