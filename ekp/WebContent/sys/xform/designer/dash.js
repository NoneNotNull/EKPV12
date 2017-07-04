/**********************************************************
功能：拖拽对象定义
使用：
	
作者：龚健
创建时间：2009-02-22
**********************************************************/
function Designer_Builder_DashBox(builder, shape) {
	//属性
	this.builder = builder || null;
	this.attached = null;                         //附属对象

	//空心矩形框(rectangle),空心待选框(chooseBox),竖线(vDashLine)(表格的单元格拖拽时)
	//横线(hDashLine)(表格的单元格拖拽时),实心拖拽框(dragBox)(控件拖拽时)
	this.shape = shape || 'rectangle';
	//实心框
	this.box = null;
	//边框
	this.border = {};
	//拖拽小虚线框
	this.dragBox = {};

	//内部属性
	this._dragElement = null;
	this._originalAttach = {left: -1, top: -1, width: 0, height: 0}; //附着对象的初始信息

	//内部调用方法
	this._initElement = _Designer_Builder_DashBox_InitElement;
	this._draw = _Designer_Builder_DashBox_Draw;
	this._drawLine = _Designer_Builder_DashBox_DrawLine;
	this._drawDragBox = _Designer_Builder_DashBox_DrawDragBox;
	this._drawAreaDragBox = _Designer_Builder_DashBox_DrawAreaDragBox;
	this._drawResizeBox = _Designer_Builder_DashBox_DrawResizeBox;
	this._showAreaDragBox = _Designer_Builder_DashBox_ShowAreaDragBox;

	//公共方法
	this.initialize = Designer_Builder_DashBox_Initialize;
	this.attach = Designer_Builder_DashBox_Attach;
	this.show = Designer_Builder_DashBox_Show;
	this.hide = Designer_Builder_DashBox_Hide;
	this.isResizeBox = Designer_Builder_DashBox_IsResizeBox;
	this.onDrag = Designer_Builder_DashBox_OnDrag;
	this.onDragMoving = Designer_Builder_DashBox_OnDragMoving;
	this.onDragStop = Designer_Builder_DashBox_OnDragStop;
	this.moveDomElement = Designer_Builder_DashBox_MoveDomElement;
	this.destroy = Designer_Builder_DashBox_Destroy;
	this.setAreaDragBox = Designer_Builder_DashBox_SetAreaDragBox;

	//对象初始化
	this.initialize();
};

function Designer_Builder_DashBox_Initialize() {
	this._initElement();
	this._draw((this.shape == 'chooseBox') ? '2px dashed #fba49e' : null);
};

function Designer_Builder_DashBox_Show() {
	if (this.box == null) {
		for (var property in this.border) {
			this.border[property].style.display = '';
		}
	} else {
		this.box.style.display = '';
	}
};

function Designer_Builder_DashBox_Hide() {
	if (this.box == null) {
		for (var property in this.border) {
			this.border[property].style.display = 'none';
		}
	} else {
		this.box.style.display = 'none';
	}
	this.attached = null;
};

function Designer_Builder_DashBox_Attach(attached, srcElement, position) {
	//记录绑定对象
	this.attached = attached || null;
	if (this.attached == null) return;
	//虚线框主体附着于选中的控件
	var area, _srcElement = srcElement || null, _position = position || null;
	var nDomElement = (attached instanceof Designer_Control) ? attached.options.domElement : attached, boxStyle;
	if (nDomElement == null) return;
	//设置框体位置
	// 2009-05-15 全部取消 this.builder.domElement 修正定位问题 傅游翔
	switch (this.shape) {
	case 'rectangle':
		//area = Designer.absPosition(nDomElement, this.builder.domElement);
		area = Designer.absPosition(nDomElement);
		this._originalAttach = {left:area.x, top:area.y, width:nDomElement.offsetWidth, height:nDomElement.offsetHeight};
		this._drawResizeBox(this._originalAttach, 2);
		this._showAreaDragBox(this.attached);
		break;
	case 'chooseBox':
		//area = Designer.absPosition(nDomElement, this.builder.domElement);
		area = Designer.absPosition(nDomElement);
		this._originalAttach = {left:area.x, top:area.y, width:nDomElement.offsetWidth, height:nDomElement.offsetHeight};
		this._drawResizeBox(this._originalAttach, 4);
		break;
	case 'vDashLine':
		if (_srcElement == null || _position == null || !(_position == 'left' || _position == 'right')) return;
		//src_area = Designer.absPosition(_srcElement, this.builder.domElement);
		src_area = Designer.absPosition(_srcElement);
		//dom_area = Designer.absPosition(nDomElement, this.builder.domElement);
		dom_area = Designer.absPosition(nDomElement);
		boxStyle = this.border['left'].style;
		boxStyle.left = (src_area.x + (_position == 'left' ? 0 : _srcElement.offsetWidth)) + 'px';
		boxStyle.top = dom_area.y + 'px';
		boxStyle.height = nDomElement.offsetHeight + 'px';
		break;
	case 'hDashLine':
		if (_srcElement == null || _position == null || !(_position == 'up' || _position == 'down')) return;
		//src_area = Designer.absPosition(_srcElement, this.builder.domElement);
		src_area = Designer.absPosition(_srcElement);
		//dom_area = Designer.absPosition(nDomElement, this.builder.domElement);
		dom_area = Designer.absPosition(nDomElement);
		boxStyle = this.border['up'].style;
		boxStyle.left = dom_area.x + 'px';
		boxStyle.top = (src_area.y + (_position == 'up' ? 0 : _srcElement.offsetHeight)) + 'px';
		boxStyle.width = nDomElement.offsetWidth + 'px';
		break;
	case 'dragBox':
		//area = Designer.absPosition(nDomElement, this.builder.domElement);
		area = Designer.absPosition(nDomElement);
		boxStyle = this.box.style;
		boxStyle.left = (area.x - 1) + 'px';
		boxStyle.top = (area.y - 1) + 'px';
		boxStyle.width = (nDomElement.offsetWidth + 2) + 'px';
		boxStyle.height = (nDomElement.offsetHeight + 2) + 'px';
		break;
	}
	this.show();
};

