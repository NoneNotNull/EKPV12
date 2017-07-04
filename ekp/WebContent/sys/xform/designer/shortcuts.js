/**********************************************************
功能：快捷键对象
使用：
	
作者：龚健
创建时间：2009-03-23
**********************************************************/
function Designer_Shortcut() {
	this.options = {
		'type'             : 'keydown',             //绑定事件
		'cancelBubble'     : false,                 //取消冒泡
		'disable_in_input' : false,                 //在输入框中是否失效
		'target'           : document,              //事件触发载体
		'keycode'          : false                  //特殊按键
	};
	this.shortCuts = [];                            //所有热键

	//内部属性
	this._shiftNums = {
		"`"  : "~",
		"1"  : "!",
		"2"  : "@",
		"3"  : "#",
		"4"  : "$",
		"5"  : "%",
		"6"  : "^",
		"7"  : "&",
		"8"  : "*",
		"9"  : "(",
		"0"  : ")",
		"-"  : "_",
		"="  : "+",
		";"  : ":",
		"'"  : "\"",
		","  : "<",
		"."  : ">",
		"/"  : "?",
		"\\" : "|"
	};
	this._specialKeys = {
		'esc'         : 27,
		'escape'      : 27,
		'tab'         : 9,
		'space'       : 32,
		'return'      : 13,
		'enter'       : 13,
		'backspace'   : 8,

		'scrolllock'  : 145,
		'scroll_lock' : 145,
		'scroll'      : 145,
		'capslock'    : 20,
		'caps_lock'   : 20,
		'caps'        : 20,
		'numlock'     : 144,
		'num_lock'    : 144,
		'num'         : 144,
		
		'pause'       : 19,
		'break'       : 19,
		
		'insert'      : 45,
		'home'        : 36,
		'delete'      : 46,
		'end'         : 35,
		
		'pageup'      : 33,
		'page_up'     : 33,
		'pu'          : 33,

		'pagedown'    : 34,
		'page_down'   : 34,
		'pd'          : 34,

		'left'        : 37,
		'up'          : 38,
		'right'       : 39,
		'down'        : 40,

		'f1'          : 112,
		'f2'          : 113,
		'f3'          : 114,
		'f4'          : 115,
		'f5'          : 116,
		'f6'          : 117,
		'f7'          : 118,
		'f8'          : 119,
		'f9'          : 120,
		'f10'         : 121,
		'f11'         : 122,
		'f12'         : 123
	};

	//公用方法
	this.add = Designer_Shortcut_Add;
	this.remove = Designer_Shortcut_Remove;
};

function Designer_Shortcut_Add(shortCut, callback, options) {
	shortCut = shortCut.toLowerCase();
	//参数配置
	var opt = {};
	Designer.extend(true, opt, this.options);
	Designer.extend(true, opt, options);
	//事件触发载体
	var element = Designer.$(opt.target);
	//在keypress时可以调用的方法
	var _self = this;
	var func = function(event) {
		var _event = event || window.event;
		//在Input和Textarea域中，快捷键失效
		if(opt['disable_in_input']) {
			var currElement = _event.srcElement || _event.target;
			//若是文本节点，则寻找父节点
			if(currElement.nodeType == 3) currElement = currElement.parentNode;
			if(currElement.tagName.toLowerCase() == 'input' || currElement.tagName.toLowerCase() == 'textarea') return;
		}
		//发现哪个键被按下
		var code = _event.keyCode || _event.which;
		var character = String.fromCharCode(code).toLowerCase();
		if(code == 188) character = ',';
		if(code == 190) character = '.';
		//记录组合键常用的特殊键
		var modifiers = { 
			shift : {wanted:false, pressed:_event.shiftKey == true},
			ctrl  : {wanted:false, pressed:_event.ctrlKey == true},
			alt   : {wanted:false, pressed:_event.altKey == true},
			meta  : {wanted:false, pressed:_event.metaKey == true}     //此属性为苹果浏览器拥有
		};
		//计算可用按键的数量
		var keys = shortCut.split('+'), key = '', kp = 0;
		for (var i = keys.length - 1; i >= 0; i--) {
			key = keys[i];
			if(key == 'ctrl' || key == 'control') {
				modifiers.ctrl.wanted = true;
				kp++;
			} else if (key == 'shift') {
				modifiers.shift.wanted = true;
				kp++;
			} else if (key == 'alt') {
				modifiers.alt.wanted = true;
				kp++;
			} else if (key == 'meta') {
				modifiers.meta.wanted = true;
				kp++;
			} else if(key.length > 1) {
				if(_self._specialKeys[key] == code) kp++;
			} else if(opt['keycode']) {
				if(opt['keycode'] == code) kp++;
			} else {
				if(character != key && _self._shiftNums[character] && _event.shiftKey)
					character = _self._shiftNums[character];
				if(character == key) kp++;
			}
		}
		//调用相应函数
		if (kp == keys.length) {
			var pass = true, sKey;
			for(var key in modifiers) {
				sKey = modifiers[key];
				pass = sKey.wanted == sKey.pressed;
				if (!pass) break;
			}
			if (pass) {
				callback(_event);
				//停止事件冒泡
				if(!opt['cancelBubble']) {
					if(Designer.UserAgent == 'msie') {
						_event.cancelBubble = true;
						_event.returnValue = false;
					} else {
						_event.stopPropagation();
						_event.preventDefault();
					}
					return false;
				}
			}
		}
	};
	//记录快捷键
	this.shortCuts[shortCut] = {
		'callback' : func, 
		'target'   : element, 
		'event'    : opt['type']
	};
	//绑定事件
	Designer.addEvent(element, opt['type'], func);
};

function Designer_Shortcut_Remove(shortCut) {
	shortCut = shortCut.toLowerCase();
	//快捷键相关信息
	var binding = this.shortCuts[shortCut];
	//删除相应信息
	delete(this.shortCuts[shortCut]);

	if(!binding) return;
	//删除相应绑定事件
	Designer.removeEvent(binding['target'], binding['event'], binding['callback']);
};