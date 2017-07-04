/**********************************************************
功能：设计器对象定义
使用：

备注：
	要调用Designer对象，返回对象必须和参数id同名。
	示例：var test = new Designer('test');

作者：龚健
创建时间：2009-02-18
**********************************************************/
function Designer(id) {
	//属性
	this.useType = '表单自定义';									// 用途
	this.version = '1.0';
	this.id = id;
	this.fdKey = '';

	this.controlDefinition = null;
	this.control = null;										// 当前控件对象
	this.controls = [];

	this.isUpTab = false;                                      //是否将选项卡提升
	this.isChanged = false;
	this.hasInitialized = false;

	this.toolBar = null;										// 工具栏
	this.toolBarDomElement = null;
	this.toolBarAction = '';									// 当前工具栏选中的操作类型

	this.builder = null;										// 绘制区
	this.builderDomElement = null;

	this.previewBar = null;
	this.attrPanel = null;
	this.hiddenDomElement = null;

	this.effect = null;											// 动画对象
	this.shortcuts = null;										// 快捷键对象
	this.cache = null;											// 缓存对象
	
	// 事件
	this._eventListeners = {};

	//内部属性
	this._currentFocus = null;									// 当前焦点对象
	this._modelName = null;										// model名
	this._dblClickTime = 0;

	//内部调用方法
	this._drawFrame = _Designer_DrawFrame;						// 绘制设计器框架
	this._initControl = _Designer_InitControl;
	this._doFocus = _Designer_DoFocus;							// 处理当前焦点对象焦点事件
	this._getSysObj = _Designer_GetSysObj;						// 获取系统内置数据字典对象

	//公共方法
	this.setControl = Designer_SetControl;
	this.setModel = Designer_SetModel;							// 记录当前使用的model名
	this.initialize = Designer_Initialize;
	this.adjustBuildArea = Designer_AdjustBuildArea;			// 调整绘制区的宽度和高度
	this.bindEvent = Designer_BindEvent;
	this.getHTML = Designer_GetHTML;
	this.setHTML = Designer_SetHTML;
	this.getXML = Designer_GetXML;
	this.checkoutAll = Designer_Attr_ALL_Checkout;				// 校验所有控件
	this.getObj = Designer_GetObj;								// 获取控件属性对象
	this.addListener = Designer_AddListener;                    // 增加监听器
	this.removeListener = Designer_RemoveListener;              // 移除监听器
	this.fireListener = Designer_FireListener;                  // 通知监听器


	//初始化控件相关定义
	this._initControl();
};

/**********************************************************
描述：
	公共函数
功能：
	Designer_Initialize : 初始化设计器
	Designer_AdjustBuildArea : 调整绘制区的宽度和高度
**********************************************************/
function Designer_Initialize(parentElement) {
	this._drawFrame(parentElement);
	//整个页面不能选择
	this.builderDomElement.onselectstart = function(){return false;};
	//屏蔽右键
	Designer.addEvent(document, "contextmenu", function(event){return false;});
	//让快捷键生效
	//this.builderDomElement.focus();
	var _self = this;
	Designer.addEvent(window, "resize", function() {
		_self.adjustBuildArea();
	});
	this.hasInitialized = true;
};

function Designer_AdjustBuildArea() {
	with(this.builderDomElement) {
		style.width = '100%';
		style.height = '100%';
	}
	if (this.toolBar)
		this.toolBarDomElement.style.height = this.toolBar.domElement.offsetHeight + 'px';
};

function Designer_BindEvent(event, ownerName, eventHandle) {
	var _event = event || window.event, _ownerName = ownerName || null, _eventHandle = eventHandle || null;
	var _Owner = null;
	if (_ownerName == null || _eventHandle == null) return;
	//事件主体
	if (_ownerName == 'builder') _Owner = this.builder;
	if (_Owner == null) return;
	//触发相应的事件
	switch (eventHandle) {
	case 'mousedown':
		// 使用自定义的双击事件，主要针对出现拖拽遮罩时，导致非IE下无法触发双击
		var t = (new Date()).getTime();
		if (t - this._dblClickTime < 500) {
			this.bindEvent(event, ownerName, 'dblclick');
			return;
		}
		this._dblClickTime = t;
		if (_Owner._mouseDown) _Owner._mouseDown(event);
		break;
	case 'mousemove':
		if (_Owner._mouseMove) _Owner._mouseMove(event);
		break;
	case 'mouseup':
		if (_Owner._mouseUp) _Owner._mouseUp(event);
		break;
	case 'dblclick':
		this._dblClickTime = 0;
		if (_Owner._dblClick) _Owner._dblClick(event);
		break;
	}
};