function Designer_Builder_DashBox_IsResizeBox(domElement) {
	return Designer.checkTagName(domElement, 'div') && domElement.getAttribute('position') != null;
};

function Designer_Builder_DashBox_OnDrag(event) {
	var currElement = event.srcElement || event.target;
	this._dragElement = currElement;
	this._mouse_prev_x = event.clientX;
	this._mouse_prev_y = event.clientY;
	this._distanceX = 0;
	this._distanceY = 0;
	//独占鼠标
	if(Designer.UserAgent == 'msie') {
		event.cancelBubble = true;
		currElement.setCapture();
	} else {
		event.stopPropagation();
	}
};

function Designer_Builder_DashBox_OnDragMoving(event) {
	if(Designer.UserAgent == 'msie') {
		this._dragElement.setCapture();
		event.cancelBubble = true;
	} else {
		event.preventDefault();
		event.stopPropagation();
	}
	window.getSelection ? window.getSelection().removeAllRanges() : document.selection.empty();
	//拖拽中...
	var position = this._dragElement.getAttribute('position');
	var nDomElement = (this.attached instanceof Designer_Control) ? this.attached.options.domElement : this.attached;
	var area = {left:-1, top:-1, width:0, height:0}, distanceX = distanceY = 0;
	switch (position) {
	case 'leftUp':
		distanceX = this._mouse_prev_x - event.clientX;
		distanceY = this._mouse_prev_y - event.clientY;
		area.left = this._originalAttach.left; area.top = this._originalAttach.top;
		area.width = this._originalAttach.width + distanceX;
		area.height = this._originalAttach.height + distanceY;
		break;
	case 'left':
		distanceX = this._mouse_prev_x - event.clientX;
		area.left = this._originalAttach.left; area.top = this._originalAttach.top;
		area.width = this._originalAttach.width + distanceX;
		area.height = this._originalAttach.height;
		break;
	case 'leftDown':
		distanceX = this._mouse_prev_x - event.clientX;
		distanceY = event.clientY - this._mouse_prev_y;
		area.left = this._originalAttach.left; area.top = this._originalAttach.top;
		area.width = this._originalAttach.width + distanceX;
		area.height = this._originalAttach.height + distanceY;
		break;
	case 'up':
		distanceY = this._mouse_prev_y - event.clientY;
		area.left = this._originalAttach.left; area.top = this._originalAttach.top;
		area.width = this._originalAttach.width;
		area.height = this._originalAttach.height + distanceY;
		break;
	case 'rightUp':
		distanceX = event.clientX - this._mouse_prev_x;
		distanceY = this._mouse_prev_y - event.clientY;
		area.left = this._originalAttach.left; area.top = this._originalAttach.top;
		area.width = this._originalAttach.width + distanceX;
		area.height = this._originalAttach.height + distanceY;
		break;
	case 'right':
		distanceX = event.clientX - this._mouse_prev_x;
		area.left = this._originalAttach.left; area.top = this._originalAttach.top;
		area.width = this._originalAttach.width + distanceX;
		area.height = this._originalAttach.height;
		break;
	case 'rightDown':
		distanceX = event.clientX - this._mouse_prev_x;
		distanceY = event.clientY - this._mouse_prev_y;
		area.left = this._originalAttach.left; area.top = this._originalAttach.top;
		area.width = this._originalAttach.width + distanceX;
		area.height = this._originalAttach.height + distanceY;
		break;
	case 'down':
		distanceY = event.clientY - this._mouse_prev_y;
		area.left = this._originalAttach.left; area.top = this._originalAttach.top;
		area.width = this._originalAttach.width;
		area.height = this._originalAttach.height + distanceY;
		break;
	}
	this._drawResizeBox(area, 2);
	this._resize_area = area;
	this._distanceX = distanceX;
	this._distanceY = distanceY;
};

