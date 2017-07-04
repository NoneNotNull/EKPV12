

define(function(require, exports, module) {
	
	var base = require('lui/base');
	var strutil = require('lui/util/str');
	var $ = require('lui/jquery');
	var tmpl = require("lui/view/Template");
	var loader = require('lui/util/loader');
	
	var decodeHTML = strutil.decodeHTML;
	
	var Render = base.DataRender.extend({
		
		initProps: function($super, cfg) {
			$super(cfg);
			this.dom = cfg ? cfg.dom : null;
			if (this.dom && !this.dom.html)
				this.dom = $(this.dom);

			this.param = {};
			if(cfg.param)
				$.extend(this.param,cfg.param);
			this.vars = cfg.vars || {};
			this.cfg = cfg;
			if(cfg.css){
				require.async(cfg.css);
			}
		},
		
		_draw: function(html, callback) {
			if (html == false) {
				return;
			}
			if (callback)
				callback(html);
			if (this.dom)
				this.dom.html(html);
			this.emit('html', html);
		},
		
		html: function(data, cb) {
			return data;
		},
		
		get: function(data, cb) {
			this._draw(this.html(data, cb), cb);
		}
	});
	
	
	var ResourceLoadRender = Render.extend(loader.ResourceLoadMixin, {
		
		initProps: function($super, cfg) {
			$super(cfg);
		},
		startup : function($super){
			$super();
			this._initResource(this.cfg,this);
		},
		get: function($super, data, callback) {
	    	this._resReady($super, data, callback);
	    }
	});
	
	
	var Template = ResourceLoadRender.extend({
		
		template: null,
		
		_onLoad: function(html) {
			this.template = new tmpl(html);
		},
		
		_byDefault: function() {
			this.template = new tmpl("");
		},
	    
	    html: function(data) {		
	    	try {
				if (this.parent && this.parent.emit)
					this.parent.emit("earse", this.parent);
				return (this.template.render({
					"data" : data,
					"render" : this,
					"env" : this.getEnv(),
					"param": this.param,
					"$": $
				}));
	    	} catch (e) {
	    		if (window.console)
					console.error("render.Template:error,render.id="+this.cid+"", e.stack);
				this.emit("error","render.Template:id="+this.cid+"错误:"+strutil.errorMessage(e.stack,"文件:"+this.src,-2));
	    	}
	    },
	    
		destroy: function($super) {
			$super();
			this.template = null;
		}
	});
	
	var Javascript = ResourceLoadRender.extend({
		
		fn : null,
		
	    _onLoad: function(script) {
			script = script + "\r\n//# sourceURL="+this.src;
	    	this.fn = new Function('done', 'data', 'render', 'env', 'param', '$', script);
		},
		
		_byDefault: function() {
			this.fn = function(data) {return data;};
		},
		//console.error("render:Javascript", e.stack);
		html: function(data, cb) {
			var self = this;
			this.draw = cb; // 兼容
			var fn = this.fn;
			try {
				if (this.parent && this.parent.emit)
					this.parent.emit("earse", this.parent);
				fn(function(html) {
					self._draw(html, cb);
				}, data, this, this.getEnv(), this.param, $);
			} catch(e) {
	    		if (window.console)
					console.error("render.Javascript:error,render.id="+this.cid+"", e.stack);
				this.emit("error","render.Javascript:id="+this.cid+"错误:"+strutil.errorMessage(e.stack,"文件:"+this.src,-2));
			}
			return false;
		},
		
		destroy: function($super) {
			$super();
			this.fn = null;
		}
	});
	
	exports.Render = Render;
	exports.ResourceLoadRender = ResourceLoadRender;
	exports.Template = Template;
	exports.Javascript = Javascript;
	
});