function Designer_GetHTML() {
	var builder = this.builder;
	//序列化相关信息
	builder.onSerialize();
	builder.serialize();
	//清除控件编辑时才有用的信息
	builder.cleanControls();
	//虚线框移到临时存储区
	builder.moveDashBox(this.hiddenDomElement);
	//记录输出的HTML
	var rtnHTML = this.builderDomElement.innerHTML;
	//#4497 解决IE 下innerHTML带img src属性带绝对路径问题 #曹映辉 2014.8.21
	var absolutePath=location.href;
	absolutePath=absolutePath.substring(0,(absolutePath.lastIndexOf("\/")+1));
	rtnHTML=rtnHTML.replace(new RegExp(absolutePath,"gm"),"");
	
	//虚线框移回到绘制区
	builder.moveDashBox(this.builderDomElement);
	builder.onSerialized();

	this.isChanged = (this._oldHTML != rtnHTML);
	return rtnHTML;
};

function Designer_SetHTML(html, setOld) {
	var builder = this.builder;
	// 清除控件
	builder.controls = [];
	//虚线框移到临时存储区
	builder.moveDashBox(this.hiddenDomElement);
	//载入HTML
	this.builderDomElement.innerHTML = html;
	//虚线框移回到绘制区
	builder.moveDashBox(this.builderDomElement);
	//初始化对象集
	builder.parse(null, this.builderDomElement);
	if (setOld == true)
		this._oldHTML = this.getHTML();
	this.fireListener("setHtml");
};

function Designer_GetXML() {
	var builder = this.builder;
	var buf = ['<model '];
	if (window.parent) {
		var e = window.parent.document.getElementById('extendDaoEventBean');
		if (e && e.value != null && e.value != '') {
			buf.push('extendDaoEventBean="', e.value, '" ');
		}
		var entityName = window.parent.document.getElementById('formEntityName');
		if (entityName && entityName.value != null && entityName.value != '') {
			buf.push('entityName="', entityName.value, '" ');
		}
	}
	buf.push('>\r\n');
//		buf.push('name="', this.options.domElement.id, '" ');
//		buf.push('label="', values.label, '" ');
//		buf.push('type="main">');
	if (builder.controls.length > 0) {
		builder.controls = builder.controls.sort(Designer.SortControl);
		for (var i = 0, l = builder.controls.length; i < l; i ++) {
			var c = builder.controls[i];
			if (c.drawXML) {
				buf.push(c.drawXML());
			}
		}
	}
	buf.push('</model>');
	return buf.join('');
}

/**
 * 获取公式变量对象 (局部混乱中)
 */
function Designer_GetObj(isGlobal, isStore) {
	var objs = [];
	//var obj = {name : 'fd_124',label:'主表', children : objs};
	if (isGlobal && window.parent) {
		var callFun = new Function('return window.parent._XForm_GetSysDictObj_' + this.fdKey + '();');
		var sysObjs = callFun();
		if (sysObjs != null) {
			objs = objs.concat(sysObjs);
		}
	}
	var controls = this.builder.controls.sort(Designer.SortControl);
	_Designer_GetObj(controls, objs, isStore ? true : false);
	return objs;
}

