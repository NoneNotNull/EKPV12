

define(function(require, exports, module) { 
	var base = require('lui/base');
	var strutil = require('lui/util/str');
	var $ = require('lui/jquery');
	
	var BaseSource = base.DataSource.extend({
		_getCode: function(cfg) {
			if (cfg.code)
				return cfg.code;
			if (cfg.element)
				return $(cfg.element).children("script[type='text/code']").html();
			return null;
		},
		getCodeAsJson: function(cfg) {
			var code = this._getCode(cfg);
			if (code)
				return strutil.toJSON(code);
			return null;
		},
		getCodeAsText: function(cfg) {
			return this._getCode(cfg);
		},
		_done: function(old, cb, ctx) {
			var data = old;
			if (cb)
				data = cb.call(ctx, old);
			this.emit('data', data);
		},
		abort: function() {
			return this;
		},
		get: function(done, ctx) {
			this._done({}, done, ctx);
			return this;
		},
		destroy: function($super) {
			$super();
			this.abort();
		}
	});
	
	var UrlSource = BaseSource.extend({
		setUrl: function(url) {
			this.url = url;
			this._url = url;
		},
		initProps: function($super, cfg) {
			$super(cfg);
			if (Object.isString(cfg)) {
				this.setUrl(cfg);
			} else {
				this.setUrl(cfg.url);
			}
			this.params = cfg.params;
			this.vars = {};
			$.extend(this.vars, this.config.vars);
			this.index = 0;
            this.callbacks = [];
	    },
		abort: function() {
			this.url = null;
			this.callbacks = [];
			return this;
		},
		onload: function(data, done, ctx) {
			this._done(data, done, ctx);
		},
		_request: function(url, dataType, done, ctx) {
			var self = this;
            var callbackId = 'callback_' + this.index++;
            this.callbacks.push(callbackId);
			url = self.getEnv().fn.formatUrl(url); 
			var reqType = dataType=='json'?'text': dataType;
            $.ajax({
            	url: url,
            	dataType: reqType,
            	data:this.params,
            	jsonp:"jsonpcallback",
            	success: function(data,textStatus) {
            		var rtnData = data; 
            		if(typeof(data)=='string' && (dataType=='json' || dataType=='jsonp')){
            			rtnData = strutil.toJSON(data);
            		}
                    if ($.inArray(callbackId, self.callbacks) > -1) {
                        delete self.callbacks[callbackId];
                        self.onload(rtnData, done, ctx);
                    }
                },
                error: function(request, textStatus, errorThrown) {
                	if ($.inArray(callbackId, self.callbacks) > -1) {
                        delete self.callbacks[callbackId];
                       // self.onload([], done, ctx);
                    }
                    var __status = request.status;
                    var msg = "source:id="+self.cid+"\r\n地址:"+url+"请求过程中错误\r\n错误类型:"+(textStatus == "parsererror" ? "解析json错误" : textStatus)+";\r\n";
                    msg += "返回文本:"+strutil.encodeHTML(request.responseText)+"\r\n";
                    msg += "错误堆栈:"+(errorThrown.stack ? errorThrown.stack : errorThrown )+"";
                    if (window.console) 
						window.console.error(msg);
					if (__status == 403) {// 无权限等错误不返回前端显示
						self.onload([], done, ctx);
					} else {
						var e = request.getResponseHeader("error");
						if ($.trim(e) != "") {
							self.emit("error", decodeURIComponent(e));
						} else {
							self
									.emit(
											"error",
											"错误类型:"
													+ (textStatus == "parsererror"
															? "解析返回数据时错误"
															: textStatus)
													+ "<br>错误信息:"
													+ (errorThrown.message
															? errorThrown.message
															: errorThrown));
						}
					}
                }
            });
		},
		get: function(done, ctx) {
			var self = this, dataType;
			
			var url = this.url;
			if (this.dataType) {
				dataType = this.dataType;
			} else if (/^(https?:\/\/)/.test(url)) {
            	dataType = 'jsonp';
            } else {
            	dataType = 'json';
            }
            this._request(url, dataType, done, ctx);
			return this;
		}
	});
	
	var ScriptSource = BaseSource.extend({
		fn: function(){return false;},
		getArgs: function(cfg) {
			if (cfg.args)
				return cfg.args;
			if (cfg.element)
				return $(cfg.element).children("script[type='text/code']").attr('data-lui-args');
			return null;
		},
		initProps: function(cfg) {
			var argNames = ["done", "query"];
			if ($.isString(cfg)) {
				this.fn = new Function(argNames, cfg);
			} else if ($.isFunction(cfg)) {
				this.fn = cfg;
			} else if (cfg.element) {
				var code = this.getCodeAsText(cfg);
				var args = this.getArgs(cfg);
				if (args) {
					if (Object.isArray(args)) {
						argNames = args;
					} else {
						var str = args.toString();
						if (str == null || $.trim(str) == 0) {
							argNames = [];
						} else {
							argNames = $.map(str.split(/[,;]/), function(arg) {return $.trim(arg);});
						}
					}
				}
				this.fn = new Function(argNames, element.innerHTML);
			}
	    },
		get: function(done, ctx) {
			var self = this, fn = this.fn;
			function _callback(data) {
				self._done(data, done, ctx);
            }
            var data = fn.call(this, _callback, query);
            if (data) {
                this._done(data, done, ctx);
            }
			return this;
		}
	});
	
	var AjaxSource = UrlSource.extend({
		initProps : function($super, cfg){
			$super(cfg);
			var json = this.getCodeAsJson(cfg);
			if (json){
				this.setUrl(json.url);
			}
			this.ajaxConfig = json;
		},
		resolveUrl: function(params) {
			if(this.url){
				var tempData = {};
				$.extend(tempData, this.vars);
				if (params != null)
					$.extend(tempData, params);
				tempData["lui.element.id"] = this.parent.id;
				tempData["lui.theme"] = ""; // TODO 取到环境参数
				// 每次都使用元素参数
				this.emit('beforeResolveUrl', tempData);
				this.url = strutil.variableResolver(this._url, tempData);
				this.emit('afterResolveUrl', this);
			}
			return this;
		},
		startup:function($super){
			$super();
			this.resolveUrl();
		}
	});
	
	/**
	获取服务端Json数据
	**/
	var AjaxJson = AjaxSource.extend({
		initProps : function($super, cfg){
			$super(cfg);
			this.dataType = 'json';
		}
	});
	
	/**
	跨域获取服务端Json数据
	**/
	var AjaxJsonp = AjaxSource.extend({
		initProps : function($super, cfg){
			$super(cfg);
			this.dataType = 'jsonp';
		}
	});
	
	/**
	获取服务端Xml数据,然后转换成呈现器能识别的JSON数据
	**/
	var AjaxXml = AjaxSource.extend({
		initProps : function($super, cfg){
			$super(cfg);
			this.dataType = 'text';
		},
		onload: function($super, data, done, ctx) {
			var source = [];
			var nodes = $(data).find("data");
			for(var i=0; i<nodes.length; i++){
				source[i] = {};
				var attNodes = nodes[i].attributes;
				for(var j=0; j<attNodes.length; j++)
					source[i][attNodes[j].nodeName] = attNodes[j].nodeValue;
			}
			$super(source, done, ctx);
		}
	});
	
	var AjaxText = AjaxSource.extend({
		initProps : function($super, cfg){
			$super(cfg);
			this.dataType = 'text';
			this.formatKey = cfg.formatKey || this.ajaxConfig.formatKey;
		},
		onload: function($super, data, done, ctx) {
			var source = {};
			source[this.formatKey] = data;
			$super(source, done, ctx);
		}
	});
	
	var AjaxJsonpText = AjaxSource.extend({
		initProps : function($super, cfg){
			$super(cfg);
			this.dataType = 'jsonp';
			this.formatKey = cfg.formatKey || this.ajaxConfig.formatKey;
		},
		onload: function($super, data, done, ctx) {
			var source = {};
			source[this.formatKey] = data.text;
			$super(source, done, ctx);
		}
	});
	
	/**
	静态数据源
	**/
	var Static = BaseSource.extend({
		initProps : function($super, cfg){
			$super(cfg);
			this.vars = {};
			$.extend(this.vars, this.config.vars);
		},
		startup : function(){
			var codeText = this.getCodeAsText(this.config);
			if (codeText){
				var tempData = {};
				$.extend(tempData, this.vars); 
				tempData["lui.element.id"] = this.parent.id;
				tempData["lui.theme"] = ""; // TODO 取到环境参数
				codeText = strutil.variableResolver(codeText, tempData);
				codeText = strutil.toJSON(codeText);
			}			
			this.source = this.config.datas || codeText;
		},
		get: function(done, ctx) {
			this._done(this.source, done, ctx);
			return this;
		}
	}); 
	

	exports.BaseSource = BaseSource;
	exports.UrlSource = UrlSource;
	exports.ScriptSource = ScriptSource;
	exports.AjaxJson = AjaxJson;
	exports.AjaxJsonp = AjaxJsonp;
	exports.AjaxXml = AjaxXml;
	exports.AjaxText = AjaxText;
	exports.AjaxJsonpText = AjaxJsonpText;
	exports.Static = Static;
	
});