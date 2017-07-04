////////////////
define(function(require, exports, module) {
	//require('/ekp/sys/ui/theme/default/style/panel.css');
	(function() {
	  var _toString = Object.prototype.toString,
		  _hasOwnProperty = Object.prototype.hasOwnProperty,
		  NULL_TYPE = 'Null',
		  UNDEFINED_TYPE = 'Undefined',
		  BOOLEAN_TYPE = 'Boolean',
		  NUMBER_TYPE = 'Number',
		  STRING_TYPE = 'String',
		  OBJECT_TYPE = 'Object',
		  FUNCTION_CLASS = '[object Function]',
		  BOOLEAN_CLASS = '[object Boolean]',
		  NUMBER_CLASS = '[object Number]',
		  STRING_CLASS = '[object String]',
		  ARRAY_CLASS = '[object Array]',
		  DATE_CLASS = '[object Date]',
		  NATIVE_JSON_STRINGIFY_SUPPORT = window.JSON &&
			typeof JSON.stringify === 'function' &&
			JSON.stringify(0) === '0' &&
			typeof JSON.stringify(function(x) { return x }) === 'undefined';
	
	
	
	  var DONT_ENUMS = ['toString', 'toLocaleString', 'valueOf','hasOwnProperty', 'isPrototypeOf', 'propertyIsEnumerable', 'constructor'];
	
	  var IS_DONTENUM_BUGGY = (function(){
		for (var p in { toString: 1 }) {
		  if (p === 'toString') return false;
		}
		return true;
	  })();
	
	  function Type(o) {
		switch(o) {
		  case null: return NULL_TYPE;
		  case (void 0): return UNDEFINED_TYPE;
		}
		var type = typeof o;
		switch(type) {
		  case 'boolean': return BOOLEAN_TYPE;
		  case 'number':  return NUMBER_TYPE;
		  case 'string':  return STRING_TYPE;
		}
		return OBJECT_TYPE;
	  }
	
	  function extend(destination, source) {
		for (var property in source)
		  destination[property] = source[property];
		return destination;
	  }
	 
	
	  function toArray(iterable) {
		  if (!iterable) return [];
		  if ('toArray' in Object(iterable)) return iterable.toArray();
		  var length = iterable.length || 0, results = new Array(length);
		  while (length--) results[length] = iterable[length];
		  return results;
	  }
	 
	  function keys(object) {
		if (Type(object) !== OBJECT_TYPE) { throw new TypeError(); }
		var results = [];
		for (var property in object) {
		  if (_hasOwnProperty.call(object, property))
			results.push(property);
		}
	
		if (IS_DONTENUM_BUGGY) {
		  for (var i = 0; property = DONT_ENUMS[i]; i++) {
			if (_hasOwnProperty.call(object, property))
			  results.push(property);
		  }
		}
	
		return results;
	  }
	  function isElement(object) {
		return !!(object && object.nodeType == 1);
	  }
	
	  function isArray(object) {
		return _toString.call(object) === ARRAY_CLASS;
	  }
	
	  var hasNativeIsArray = (typeof Array.isArray == 'function') && Array.isArray([]) && !Array.isArray({});
	
	  if (hasNativeIsArray) {
		isArray = Array.isArray;
	  }
	  
	  function isFunction(object) {
		return _toString.call(object) === FUNCTION_CLASS;
	  }
	
	  function isString(object) {
		return _toString.call(object) === STRING_CLASS;
	  }
	
	  function isNumber(object) {
		return _toString.call(object) === NUMBER_CLASS;
	  }
	
	  function isDate(object) {
		return _toString.call(object) === DATE_CLASS;
	  }
	
	  function isUndefined(object) {
		return typeof object === "undefined";
	  }
	
	  extend(Object, {
		extend:        extend, 
		toArray:       toArray, 
		isElement:     isElement,
		keys:          Object.keys || keys,
		isArray:       isArray,
		isFunction:    isFunction,
		isString:      isString,
		isNumber:      isNumber,
		isDate:        isDate,
		isUndefined:   isUndefined
	  });
	})();
	Object.extend(Function.prototype, (function() {
	  var slice = Array.prototype.slice;
	
	  function update(array, args) {
		var arrayLength = array.length, length = args.length;
		while (length--) array[arrayLength + length] = args[length];
		return array;
	  }
	
	  function merge(array, args) {
		array = slice.call(array, 0);
		return update(array, args);
	  }
	
	  function argumentNames() {
		var names = this.toString().match(/^[\s\(]*function[^(]*\(([^)]*)\)/)[1]
		  .replace(/\/\/.*?[\r\n]|\/\*(?:.|[\r\n])*?\*\//g, '')
		  .replace(/\s+/g, '').split(',');
		return names.length == 1 && !names[0] ? [] : names;
	  }
	
	
	  function bind(context) {
		if (arguments.length < 2 && Object.isUndefined(arguments[0]))
		  return this;
	
		if (!Object.isFunction(this))
		  throw new TypeError("The object is not callable.");
	
		var nop = function() {};
		var __method = this, args = slice.call(arguments, 1);
	
		var bound = function() {
		  var a = merge(args, arguments), c = context;
		  var c = this instanceof bound ? this : context;
		  return __method.apply(c, a);
		};
	
		nop.prototype   = this.prototype;
		bound.prototype = new nop();
	
		return bound;
	  }
	 
	  function wrap(wrapper) {
		var __method = this;
		return function() {
		  var a = update([__method.bind(this)], arguments);
		  return wrapper.apply(this, a);
		};
	  }
	 
	
	  var extensions = {
		argumentNames:       argumentNames,
		wrap:                wrap
	  };
	
	  if (!Function.prototype.bind)
		extensions.bind = bind;
	
	  return extensions;
	})());
	//////	  
	
	//Class 类定义
	
	//////
	var Class = (function() {
		var IS_DONTENUM_BUGGY = (function() {
			for (var p in {
				toString: 1
			}) {
				if (p === 'toString') return false;
			}
			return true;
		})();
	
		function subclass() {};
		function create() {
			var parent = null,
			properties = Object.toArray(arguments);
			if (Object.isFunction(properties[0])) parent = properties.shift();
	
			function klass() {
				this.initialize.apply(this, arguments);
			}
	
			Object.extend(klass, Class.Methods);
			klass.superclass = parent;
			klass.subclasses = [];
	
			if (parent) {
				subclass.prototype = parent.prototype;
				klass.prototype = new subclass;
				parent.subclasses.push(klass);
			}
	
			for (var i = 0,
			length = properties.length; i < length; i++) klass.addMethods(properties[i]);
	
			if (!klass.prototype.initialize) klass.prototype.initialize = function() {};
			
			// add extend method to 
			klass.extend = function() {
				var args = [klass];
				for (var i = 0; i < arguments.length; i ++) {
					args.push(arguments[i]);
				}
				return create.apply(klass, args);
			};
	
			klass.prototype.constructor = klass;
			return klass;
		}
	
		function addMethods(source) {
			var ancestor = this.superclass && this.superclass.prototype,
			properties = Object.keys(source);
	
			if (IS_DONTENUM_BUGGY) {
				if (source.toString != Object.prototype.toString) properties.push("toString");
				if (source.valueOf != Object.prototype.valueOf) properties.push("valueOf");
			}
	
			for (var i = 0,length = properties.length; i < length; i++) {
				var property = properties[i],
				value = source[property];
				if (ancestor && Object.isFunction(value) && value.argumentNames()[0] == "$super") {
					var method = value;
					value = (function(m) {
						return function() {
							return ancestor[m].apply(this, arguments);
						};
					})(property).wrap(method);
	
					value.valueOf = (function(method) {
						return function() {
							return method.valueOf.call(method);
						};
					})(method);
	
					value.toString = (function(method) {
						return function() {
							return method.toString.call(method);
						};
					})(method);
				}
				this.prototype[property] = value;
			}
	
			return this;
		}
		function extend(destination, source) {
			for (var property in source)
			  destination[property] = source[property];
			return destination;
		}
		return {
			create: create,
			extend: extend,
			Methods: {
				addMethods: addMethods
			}
		};
	})();
 	Class.extend(exports,Class);
});