function _Designer_GetObj(controls, objs, isStore) {
	for (var i = 0, l = controls.length; i < l; i ++) {
		var control = controls[i];
		if (control.storeType == 'none')
			continue;
		if (control.storeType == 'layout' && !isStore) {
			_Designer_GetObj(control.children.sort(Designer.SortControl), objs, isStore);
			continue;
		}
		var rowDom = Designer_GetObj_GetParentDom(function(parent) {
			return (Designer.checkTagName(parent, 'tr') && parent.getAttribute('type') == 'templateRow')
		}, control.options.domElement);
		
		var obj = {}, isTempRow = (rowDom != null && rowDom.getAttribute('type') == 'templateRow');
		if (control.options.values.__dict__) {
			var dict = control.options.values.__dict__;
			for (var di = 0; di < dict.length; di ++) {
				var _dict = dict[di];
				objs.push({
					name: _dict.id,
					label: _dict.label,
					type: _dict.type,
					isTemplateRow: isTempRow
				});
			}
		} else {
			obj.name = control.options.values.id;
			obj.label = control.options.values.label;
			obj.type = _Designer_GetObj_GetType(control);
			obj.isTemplateRow = isTempRow;
			objs.push(obj);
		}
		/*
		obj.children = [];
		if (isStore) {
			obj.isTable = (control.storeType == 'layout');
			obj.values = control.options.values;
		}
		_Designer_GetObj(control.children.sort(Designer.SortControl), obj.children, isStore);
		*/
		var childrenObj = [];
		_Designer_GetObj(control.children.sort(Designer.SortControl), childrenObj, isStore);
		for (var j = 0; j < childrenObj.length; j ++) {
			var chc = childrenObj[j];
			if (chc.isTemplateRow) {
				chc.name = obj.name + '.' + chc.name;
				chc.label = obj.label + '.' + chc.label;
				chc.type = chc.type + '[]';
			}
			objs.push(chc);
		}
	}
}
function Designer_GetObj_GetParentDom(tagName, dom) {
	var parent = dom;
	while((parent = parent.parentNode) != null) {
		if (typeof tagName == 'function') {
			if (tagName(parent))
				return parent;
		}
		else if (Designer.checkTagName(parent, tagName)) {
			return parent;
		}
	}
	return parent;
}
// 根据控件类型，判断后传回持久化对话框要用的数据类型
function _Designer_GetObj_GetType(control) {
	var values = control.options.values;
	if (control.type == 'rtf') {
		return 'RTF';
	}
	if (control.type == 'address') {
		var orgType = 'com.landray.kmss.sys.organization.model.SysOrgElement';
		return values.multiSelect == 'true' ? orgType + '[]' : orgType;
	}
	if (control.type == 'datetime') {
		if (values.businessType == 'timeDialog') {
			return 'Time';
		}
		return 'Date';
	}
	return (values.dataType ? values.dataType : 'String');
}

// 设置当前操作对象，并触发其他控件onSelectControl事件
function Designer_SetControl(control) {
	this.control = control;
	this.toolBar.onSelectControl();
}

function _Designer_GetSysObj() {
	if (window.parent) {
		return (new Function('return window.parent._XForm_GetSysDictObj_' + this.fdKey + '();'))();
	} else {
		return [];
	}
}

function Designer_AddListener(name, fun) {
	var evt = this._eventListeners[name];
	if (evt == null) {
		evt = [];
		this._eventListeners[name] = evt;
	}
	evt.push(fun);
}

function Designer_RemoveListener(name, fun) {
	var evt = this._eventListeners[name];
	if (evt != null) {
		for (var i = 0; i < evt.length; i ++) {
			if (fun === evt[i]) {
				evt.splice(i, 1);
				return;
			}
		}
	}
}

function Designer_FireListener(name) {
	var evt = this._eventListeners[name];
	if (evt != null) {
		for (var i = 0; i < evt.length; i ++) {
			evt[i](this);
		}
	}
}

function Designer_SetModel(modelName) {
	this._modelName = modelName || null;
}

