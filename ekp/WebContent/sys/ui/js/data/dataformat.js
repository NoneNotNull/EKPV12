define(function(require, exports, module) {
			var $ = require('lui/jquery');
			var base = require('lui/base');
			var source = require('lui/data/source');
			var strutil = require('lui/util/str');

			var DataFormat = source.BaseSource.extend({
					initProps : function($super, cfg) {
						$super(cfg);
						var cid = this.cid;
						this.params = cfg.params;
						this.element = cfg.element
								? $(cfg.element)
								: $("<div id='" + this.id + "'></div>");
						this.element.attr("data-lui-cid", cid);
					},

					addChild : function(child) {
						if (child instanceof source.BaseSource) {
							this.setSource(child);
						} else {
							this.setTransform(child);
						}
					},
				
					startup : function() {
						var self = this;
						if (this.isStartup) {
							return;
						}
						if (!this.source) {
							this.setSource(new source.Static({
										datas : [],
										parent : this
									}));
							if(this.source.startup)
								this.source.startup();
						}
						// 事件传递
						this.source.on('data', function(data) {
									self.emit('data', data);
								});

						this.isStartup = true;
					},

					setSource : function(_source) {
						this.source = _source;
					},

					setTransform : function(_transform) {
						this.transform = _transform;
					},
					
					resolveUrl:function(params){
						if (this.source){
							if(this.source.resolveUrl){
								this.source.resolveUrl(params);
							}
						}
					},
					
					get : function() {
						var self = this;
						if(self.params !=null)
							self.source.params = self.params;
						self.source.get(self.transform.format,
								self.transform);
					}
				});

			// 转化器
			var Transform = base.Base.extend({
						getCode : function(cfg) {
							if (cfg.element)
								return $(cfg.element)
										.children("script[type='text/code']")
										.html();
							return null;
						},
						getCodeAsJson : function(cfg) {
							var code = this.getCode(cfg);
							if (code)
								return strutil.toJSON(code);
							return null;
						}
					});

			var DefaultTransform = Transform.extend({
						initProps : function($super, cfg) {
							$super(cfg);
							// 获取转换格式
							this.jsonConfig = this.getCodeAsJson(cfg) || {};
						},
						format : function(old) {
							var data = $.isArray(old)
									? this.arrayFormat(old)
									: this.jsonFormat(old);
							return data;
						},

						// 数组数据源
						arrayFormat : function(old) {
							var data = [];
							if (old.length) {
								for (var i = 0; i < old.length; i++) {
									var obj = {};
									for (var configKey in this.jsonConfig) {
										var R = "return", scriptValue = new Function(
												"data",
												[R, this.jsonConfig[configKey]]
														.join(" "));
										obj[configKey] = scriptValue(old[i]);
									}
									data.push(obj);
								}
							}
							return data;
						},

						// json数据源
						jsonFormat : function(old) {
							var data = {};
							for (var configKey in this.jsonConfig) {
								var R = "return", scriptValue = new Function(
										"data", [R, this.jsonConfig[configKey]]
												.join(" "));
								data[configKey] = scriptValue(old);
							}
							return data;
						}
					});

			var SpecialTransform = Transform.extend({
						initProps : function($super, cfg) {
							$super(cfg);
							// 获取转换格式
							this.jsonConfig = this.getCodeAsJson(cfg) || {};
						},
						format : function(old) {
							var data = [];
							var R = "return";
							var scriptValue, scriptKey;
							if (this.jsonConfig.value) {
								scriptValue = new Function("data", [R,
												this.jsonConfig.value]
												.join(" "));
							}
							if (this.jsonConfig.key) {
								var scriptKey = new Function("data", [R,
												this.jsonConfig.key].join(" "));
							}
							for (var i = 0; i < old.length; i++) {
								var key = "", val = "", obj = {};
								for (var k in old[i]) {
									if (scriptKey) {
										key = scriptKey(old[i]);
									} else {
										key = k;
									}
									if (scriptValue) {
										val = scriptValue(old[i]);
									} else {
										val = old[i][k];
									}
									obj[key] = val;
								}
								data.push(obj);
							}
							return data;
						}
					});
			var ScriptTransform = Transform.extend({
					initProps : function($super, cfg) {
						$super(cfg);
						// 获取转换格式
						this.script = this.getCode(cfg);
					},
					format : function(old) {
						var fn = new Function('data','transform' , '$' , this.script);
						return fn(old , this , $ );
					}
			});
			exports.SpecialTransform = SpecialTransform;
			exports.DefaultTransform = DefaultTransform;
			exports.ScriptTransform = ScriptTransform;
			exports.Transform = Transform;
			exports.DataFormat = DataFormat;
		});
