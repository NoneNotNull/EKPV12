~~function(window) {
	if (!Function.prototype.bind) {
		Function.prototype.bind = function(obj) {
			var slice = [].slice, args = slice.call(arguments, 1), self = this, nop = function() {
			}, bound = function() {
				return self.apply(this instanceof nop ? this : (obj || {}),
						args.concat(slice.call(arguments)));
			};
			nop.prototype = self.prototype;
			bound.prototype = new nop();
			return bound;
		};
	}

	if (typeof Pda === "undefined") {
		Pda = {};
		Pda.Base = {};
	}

	Pda.Constant = {};

	Pda.Util = {
		// 一般列表使用，转换为key-value类型
		data2kv : function(_datas) {
			var kvData = [];
			for (var i = 0; i < _datas.length; i++) {
				var json = {};
				for (var j = 0; j < _datas[i].length; j++) {
					json[_datas[i][j]['col']] = _datas[i][j]['value'];
				}
				kvData.push(json);
			}
			return kvData;
		},
		setParam : function(name, value) {
			localStorage.setItem(name, value)
		},
		getParam : function(name) {
			return localStorage.getItem(name)
		},

		// 获取触摸事件
		getTouchEvent : function(e) {
			if (e.originalEvent)
				return e.originalEvent;
			// 兼容zepto
			else
				return e;
		},

		// 返回触摸点
		getTouchPoint : function(touches) {
			return {
				x : touches[0].pageX,
				y : touches[0].pageY
			};
		},
		replaceParam : function(param, value, url) {
			var re = new RegExp();
			re.compile("([\\?&]" + param + "=)[^&]*", "i");
			if (value == null) {
				if (re.test(url)) {
					url = url.replace(re, "");
				}
			} else {
				value = encodeURIComponent(value);
				if (re.test(url)) {
					url = url.replace(re, "$1" + value);
				} else {
					url += (url.indexOf("?") == -1 ? "?" : "&") + param + "="
							+ value;
				}
			}
			if (url.charAt(url.length - 1) == "?")
				url = url.substring(0, url.length - 1);
			return url;
		},
		// 替换url上参数
		replaceParams : function(params, url) {
			for (var i = 0; i < params.length; i++) {
				var p = params[i];
				for (var j = 0; j < p.value.length; j++) {
					url = this.replaceParam(p.key, p.value[j], url);
				}
			}
			return url;
		},
		textEllipsis : function(str, num) {
			if (str) {
				if (str.length * 2 <= num)
					return str;
				var rtnLength = 0;
				for (var i = 0; i < str.length; i++) {
					if (Math.abs(str.charCodeAt(i)) > 200)
						rtnLength = rtnLength + 2;
					else
						rtnLength++;
					if (rtnLength > num)
						return str.substring(0, i)
								+ (rtnLength % 2 == 0 ? ".." : "...");
				}
				return str;
			}
		},
		// 字符串转换数组
		toJSON : function(str) {
			return (new Function("return (" + str + ");"))();
		},
		upperFirst : function(str) {
			return str.charAt(0).toUpperCase() + str.substring(1);
		},
		// 申请zindex
		getZIndex : function() {
			Pda.___ZIndex___ = Pda.___ZIndex___ + 10;
			return Pda.___ZIndex___;
		},
		// 申请id
		getId : function() {
			____pda__id____++;
			return 'pda_id_' + ____pda__id____;
		},

		variableResolver : function(str, data) {
			function extend(destination, source) {
				for (var property in source)
					destination[property] = source[property];
				return destination;
			}
			return str.replace(/\!\{([\w\.]*)\}/gi, function(_var, _key) {
						var value = data[_key];
						return (value === null || value === undefined)
								? ""
								: value;
					});
		},

		// 补全url项目路径
		formatUrl : function(url) {
			if (url == null) {
				return "";
			}
			if (url.substring(0, 1) == '/') {
				return Com_Parameter.ContextPath + url.substring(1, url.length);
			} else {
				return url;
			}
		},
		getClientHeight : function() {
			var h = 0;
			if (!window.innerHeight)
				h = $(window).height();
			else
				h = window.innerHeight;
			return h;
		},
		browser : {
			webkit : /webkit/i.test(navigator.userAgent),
			isAndroid : /android/i.test(navigator.userAgent),
			isiOS : /like Mac OS/i.test(navigator.userAgent)
		},
		// 格式化日期
		parseDate : function(str, format) {
			var _format = format;
			var result = new Date();
			if (/(y+)/.test(_format))
				result.setFullYear(str.substring(_format.indexOf(RegExp.$1),
						_format.indexOf(RegExp.$1) + RegExp.$1.length));
			if (/(M+)/.test(_format))
				result.setMonth(parseInt(str.substring(_format
										.indexOf(RegExp.$1), _format
										.indexOf(RegExp.$1)
										+ RegExp.$1.length), 10)
						- 1);
			if (/(d+)/.test(_format))
				result.setDate(str.substring(_format.indexOf(RegExp.$1),
						_format.indexOf(RegExp.$1) + RegExp.$1.length));
			if (/(h+)/.test(_format))
				result.setHours(str.substring(_format.indexOf(RegExp.$1),
						_format.indexOf(RegExp.$1) + RegExp.$1.length));
			if (/(m+)/.test(_format))
				result.setMinutes(str.substring(_format.indexOf(RegExp.$1),
						_format.indexOf(RegExp.$1) + RegExp.$1.length));
			if (/(s+)/.test(_format))
				result.setSeconds(str.substring(_format.indexOf(RegExp.$1),
						_format.indexOf(RegExp.$1) + RegExp.$1.length));
			if (/(S+)/.test(_format))
				result.setMilliseconds(str.substring(
						_format.indexOf(RegExp.$1), _format.indexOf(RegExp.$1)
								+ RegExp.$1.length));
			return result;
		},

		formatDate : function(date, format) {
			var o = {
				"M+" : date.getMonth() + 1,
				"d+" : date.getDate(),
				"h+" : date.getHours(),
				"m+" : date.getMinutes(),
				"s+" : date.getSeconds(),
				"q+" : Math.floor((date.getMonth() + 3) / 3),
				"S" : date.getMilliseconds()
			};
			if (/(y+)/.test(format))
				format = format.replace(RegExp.$1, (date.getFullYear() + "")
								.substr(4 - RegExp.$1.length));
			for (var k in o) {
				if (new RegExp("(" + k + ")").test(format)) {
					format = format.replace(RegExp.$1, RegExp.$1.length == 1
									? o[k]
									: ("00" + o[k]).substr(("" + o[k]).length));
				}
			}
			return format;
		}
	};

	Pda.___ZIndex___ = 50;

	Pda.Base.Widget = {
		widgets : [],
		register : function(role) {
			this.widgets.push(role)
		},
		hasWidget : function(role) {
			var _has = false;
			for (var j = 0; j < this.widgets.length;) {
				if (this.widgets[j] === role) {
					_has = true;
					break;
				}
				j++;
			}
			return _has;
		}
	};

	// 根据id获取对象
	Pda.Element = function(id) {
		return ____pda__cache____[id];
	};

	// 根据角色获取对象组
	Pda.Role = function(role, group) {
		if (!role)
			return;

		var arr = [];
		for (var key in ____pda__cache____) {
			var obj = ____pda__cache____[key];
			if (role == obj.role)
				if (!group || obj.group && obj.group == group)
					arr.push(____pda__cache____[key]);
		}
		return arr;
	};

	// 全局事件
	Pda.Topic = {
		_topic : {},

		emit : function(event) {
			if (typeof event == "string") {
				event = {
					type : event
				};
			}
			if (!event.target) {
				event.target = this;
			}
			if (this._topic[event.type] instanceof Array) {
				var topic = this._topic[event.type];
				for (var i = 0, len = topic.length; i < len; i++) {
					topic[i].call(this, event);
				}
			}
		},
		off : function(type, listener) {
			if (this._topic[type] instanceof Array) {
				var topic = this._topic[type];
				for (var i = 0, len = topic.length; i < len; i++) {
					if (topic[i] === listener) {
						topic.splice(i, 1);
						break;
					}
				}
			}
		},
		on : function(type, listener) {
			if (typeof this._topic[type] === 'undefined') {
				this._topic[type] = [];
			}
			this._topic[type].push(listener);
		}
	}

}(window);