/**********************************************************
描述：
	内部调用函数
功能：
	_Designer_DrawFrame   : 绘制设计器框架
	_Designer_InitControl : 初始化控件相关定义
	_Designer_DoFocus     : 处理当前焦点对象焦点事件
**********************************************************/
function _Designer_DrawFrame(parentElement) {
	var _parentElement = parentElement || null, buf = new Array();
	buf.push('<table width="100%" height="100%" cellspacing="0" cellpadding="0" border="0">');
	buf.push('<tr><td colspan="3" id="designer_toolbar" height="30" valign="top"></td></tr>');
	buf.push('<tr><td width="0" valign="top" id="designer_draw_left"></td><td valign="top">');
	buf.push('<div id="designer_draw" style="height:100%"');
	buf.push(' onmousedown="' + this.id + '.bindEvent(event, \'builder\', \'mousedown\');"');
	buf.push(' onmousemove="' + this.id + '.bindEvent(event, \'builder\', \'mousemove\');"');
	buf.push(' onmouseup="' + this.id + '.bindEvent(event, \'builder\', \'mouseup\');"');
	buf.push(' ondblclick="' + this.id + '.bindEvent(event, \'builder\', \'dblclick\');"');
	buf.push('>&nbsp;</div></td><td width="0" valign="top" id="designer_draw_right"></td></tr>');
	buf.push('</table>');
	buf.push('<div id="designer_hidden" style="display:none"></div>');
	if (_parentElement == null) _parentElement = document.body || document.documentElement;
	_parentElement.innerHTML = buf.join('');

	this.toolBarDomElement = Designer.$('designer_toolbar');
	this.builderDomElement = Designer.$('designer_draw');
	this.hiddenDomElement = Designer.$('designer_hidden');
	this.builderLeftDomElement = Designer.$('designer_draw_left');
	this.builderRightDomElement = Designer.$('designer_draw_right');

	this.adjustBuildArea();

	//快捷键对象
	if (typeof(Designer_Shortcut) != 'undefined') this.shortcuts = new Designer_Shortcut();
	//动画对象
	if (typeof(Designer_Animation) != 'undefined') this.effect = new Designer_Animation(this);
	//缓存对象
	if (typeof(Designer_Cache) != 'undefined') this.cache = new Designer_Cache('landray');
	//绘制区
	if (typeof(Designer_Builder) != 'undefined') this.builder = new Designer_Builder(this);
	//工具栏
	if (typeof(Designer_Toolbar) != 'undefined') this.toolBar = new Designer_Toolbar(this);
	//属性框
	if (typeof(Designer_AttrPanel) != 'undefined') this.attrPanel = new Designer_Panel(this, new Designer_AttrPanel());
	//控件树
	if (typeof(Designer_TreePanel) != 'undefined') this.treePanel = new Designer_Panel(this, new Designer_TreePanel());
	//基本属性列表
	if (typeof(Designer_FieldPanel) != 'undefined') this.fieldPanel = new Designer_Panel(this, new Designer_FieldPanel());
	//右键菜单
	if (typeof(Designer_RightMenu) != 'undefined') this.rightMenu = new Designer_RightMenu(this, null, Designer_Menus);
	
	this.adjustBuildArea();
};

function _Designer_InitControl() {
	var definition = null;
	//控件定义
	if (typeof(Designer_Control_Definition) == 'undefined') return;
	definition = new Designer_Control_Definition();
	this.controlDefinition = definition.controls;
};

function _Designer_DoFocus(currentFocus) {
	if (this._currentFocus === currentFocus) return true;
	if (this._currentFocus && this._currentFocus.onLeave) {
		if (!this._currentFocus.onLeave()) {
			return false;
		}
	}
	this._currentFocus = currentFocus;
	return true;
};


/**********************************************************
描述：
	以下所有函数为设计器公用函数。
功能：
	$                 : 获得Dom对象，根据ID。
		  参数: id或id集合
		  返回: 一个或多个对象

	absPosition       : 获得Dom对象的绝对位置。

	getDesignElement  : 获得设计元素

	isDesignElement   : 是否是设计元素

	extend            : 复制对象
		  参数:
			  destination : 目标对象
			  source      : 源对象
			  mode        : 复制模式 注：可选，值为：onlyMethod(只复制方法)

	$A                : 参数转换成数组。

	getBrowser        : 获得浏览器信息

	getBrowserVersion : 获得浏览器版本信息

	addEvent          : 追加事件
		  参数:
			  element     : 源对象
			  eventHandle : 源对象的事件句柄，比如click
			  method      : 绑定的方法句柄
		  示例:
		      function ceshi(event, p1, p2){};
			  var p = ['1', '2'];
			  addEvent(element, 'click', ceshi);

	removeEvent       : 删除事件

	bindEvent         : 绑定事件
		  参数: (按顺序)
			  1. element: 源对象
			  2. eventHandle: 源对象事件句柄
			  3. method: 绑定方法句柄
			  4. 绑定方法参数
			  5. 绑定方法参数...
		  示例:
		      function ceshi(event, p1, p2){};
			  =>bindEvent(element, 'click', ceshi, p1, p2);

	leaveEvent        : 解除事件(与bindEvent方法相反)

	getWindowSize     : 获得当前窗口的宽和高

	getMousePosition  : 获得当前鼠标坐标

	isIntersect       : 检测坐标是否在Dom对象区域中
		  参数:
			  position : (X坐标，Y坐标)
			  element  : Dom对象

	spliceArray       : 从一个数组中移除指定的元素

	getElementsByClassName : 获得Dom对象集，根据className

	checkTagName      : 校验Dom元素的tagName
**********************************************************/
Designer.$ = function() {
	var results = [], element;
	for (var i = 0; i < arguments.length; i++) {
		element = arguments[i];
		if (typeof element == 'string') element = document.getElementById(element);
		results.push(element);
	}
	return results.length < 2 ? results[0] : results;
};

