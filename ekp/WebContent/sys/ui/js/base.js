

define(function(require, exports, module) {
	require('theme!dataview');
	var Class = require("lui/Class");
	var $ = require("lui/jquery");
	var Evented = require('lui/Evented');
	var env = require('lui/util/env');
	var strutil = require('lui/util/str');

	$.isString = Object.isString;
	var upperFirst = strutil.upperFirst;

	var cidIndex = 1;
	var cachedInstances = window.LUI.cachedInstances;
	
	
	var parseConfig = function(element) {
		var cfg = {};
		if(Object.isString(element)){
			element = $(element).get(0);
		}
		if (element.tagName && element.tagName.toLowerCase() == 'script') {
			if (element.type == 'text/config' ||  element.type == 'lui/config') {
				return Object.extend(cfg, strutil.toJSON(element.innerHTML));
			}
			return cfg;
		}
		$(element).children("script[type='text/config'], script[type='lui/config']").each(function(i, v) {
			var elem = $(v);
			$.extend(cfg, strutil.toJSON(elem.html()));
			elem.remove();
		});
		return cfg;
	};
	
	var Base = new Class.create(Evented, {
		
		initialize : function(config) {
			var cfg = this._parseAttrsConfig(config);
			this._init(cfg);
			this.initProps(cfg);
			this._stamp();
			this.env = null;
		},
		_init: function(cfg) {
			this.config = cfg;
			if (cfg.id) {
				this.cid = cfg.id;
			}
			else if (cfg.element && cfg.element.id) {
				this.cid = cfg.element.id;
			} else {
				this.cid = uniqueCid();
			}
			this._init_signal();
			this.setParent( cfg.parent || null );
			this.children = [];
			this.channel = cfg.channel || cfg.group || null;
			this._destroyed = false;
		},
		initProps: function(cfg) {
	    },
	    _parseAttrsConfig: function(config) {
	    	if (config == null)
	    		return {};
			if ($.isString(config)) {
				return config;
			}
			var src = {};
			if (config.element) {
				src = parseConfig(config.element);
			}
			return $.extend(src, config);
	    },
		_stamp: function() {
			cachedInstances[this.cid] = this;
		},
		setParent: function(parent) {
			this.parent = parent;
		},
		addChild: function(child, attrName) {
	    	this.children.push(child);
	    	if(attrName && 'child' != attrName){
		    	var attrSetterName = "set" + upperFirst(attrName);
		    	if (this[attrSetterName]) {
		    		this[attrSetterName](child);
		    	}
		    	var attrsAddName = "add" + upperFirst(attrName);
		    	if (this[attrsAddName]) {
		    		this[attrsAddName](child);
		    	}
	    	}
	    },
		_startupChild: function(child) {
			if (child && child.startup) {
				if (!child.isStartup) {
					child.startup();
					if (!child.isStartup) {
						child.isStartup = true;
					}
				}
			}
		},
	    _destroyAll: function(array) {
	    	if (Object.isArray(array)) {
	    		for (var i = 0, l = array.length ; i < l ; i ++) {
	    			array[i].destroy();
				}
	    	}
    		else if (array && array.destroy) {
    			array.destroy();
    		}
	    },
		destroy: function() {
			if (this._destroyed) {
				return;
			}
			this._destroyAll(this.children);
			this.children = null;
			this.off();
			this.config = null;
			this._destroyed = true;
			
			delete cachedInstances[this.cid];
		},
		startup : function(){
			
		},
		__env : function(){
			var self = this;
			var envConfig = self.__env__(self);
			//debugger;
			if(self.env == null)
				self.env = {};
			self.env.fn = new env.fnclass();
			var config = {};
			$.extend(config, seajs.data.env);
			$.extend(config, envConfig);
			if(self.config != null && self.config.contextPath != null){
				config.contextPath = self.config.contextPath;				
			}
			self.env.config = config;
			self.env.fn.config = config;
		},
		getEnv : function(){
			if(this.env == null){
				var senv = {};
				senv.config = seajs.data.env;
				senv.fn = new env.fnclass();
				return senv;
			}else{
				return this.env;
			}
		},
		__env__ : function(obj){
			var self = this;
			if(obj == null){
				return seajs.data.env;
			} else if(obj instanceof Env){
				return obj.config;
			} else if(obj.env != null){
				return obj.env.config;
			} else {
				return self.__env__(obj.parent);
			}
		}
	});
	
	var Component = Base.extend({
		
		className: "lui-component",
		
		initialize : function(config) {
			var cfg = this._parseAttrsConfig(config);
			this._init(cfg);
			this._initElement(cfg);
			this.initProps(cfg);
			this._stamp();
		},
		_parseAttrsConfig: function(config) {
			if (config == null) {
				return {};
			}
			var cfg;
			if (Object.isString(config)) {
				cfg = {id: config, element: $("#" + config)[0]};
			} else if (isElement(config)) {
				cfg = {id: config.id, element: config};
			} else {
				cfg = config;
			}
			
			if (cfg.element) {
				// 传入参数优先级别比dom上script中配置级别更高
				cfg = $.extend(parseConfig(cfg.element), cfg);
			}
			if (!cfg.id) {
				if (cfg.element && cfg.element.id) {
					cfg.id = cfg.element.id;
				} else {
					cfg.id = this.cid;
				}
			}
			return cfg;
		},
		_initElement: function(cfg) {
			this.id = cfg.id;
			if(!this.id)
				this.id = this.cid;
			this.element = cfg.element ? $(cfg.element) : $("<div id='" + this.id + "'></div>");
			if (this.element.attr('id') != this.id) {
				this.element.attr('id', this.id);
			}
			if (this.className) {
				this.element.addClass(this.className);
			}
			this.setParentNode(cfg.parentNode);
		},
		
		_stamp: function($super) {
			var cid = this.cid;
			this.element.attr("data-lui-cid", cid);
			$super();
		},
		
		setParentNode: function(parentNode) {
			if (!parentNode)
				return;
			if (Object.isString(parentNode))
				parentNode = $("#" + parentNode)[0];
			this.element.appendTo(parentNode);
			return this;
		},
		
		draw: function() {
			if(this.isDrawed)
				return;
			this.element.show();
			this.isDrawed = true;
			return this;
		},
		erase: function() {
			if (this.children && this.children.length) {
				for (var i = 0; i < this.children.length; i ++) {
					if (this.children[i].erase) {
						this.children[i].erase();
					}
				}
			}
			this.emit("erase", this);
			this.off("erase");
			if (this.element)
				this.element.empty();		
			this.isDrawed = false;
		},
		onErase:function(fn){
			this.on("erase",fn);
		},
		destroy: function($super) {
			delete cachedInstances[this.cid];
			this.erase();
			if (this.element) {
				this.element.off();
				this.element.remove();
				this.element = null;
			}
			
			$super();
		},		
		getRootElement:function(){
			return this.element;
		},
		getSize : function(){
			return {
				width: this.element.width(),
				heigth: this.element.height()
			};
		},
		getPosition : function(){
			return this.element.position();
		},
		getOffset : function(){
			return this.element.offset();
		},
		refresh:function(){
			this.erase();
			this.draw();
		}
	});
	

	var DataSource = Base.extend({
		get: function() {}
	});
	
	var DataRender = Base.extend({
		get: function() {}
	});
	
	var Layout = Base.extend({
		get: function() {}
	});
	
	var Container = Component.extend({
		initProps: function($super, cfg) {
			this.layout = cfg.layout || null;
			if(cfg.style)
				this.element.attr("style",(this.element.attr("style") ? this.element.attr("style") + ";" : "" ) + cfg.style);
			$super(cfg);
		},
		startup : function(){
			if (this.isStartup) {
				return;
			}
			this.isStartup = true;
		},
		destroy: function($super) {
			$super();
			if (this.layout) {
				this.layout.destroy();
			}
		},
		doLayout : function(obj){ 
			for ( var i = 0; i < this.children.length; i++) {
				if(this.children[i].draw)
					this.children[i].draw();
			}
		},
		lazyDraw : function(){
			this.config.lazyDraw = null;
			this.draw();
		},
		draw :function($super){
			if(this.isDrawed)
				return this;
			if($.trim(this.config.lazyDraw)=='true')
				return this;
			var self = this;
			if(this.layout){
				this.layout.on("error",function(msg){
					self.element.append(msg);
				});
				this.layout.get(this,function(obj){
					 self.doLayout(obj);
				});
			} else {
				for ( var i = 0; i < this.children.length; i++) {
					if(this.children[i].draw)
						this.children[i].draw();
				}
			}
			return $super();
		},
		refresh:function(){
			for ( var i = 0; i < this.children.length; i++) {
				if(this.children[i].refresh)
					this.children[i].refresh();
			}
		},
		addChild :function($super,obj,attr){
			if(obj instanceof Layout){
				this.layout = obj;
			}
			$super(obj,attr);
		}
	});
	
	var Env = Container.extend({
		initProps : function($super, cfg){
			$super(cfg);
			this.config = cfg;
		}
	});
	
	var DataView = Component.extend({
		initProps : function($super, cfg){ 
			$super(cfg);
			if(cfg.style)
				this.element.attr("style",(this.element.attr("style") ? this.element.attr("style") + ";" : "" ) + cfg.style);
			this.loading = $("<img src='"+env.fn.formatUrl('/sys/ui/js/ajax.gif')+"' />");
		},
		load : function(){
			this.element.append(this.loading);
			this.source.get();
		},
		startup : function(){
			if (this.isStartup) {
				return;
			}
			this.source.on('error',this.onError,this);
			this.render.on('error', this.onError,this);
			this.source.on('data', this.onDataLoad, this);
			this.render.on('html', this.doRender, this);
			this.isStartup = true;
		},
		onDataLoad: function(data) {
			this.data = data;
			this.render.get(data);
		},
		onError : function(msg){
			this.doRender(msg);
		},
		addChild: function(child) {
			if(child instanceof DataSource){
				this.setSource(child);
			}
			if(child instanceof DataRender){
				this.setRender(child);
			}
		},
		doRender : function(html){
			this.loading.remove();
			if(html){
				this.element.html("");
				this.element.append(html);
			}
			this.isLoad = true;
			this.fire({"name":"load"});
		},
		setSource : function(_source){
			this.source = _source;
			_source.dataview = this;
		},
		setRender : function(_render){
			this.render = _render;
			_render.dataview = this;
		},
		erase: function($super) {
			this.element.html("");
			$super();
		},
		draw: function() {
			if(this.isDrawed)
				return;
			this.element.show();
			this.load();
			this.isDrawed = true;
		},
		resize : function(){
			if(this.isDrawed){
				this.element.off();
				this.element.html("");
				this.render.get(this.data);
			}
		}
	});

	
	// --------- exports --------
	
	function byId(id) {
		if (Object.isString(id))
			return cachedInstances[id];
		else if(id && id.id)
			return cachedInstances[id.id];
		return null;
	}
	
	exports.Base = Base;
	exports.Component = Component;
	exports.Container = Container;
	exports.byId = byId;
	exports.Layout = Layout;
	exports.DataRender = DataRender;
	exports.DataSource = DataSource;
	exports.DataView = DataView;
	exports.Env = Env;
	try{window.___lui_cache___ = cachedInstances;}catch(e){}
	
	// --------- utils --------
	
	var isElement = function(object) {
		return !!(object && object.nodeType == 1);
	};
	$.isElement = isElement;
	var isInDocument = function(element) {
		return $.contains(document.documentElement, element);
	};
	
	var uniqueCid = function() {
		return "lui-id-" + (cidIndex++);
	};
});