~~function() {
	Pda.Base.EventClass = SimpleClass.extend({

				role : 'event',

				_listeners : null,
				init : function() {
					this._listeners = {};
				},

				initId : function(id) {
					this.id = id;
					this.target.attr('id', id);
				},

				on : function(type, listener) {
					if (typeof this._listeners[type] === 'undefined') {
						this._listeners[type] = [];
					}
					this._listeners[type].push(listener);
				},
				emit : function(event) {
					if (typeof event == "string") {
						event = {
							type : event
						};
					}
					if (!event.target) {
						event.target = this;
					}
					if (this._listeners[event.type] instanceof Array) {
						var listeners = this._listeners[event.type];
						for (var i = 0, len = listeners.length; i < len; i++) {
							listeners[i].call(this, event);
						}
					}
				},
				off : function(type, listener) {
					if (this._listeners[type] instanceof Array) {
						var listeners = this._listeners[type];
						for (var i = 0, len = listeners.length; i < len; i++) {
							if (listeners[i] === listener) {
								listeners.splice(i, 1);
								break;
							}
						}
					}
				},

				clientWidth : function() {
					if (!window.innerWidth)
						return $(window).width();
					return window.innerWidth;
				},

				clientHeight : function() {
					return Pda.Constant.clientHeight;
				},

				emitGroup : function(event) {
					var self = this;
					if (typeof event == "string")
						event = {
							type : event,
							target : self
						};
					else
						event.target = self;
					var arr = Pda.Role(this.role);
					for (var j = 0; j < arr.length; j++) {
						if (arr[j].group && this.group
								&& arr[j].group === this.group) {
							arr[j].emit(event);
						}
					}
				},

				destroy : function() {
					delete ____pda__cache____[this.id];
				}
			});
}();

