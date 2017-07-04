

define(function(require, exports, module) {

	var strutil = require('lui/util/str');
	var topic = require('lui/topic');
	var $ = require("lui/jquery");
	
	var toJSON = strutil.toJSON;
	var upperFirst = strutil.upperFirst;
	

	
	function parse(root, callback) {
		if (Object.isFunction(root)) {
			callback = root;
			root = null;
		}
		root = root || document.body;
		var elements = [];
		var modules = [];
		var clazzes = [];
		
		var preLoads = [];
		var parseFailedElems = [];
		
		$(root).find("[data-lui-type]").each(function() {
			var elem = $(this);
			
			if (elem.attr('data-lui-cid') != null)
				return;
			
			if (elem.attr('data-lui-parse-init') != null)
				return;
			
			var module = elem.attr('data-lui-type');
			module = module.split("!");
			
			if (elem.attr('data-lui-parse') == 'false'
				|| elem.attr('data-lui-parse') == 'stop' 
				|| isInParseFailedElements(parseFailedElems, this)) {
				preLoads.push(module[0]);
				parseFailedElems.push(this);
				return;
			}
			
			elements.push(this);
			modules.push(module[0]);
			clazzes.push(module[1]);
		});
		
		parse.emit("afterScan", modules, elements);
		 
			
		if (modules.length) {
			require.async(modules, function() {
				var instances = {};
				var instancesArray = [];
				for (var i = 0; i < arguments.length; i++) {

					try {
						var clz = arguments[i][clazzes[i]];
						var instance = new clz({ element: elements[i] });
						instances[instance.cid] = instance;
						instancesArray.push(instance);
						elements[i].setAttribute('data-lui-parse-init', i + 1);
						if (!instance.element)
							instance.__element = $(elements[i]);
						
						try {
							parseEvents(instance.element || instance.__element, instance);
						} catch (e) {
							if (window.console)
								console.error("parser:parse.parseEvents:id="+instance.id, e, e.message, e.stack);
						}
					} catch(e) {
						if (window.console)
							console.error("parser:parse.new", e, e.message, e.stack);
					}
				}
				instancesArray = instancesArray.sort(instanceSorter);
				
				parse.emit("beforeBuildRelation", instances, instancesArray);
				
				buildRelation(instances, instancesArray);
				
				parse.emit("afterBuildRelation", instances, instancesArray);
				
				for (var i = 0; i < instancesArray.length; i ++) {
					var instance = instancesArray[i];
					if (instance.__env) {
						try {
							instance.__env();
						} catch(e) {
							if (window.console)
								console.error("parser:parse.__env:id="+instance.id, e, e.message, e.stack);
						}
					}
					if (instance.startup) {
						try {
							instance.startup();
						} catch(e) {
							if (window.console)
								console.error("parser:parse.startup:id="+instance.id, e, e.message, e.stack);
						}
					}
				}
				
				parse.emit("afterStartup", instances, instancesArray);
				
				for (var i = 0; i < instancesArray.length; i ++) {
					var instance = instancesArray[i];
					
					if (!instance.parent && instance.draw) {
						try {
							instance.draw();
						} catch(e) {
							if (window.console)
								console.error("parser:parse.draw:id="+instance.id, e, e.message, e.stack);
						}
					}
					if (instance.__element) {
						instance.__element.remove();
						delete instance.__element;
					}
				}
				callback && callback(instances);

				parse.emit("afterDraw", instances);
				
				luiReady(instances);
				parse.emit("luiReady", instances);
			});
		}else{
			luiReady();
		}
		
		if (preLoads.length) {
			require.async(preLoads, function() {
				// do nothing
			});
		}
	}
	
	var Evented = require('./Evented');
	$.extend(parse, Evented);
	parse._init_signal();
	
	function buildRelation(instances, instancesArray) {
		for (var i = 0; i < instancesArray.length; i ++) {
			try {
				var instance = instancesArray[i];
				var elem = instance.element || instance.__element;
				var parentElement = null;
				if (elem.attr('data-lui-parentid')) {
					parentElement = $('#' + elem.attr('data-lui-parentid'));
				} else {
					parentElement = elem.parents('[data-lui-type]');
					if (parentElement.length < 1) {
						continue;
					}
					parentElement = $(parentElement[0]);
				}
				
				var parent = instances[parentElement.attr('data-lui-cid')];
				if (!parent) {
					continue;
				}
				
				instance.setParent(parent);
				
				var attrName = elem.attr('data-lui-attr') || null;
				parent.addChild(instance, attrName);
			} catch(e) {
				if (window.console)
					console.error("parser:parse.buildRelation:id="+instance.id, e, e.message, e.stack);
			}
		}
	}
	
	function parseEvents(element, obj, onLuiReturn) {
		if (onLuiReturn && element.attr('data-lui-type') != null) {
			return;
		}
		element.children("script[type='lui/event'],script[type='text/event']").each(function() {
			var fn = functionFromScript(this);
			obj.on(this.getAttribute("data-lui-event"), fn);
		}).remove();
		
		element.children("script[type='lui/topic'],script[type='text/topic']").each(function() {
			var fn = functionFromScript(this);
			topic.channel(obj).subscribe(this.getAttribute("data-lui-topic"), fn);
		}).remove();
		
		element.children().each(function() {
			parseEvents($(this), obj, true);
		});
	}
	
	function functionFromScript(script) {
		var argsStr = (script.getAttribute("data-lui-args") || script.getAttribute("args"));
		var fnArgs = (argsStr || "").split(/\s*,\s*/);
		return new Function(fnArgs, script.innerHTML);
	}
	
	function isInParseFailedElements(parseFailedElement, curr) {
		for (var i = parseFailedElement.length - 1; i > -1; i --) {
			if ($.contains(parseFailedElement[i], curr)) {
				return true;
			}
		}
		return false;
	}
	
	// 深度优先
	function instanceSorter(i1, i2) {
		var e1 = i1.element || i1.__element;
		var e2 = i2.element || i2.__element;
		if ($.contains(e1, e2)) {
			return 1;
		}
		if ($.contains(e2, e1)) {
			return -1;
		}
		var o1 = parseInt( e1.attr('data-lui-parse-init') );
		var o2 = parseInt( e2.attr('data-lui-parse-init') );
		return o1 - o2;
	}
	
	// lui对象加载完触发，非dom元素
	function luiReady(instances) {
		var _ready = LUI._ready;
		LUI._ready = [];
		while(_ready.length>0){
			_ready.shift().call(window, instances);
		}
		//placeholder
		LUI.placeholder(window.document.body);
		 
	}
	
	exports.parseEvents = parseEvents; 
	exports.parse = parse;
	exports.functionFromScript = functionFromScript;
});