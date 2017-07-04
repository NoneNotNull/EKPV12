/**********************************************************
功能：拖拽框定义
参数：
	designer : 设计器对象
	panel    : 属性面板对象
使用：
	panel(面板对象)：
		1.必须有domElement属性(面板DomElement)
		2.必须有init方法(面板初始化方法)，参数是拖拽框对象，
作者：龚健
创建时间：2009-03-04
	修改者：傅游翔
	修改时间：2009-03-16
	修改记录：增加默认头部和底部绘制方法。修正被拖拽出页面问题 x 与 y 最小为 0。
**********************************************************/
function Designer_Panel(designer, panel) {
	//属性
	this.owner = designer || null;                      //设计器对象
	this.domElement = null;                             //整个拖拽框DomElement
	this.titleBar = null;                               //标题栏DomElement
	this.panelBar = null;                               //面板栏DomElement
	this.panel = panel || {domElement:null, init:null}; //面板拦对象
	this.isClosed = true;
	this.canDrag = true;
	this.canHidden  = true;

	this.attach = {effect:false, position:null};        //依附控制

	//内部方法
	this._initialize = _Designer_Panel_Initialize;
	this._initTitleDrag = _Designer_Panel_InitTitleDrag;
	this._initSideHidden = _Designer_Panel_InitSideHidden;
	this._invokeListeners = _Designer_Panel_InvokeListeners;

	//公共方法
	this.drawTitle = Designer_Panel_DrawTitle; 
	this.resize = Designer_Panel_Resize;
	this.restore = Designer_Panel_Restore;
	this.minimize = Designer_Panel_Minimize;
	this.show = Designer_Panel_Show;
	this.open = Designer_Panel_Open;
	this.close = Designer_Panel_Close;
	this.fold = Designer_Panel_Fold;
	this.expand = Designer_Panel_Expand;
	this.isFolded = Designer_Panel_IsFold;
	this.resizeHeight = Designer_Panel_Resize_Heigth;
	this.focusPanel = function(){};
	
	//发布事件
	this.openListeners = [];

	//初始化拖拽框
	this._initialize();

	Designer_Panel.Container.push(this);// 放入到容器
};

Designer_Panel.Container = [];

/**********************************************************
描述：
	公共函数
功能：
	Designer_Panel_DrawTitle : 绘制标题栏
	Designer_Panel_Resize    : 重置拖拽框大小
	Designer_Panel_Restore   : 还原
	Designer_Panel_Minimize  : 最小化
**********************************************************/
function Designer_Panel_DrawTitle(titleDomElement) {
	if (!titleDomElement) return;
	var _tDomElement = this.titleBar.appendChild(titleDomElement);
	return;
	// console.info(_tDomElement.offsetWidth, _tDomElement.offsetHeight);
	this.titleBar.style.width = _tDomElement.offsetWidth + 'px';
	this.titleBar.style.height = _tDomElement.offsetHeight + 'px';
};

function Designer_Panel_Resize() {
	var width = Math.max(this.titleBar.offsetWidth, this.panelBar.offsetWidth);
	return;
	this.domElement.style.width = this.titleBar.style.width = this.panelBar.style.width = width + 'px';
	this.domElement.style.height = this.titleBar.offsetHeight + this.panelBar.offsetHeight;
};

function Designer_Panel_Resize_Heigth() {
	return;
	this.domElement.style.height = this.titleBar.offsetHeight + this.panelBar.offsetHeight;
}

function Designer_Panel_Restore() {
	this.panelBar.style.display = '';
	return;
	this.domElement.style.height = this.titleBar.offsetHeight + this.panelBar.offsetHeight;
};

function Designer_Panel_Minimize() {
	this.panelBar.style.display = 'none';
	return;
	this.domElement.style.height = this.titleBar.offsetHeight;
};

function Designer_Panel_Show() {
	this.isClosed = false;
	this.domElement.style.zIndex = 101;
	var _self = this;
	if (this.isFolded()) {this.expand();}
	if (this.draw) this.draw();
	this.owner.effect.setOptions({onFinish: function(){_self.focusPanel();}});
	this.owner.effect.show(this.domElement);
	this._invokeListeners(this.openListeners);
};

function Designer_Panel_Open() {
	this.isClosed = false;
	this.domElement.style.display = '';
	this.domElement.style.zIndex = 101;
	if (this.draw) this.draw();
	if (!this.isFolded()) {
		this.focusPanel();
		this._invokeListeners(this.openListeners);
	}
};