Designer.absPosition = function(node, stopNode) {
	var x = y = 0;
	//for (var pNode = node; pNode != null && pNode !== stopNode; pNode = pNode.offsetParent) {
		//x += pNode.offsetLeft - pNode.scrollLeft; y += pNode.offsetTop - pNode.scrollTop;
//		if ( pNode.style.position == 'absolute' || pNode.style.position == 'relative'  
//            || ( pNode.style.overflow != 'visible' && pNode.style.overflow != '' ) ) {
//            break;
//        }
		//x += pNode.offsetLeft; y += pNode.offsetTop;
	//}
	//x = x + document.body.scrollLeft;
	//y = y + document.body.scrollTop;
//	if (window.console)
//		console.info('absPosition:', {'x':x, 'y':y}, node.tagName);
	var offset = $(node).offset();
	return {'x':offset.left, 'y':offset.top};
};

Designer.getDesignElement = function(node, attr) {
	if (attr == null) attr = 'parentNode';
	for (var findNode = node; findNode && findNode.tagName && findNode.tagName.toLowerCase() != 'body'; findNode = findNode[attr]) {
		if (Designer.isDesignElement(findNode)) return findNode;
	}
	return null;
};

Designer.isDesignElement = function(node) {
	return node && node.getAttribute('formDesign') && node.getAttribute('formDesign') == 'landray';
};

Designer.extend = function() {
	var target = arguments[0] || {}, i = 1, length = arguments.length, deep = false, options;
	if ( target.constructor == Boolean ) {
		deep = target;
		target = arguments[1] || {};
		i = 2;
	}
	if ( typeof target != "object" && typeof target != "function" ) target = {};
	if ( length == i ) {
		target = this;
		--i;
	}

	for ( ; i < length; i++ )
		if ( (options = arguments[ i ]) != null )
			for ( var name in options ) {
				var src = target[ name ], copy = options[ name ];
				if ( target === copy ) continue;
				if ( deep && copy && typeof copy == "object" && !copy.nodeType )
					target[ name ] = Designer.extend( deep, src || ( copy.length != null ? [ ] : { } ), copy );
				else if ( copy !== undefined )
					target[ name ] = copy;
			}
	return target;
};

Designer.$A = function(iterable) {
	if (!iterable) return [];
	if (iterable.toArray) {
		return iterable.toArray();
	} else {
		var results = [];
		for (var i = 0; i < iterable.length; i++)
			results.push(iterable[i]);
		return results;
	}
};

Designer.getBrowser = function() {
	var userAgent = navigator.userAgent.toLowerCase();
	if (/msie/.test( userAgent ) && !/opera/.test( userAgent )) return 'msie';
	if (/mozilla/.test( userAgent ) && !/(compatible|webkit)/.test( userAgent )) return 'mozilla';
	if (/webkit/.test( userAgent )) return 'safari';
	if (/opera/.test( userAgent )) return 'opera';
};

Designer.getBrowserVersion = function() {
	var userAgent = navigator.userAgent.toLowerCase();
	return (userAgent.match( /.+(?:rv|it|ra|ie)[\/: ]([\d.]+)/ ) || [])[1];
};

Designer.UserAgent = Designer.getBrowser();

Designer.instance = new Designer('Designer.instance');

Designer.addEvent = function(element, eventHandle, method) {
	if(Designer.UserAgent == 'msie')
		element.attachEvent("on" + eventHandle, method);
	else
		element.addEventListener(eventHandle, method, false);
};

Designer.removeEvent = function(element, eventHandle, method) {
	if(Designer.UserAgent == 'msie')
		element.detachEvent("on" + eventHandle, method);
	else
		element.removeEventListener(eventHandle, method, false);
};

Designer.bindEvent = function(element, eventHandle, method) {
	var args = Designer.$A(arguments), args = args.slice(3);
	element[eventHandle + method] = function(event) {
		return method.apply(element, [event||window.event].concat(args));
	};
	Designer.addEvent(element, eventHandle, element[eventHandle + method]);
};

Designer.leaveEvent = function(element, eventHandle, method) {
	Designer.removeEvent(element, eventHandle, element[eventHandle + method]);
	element[eventHandle + method] = null;
};