~~function(win) {
	Pda.Base.Widget.register('component');
	Pda.Component = Pda.Base.EventClass.extend({

		role : 'component',

		init : function(options) {
			this._super();
			// 渲染位置
			this.target = $(options.target);
			this.lazy = options.lazy;

			if (!options || !options.source) {
				this.self = true;
				return;
			}

			if (options.parent) {
				if (typeof options.parent == "string")
					this.parent = Pda.Element(options.parent);
				else
					this.parent = options.parent;
			}

			// 数据源
			this.___source___ = options.source;

			this._url = this.___source___.url;
			this.url = this._url + '';
			// 自定义格式化数据
			this.format = this.___source___.format || this.format
					|| new Function('data', 'return data;');
			this.type = this.___source___.type || 'json';

			// 渲染模板
			this.___render___ = options.render;
			this.templateId = this.___render___.templateId;
			this.templateUrl = this.___render___.url;
			// 自定义渲染方式
			this.render = this.render || this.___render___.render;

			if (!this.target || this.target.length === 0) {
				this.id = Pda.Util.getId();
				this.target = $('<div id="' + this.id + '">');
				$('[data-lul-role="body"]').append(this.target);
			}

			if (!this.lazy) {
				this.draw();
				this.loaded = false;
			}

			this.parentData = options.parentData || {};
		},

		startup : function() {
			if (this.self)
				return;
			if (this.templateId)
				this.template = this.getTemplate(this.templateId);
			if (this.templateUrl) {
				this.on('dataon', this.getRender);
				this.on('renderon', this.__render);
			} else
				this.on('dataon', this.__render);
		},

		draw : function() {
			if (this.self) {
				this.loaded = true;
				this.target.show();
				this.emit('loaded');
				return;
			}

			if (!this.loading)
				this.loading = Pda.loading();
			this.loading.show()
			if (this.loaded) {
				this.loading.hide();
				this.target.show();
				return;
			}
			this.__getDate();
		},

		getTemplate : function(id) {
			return $(id).html();
		},

		getRender : function(evt) {
			this.renderReq(evt);
		},

		__render : function(evt) {
			var self = this;
			var html = KmsTmpl(this.template).render({
						"data" : evt.data,
						"component" : self
					});
			if (this.render) {
				this.render.call(this, html)
				return;
			}
			this.target.html(html);
			this.loaded = true;
			this.loading.hide();
			this.emit('loaded');
		},

		renderReq : function(evt) {
			var self = this;
			$.ajax({
						url : this.templateUrl,
						dataType : 'html',
						success : function(txt) {
							self.template = txt;
							evt.type = 'renderon';
							self.emit(evt)
						}
					});
		},

		AjaxJson : function() {
			var self = this;
			this.___url = Pda.Util.variableResolver(this.url, self.parentData);
			$.ajax({
						url : this.___url,
						dataType : 'json',
						success : function(txt) {
							if (txt && self.format)
								txt = self.format.call(self, txt);
							if (!txt || txt instanceof Array && txt.length == 0) {
								self.emit('dataoff');
								if (self.loading)
									self.loading.hide();
								return;
							}
							self.__data__ = txt;
							self.emit({
										type : 'dataon',
										data : txt
									})
						}
					});
		},

		Static : function() {
			this.emit({
						type : 'dataon',
						data : this.___source___.data || []
					})
		},

		__getDate : function() {
			this[Pda.Util.upperFirst(this.___source___.type)]();
		},

		destroy : function() {
			this._super();
			if (this.target) {
				this.target.off();
				this.target.remove();
				this.target = null;
			}
			this.erase();
		},
		erase : function() {
			this.emit("erase", this);
			this.off("erase");
		}
	})
}(window);

