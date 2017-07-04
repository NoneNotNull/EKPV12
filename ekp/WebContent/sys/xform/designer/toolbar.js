/**********************************************************
功能：工具栏对象和操作按钮对象
使用：
	
作者：傅游翔
创建时间：2009-03-01
修改记录：
	1.重新梳理了下工具栏对象和按钮对象
		修改者：龚健，修改日期：2009-03-16
**********************************************************/
function Designer_Toolbar(designer) {
	this.owner = designer || null;
	this.domElement = null;
	this.buttons = [];
	this.selectedButton = null;
	this.isShowAdvancedButton = false;

	//公共方法
	this.addLine = Designer_Toolbar_AddLine;			//添加一条分隔线
	this.addButton = Designer_Toolbar_AddButton;		//添加一个操作按钮
	this.initialize = Designer_Toolbar_Initialize;
	this.initButtons = Designer_Toolbar_initButtons;
	this.cancelSelect = Designer_Toolbar_CancelSelect;
	this.getCursorImgPath = Designer_Toolbar_GetCursorImgPath;
	this.getButton = Designer_Toolbar_GetButton;
	this.selectButton = Designer_Toolbar_SelectButton;
	this.showAdvancedButton = Designer_Toolbar_ShowAdvancedButton;
	this.hideAdvancedButton = Designer_Toolbar_HideAdvancedButton;
	this.onSelectControl = Designer_Toolbar_OnSelectControl;

	this.showGroupButton = Designer_Toolbar_ShowGroupButton;
	this.hideGroupButton = Designer_Toolbar_HideGroupButton;

	//初始化
	this.initialize();
	this.initButtons(Designer_Config.buttons, Designer_Config.operations);
};

Designer_Toolbar.ICON_SIZE = 16;

/**********************************************************
描述：
	公共函数
功能：
	Designer_Toolbar_Initialize : 初始化工具栏
**********************************************************/
function Designer_Toolbar_Initialize() {
	var domElement, row;
	with(this.owner.toolBarDomElement.appendChild(domElement = document.createElement('table'))) {
		setAttribute('cellSpacing', '1'); setAttribute('cellPadding', '0');
		style.position = 'absolute'; style.top = '0'; style.left = '0'; style.zIndex = '90';
	};
	domElement.style.width = '100%';
	domElement.style.border = '0px';
	//插入行
	row = domElement.insertRow(-1);
	row.className = 'buttonbar_main';
	//生成放入工具栏的单元格
	this.domElement = row.insertCell(-1);
	
	Designer.addEvent(window , 'scroll' , function() {
		domElement.style.top = document.body.scrollTop;
	});
	
	var resetToolBar = function() {
		if (domElement.style.top != document.body.scrollTop) {
			domElement.style.top = document.body.scrollTop;
		}
		setTimeout(resetToolBar, 800);
	}
	setTimeout(resetToolBar, 800);
}

/**
 * 初始化函数
 * @param {Object} controls
 */
function Designer_Toolbar_initButtons(buttons, operations) {
	for (var name in buttons) {
		var btns = buttons[name];
		this.addLine();
		for (var i = 0; i < btns.length; i ++) {
			var btn = btns[i];
			if (typeof btn == 'string')
				this.addButton(btn, operations[btn]);
			else
				this.addButton(btn.name, btn);
		}
	}
}

//功能：添加一条分隔线
function Designer_Toolbar_AddLine(){
	var newElem = document.createElement("div");
	this.domElement.appendChild(newElem);
	newElem.className = "button_line";
	var childElem = document.createElement("div");
	newElem.appendChild(childElem);
	childElem.className = "button_line_img";
}

//功能：添加一个操作按钮
function Designer_Toolbar_AddButton(name, config){
	return new Designer_Toolbar_Button(this, name, config);
}

//功能：取消选中
function Designer_Toolbar_CancelSelect() {
	
	if (this.selectedButton) {
		//属性布局面板处于打开状态时需要重新open刷新 作者 曹映辉 #日期 2014年11月29日
		if(this.owner.fieldPanel&&!this.owner.fieldPanel.isClosed){
			this.owner.fieldPanel.open();
		}
		this.selectedButton.setSelected(false);
	}
}

//功能：或许选择按钮鼠标图片
function Designer_Toolbar_GetCursorImgPath() {
	if (this.selectedButton && this.selectedButton.config.cursorImg != null) {
		return this.selectedButton.config.cursorImg;
	}
	return null;
}

function Designer_Toolbar_GetButton(name) {
	for (var i = this.buttons.length -1; i >=0; i --) {
		if (this.buttons[i].name == name)
			return this.buttons[i];
	}
}

function Designer_Toolbar_SelectButton(name) {
	var button = this.getButton(name);
	this.cancelSelect();
	if (button)
		button.setSelected(true);
}

function Designer_Toolbar_ShowAdvancedButton() {
	this.isShowAdvancedButton = true;
	for(var i = 0; i < this.buttons.length; i ++) {
		if (this.buttons[i].isAdvanced) {
			this.buttons[i].domElement.style.display = 'inline';
		}
	}
}

function Designer_Toolbar_HideAdvancedButton() {
	this.isShowAdvancedButton = false;
	for(var i = 0; i < this.buttons.length; i ++) {
		if (this.buttons[i].isAdvanced) {
			this.buttons[i].domElement.style.display = 'none';
		}
	}
}

function Designer_Toolbar_OnSelectControl() {
	for(var i = 0; i < this.buttons.length; i ++) {
		if (this.buttons[i].onSelectControl) {
			this.buttons[i].onSelectControl(this.owner);
		}
	}
}

