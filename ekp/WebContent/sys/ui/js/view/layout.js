define(function(require, exports, module) {
	var base = require("lui/base"); 
	var $ = require("lui/jquery");
	var strutil = require("lui/util/str");
	var tmpl = require("lui/view/Template");
	var loader = require('lui/util/loader');
	
	var AbstractLayout = base.Layout.extend({
		
		initProps: function($super, cfg) {
			$super(cfg);
			this.dom = cfg ? cfg.dom : null;
			if (this.dom && !this.dom.html)
				this.dom = $(this.dom);
			
			this.kind = cfg.kind;
			this.param = cfg.param;
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
	
	var ResourceLoadLayout = AbstractLayout.extend(loader.ResourceLoadMixin, {
		
		initProps: function($super, cfg) {
			$super(cfg);
		},
		startup : function(){
			this._initResource(this.cfg,this);			
		},
		get: function($super, data, cb) {
	    	this._resReady($super, data, cb);
	    }
	});
	
	var Template = ResourceLoadLayout.extend({
	
		template: null,
		
		_onLoad: function(html) {
			this.template = new tmpl(html);
		},
		
		_byDefault: function() {
			this.template = new tmpl("");
		},
	    
	    html: function(data) {
	    	this[this.kind] = data;
	    	var ctx = {
	    		"layout":this,
	    		"env":this.env,
	    		"param":this.param,
	    		"$": $
	    	};
	    	try {
	    		if (data && data.emit)
	    			data.emit("earse",data);
	    		return (this.template.render(ctx));
	    	} catch (e) {
	    		if (window.console)
					console.error("layout.Template:id="+this.cid, e.stack);
	    		this.emit("error","layout.Template:id="+this.cid+"错误:"+strutil.errorMessage(e.stack,"文件:"+this.src,-2));
	    	}
	    },
	    
		destroy: function($super) {
			$super();
			this.template = null;
		}
	}); 
 
		  
	var Javascript = ResourceLoadLayout.extend({
		
		fn : null,
		
	    _onLoad: function(script) {
			script = script + "\r\n//# sourceURL="+this.src;
	    	this.fn = new Function('done','layout','env','param','$', script);
		},
		
		_byDefault: function() {
			this.fn = function() {return "";};
		},
		
		html: function(data, cb) {
			var self = this;
			var fn = this.fn;
			this[this.kind] = data;
			try {
				if (data && data.emit)
					data.emit("earse",data);
				fn(function(html) {
					self._draw(html, cb);
				}, this, this.env,this.param, $);
			} catch (e) {
	    		if (window.console)
					console.error("layout.Javascript:id="+this.cid + " file:" + this.src, e.stack);	    		
	    		this.emit("error","layout.Javascript:id="+this.cid+"错误:"+strutil.errorMessage(e.stack,"文件:"+this.src,-2));
			}
			return false;
		},
		
		destroy: function($super) {
			$super();
			this.fn = null;
		}
	}); 

	exports.AbstractLayout = AbstractLayout;
	exports.ResourceLoadLayout = ResourceLoadLayout;
	exports.Template = Template;
	exports.Javascript = Javascript;
	
});