window.____pda__cache____ = {};
window.____pda__id____ = 1;

Pda.init = function(container) {
	container = container || document;
	var ___arr = [];
	$('[data-lui-role]', container).each(function() {
		var role = $(this).attr('data-lui-role');
		if (!Pda.Base.Widget.hasWidget(role))
			return true;
		var config = Pda.Util.toJSON($(this).find("script[type='text/config']")
				.html());
		if (!config)
			config = {};
		config.target = $(this);
		___arr.push({
					id : $(this).attr('id'),
					role : role,
					config : config
				});
	});

	var current = {};
	for (var i = 0; i < ___arr.length; i++) {
		var obj = new window['Pda'][Pda.Util.upperFirst(___arr[i].role)](___arr[i].config);
		if (!___arr[i].id)
			___arr[i].id = Pda.Util.getId();
		obj.initId(___arr[i].id);
		____pda__cache____[___arr[i].id] = obj;
		current[___arr[i].id] = obj;
	}

	for (var i in current) {
		if (current[i].startup)
			current[i].startup();
	}

	for (var i in current) {
		if (!current[i].lazy && current[i].draw)
			current[i].draw();
	}
	Pda.Topic.emit('ready');
};

// 初始化组件
$(function() {
			$(document.body).css('height', 2000);
			function ___init() {
				setTimeout(function() {
							var h = Pda.Util.getClientHeight();
							if (h < 200) {
								___init()
								return;
							}

							Pda.Constant.clientHeight = h;
							$(document.body).css('height',
									Pda.Util.getClientHeight());
							Pda.init();
						}, 100);
			};
			___init();
		});