function Designer_Panel_Close() {
	this.isClosed = true;
	this.domElement.style.display = 'none';
	if (this.panel.onClosed) this.panel.onClosed();
};

function Designer_Panel_Fold() {
	this.panel.domElement.style.display = 'none';
};

function Designer_Panel_Expand() {
	this.panel.domElement.style.display = '';
};

function Designer_Panel_IsFold() {
	return (this.panel.domElement.style.display == 'none');
}

/**********************************************************
描述：
	内部调用函数
功能：
	_Designer_Panel_Initialize     : 初始化拖拽面板
	_Designer_Panel_InitTitleDrag  : 标题栏拖拽事件
**********************************************************/
function _Designer_Panel_Initialize() {
	if (!this.panel.init) return;
	//拖拽框
	with(document.body.appendChild(this.domElement = document.createElement('div')).style) {
		position = 'absolute'; display = 'none'; top = '35px'; left = '5px';
	}
	//标题栏
	this.domElement.appendChild(this.titleBar = document.createElement('div'));
	this.titleBar.onselectstart = function(){return false;};
	//this.titleBar.style.height = '24px';
	this.titleBar.style.clear = 'both';
	//面板栏
	this.domElement.appendChild(this.panelBar = document.createElement('div'));
	//面板对象初始化
	this.panel.init(this);
	//初始化面板栏大小
	if (this.panel.domElement) {
		//this.panelBar.style.width = this.panel.domElement.offsetWidth + 'px';
		//this.panelBar.style.height = this.panel.domElement.offsetHeight + 'px';
		this.panelBar.appendChild(this.panel.domElement);
	}
	//重置整个拖拽框大小
	this.resize();
	//初始化相应的隐藏事件
	this._initSideHidden();
	//初始化相应的拖拽事件
	this._initTitleDrag();
};

function _Designer_Panel_InitTitleDrag() {
	var _self = this, currElement = _self.titleBar, moveElement;
	currElement.style.cursor = 'move';
	this.minX = 200;
	this.minY = 25;

	var _titleMouseDown = function(event) {
		for (var i = 0, l = Designer_Panel.Container.length; i < l; i ++) {
			Designer_Panel.Container[i].domElement.style.zIndex = 100;
		}
		_self.domElement.style.zIndex = 101;
		if (!_self.canDrag) {return false;}
		if (_self.relaseSideHidden)
			_self.relaseSideHidden();
		
		var _event = event ? event : window.event, mousePos = Designer.getMousePosition(_event);
		var area = Designer.absPosition(currElement);
		if (window.console)
			console.info(area);
		//创建拖拽对象
		with(document.body.appendChild(moveElement = document.createElement('div')).style) {
			width = _self.domElement.offsetWidth + 'px'; height = _self.domElement.offsetHeight + 'px';
			position = 'absolute'; border = '1px dashed #000000'; display = 'none'; zIndex = '1'; cursor = 'move';
			opacity = '0.50'; filter = 'progid:DXImageTransform.Microsoft.Alpha(style=0,opacity=50,finishOpacity=100)';
		}
		moveElement.style.zIndex = 102;
		//记录拖拽原始信息
		_self._prev_x = _event.clientX;
		_self._prev_y = _event.clientY;
		_self._x = mousePos.x - area.x;
		_self._y = mousePos.y - area.y;
		//独占鼠标
		if(Designer.UserAgent == 'msie') {
			Designer.addEvent(currElement, "losecapture", _titleMouseUp);
			_event.cancelBubble = true;
			currElement.setCapture();
		} else {
			Designer.addEvent(window, "blur", _titleMouseUp);
			_event.stopPropagation();
		}
		Designer.addEvent(document, "mousemove", _titleMouseMove);
		Designer.addEvent(document, "mouseup", _titleMouseUp);
	};

	var _titleMouseMove = function(event) {
		if (!_self.canDrag) {return false;}
		var _event = event ? event : window.event, mousePos = Designer.getMousePosition(_event);
		if(Designer.UserAgent == 'msie') {
			currElement.setCapture();
			_event.cancelBubble = true;
		} else {
			_event.preventDefault();
			_event.stopPropagation();
		}
		window.getSelection ? window.getSelection().removeAllRanges() : document.selection.empty();
		moveElement.style.display = '';
		var _x = (mousePos.x - _self._x);
		var _y = (mousePos.y - _self._y);
		var _x_max = document.body.clientWidth + document.body.scrollLeft - _self.minX;//moveElement.offsetWidth;
		var _y_max = document.body.clientHeight + document.body.scrollTop - _self.minY;//moveElement.offsetHeight;
		moveElement.style.left = (_x > 0 ? (_x > _x_max ? _x_max : _x) : 0) + 'px';
		moveElement.style.top = (_y > 0 ? (_y > _y_max ? _y_max : _y) : 0) + 'px';
		_self.needSideHidden = (_x >= _x_max) ? true : false;
	};

	var _titleMouseUp = function(event) {
		if (!_self.canDrag) {return false;}
		var _event = event ? event : window.event;
		Designer.removeEvent(document, "mousemove", _titleMouseMove);
		Designer.removeEvent(document, "mouseup", _titleMouseUp);
		if(Designer.UserAgent == 'msie') {
			Designer.removeEvent(currElement, "losecapture", _titleMouseUp);
			currElement.releaseCapture();
		} else {
			Designer.removeEvent(window, "blur", _titleMouseUp);
		}
		//若鼠标移动没超过5px，则认为没有拖动
		var distance_x = Math.abs(event.clientX - _self._prev_x), distance_y = Math.abs(event.clientY - _self._prev_y);
		if (distance_x >= 5 || distance_y >= 5) {
			var _x = parseInt(moveElement.style.left);
			var _y = parseInt(moveElement.style.top);
			_self.domElement.style.left = (_x > 0 ? _x : 0) + 'px';
			_self.domElement.style.top = (_y > 0 ? _y : 0) + 'px';

			if (_self.needSideHidden && _self.panelStartSideHidden) {
				_self.panelStartSideHidden();
			}
		}
		document.body.removeChild(moveElement);
		_self.domElement._clientTop = _self.domElement.offsetTop - document.body.scrollTop;
	};

	//绑定事件
	Designer.addEvent(currElement, "mousedown", _titleMouseDown);	
};