function Designer_Toolbar_ShowGroupButton(name) {
	for(var i = 0; i < this.buttons.length; i ++) {
		if (this.buttons[i].group == name) {
			this.buttons[i].domElement.style.display = 'inline';
		}
	}
}

function Designer_Toolbar_HideGroupButton() {
	for(var i = 0; i < this.buttons.length; i ++) {
		if (this.buttons[i].group == name) {
			this.buttons[i].domElement.style.display = 'none';
		}
	}
}

/**********************************************************
描述：
	工具栏按钮
**********************************************************/
function Designer_Toolbar_Button(parent, name, config){
	this.isAdvanced = config.isAdvanced == true ? true : false;
	this.name = name;
	var imgIndex = config.imgIndex;
	this.toolbar = parent;
	parent.buttons.push(this);

	this.config = config;
	this.selected = false;

	var newElem = document.createElement("div");
	parent.domElement.appendChild(newElem);
	newElem.className = "button_nor";
	//增加控件端可以控制 工具栏按钮的宽度属性 多浏览器支持
	if(config&&config.domWidth){
		newElem.style.width=config.domWidth;
	}
	if (config.title && config.sampleImg == null) {
		newElem.title = config.title;
	}
	if (this.isAdvanced) {
		newElem.style.display = 'none';
	}
	this.domElement = newElem;

	if (config.childElem == null) {
		var childElem = document.createElement("div");
		newElem.appendChild(childElem);
		childElem.className = "button_img";
		childElem.style.backgroundPosition = "center " + (- imgIndex * Designer_Toolbar.ICON_SIZE - 1 ) + "px";
	} else {
		newElem.appendChild(config.childElem(parent.owner));
	}
	
	this.onSelectControl = config.onSelectControl ? config.onSelectControl : function() {};

	this.initActions();
}

/**
 * 按钮方法设置
 */
Designer_Toolbar_Button.prototype = {
	// 初始化操作
	initActions : function() {
		var self = this;
		this.domElement.onmouseover = function() {
			this.className = "button_sel";
			//取得定位，并显示示例图片
			var config = self.config;
			if (config.sampleImg) {
				if (self.sampleImgDom == null) {
					var img = document.createElement('img');
					img.src = config.sampleImg;
					self.sampleImgDom = self.createSampleImg(img);
					document.body.appendChild(self.sampleImgDom);
					self.sampleImgDom.style.position = 'absolute';
					self.sampleImgDom.style.zIndex = '100';
					var w = img.offsetWidth;
					if (w > 250) {
						img.width = '250';
						img.height = '' + (img.offsetHeight / w * 250);
					}
				}
				var p = Designer.absPosition(this);
				self.sampleImgDom.style.top = p.y + this.offsetHeight + 'px';
				self.sampleImgDom.style.left = p.x + 'px';
				self.sampleImgDom.style.display = '';
			}
		};

		this.domElement.onmouseout = function() {
			this.className = self.selected ? "button_sel" : "button_nor";
			//隐藏示例图片
			if (self.sampleImgDom != null) {
				self.sampleImgDom.style.display = 'none';
			}
		};

		this.domElement.onclick = function() {
			if (self.toolbar.selectedButton && self.toolbar.selectedButton != this) {
				self.toolbar.selectedButton.setSelected(false);
			}
			if (self.config.select == true) {
				//self.setSelected(true);
			} else {
				//self.setSelected(false);
			}
			if (self.config.run)
				self.config.run(self.toolbar.owner, self);
		};
	},
	setAsSelectd : function(selected) {
		this.domElement.className = selected ? "button_sel" : "button_nor";
		this.selected = selected;
	},
	// 设置是否被选择
	setSelected : function(selected) {
		this.domElement.className = selected ? "button_sel" : "button_nor";
		this.selected = selected;
		if (selected) {
			this.toolbar.selectedButton = this;
			this.toolbar.owner.toolBarAction = this.name;
		} else {
			this.toolbar.selectedButton = null;
			this.toolbar.owner.toolBarAction = '';
		}
	},
	// 创建预览框
	createSampleImg : function(img) {
		var table = document.createElement('table'), row, cell;
		table.className = "toolbar_preview_table";
		var text = document.createElement('div');
		if (this.config.title)
			text.innerHTML = '<div class="toolbar_preview_main_text">'
				+ this.config.title +'</div>';
		else
			text.innerHTML = '<div class="toolbar_preview_main_text">'+Designer_Lang.toolbarSampleImg+'</div>';
		text.className = 'toolbar_preview_main_text_box';

		row = table.insertRow(-1);
		cell = row.insertCell(-1);
		cell.className = "toolbar_preview_top_left";
		cell = row.insertCell(-1);
		cell.className = "toolbar_preview_top_center";
		cell = row.insertCell(-1);
		cell.className = "toolbar_preview_top_right";

		row = table.insertRow(-1);
		cell = row.insertCell(-1);
		cell.className = "toolbar_preview_main_left";
		cell = row.insertCell(-1);
		cell.className = "toolbar_preview_main_center";
		cell.appendChild(text);
		cell.appendChild(img);
		cell = row.insertCell(-1);
		cell.className = "toolbar_preview_main_right";

		row = table.insertRow(-1);
		cell = row.insertCell(-1);
		cell.className = "toolbar_preview_bottom_left";
		cell = row.insertCell(-1);
		cell.className = "toolbar_preview_bottom_center";
		cell = row.insertCell(-1);
		cell.className = "toolbar_preview_bottom_right";
		
		return table;
	}
};