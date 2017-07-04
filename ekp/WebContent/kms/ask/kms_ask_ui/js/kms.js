/*!
 * KMS Core Javascript Library v1.0
 * Copyright 2010, Landray(http://www.landray.com.cn)
 * 
 * Includes Base.js
 * http://dean.edwards.name/base/Base.js
 * 
 * Requires:
 * [jquery.js]
 * 
 * Author: 
 * yangf@landray.com.cn
 * Date: 2011/8/17 16:26
 * Version: v1.0
 */


/**
 * 里面包含了Base.js,Base.js的作者是Dean Edwards, 旨在便捷地使用类式继承的方式写javascript
 * 另外对Object对象进行了拓展，以方便对一些基础类型和其它对象对进行拓展
 * @author yangf@landray.com.cn
 */
;(function(window, $) {
	/*
	Base.js, version 1.1a
	Copyright 2006-2010, Dean Edwards
	License: http://www.opensource.org/licenses/mit-license.php
*/

var Base = function() {
	// dummy
};

Base.extend = function(_instance, _static) { // subclass
	var extend = Base.prototype.extend;
	
	// build the prototype
	Base._prototyping = true;
	var proto = new this;
	extend.call(proto, _instance);
  proto.base = function() {
    // call this method from any other method to invoke that method's ancestor
  };
	delete Base._prototyping;
	
	// create the wrapper for the constructor function
	//var constructor = proto.constructor.valueOf(); //-dean
	var constructor = proto.constructor;
	var klass = proto.constructor = function() {
		if (!Base._prototyping) {
			if (this._constructing || this.constructor == klass) { // instantiation
				this._constructing = true;
				constructor.apply(this, arguments);
				delete this._constructing;
			} else if (arguments[0] != null) { // casting
				return (arguments[0].extend || extend).call(arguments[0], proto);
			}
		}
	};
	
	// build the class interface
	klass.ancestor = this;
	klass.extend = this.extend;
	klass.forEach = this.forEach;
	klass.implement = this.implement;
	klass.prototype = proto;
	klass.toString = this.toString;
	klass.valueOf = function(type) {
		//return (type == "object") ? klass : constructor; //-dean
		return (type == "object") ? klass : constructor.valueOf();
	};
	extend.call(klass, _static);
	// class initialisation
	if (typeof klass.init == "function") klass.init();
	return klass;
};

Base.prototype = {	
	extend: function(source, value) {
		if (arguments.length > 1) { // extending with a name/value pair
			var ancestor = this[source];
			if (ancestor && (typeof value == "function") && // overriding a method?
				// the valueOf() comparison is to avoid circular references
				(!ancestor.valueOf || ancestor.valueOf() != value.valueOf()) &&
				/\bbase\b/.test(value)) {
				// get the underlying method
				var method = value.valueOf();
				// override
				value = function() {
					var previous = this.base || Base.prototype.base;
					this.base = ancestor;
					var returnValue = method.apply(this, arguments);
					this.base = previous;
					return returnValue;
				};
				// point to the underlying method
				value.valueOf = function(type) {
					return (type == "object") ? value : method;
				};
				value.toString = Base.toString;
			}
			this[source] = value;
		} else if (source) { // extending with an object literal
			var extend = Base.prototype.extend;
			// if this object has a customised extend method then use it
			if (!Base._prototyping && typeof this != "function") {
				extend = this.extend || extend;
			}
			var proto = {toSource: null};
			// do the "toString" and other methods manually
			var hidden = ["constructor", "toString", "valueOf"];
			// if we are prototyping then include the constructor
			var i = Base._prototyping ? 0 : 1;
			while (key = hidden[i++]) {
				if (source[key] != proto[key]) {
					extend.call(this, key, source[key]);

				}
			}
			// copy each of the source object's properties to this object
			for (var key in source) {
				if (!proto[key]) extend.call(this, key, source[key]);
			}
		}
		return this;
	}
};

// initialise
Base = Base.extend({
	constructor: function() {
		this.extend(arguments[0]);
	}
}, {
	ancestor: Object,
	version: "1.1",
	
	forEach: function(object, block, context) {
		for (var key in object) {
			if (this.prototype[key] === undefined) {
				block.call(context, object[key], key, object);
			}
		}
	},
		
	implement: function() {
		for (var i = 0; i < arguments.length; i++) {
			if (typeof arguments[i] == "function") {
				// if it's a function, call it
				arguments[i](this.prototype);
			} else {
				// add the interface using the extend method
				this.prototype.extend(arguments[i]);
			}
		}
		return this;
	},
	
	toString: function() {
		return String(this.valueOf());
	}
});
	
var slice = Array.prototype.slice,
	push = Array.prototype.push,
	toString = Object.prototype.toString;

/**
 *  拓展Object，用于简单的将source对象的属性浅复制到dest所指定的对象里
 * @param dest {Object} 目标对象
 * @param source {Object} 源对象
 * @returns {Object} 返回目标对象
 */
Object.extend = function(dest, source) {
	for (var property in source) 
		dest[property] = source[property];
	return dest;
};

/*
 * Object对象的拓展
 */
Object.extend(Object, {
	
	forEach: function(object, fn, bind) {
		for (var key in object) {
			if (object.hasOwnProperty(key)) fn.call(bind, object[key], key, object);
		}
	}
});

Object.each = Object.forEach;

/*
 * Array对象的拓展
 */
Object.extend(Array.prototype, {
	
	forEach: function(fn, bind) {
		for (var i = 0, len = this.length; i < len; i++) {
			if (i in this) fn.call(bind, this[i], i, this);
		}
	},
	
	indexOf: function(item, from) {
		var len = this.length,
		i = (from < 0) ? Math.max(0, len + from) : from || 0;
		for (; i < len; i++) {
			if (this[i] === item) return i;
		}
		return -1;
	},
	
	contains: function(item, from) {
		return this.indexOf(item, from) != -1;
	},
	
	include: function(item) {
		if (!this.contains(item)) this.push(item);
		return this;
	},
	
	append: function(array) {
		this.push.apply(this, array);
		return this;
	},
	
	swap: function(prev, last) {
		var temp = this[prev];
		this[prev] = this[last];
		this[last] = temp;
	},
	
	last: function() {
		return this[this.length - 1];
	}
	
});

/**
 * 拓展String对象
 */
Object.extend(String.prototype, {
	contains: function(str) {
		return this.indexOf(str) != -1;
	},
	
	toInt: function(base) {
		return parseInt(this, base || 10);
	},
	
	toFloat: function(){
		return parseFloat(this);
	},
	
	equals: function(str) {
		return this == str;
	}, 
	
	equalsIgnoreCase: function(str) {
		return this.toLowerCase().equals(str.toLowerCase());
	},
	
	// 补充ie6下的trim方法
	trim : function(str) {
		return this.replace(/^s+|s+$/g, '');
	}
});

/*
 * Function对象的拓展
 */
Object.extend(Function.prototype, {
	// bind 方法名改为binding，避免与mootools冲突
	binding: function(bind) {
		var self = this,
		args = (arguments.length > 1) ? slice.call(arguments, 1) : null;
		return function() {
			if (!args && !arguments.length) return self.call(bind);
			if (args && arguments.length) return self.apply(bind, args.concat(slice.call(arguments, 0)));
			return self.apply(bind, arguments || args);
		};
	}
});

/*
 * 移除方法名前的on
 */
var removeOn = function(string) {
	return string.replace(/^on([A-Z])/, function(full, first) {
		return first.toLowerCase();
	}); 
};

/*
 * 事件处理类，其它类的实现可通过继承的方式，拓展事件处理的功能
 */
var EventTarget = Base.extend({
	constructor: function(options) {
		this.options = this.options || {};
		options = this.options = $.extend(true, {}, this.options, options);
		for (var option in options) {
			if (!$.isFunction(options[option]) || !(/^on[A-Z]/).test(option)) continue;
			this.addEvent(option, options[option]);
			delete options[option];
		}
	},
	
	handlers: {},	//事件处理函数的窗口
	
	// 绑定事件句柄
	addEvent: function(type, fn) { 
		type = removeOn(type);
		this.handlers[type] = (this.handlers[type] || []).include(fn);
	},
	
	// 触发事件函数的执行
	fireEvent: function(type) {
		type = removeOn(type);
		var handlers = this.handlers[type];
		if (!handlers) return this;
		var args = (arguments.length > 1) ? slice.call(arguments, 1) : null;
		handlers.forEach(function(fn) {
			if (args != null) fn.apply(this, args);
			else fn.call(this);
		}, this);
		return this;
	},
	
	// 解除事件句柄的绑定
	removeEvent: function(type, fn) {
		type = removeOn(type);
		var handlers = this.handlers[type];
		if (handlers) {
			var index = handlers.indexOf(fn);
			if (index != -1) delete handlers[index];
		}
		return this;
	}
});

// 将一些变量暴露为全局变量
Object.extend(window, {
	Base: Base,
	EventTarget: EventTarget
});


jQuery.isString = function(str) {
	return Object.prototype.toString.call(str) == "[object String]";
};
 /**
 * 打控制台打印日志
 * @param msg {String} 日志记录的文本
 * @param cat {String} 日志类型，有以下类型 "info", "warn", "error", "time"
 * @param src {String} 日志发生的源码（可选）
 */
$.log = function(msg, cat, src) {
	if (src) {
        msg = src + ': ' + msg;
    }
    if (window.console && console.log) {
        console[cat && console[cat] ? cat : 'log'](msg);
    }
}

// 解决IE6下使用背景图片的时候不断重新发送请求的bug
if (document.execCommand) try {
	document.execCommand("BackgroundImageCache", false, true);
} catch (e) {}

}(window, jQuery));