function _Designer_Panel_SideHidden_SetPostion(panel, width) {
	panel.domElement.style.width = width + 'px';
	panel.domElement.style.left =  (document.body.clientWidth + document.body.scrollLeft - panel.domElement.offsetWidth) + 'px';
	if (panel._isResizeHeight)
		panel.resizeHeight();
}

function _Designer_Panel_InitSideHidden() {
	this.sideHidden = true; // --- 设置是否侧边隐藏
	this.timer = null; // --- 动画定时任务ID
	this.hiddenSize = 10; // --- 隐藏露出值
	this.interval = 50; // --- 定时定时动画时间
	this.stepSize = 30; // --- 移动步长
	this.needSideHidden = false; // --- 标识是否要开始隐藏

	var _self = this;

	var _panelStepSideShowInterval = function() {
		if (!_self.canHidden) {return false;}
		var _width = _self.domElement.offsetWidth + _self.stepSize;
		if (_width >= _self.titleBar.offsetWidth) {
			_width = _self.titleBar.offsetWidth;
			clearTimeout(_self.timer);
			_self.timer = null;
			Designer.addEvent(document, "mousemove", _panelStepSideHidden);
			_Designer_Panel_SideHidden_SetPostion(_self, _width);
		} else {
			_Designer_Panel_SideHidden_SetPostion(_self, _width);
			_self.timer = setTimeout(_panelStepSideShowInterval, _self.interval);
		}
	};

	var _panelStepSideShow = function() {
		if (!_self.canHidden) {return false;}
		Designer.removeEvent(_self.domElement, "mouseover", _panelStepSideShow);
		_panelStepSideShowInterval();
	};

	var _panelStepSideHiddenInterval = function() {
		if (!_self.canHidden) {return false;}
		var _width = _self.domElement.offsetWidth - _self.stepSize;
		if (_width <= _self.hiddenSize) {
			_width = _self.hiddenSize;
			clearTimeout(_self.timer);
			_self.timer = null;
			Designer.addEvent(_self.domElement, "mouseover", _panelStepSideShow);
			_Designer_Panel_SideHidden_SetPostion(_self, _width);
		} else {
			_Designer_Panel_SideHidden_SetPostion(_self, _width);
			_self.timer = setTimeout(_panelStepSideHiddenInterval, _self.interval);
		}
	};

	var _panelStepSideHidden = function(event) {
		if (!_self.canHidden) {return false;}
		var _event = event ? event : window.event, mousePos = Designer.getMousePosition(_event);
		if (!Designer.isIntersect(mousePos, _self.domElement)) {
			Designer.removeEvent(document, "mousemove", _panelStepSideHidden);
			_panelStepSideHiddenInterval();
		}
	};
	
	var _panelLeftPosSet = function() {
		_self.domElement.style.left = (document.body.clientWidth + document.body.scrollLeft - _self.domElement.offsetWidth) + 'px';
	};

	// 功能：初始化开始执行隐藏
	this.panelStartSideHidden = function() {
		if (!_self.canHidden) {return false;}
		if (_self.domElement.style.overflowX != null) {
			_self.domElement.style.overflowX = 'hidden';
			_self._isResizeHeight = false;
		} else {
			_self._isResizeHeight = true;
			_self.domElement.style.overflow = 'hidden';
		}
		Designer.addEvent(document, "mousemove", _panelStepSideHidden);
		_panelLeftPosSet();
		Designer.addEvent(window , 'scroll' , _panelLeftPosSet);
	};

	// 功能：释放隐藏相关事件，以及恢复外形宽度。 外部绝对定位需调用
	this.relaseSideHidden = function() {
		// 清理定时
		if (_self.timer) {
			clearTimeout(_self.timer);
			_self.timer = null;
		}
		// 移除隐藏移动触发事件
		Designer.removeEvent(document, "mousemove", _panelStepSideHidden);
		// 移除显示移动触发事件
		Designer.removeEvent(_self.domElement, "mouseover", _panelStepSideShow);
		Designer.removeEvent(window , 'scroll' , _panelLeftPosSet);
		// 展现被隐藏部分
		if (_self.domElement.offsetWidth < _self.titleBar.offsetWidth) {
			_self.domElement.style.width = _self.titleBar.offsetWidth + 'px';
		}
	};
}