function Designer_Builder_DashBox_OnDragStop(event) {
	if(Designer.UserAgent == 'msie') {
		this._dragElement.releaseCapture();
	} else {
		//
	}
	//更新附着对象
	var attached = this.attached;
	if (attached instanceof Designer_Control) {
		var values = attached.options.values, resizeMode = attached.resizeMode;
		var _domElement = attached.options.domElement;
		if (values.width != null) values.width = parseInt(values.width.toString().indexOf('%') > -1 ? _domElement.offsetWidth : values.width) + parseInt(this._distanceX);
		if (values.height != null) values.height = parseInt(values.height.toString().indexOf('%') > -1 ? _domElement.offsetHeight : values.height) + parseInt(this._distanceY);
		this.builder.setProperty(attached);
		//更新属性框的属性
		var attrPanel = this.builder.owner.attrPanel;
		if (!attrPanel.isClosed) attrPanel.show();
	} else {
		attached.style.left = this._resize_area.left + 'px';
		attached.style.top = this._resize_area.top + 'px';
		attached.style.width = this._resize_area.width + 'px';
		attached.style.height = this._resize_area.height + 'px';
	}
};

function Designer_Builder_DashBox_MoveDomElement(parentNode) {
	if (parentNode == null) return;
	if (this.box == null) {
		for (var property in this.border) {
			currElement = this.border[property];
			if (currElement) parentNode.appendChild(currElement);
		}
	} else {
		if (this.box) parentNode.appendChild(this.box);
	}
};

function Designer_Builder_DashBox_Destroy() {
	var currElement;
	if (this.box == null) {
		for (var property in this.border) {
			currElement = this.border[property];
			if (currElement) currElement.parentNode.removeChild(currElement);
		}
	} else {
		currElement = this.box;
		if (currElement) currElement.parentNode.removeChild(currElement);
	}
};

/**********************************************************
描述：
	内部调用函数
功能：
	_Designer_Builder_DashBox_InitElement       : 初始化边框和拖拽要素配置
	_Designer_Builder_DashBox_Draw              : 绘制整个虚线框
	_Designer_Builder_DashBox_DrawLine          : 绘制竖线或横线
	_Designer_Builder_DashBox_DrawDragBox       : 绘制拖拽框
	_Designer_Builder_DashBox_DrawAreaDragBox   : 绘制小虚线框
	_Designer_Builder_DashBox_DrawResizeBox     : 设置虚线框大小
	_Designer_Builder_DashBox_ShowAreaDragBox   : 根据控件的resizeMode属性来显示相应的小虚线框
**********************************************************/
function _Designer_Builder_DashBox_InitElement() {
	switch (this.shape) {
	case 'rectangle':
		this.border = {left: null, right: null, up: null, down: null};
		this.dragBox = {leftUp: null, left: null, leftDown: null, up: null, rightUp: null, right:null, rightDown:null, down:null};
		break;
	case 'chooseBox':
		this.border = {left: null, right: null, up: null, down: null};
		break;
	case 'vDashLine':
		this.border = {left: null};
		break;
	case 'hDashLine':
		this.border = {up: null};
		break;
	}
};

function _Designer_Builder_DashBox_Draw(border) {
	if (this.shape == 'dragBox') {
		this.box = this._drawDragBox(border);
	} else {
		//绘制边框
		for (var property in this.border) {
			this.border[property] = this._drawLine(property, border);
		}
		//绘制拖拽虚线框
		for (var property in this.dragBox) {
			this.dragBox[property] = this._drawAreaDragBox(property);
		}
	}
};

function _Designer_Builder_DashBox_DrawLine(position, border) {
	var _domElement = null, _position = position || 'left', _border = border || '1px dashed #000000';
	this.builder.domElement.appendChild(_domElement = document.createElement('div'));
	with (_domStyle = _domElement.style) {
		width = height = '1px'; position = 'absolute'; display = 'none'; fontSize = '0px'; zIndex = '1';
	}
	//描边
	switch (_position) {
	case 'left':
		_domStyle.borderLeft = _border;
		break;
	case 'right':
		_domStyle.borderRight = _border;
		break;
	case 'up':
		_domStyle.borderTop = _border;
		break;
	case 'down':
		_domStyle.borderBottom = _border;
		break;
	}
	return _domElement;
};

