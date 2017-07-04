/***********************************************
JS文件说明：
	该文件是前端页面的事件总线，可以作为事件管理。
	包含的对象：
		1. Bus 事件总线对象
		2. Channel 频道，可配置事件频道名，事件使用元素集，事件激活方法。
	规则：
		1. 频道常规规则，window.eventBus.addChannels(channels)注入自定义频道，然后在页面元素中添加自定义的频道属性。
		2. 自助频道规则，页面元素中添加自定义频道属性，此属性的规则是 on_自定义事件名_频道名，自定义事件名来自于DefaultCustomEvents
		或通过window.eventBus.addCustomEvents(customEvents)注入的自定义事件。其使用范围是当前页面所有元素，触发条件就是自定义事件
		定义的激活的事件。
	使用：
		1. 频道常规规则样例：
			<input type="text" name="ttt" xform="true" onValueChange="window.status+='test case is ok';"/>
			<button name="btnTest" act="true" onclick="alert(' click   按钮点击   ');">测试</button>
			onValueChange在缺省频道集中有相应的配置。频道是由按钮的click触发，对于配置中的isActivator配置和activate配置。
		2. 自助频道规则样例：
			<input type="text" name="ttt" on_change_example="window.status+='test case is ok';"/>
			on_change_example根据规则，会自动激活change自定义事件，并根据配置在当前页面所有元素中on_change_example频道中广播。
作者：龚健
版本：1.0 2010-6-28
***********************************************/
(function(window){
// 事件总线
function Bus() {
	// 内部属性
	this._defaultChannel = new DefaultChannel();					// 缺省事件频道
	this._channels = {};											// 频道集
	this._activeChannel = {element: null, channel:null, arg:[]};	// 当前被激活的频道，激活对象，频道参数
	this._customEvents = {};										// 常用的自定义事件
	
	// 内部函数
	this._dispatch = _Bus_Dispatch;
	this._notify = _Bus_Notify;										// 激活指定对象的指定频道
	this._getEvent = _Bus_GetEvent;
	this._registerActivator = _Bus_RegisterActivator;
	this._bindActivator = _Bus_BindActivator;
	this._beforePublish = _Bus_BeforePublish;
	this._getChannel = _Bus_GetChannel;
	this._initialize = _Bus_Initialize;
	
	// 公用函数
	this.publish = Bus_Publish;
	this.subscribe = Bus_Subscribe;
	this.addChannel = Bus_AddChannel;
	this.addChannels = Bus_AddChannels;
	this.addCustomEvents = Bus_AddCustomEvents;
	
	this._initialize();
};

function Bus_Publish(channel, arg) {
	var channelName = channel || null;
	if (channelName == null) return;
	
	this._activeChannel.channel = channelName;
	this._activeChannel.arg = arg;
	// 在指定频道中广播
	var chn = this._getChannel(channelName);
	var elements = chn.channel.getElements(chn.name);
	for (var i = 0, length = elements.length; i < length; i++) {
		this._activeChannel.element = elements[i];
		this._dispatch();
	}
};

function Bus_Subscribe(element, channel, arg) {
	var channelName = channel || null, elementToUse = element || null;
	if (channelName == null || elementToUse == null) return;
	
	var chn = this._getChannel(channelName);
	if (chn.channel.isElement(elementToUse, chn.name)) {
		this._activeChannel.element = elementToUse;
		this._activeChannel.channel = channelName;
		this._activeChannel.arg = arg;
		this._dispatch();
	}
};

function Bus_AddChannel(name, elements, elementFilter, activate, isActivator, channelInfo) {
	this._channels[name] = new Channel(name, elements, elementFilter, activate, isActivator, channelInfo);
};

function Bus_AddChannels(channels) {
	for (var name in channels) {
		var _channel = channels[name];
		this._channels[name] = new Channel(name, _channel.elements, _channel.elementFilter,
				_channel.activate, _channel.isActivator, _channel.channelInfo);
	}
};

function Bus_AddCustomEvents(customEvents) {
	Bus_Extend(true, this._customEvents, customEvents);
};

/**********************************************************
描述：
	以下事件总线的内部函数。
功能：
	_Bus_Initialize					: 初始化总线对象
	_Bus_Dispatch					: 频道广播
	_Bus_Notify						: 激活指定对象的指定频道
	_Bus_GetEvent					: 根据自定义事件->浏览器事件的顺序查找，返回事件名
	_Bus_RegisterActivator			: 注册激活器，并且绑定相应事件
	_Bus_BindActivator				: 绑定激活事件
	_Bus_BeforePublish				: 广播事件前执行的过滤器，此过滤器只在自动激活的时候有用
	_Bus_GetChannel					: 根据频道名，返回频道对象和频道真实名
*********************************************************/
function _Bus_Initialize() {
	// 常用的事件频道
	this.addChannels(Bus.DefaultChannels);
	// 缺省的自定义事件
	this.addCustomEvents(Bus.DefaultCustomEvents);
	// 初始化分发事件和激活事件
	var _self = this;
	if (document.addEventListener) {
		this._chanelEvent = document.createEvent("HTMLEvents");
		this._chanelEvent.initEvent("chanelEvent", false, false);
		document.addEventListener("chanelEvent", function() {
			_self._notify();
	    }, false);
		document.addEventListener("focus", function(event) {
			var _event = event || window.event;
			_self._registerActivator(_event.srcElement || _event.target);
	    }, true);
	} else if (document.attachEvent) {
		document.body.channel = 0;
	    document.body.attachEvent("onpropertychange", function(event) {
	    	if (event.propertyName == "channel") _self._notify();
	    });
	    document.attachEvent('onfocusin', function(){
			_self._registerActivator(window.event.srcElement);
		});
	}
};

function _Bus_Dispatch() {
	if (document.addEventListener) {
        document.dispatchEvent(this._chanelEvent);
	} else if (document.attachEvent) {
		document.body.channel++;
	}
};

function _Bus_Notify(element, channel, arg) {
	var _activeChannel = this._activeChannel;
	var elementToUse = element || _activeChannel.element || null;
	var channelNameToUse = channel || _activeChannel.channel || null;
	if (elementToUse == null || channelNameToUse == null) return;
	// 初始化广播参数
	var _arg = arg || _activeChannel.arg;
	var argToUse = (_arg instanceof Array) ? _arg : [_arg];
	// 广播...
	var chn = this._getChannel(channelNameToUse);
	var _method = chn.channel.getPublish(elementToUse, chn.name);
	if (_method) _method.apply(elementToUse, argToUse);
};

function _Bus_GetEvent(eventName, element, isDefault) {
	var arrName = eventName.split(':'), _name = arrName[0], _check = (arrName.length == 2) ? arrName[1] : null;
	var nameToUse = isDefault ? null : _name, eventToUse = this._customEvents[_name];
	if (eventToUse) {
		var ctmEvent = eventToUse(element);
		if (typeof(ctmEvent) == 'string') {
			arrName = ctmEvent.split(':');
			nameToUse = arrName[0];
			_check = (arrName.length == 2) ? arrName[1] : null;
		}
	}
	if (nameToUse == null) return null;
	nameToUse = (nameToUse.indexOf('on') == 0) ? nameToUse.substr(2) : nameToUse;
	return {name: nameToUse, check: _check};
};

function _Bus_RegisterActivator(element) {
	if (element['isChannel']) return;
	if(element.attributes == null)
		return;
	// 激活相关的所有自定义频道
	for (var i = 0, length = element.attributes.length; i < length; i++) {
		var att = element.attributes[i];
		if (att.nodeType && att.nodeType == 2) this._bindActivator(element, att.nodeName);
	}
	// 激活相关的常用频道
	for (var name in this._channels) {
		this._bindActivator(element, name);
	}
	element['isChannel'] = 'true';
};

function _Bus_BindActivator(element, channelName) {
	var chn = this._getChannel(channelName);
	// 不属于频道的适用范围
	if (!chn.channel.isActivator(element, chn.name)) return;
	// 获取激活事件
	var activateName = chn.channel.getActivateName(element, chn.name);
	if (activateName) {
		var eventInfo = this._getEvent(activateName, element, chn.name != null);
		if (eventInfo == null) return;
		// 绑定事件
		var self = this, channelInfo = chn.channel.getChannelInfo();
		Bus_AddEvent(element, eventInfo.name, function(event){
			if (self._beforePublish(event, eventInfo.name, eventInfo.check)) self.publish(channelName, [element, channelInfo]);
		}, false);
	}
};

function _Bus_BeforePublish(event, eventName, checkValue) {
	if (checkValue) {
		switch (eventName) {
		case 'propertychange':
			return event.propertyName.toLowerCase() == checkValue;
		}
	}
	return true;
};

function _Bus_GetChannel(channelName) {
	var _name = null, _channel = this._channels[channelName];
	if (!_channel) {
		_channel = this._defaultChannel;
		_name = channelName;
	}
	return {channel: _channel, name: _name};
};

/**********************************************************
功能：事件频道
格式：
	name: {
		elements : function() {return []},
		elementFilter : function(element) {return true;},
		activate : function(element) {return null;},
		isActivator : function(element) {return true;},
		channelInfo : new Object()
	}
参数：
	1. name --> 广播频道名
	2. elements --> 获取适用元素集的函数 --> 例如：开始时间和结束时间需要相差7天，即开始时间和结束事件是联动事件，则元素集[开始时间域，结束时间域]
	3. elementFilter --> 过滤适用元素的函数 --> 例如：xform只有效于拥有xform属性，并且此属性不为空的所有页面元素，则element.getAttribute("xform")
	4. activate --> 激活器事件名，在适用范围内的任一元素一旦触发此事件则会自动触发广播事件，此激活事件必须是浏览器支持的事件。
	5. isActivator --> 检测是否是激活对象。
	6. channel --> 广播时作为参数（参数名channel）传递。
备注：
	name 必填。
	elements 可选，若没有此方法或提供的函数返回的不是数组时，则会把当前页面所有元素作为适用范围。
	elementFilter 可选，若没此方法，则不做任何过滤。
	activate 可选，此函数必须返回激活事件的函数名。此激活事件必须是浏览器支持的事件或自定义事件，否则不能自动激活。例如：click,mouseover。
	isActivator 可选，检测是否是激活对象。若没此方法，则默认为频道适用元素范围。
	channel 可选，若配置的不是对象，则会自动转换为Object。
**********************************************************/
function Channel(name, elements, elementFilter, activate, isActivator, channelInfo) {
	this.name = name;
	// 内部属性
	this._channelInfo = channelInfo || new Object();
	this._elements = elements || function(){return null;};						// 适用元素集
	this._elementFilter = elementFilter || function(element) {return true;};	// 适用元素集的过滤器
	this._activate = activate || function(element) {return null;};
	this._isActivator = isActivator || null;
	// 公共函数
	this.getElements = Channel_GetElements;										// 获得适用的对象集
	this.getActivateName = Channel_GetActivateName;								// 获取激活方法名
	this.getPublish = Channel_GetPublish;										// 获取接受广播方法
	this.filterElement = Channel_filterElement;									// 过滤元素方法
	this.isActivator = Channel_IsActivator;										// 是否是触发对象
	this.isElement = Channel_IsElement;											// 是否包含指定对象元素
	this.getChannelInfo = Channel_GetChannelInfo;								// 获得频道传递对象
};

function Channel_GetElements(channelName) {
	var elementsToUse = [], _elements = this._elements();
	if (_elements instanceof Array) {
		for (var i = 0, length = _elements.length; i < length; i++) {
			if (this.filterElement(_elements[i], channelName)) elementsToUse.push(_elements[i]);
		}
	} else {
		// 默认适用于当前页面满足过滤器条件的所有元素
		var tagNames = ['input', 'textarea', 'select', 'a'];
		for (var key in tagNames) {
			var tagElements = document.getElementsByTagName(tagNames[key]);
			for (var i = 0, length = tagElements.length; i < length; i++) {
				if (this.filterElement(tagElements[i], channelName)) elementsToUse.push(tagElements[i]);
			}
		}
	}
	return elementsToUse;
};

function Channel_GetActivateName(element, channelName) {
	var activateToUse = this._activate(element);
	return (typeof(activateToUse) == 'string') ? activateToUse : null;
};

function Channel_GetPublish(element, channelName) {
	var _channelName = channelName || this.name;
	if (typeof(_channelName) == 'string') {
		try {
			var publishToUse = element.getAttribute(_channelName);
			if (typeof(publishToUse) == 'string') return new Function('source', 'channel', publishToUse);
		} catch (exception) {}
	}
	return null;
};

function Channel_filterElement(element, channelName) {
	var rtnFilter = false, _channelName = channelName || this.name;
	if (element.getAttribute(_channelName) != null) {
		try {
			rtnFilter = this._elementFilter(element);
			if (typeof(rtnFilter) != 'boolean') return false;
		} catch (exception) {}
	}
	return rtnFilter;
};

function Channel_IsActivator(element, channelName) {
	if (this._isActivator == null) return this.isElement(element, channelName);
	// 配置了检测是否是激活对象函数
	var rtnFilter = false;
	try {
		rtnFilter = this._isActivator(element);
		if (typeof(rtnFilter) != 'boolean') return false;
	} catch (exception) {}
	return rtnFilter;
};

function Channel_IsElement(element, channelName) {
	if (!this.filterElement(element, channelName)) return false;
	
	var elements = this._elements();
	if (elements instanceof Array) {
		for (var i = 0, length = elements.length; i < length; i++) {
			if (elements[i] == element) return true;
		}
	} else {
		var tagName = element.tagName.toLowerCase();
		return tagName == 'input' || tagName == 'textarea' || tagName == 'select' || tagName == 'a';
	}
};

function Channel_GetChannelInfo() {
	return (typeof(this._channelInfo) == 'object') ? this._channelInfo : new Object();
};

/**********************************************************
 功能：缺省事件频道（又：自助频道）
 描述：
 	自助频道规则，页面元素中添加自定义频道属性，属性规则是 on_自定义事件名_频道名。
 	此对象作为内部对象调用，外界不能调用。
 **********************************************************/
function DefaultChannel(channelInfo) {
	this.name = '&Default';
	// 内部属性
	this._channelInfo = channelInfo || new Object();
	this._elements = function(){return null;};									// 适用元素集
	this._isActivator = null;
	// 公共函数
	this.resolveChannelName = DefaultChannel_ResolveChannelName;				// 根据频道名，获取 自定义事件名
	this.getElements = Channel_GetElements;										// 获得适用的对象集
	this.getActivateName = DefaultChannel_GetActivateName;						// 获取激活方法名
	this.getPublish = Channel_GetPublish;										// 获取接受广播方法
	this.filterElement = DefaultChannel_filterElement;							// 过滤元素方法
	this.isActivator = Channel_IsActivator;										// 是否是触发对象
	this.isElement = Channel_IsElement;											// 是否包含指定对象元素
	this.getChannelInfo = Channel_GetChannelInfo;								// 获得频道传递对象
};

function DefaultChannel_ResolveChannelName(channelName) {
	var nameArray = channelName.split('_');
	return (nameArray.length < 3 || nameArray[0].toLowerCase() != 'on') ? null : nameArray[1].toLowerCase();
};

function DefaultChannel_GetActivateName(element, channelName) {
	return channelName ? this.resolveChannelName(channelName) : null;
};

function DefaultChannel_filterElement(element, channelName) {
	try{
		return channelName && (element.getAttribute(channelName) != null) && (this.resolveChannelName(channelName) != null);
	}catch(e){
		return false;
	}
};

//=============================缺省配置==============================
// 缺省频道集配置
Bus.DefaultChannels = {
	'onValueChange'	: {
		elementFilter	: function(element) {
			return element.getAttribute("xform") != null;
		},
		activate		: function(element) {
			var _element = element || null;
			return (_element == null) ? null : 'change';
		},
		isActivator		: function(element) {
			return element.getAttribute("act") != null;
		}
	}
};

// 缺省自定义事件集
Bus.DefaultCustomEvents = {
	'enter'			: function(element) {
		return element.addEventListener ? 'focus' : 'focusin';
	},
	'change'		: function(element) {
		var tagName = element.tagName.toLowerCase();
		if (tagName == 'input') {
			switch (element.type.toLowerCase()) {
			case 'submit':
			case 'hidden':
			case 'password':
			case 'text':
				return 'blur';
			case 'checkbox':
			case 'radio':
				return 'click';
			}
		} else if (tagName == 'textarea') {
			return 'blur';
		} else if (tagName == 'select') {
			return 'change';
		}
		return 'click';
	},
	'inputchange'	: function(element) {
		var tagName = element.tagName.toLowerCase();
		if (tagName == 'input') {
			switch (element.type.toLowerCase()) {
			case 'submit':
			case 'hidden':
			case 'password':
			case 'text':
				return element.addEventListener ? 'input' : 'propertychange:value';
			}
		}
		return null;
	}
};

/**********************************************************
 描述：
	以下所有函数为事件总线使用的公用函数。
功能：
	Bus_Extend				: 复制对象
	Bus_AddEvent			: 追加事件
 *********************************************************/
function Bus_Extend() {
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
					target[ name ] = Bus_Extend( deep, src || ( copy.length != null ? [ ] : { } ), copy );
				else if ( copy !== undefined )
					target[ name ] = copy;
			}
	return target;
};

function Bus_AddEvent(element, eventHandle, method, useCapture) {
	if (element.addEventListener) {
		element.addEventListener(eventHandle, method, useCapture);
	} else if (element.attachEvent) {
		element.attachEvent("on" + eventHandle, method);
	}
};

//=============================加载对象==============================
Bus_AddEvent(window, "load", function(){window.eventBus = new Bus();});
})(window)