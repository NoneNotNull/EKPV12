/**********************************************************
功能：右键菜单对象的定义
作者：傅游翔
创建时间：2009-05-13
修改记录：
**********************************************************/

function Designer_RightMenu(designer, parentMenu, configs) {
	this.designer = designer;
	this.items = [];
	this.parent = parentMenu;
	this.curItem = null;
	this.cancelShow = false; // ??
	this.pItem = null;
	this.isShow = false;
	
	this.domElement = document.createElement('table');
	this.domElement.className = 'right_menu';
	this.domElement.style.zIndex = '' + (Designer_RightMenu.zIndex ++);
	var _lab = '1';
	for (var _name in configs) {
		var config = configs[_name];
		if (config.type == 'line') {
			this.addLine();
		} else {
			this.addItem(config);
		}
	}
	document.body.appendChild(this.domElement);
	this.domElement.style.left = '0';
	this.domElement.style.top = '0';
	this.domElement.style.display = 'none';
}
Designer_RightMenu.zIndex = 200;

Designer_RightMenu.prototype = {
	getLeft : function(x) {
		var ww = Math.max(document.documentElement.clientWidth, document.body.clientWidth);
		var dw = this.domElement.offsetWidth;
		var _x = x - document.body.scrollLeft;
		if (this.parent == null)
			return (x + dw > ww) ? x - dw : x + 1;
		else {
			return (x + dw > ww) ? x - (dw - 4) * 2 : x - 1;
		}
	},
	getTop : function(y) {
		var wh = document.body.clientHeight;//Math.max(document.documentElement.clientHeight, document.body.clientHeight);
		var dh = this.domElement.offsetHeight;
		var _y = y - document.body.scrollTop;
		if (this.parent == null)
			return (_y + dh > wh && _y - dh > 0) ? y - dh : y + 1;
		else {
			if (_y + dh > wh) {
				var r = (_y - dh > 0) ? (y - dh + this.pItem.domElement.offsetHeight) : y + (wh - _y - dh);
				return r > 0 ? r : 0;
			}
			return (y - 6);
		}
	},
	show : function(event) {
		event = event || window.event;
		var pos;
		if (this.parent == null) {
			pos = Designer.getMousePosition(event);
			//this.designer._doFocus(this);
			if (this.curItem)
				this.curItem.reset();
			this.domElement.style.display = '';
			this.domElement.style.left = this.getLeft( pos.x );
			this.domElement.style.top = this.getTop( pos.y );
		} else {
			this.domElement.style.display = '';
			pos = Designer.absPosition(this.pItem.domElement);
			this.domElement.style.left = this.getLeft( pos.x + this.pItem.domElement.offsetWidth );
			this.domElement.style.top = this.getTop( pos.y );
		}
		this.isShow = true;
		//this.domElement.focus();
		if (this.items.length > 0)
			this.items[0].domElement.focus();
		for (var i = this.items.length - 1; i >= 0; i--) {
			this.items[i].setEnable();
		}
	},
	hide : function() {
		if (this.curItem)
			this.curItem.reset();
		if (this.isShow == true)
			this.domElement.style.display = 'none';
		this.isShow = false;
	},
	addLine : function() {
		this.items.push(new Designer_RightMenu_Item(this, {type:'line'}));
	},
	addItem : function(config) {
		if (config.type == 'menu') {
			this.addMenu(config);
		} else {
			this.items.push(new Designer_RightMenu_Item(this, config));
		}
	},
	addMenu : function(config) {
		this.items.push(new Designer_RightMenu_Item(this, config, new Designer_RightMenu(this.designer, this, config.menu)));
	},
	onLeave : function() {
		this.hide();
	}
};

function Designer_RightMenu_Item(menu, config, submenu) {
	this.parent = menu;
	this.text = config.title;
	this.type = config.type;
	this.action = config.run ? config.run : null;
	this.hotkeyName = config.hotkeyName ? config.hotkeyName : null;
	this.hotkey = config.hotkey ? config.hotkey : null;
	this.shortcut = config.shortcut ? config.shortcut : null;
	this.menu = submenu;
	this.validate = config.validate ? config.validate : function() {return true};
	this.enabled = true;
	if (this.menu) {
		this.menu.pItem = this;
	}

	var _self = this;
	this.domElement = this.parent.domElement.insertRow(-1).insertCell(-1);

	if (this.type == 'cmd') {
		var htmlCode = "<table border=0 cellpadding=0 cellspacing=0 width=100% height=100%><tr>";
		htmlCode += "<td width=10px class=rightmenu_check></td><td nowrap>"+this.text
			+(this.shortcut==null?"":(" ("+this.shortcut)+")")+"</td><td style='text-align:right' nowrap>"
			+(this.hotkeyName==null?"":this.hotkeyName)+"</td><td width=10px></td></tr></table>";
		this.domElement.innerHTML = htmlCode;
		Designer.addEvent(this.domElement, 'mouseup', function(event) {
			event = event || window.event;
			//event.cancelBubble = true;
			_self.onClick();
		});
	}
	else if (this.type == 'menu') {
		var htmlCode = "<table border=0 cellpadding=0 cellspacing=0 width=100% height=100%><tr>";
		htmlCode += "<td width=10px></td><td nowrap>"+this.text+"</td><td style='text-align:right' width=10>»</td></tr></table>";
		this.domElement.innerHTML = htmlCode;
		Designer.addEvent(this.domElement, 'click', function(event) {
			event = event || window.event;
			event.cancelBubble = true;
		});
	}
	else if (this.type == 'line') {
		this.domElement.className = "rightmenu_line";
	}
	if (this.type != 'line') {
		Designer.addEvent(this.domElement, 'mouseover', function(event) {
			event = event || window.event;
			event.cancelBubble = true;
			_self.onOver();
		});
		Designer.addEvent(this.domElement, 'mouseout', function(event) {
			event = event || window.event;
			event.cancelBubble = true;
			_self.onOut();
		});
	}
	
	if (this.hotkey != null) {
		this.parent.designer.shortcuts.add(this.hotkey, function(){
			_self.onClick();
		}, {'target':this.parent.designer.builderDomElement}
		);
	}
	if (this.shortcut != null) {
		this.parent.designer.shortcuts.add(this.shortcut, function(){
			_self.onClick();
		}, {'target':this.parent.domElement});
	}
	this.setCSS();
}

Designer_RightMenu_Item.prototype = {
	validate : function() {return true;},
	reset : function() {
		this.setCSS();
		if (this.menu) {
			this.menu.hide();
		}
	},
	show : function() {
		if (this.menu) {
			this.menu.show();
		}
	},
	setCSS : function() {
		this.domElement.className = this.type == "line" ? "rightmenu_line" : (this.enabled ? "rightmenu_nor" : "rightmenu_dis");
	},
	setSelected : function() {
	
	},
	setEnable : function() {
		this.enabled = this.validate(this.parent.designer);
		this.setCSS();
	},
	onClick : function() {
		if (!this.enabled) return;
		if (this.action)
			this.action(this.parent.designer);
		var p = this.parent;
		while (p.parent != null) {
			p = p.parent;
		}
		p.hide();
	},
	onOver : function() {
		if (!this.enabled) return;
		if (this.parent.isShow == false) return;
		if (this.parent.curItem && this.parent.curItem != this)
			this.parent.curItem.reset();
		if (this.type == 'line') return;
		this.parent.curItem = this;
		this.show();
		this.domElement.className = "rightmenu_sel";
	},
	onOut : function() {
		this.setCSS();
	}
};