function _Designer_Builder_DashBox_DrawDragBox(border) {
	var _domElement = null, _border = border || '1px dashed #000000';
	with(this.builder.domElement.appendChild(_domElement = document.createElement('div')).style) {
		width = height = '1px'; position = 'absolute'; display = 'none'; border = _border; zIndex = '1';
	}
	return _domElement;
};

function _Designer_Builder_DashBox_DrawAreaDragBox(position) {
	var domElement, domParent;
	switch (position) {
	case 'leftUp':
		domParent = this.border['up'];
		if (domParent == null) return;
		with(domParent.appendChild(domElement = document.createElement('div')).style) {
			cursor = 'nw-resize'; left = top = '-4px';
		}
		break;
	case 'left':
		domParent = this.border['left'];
		if (domParent == null) return;
		with(domParent.appendChild(domElement = document.createElement('div')).style) {
			cursor = 'e-resize'; left = marginTop = '-4px'; top = '50%';
		}
		break;
	case 'leftDown':
		domParent = this.border['down'];
		if (domParent == null) return;
		with(domParent.appendChild(domElement = document.createElement('div')).style) {
			cursor = 'ne-resize'; left = bottom = '-4px';
		}
		break;
	case 'up':
		domParent = this.border['up'];
		if (domParent == null) return;
		with(domParent.appendChild(domElement = document.createElement('div')).style) {
			cursor = 'n-resize'; top = marginLeft = '-4px'; left = '50%';
		}
		break;
	case 'rightUp':
		domParent = this.border['up'];
		if (domParent == null) return;
		with(domParent.appendChild(domElement = document.createElement('div')).style) {
			cursor = 'ne-resize'; right = top = '-4px';
		}
		break;
	case 'right':
		domParent = this.border['right'];
		if (domParent == null) return;
		with(domParent.appendChild(domElement = document.createElement('div')).style) {
			cursor = 'e-resize'; right = marginTop = '-4px'; top = '50%';
		}
		break;
	case 'rightDown':
		domParent = this.border['down'];
		if (domParent == null) return;
		with(domParent.appendChild(domElement = document.createElement('div')).style) {
			cursor = 'nw-resize'; right = bottom = '-4px';
		}
		break;
	case 'down':
		domParent = this.border['down'];
		if (domParent == null) return;
		with(domParent.appendChild(domElement = document.createElement('div')).style) {
			cursor = 'n-resize'; bottom = marginLeft = '-4px'; left = '50%';
		}
		break;
	}
	domElement.setAttribute('position', position);
	//公共样式
	with(domElement.style) {
		//#4150 border 设置为0px 避免在chrome下,日历,控件,前端计算控件出现一个小框框 
		width = height = '7px'; position = 'absolute'; fontSize = '0px'; border = '0px solid #000000';
	}
	return domElement;
};

function _Designer_Builder_DashBox_DrawResizeBox(nElement, bordWidth) {
	var domElement;
	for (var property in this.border) {
		domElement = this.border[property];
		switch (property) {
		case 'left':
			domElement.style.left = (nElement.left - bordWidth/2) + 'px';
			domElement.style.top = (nElement.top - bordWidth/2) + 'px';
			domElement.style.height = (nElement.height + bordWidth) + 'px';
			break;
		case 'right':
			domElement.style.left = (nElement.left + nElement.width - domElement.offsetWidth) + 'px';
			domElement.style.top = (nElement.top - bordWidth/2) + 'px';
			domElement.style.height = (nElement.height + bordWidth) + 'px';
			break;
		case 'up':
			domElement.style.left = (nElement.left - bordWidth/2) + 'px';
			domElement.style.top = (nElement.top - bordWidth/2) + 'px';
			domElement.style.width = (nElement.width + bordWidth) + 'px';
			break;
		case 'down':
			domElement.style.left = (nElement.left - bordWidth/2) + 'px';
			domElement.style.top = (nElement.top + nElement.height - bordWidth/2) + 'px';
			domElement.style.width = (nElement.width + bordWidth) + 'px';
			break;
		}
	}
};

function _Designer_Builder_DashBox_ShowAreaDragBox(control) {
	if (!control.resizeMode) return;
	this.setAreaDragBox(control.resizeMode);
};

function Designer_Builder_DashBox_SetAreaDragBox(type) {
	switch (type) {
	case 'all':
		for (var property in this.dragBox) {
			this.dragBox[property].style.display = '';
		}
		break;
	case 'onlyWidth':
		for (var property in this.dragBox) {
			this.dragBox[property].style.display = (property == 'left' || property == 'right') ? '' : 'none';
		}
		break;
	case 'onlyHeight':
		for (var property in this.dragBox) {
			this.dragBox[property].style.display = (property == 'up' || property == 'down') ? '' : 'none';
		}
		break;
	case 'no':
		for (var property in this.dragBox) {
			this.dragBox[property].style.display = 'none';
		}
		break;
	}
}