Designer.getWindowSize = function() {
	var width = Math.max(document.documentElement.clientWidth, document.body.clientWidth);
	var height = Math.max(document.documentElement.clientHeight, document.body.clientHeight);
	return {
		width  : Math.max(width, document.body.scrollWidth),
		height : Math.max(height, document.body.scrollHeight)
	};
};

Designer.getMousePosition = function(event) {
	var pos = null;
	if (event.clientX || event.clientY) {
		pos = {
			x:event.clientX + document.body.scrollLeft - document.body.clientLeft,
			y:event.clientY + document.body.scrollTop  - document.body.clientTop
		};
	}
	else {
		//console.info('use page x y');
		pos = {x:event.pageX, y:event.pageY};
	}
	//console.info("pos x = " + pos.x + ", y = " + pos.y);
	return pos;
};

Designer.eventButton = function(event) {
	var button = event.button;
	if (event.which != null) { // 用which确定按键
		if (1 == event.which) {
			return 1;
		}
		if (2 == event.which) {
			return 4;
		}
		if (3 == event.which) {
			return 2;
		}
	}
	if ('msie' == Designer.UserAgent) {
		return button;
	}

	if (0 == button) {
		return 1;
	}
	if (1 == button) {
		return 4;
	}
	return button;
};

Designer.isIntersect = function(position, element) {
	if (!element) return false;
	var area = Designer.absPosition(element);
	return !(position.x < area.x || position.y < area.y ||
		position.x > (area.x + element.offsetWidth) || position.y > (area.y + element.offsetHeight));
};

Designer.spliceArray = function(array, spliced) {
	for (var i = 0; i < array.length; i++)	{
		if (array[i] == spliced) {
			array.splice(i, 1);
			break;
		}
	}
};

Designer.getElementsByClassName = function(className, parent) {
	var _parent = parent || document, matches = [], nodes = _parent.getElementsByTagName('*');
	for (var i = nodes.length - 1; i >= 0; i--) {
		if (nodes[i].className == className || nodes[i].className.indexOf(className) + 1 ||
			nodes[i].className.indexOf(className + ' ') + 1 || nodes[i].className.indexOf(' ' + className) + 1)
			matches.push(nodes[i]);
	}
	return matches;
};

Designer.checkTagName = function(element, tagName) {
	return element && element.tagName && element.tagName.toLowerCase() == tagName.toLowerCase();
};

Designer.generateID = function (){
	return parseInt(((new Date().getTime()+Math.random())*10000)).toString(16);
};

Designer.HtmlEscape = function (s){
	if (s == null || s ==' ') return '';
	s = s.replace(/&/g, "&amp;");
	s = s.replace(/\"/g, "&quot;");
	s = s.replace(/</g, "&lt;");
	return s.replace(/>/g, "&gt;");
};

//控件按位置排序
Designer.SortControl = function (a, b) {
	var aElem = a.options.domElement;
	var bElem = b.options.domElement;
	
	if (aElem.parentNode.tagName != 'TD' || bElem.parentNode.tagName != 'TD') {
		return Designer.SortCompareByAbs(aElem, bElem);
	}
	var aTd = aElem.parentNode, aTr = aTd.parentNode;
	var bTd = bElem.parentNode, bTr = bTd.parentNode;
	var result = aTr.rowIndex - bTr.rowIndex;
	if (result != 0) return result;
	result = aTd.cellIndex - bTd.cellIndex;
	if (result != 0) return result;
	return Designer.SortCompareByAbs(aElem, bElem);
}
// 没在表格中，直接比较坐标
Designer.SortCompareByAbs = function (aElem, bElem) {
	var aPos = Designer.absPosition(aElem);
	var bPos = Designer.absPosition(bElem);
	var result = aPos.x - bPos.x;
	if ( result > 5 || result < -5) return result;
	result = aPos.y - bPos.y;
	if ( result > 5 || result < -5) return result;
	return 0;
}

//====================::::::::::数据初始化::::::::::====================
Designer.Initialize = function () {
	//等待页面载入后再执行
	if(document.body == null) {
		setTimeout("Designer.Initialize();", 100);
		return;
	}
	if(document.body.clientWidth == 0) {
		document.body.onresize = function() {
			document.body.onresize = null;
			Designer.Initialize();
		};
		return;
	}
	document.body.style.cursor="default";
	//初始化设计器
	Designer.instance.initialize();
};