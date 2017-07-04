

define(function(require, exports, module) {
	var $ = require('lui/jquery');
	var str = require('lui/util/str');
	
	var ResourceLoadMixin = {
		
		_parseFormScript: function(cfg) {
			if (cfg.src || !cfg.element) {
				return;
			}
			var elem = $(cfg.element).children("script[type='text/code']");
			if (elem.length < 1) {
				return;
			}
			if (elem.attr('xsrc') != null) {
				cfg.src = elem.attr('xsrc');
			} else {
				cfg.code = str.decodeHTML(elem.html());
			}
		},
		
		_initResource: function(cfg,xobj) {
			if(this._loaded)
				return;
//			this._loaded = false;
			this._try_times = 1;
			this._parseFormScript(cfg); 
			if(xobj != null && cfg.src != null)
				cfg.src = xobj.getEnv().fn.formatUrl(cfg.src);
			this.code = cfg.code;
			
			if (cfg.code) {
				this._onLoad(cfg.code);
				this._loaded = true;
			} else if (cfg.src) {
				this.loadResource(cfg.src);
			} else {
				this._byDefault();
				this._loaded = true;
			}
		},
		
		loadResource: function(url) {
			if(url.indexOf('s_cache=')<0){
				if(url.indexOf("?")>=0){
					url = url + "&s_cache=" + seajs.data.env.cache;
				}else{
					url = url + "?s_cache=" + seajs.data.env.cache;
				}
			}
			var self = this;
			this._loaded = false;
			$.ajax({
            	url: url,
            	dataType: 'text',
            	success: function(txt){
            		self._loaded = true;
            		self._onLoad(txt);
            	},
                error: function() {
                	self._loaded = true;
                	self._byDefault();
                }
            });
		},
		
		_onLoad: function(txt) {
			
		},
		
		_byDefault: function() {
			
		},
		
		_resReady: function(draw, data, callback) {
			if (this._loaded) {
				draw(data, callback);
				return;
			}
			this._try_times ++;
    		if (this._try_times > 5000) {
    			return;
    		};
	    	var self = this;
	    	setTimeout(function() {
	    		self._resReady(draw, data, callback);
	    	}, 20);
		}
	};
	
	
	exports.ResourceLoadMixin = ResourceLoadMixin;
});