function _Designer_Panel_InvokeListeners(listeners) {
	for (var i = 0; i < listeners.length; i ++) {
		listeners[i](this);
	}
}

function Designer_Panel_Default_TitleDraw() {
	this.title = document.createElement('div');
	this.title.className = 'panel_title';
	var html = '<div class="panel_title_left"><div class="panel_title_right"></div><div class="panel_title_center">'
		+ '<div class="panel_title_text"><div></div></div>';
	
	var tbb = document.createElement('div');
	tbb.className = "panel_title_btn_bar";
	var self = this;

	var tbc = document.createElement('a');
	tbc.href = "#";
	tbc.title = Designer_Lang.panelCloseTitle;
	tbc.className = "panel_title_close";
	tbb.appendChild(tbc);

	var tbf = document.createElement('a');
	tbf.href = "#";
	tbf.title = Designer_Lang.panelFoldTitle;
	tbf.className = "panel_title_fold";
	tbb.appendChild(tbf);

	var tbe = document.createElement('a');
	tbe.href = "#";
	tbe.title = Designer_Lang.panelExpandTitle;
	tbe.className = "panel_title_expand";
	tbe.style.display = 'none';
	tbb.appendChild(tbe);
	
	this.title.innerHTML = html;
//	if (this.title.childNodes)
//		this.title.insertBefore(tbb, this.title.childNodes[0]);
//	else
		this.title.appendChild(tbb);
	this.panel.drawTitle(this.title);

	tbc.onclick = function() {
		self.panel.close();
		self.panel.owner._currentFocus = null;
		return false;
	}
	tbf.onclick = function() {
		self.panel.fold();
		tbe.style.display = '';
		this.style.display = 'none';
		return false;
	}
	tbe.onclick = function() {
		self.panel.expand();
		tbf.style.display = '';
		this.style.display = 'none';
		return false;
	}
	this.panel.openListeners.push(function() {
		tbe.style.display = 'none';
		tbf.style.display = '';
	});
}

function Designer_Panel_Default_SetTitle(text) {
	if (this.titleText == null) {
		var tts = this.title.getElementsByTagName("div");
		for (var i = 0; i < tts.length; i++) {
			if (tts[i].className == 'panel_title_text') {
				this.titleText = tts[i];
				break;
			}
		}
	}
	this.titleText.innerHTML = '<span>' + text + '</span>';
}

function Designer_Panel_Default_BottomDraw() {
	var bottom_bottom = document.createElement('div');
	bottom_bottom.innerHTML = '<div class="panel_bottom_left"><div class="panel_bottom_right"></div>'
		+ '<div class="panel_bottom_center"></div></div>';
	bottom_bottom.className = 'panel_bottom';
	this.domElement.appendChild(bottom_bottom);
}