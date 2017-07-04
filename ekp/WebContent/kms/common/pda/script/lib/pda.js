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
				return Com_Parameter.ContextPath + url;
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
~~function(win) {
	Pda.Base.Widget.register('column');
	Pda.Column = Pda.Component.extend({

		role : 'column',

		// 分页使用
		totalSize : 1,
		currentPage : 0,

		lock : false,
		padding : 10,
		// 当前y轴偏移量
		currentY : 0,
		// 是否处于滑动状态，只有非滑动状态才有可能触发点击
		moved : false,
		// 滑动开始位置
		start : {},
		// 滑动当前位置
		touchMovePoint : {},
		// 滑动期间暂存值
		touchStartPoint : {
			x : 0,
			y : 0
		},

		init : function(options) {
			// IOS使用默认滚动大图下有点小卡，android相反，艹
			this.scroll = options.scroll === false
					? false
					: (options.scroll == 'auto' ? Pda.Util.browser.isiOS : true);
			this._super(options);
		},

		startup : function() {
			this._super();
			this.parent = this.target.parents('[data-lui-role="listview"]');
			if (this.parent && this.parent.length > 0)
				Pda.Element(this.parent.attr('id')).pushChild(this.id, this);

			var self = this;
			var css = {
				'width' : this.clientWidth() - 2 * this.padding,
				'padding' : '0 ' + this.padding + 'px',
				'min-height' : 200
				// 用于占位
			}
			// 列表内部窗口高度
			this.ch = this.clientHeight();
			this.container = $('<div>');
			this.target.append(this.container);
			if (!this.scroll) {
				var self = this;
				css['height'] = '100%';
				css['overflow-y'] = 'scroll';
				this.target.on('scroll', function(evt) {
					if (self.target.scrollTop() + self.target.height() >= self.container
							.height())
						self.onTm();
				});
			}
			this.target.css(css);
			// 无数据
			this.on('dataoff', function() {
						self.buildNoResult();
						self.offTouch();
					});
			this.on('dataon', function() {
						self.offTouch();
						self.onTouch();
					});
		},

		offTouch : function() {
			this.target.off('touchstart').off('touchmove').off('touchend');
		},

		onTouch : function() {
			this.target.on('touchstart', this.tsHandler.bind(this));
			this.target.on('touchmove', this.tmHandler.bind(this));
			if (this.scroll)
				this.target.on('touchend', this.teHandler.bind(this));

		},

		// 构建无数据提示
		buildNoResult : function() {
			this.container
					.html('<div style="width:100%;height:100%;text-align:center;padding-top:100px;">'
							+ '<span>未找到相关文档.</span>' + '</div>')
		},

		__draw : function() {
			if (!this.hasNext())
				return;
			if (this.lock)
				return;
			this.loaded = false;
			this.currentPage += 1;
			this.url = Pda.Util.replaceParams([{
								value : [this.currentPage],
								key : 'pageno'
							}], this.url);
			this.draw();
		},

		_tranlate : function(x, y, time) {
			return {
				'-webkit-transition' : time
						+ 'ms cubic-bezier(0.1, 0.57, 0.1, 1)',
				'-webkit-transform' : 'translate( ' + x + 'px,' + y
						+ 'px) translateZ(0px)'
			};
		},

		// 停止动画
		stopTransition : function() {
			var duration = '-webkit-transition-duration';
			this.target.css(duration, 0);
		},

		// 还原滚动最初位置
		resetScroll : function() {
			this.__scroll__(0, 0, 0);
		},

		scrollTo : function(x, y, time) {
			this.currentY = this.currentY + y;
			var height = this.container.height() + 50;
			if (this.currentY < -height + this.ch) {
				this.currentY = -height + this.ch;
				this.onTm(height);
			}
			if (this.currentY > 0)
				this.currentY = 0;
			this.__scroll__(x, this.currentY, time);
			height = null;
		},

		__scroll__ : function(x, y, time) {
			this.target.css(this._tranlate(x, y, time));
		},

		onTm : function(sh) {
			this.__draw();
		},

		getLoading : function() {
			if ($('.loading').length > 0)
				this.loading = $('.loading');
			else
				this.loading = $('<div class="loading"><span></span></div>');
			return this.loading;
		},

		tsHandler : function(e) {
			var event = Pda.Util.getTouchEvent(e);
			this.start = Pda.Util.getTouchPoint(event.touches);
			if (!this.scroll)
				return;
			this.cancelEvent(e);
			this.moved = false;
			this.touchStartPoint = Pda.Util.getTouchPoint(event.touches);
			this.stopTransition();
			this.startTime = this.getTime();
		},

		// 取消默认事件
		cancelEvent : function(e) {
			e.preventDefault();
			e.stopPropagation();
		},

		tmHandler : function(e) {
			var touches = Pda.Util.getTouchEvent(e).touches;
			if (!this.scroll) {
				this.touchStartPoint = Pda.Util.getTouchPoint(touches);
				var y_distance = this.touchStartPoint.y - this.start.y;
				var x_distance = this.touchStartPoint.x - this.start.x;
				// 列表左右滑动切换
				if (this.parent && this.parent.teHandler)
					this.parent.teHandler(x_distance * 10, y_distance * 10);
				return;
			}
			this.cancelEvent(e);
			this.moved = true;
			// 当前位置
			this.touchMovePoint = Pda.Util.getTouchPoint(touches);
			this.scrollTo(0, this.touchMovePoint.y - this.touchStartPoint.y, 0);
			// 重置上次位置
			this.touchStartPoint = Pda.Util.getTouchPoint(touches);
			var time = this.getTime();
			if (time - this.startTime > 300) {
				this.startTime = time;
				this.start.y = this.touchMovePoint.y;
			}

		},

		teHandler : function(e) {
			var y_distance = this.touchStartPoint.y - this.start.y;
			var x_distance = this.touchStartPoint.x - this.start.x;
			// 通知listview对象是否左右滑动切换
			var p = this.parent;
			if (p && p.target && p.target.length > 0)
				p.teHandler(x_distance, y_distance);
			p = null;
			this.cancelEvent(e);
			var time = this.getTime() - this.startTime;
			x_distance = null;
			if (Math.abs(y_distance) > 20)
				if (y_distance > 0) {
					// 上滑
					if (time >= 150)
						return;
					this.scrollTo(0, 188, 791);
					this.start.y += 188;
				} else {
					// 拉下
					if (time >= 300)
						return;
					this.scrollTo(0, -188, 791);
					this.start.y -= 188;
				}
			y_distance = null;
			if (!this.moved)
				this.__click(e);
		},

		getTime : function() {
			return new Date().getTime();
		},

		render : function(html) {
			if (!html)
				return;
			this.container.append(html);
			this.loaded = true;
			this.lock = false;
			if (this.loading)
				this.loading.hide();
			if (this.hasNext()) {
				this.loading = this.getLoading();
				this.container.append(this.loading);
				this.loading.show();
			}
			this.emit('loaded');
		},

		hasNext : function() {
			return this.totalPage > this.currentPage;
		},

		format : function(data) {
			var p = data.page;
			for (var i in p)
				this[i] = parseInt(p[i]);
			this.totalPage = Math.ceil(this.totalSize / this.pageSize);
			return Pda.Util.data2kv(data.datas);
		},

		reDraw : function() {
			this.container.html('');
			this.__getDate();
		},

		draw : function() {
			if (this.lock)
				return;
			if (!this.loaded)
				this.lock = true;
			this._super();
		},

		selected : function() {
			this.lock = false;
			this.target.show();
			this.draw();
		},

		// 模拟点击事件--由于将默认事件取消增加滚动流畅性
		__click : function(e) {
			var target = e.target, ev;
			if (!(/(SELECT|INPUT|TEXTAREA)/i).test(target.tagName)) {
				ev = document.createEvent('MouseEvents');
				ev.initMouseEvent('click', true, true, e.view, 1,
						target.screenX, target.screenY, target.clientX,
						target.clientY, e.ctrlKey, e.altKey, e.shiftKey,
						e.metaKey, 0, null);

				ev._constructed = true;
				target.dispatchEvent(ev);
			}
		},

		// 列表视图变更
		change : function() {
		},

		// 置顶
		toTop : function() {
			if (this.scroll) {
				this.__scroll__(0, 0, 791);
				this.currentY = 0;
			} else
				this.target.scrollTop(0);
		}
	})
}(window);

// 移除旧有图片懒加载，优化滑动抖动
~~function(win) {
	Pda.Base.Widget.register('rowTable');
	Pda.RowTable = Pda.Column.extend({});
}(window);

~~function(win) {
	Pda.Base.Widget.register('listview');
	Pda.Listview = Pda.Base.EventClass.extend({

		role : 'listview',
		// 记录孩子数
		__index__ : 0,
		// 孩子集合
		children : {},
		// 横向偏移，超过切换
		swipeX : 100,
		// 竖向偏移，超过不切换
		swipeY : 70,
		// 动画锁，防止动画其间重复触发动画
		lock : false,
		// 当前所在视图の索引
		index : 0,
		// 筛选前缀，兼容ued数据源
		prefix : 'q._prop_.',

		init : function(options) {
			this._super();
			this.target = $(options.target);
			this.container = $('<div class="lui-listview-container">');
		},

		pushChild : function(id, child) {
			var self = this;
			this.children[id] = {
				obj : child,
				left : self.__index__ * self.clientWidth(),
				index : self.__index__,
				id : id
			};
			child.parent = self;
			this.__index__++;
		},

		startup : function() {
			var self = this;
			Pda.Topic.on('listChange', function(evt) {
						self.listChange(evt);
					});
		},

		// 筛选
		listChange : function(evt) {
			var data = evt.data || {}, prex = this.prefix, arr = [], children = this.children, categoryId = evt.categoryId, prop = evt.prop;
			for (var key in children) {
				var list = children[key], obj = list.obj;
				obj.loaded = false;
				for (var key in data) {
					var item = prex + encodeURIComponent(key) + '='
							+ encodeURIComponent(data[key]);
					arr.push(item);
				}
				var url = obj._url;
				var str = arr.join('&');
				if (prop)
					url = Pda.Util.replaceParams([{
										value : [prop.value],
										key : prop.key
									}], url);

				if (categoryId)
					url = Pda.Util.replaceParams([{
										value : [categoryId],
										key : 'categoryId'
									}], url);
				if (url.indexOf('?') > 0)
					url += "&" + str;
				else
					url += "?" + str;
				obj.url = url;
				obj.container.html('');
				obj.resetScroll();
			}
			var i = this.getIndex();
			this.selectedByIndex(i, true);
		},

		draw : function() {
			var h = this.clientHeight();
			var css = {
				'overflow' : 'hidden',
				'height' : h - 50
			};
			this.target.css(css);
			this.container.css(css);
			var children = this.target.children();
			children.css({
						'float' : 'left'
					});
			children.appendTo(this.container);
			this.target.append(this.container);
			var self = this;
			this.container.on('webkitTransitionEnd', function() {
						self.lock = false;
					});
		},

		teHandler : function(x_distance, y_distance) {
			if (this.lock)
				return;
			if (Math.abs(x_distance) >= this.swipeX
					&& Math.abs(y_distance) <= this.swipeY) {
				if (x_distance < 0)
					this.slideLeft();
				else
					this.slideRight();
			}
		},

		slideLeft : function(flag) {
			var i = this.getIndex();
			this.selectedByIndex(i + 1, flag);
		},

		slideRight : function(flag) {
			var i = this.getIndex();
			this.selectedByIndex(i - 1, flag);
		},

		selectedByIndex : function(index, flag) {
			for (var key in this.children) {
				var list = this.children[key];
				if (list.index === index) {
					if (!flag)
						this.lock = true;
					this.selectedList(list);
					// 往外扔事件
					Pda.Topic.emit({
								type : 'slide',
								obj : list
							});
					break;
				}
			}
		},

		getListByIndex : function(index) {
			for (var key in this.children) {
				var list = this.children[key];
				if (list.index === index)
					return list;
			}
		},

		selectedList : function(list) {
			var self = this;
			// 渲染对应列表
			list.obj.selected();
			this.setIndex(list.index);
			this.container.css(this._3dChange(-list.left + "px"));
		},

		getIndex : function() {
			return this.index;
		},

		setIndex : function(index) {
			this.index = index;
		},

		selected : function(key) {
			var c = this.children;
			for (var kk in c)
				if (c[kk].obj.change)
					c[kk].obj.change();
			if (c[key]) {
				var list = c[key];
				this.selectedList(list);
			};
		},

		_3dChange : function(x) {
			return {
				'-webkit-transform' : 'translate3d(' + x + ', 0, 0)',
				'-moz-transform' : 'translate3d(' + x + ', 0, 0)',
				'transform' : 'translate3d(' + x + ', 0, 0)'
			}
		},

		top : function() {
			var obj = this.getListByIndex(this.index).obj;
			obj.toTop();
		}
	});
}(window);
~~function(win) {
	Pda.Base.Widget.register('panel');
	Pda.Panel = Pda.Base.EventClass.extend({
				role : 'panel',

				touchStartPoint : {},
				touchEndPoint : {},
				swipeThreshold : 10,
				swipeY : 3,
				action : '',
				top : 0,
				loaded : false,

				init : function(options) {
					this._super(options);
					this.target = options.target;
					this.page = $('[data-lui-role="page"]');
					this.slide(options);
					this.index = 9000 + Pda.Util.getZIndex();
					this.url = options.url;
					this.width = options.width || 1;
					this.mask = options.mask || false;
					this.canClose = options.canClose === false ? false : true;
					// 是否处于活跃状态
					this.active = false;
					if (!this.target || this.target.length === 0) {
						this.id = options.id ? options.id : Pda.Util.getId();
						this.target = $('<div id="' + this.id + '">');
						$('[data-lul-role="body"]').append(this.target);
					}

					win.____pda__cache____[this.id] = this;
				},

				startup : function() {
				},

				draw : function() {
					this.target.css({
								'position' : 'absolute',
								'top' : this.top,
								'height' : 0,
								'width' : 0,
								'overflow' : 'hidden'
							});
					this.target.addClass('lui-panel');
					this.target.addClass('lui-panel-transition');
					$('[data-lul-role="body"]').append(this.target);
					this.bindEvent();
				},

				bindEvent : function() {
					var self = this;
					this.target.on('touchstart', self.tsHandler.bind(self));
					this.target.on('touchmove', self.tmHandler.bind(self));
					// 返回
					this.target.on('click', function(evt) {
								var $target = $(evt.target);
								if ($target.hasClass('lui-back-icon'))
									self.slideLeft__();
							});
				},

				tsHandler : function(e) {
					var event = Pda.Util.getTouchEvent(e);
					this.touchStartPoint = Pda.Util
							.getTouchPoint(event.touches);
				},

				tmHandler : function(e) {
					var event = Pda.Util.getTouchEvent(e);
					this.touchEndPoint = Pda.Util.getTouchPoint(event.touches);
					var x = this.touchStartPoint.x, __x = this.touchEndPoint.x;
					var distance = x - __x;
					var y = this.touchStartPoint.y, __y = this.touchEndPoint.y;
					var y_distance = y - __y;
					if (Math.abs(distance) >= this.swipeThreshold
							&& Math.abs(y_distance) <= this.swipeY) {
						if (distance < 0)
							this[this.action + '__']();
					}
				},

				selected : function(evt) {
					this[this.action]();
					if (this.loaded)
						return;
					if (this.url) {
						this.on('reqon', this.reqOn.bind(this));
						this.req(this.url);
					}
				},

				reqOn : function(evt) {
					if (!evt || !evt.txt)
						return;
					this.target.html(evt.txt);
					Pda.init(this.target);
					this.loaded = true;
					// panel渲染完发事件
					this.emit({
								type : 'ready',
								id : this.id
							});
				},

				// 修复 zepto请求html不执行其中script标签的问题
				evalHtml : function(txt) {
					var scripts = $(txt).find('script');
					var rscriptType = /^$|\/(?:java|ecma)script/i;
					for (var i = 0; i < scripts.length; i++) {
						var node = scripts[i];
						if (rscriptType.test(node.type || ""))
							if (node.src)
								this._evalUrl(node.src);
							// 执行scrip标签中的内容，同时zepto中去除所有对script标签内容执行的操作
							else if (!node.type
									|| node.type === 'text/javascript')
								this._evalScript(node.innerHTML);
					}
				},

				_evalScript : function(txt) {
					window['eval'].call(window, txt);
				},

				_evalUrl : function(url) {
					$.ajax({
								url : url,
								type : "GET",
								dataType : "script",
								async : false,
								global : false,
								"throws" : true
							});
				},

				req : function(url) {
					var self = this;
					$.ajax({
								url : url,
								dataType : 'html',
								success : function(txt) {
									self.evalHtml(txt);
									var evt = {
										type : 'reqon',
										txt : txt
									};
									self.emit(evt)
								}
							});
				},

				slideLeft : function() {
					var h = this.clientHeight();
					var w = this.clientWidth();
					var self = this;
					$('[data-lul-role="body"]').css({
								'width' : w,
								'overflow' : 'hidden',
								'height' : h
							});
					this.target.css({
								'width' : w * this.width,
								'height' : h,
								'z-index' : this.index
							});
					this.page.css({
								'height' : h,
								'overflow' : 'auto'
							});

					this.showMask();
					setTimeout(function() {
								self.target.addClass('lui-panel-animate');
								this.active = true;
							}, 100);
				},

				showMask : function() {
					if (this.mask) {
						var markClass = "lui-panel-dismiss";
						if (this.canClose == false)
							markClass = "lui-panel-dismiss-not-hide";
						var mask = $('.' + markClass);
						this.mask = mask.length > 0
								? mask.show()
								: $('<div class="' + markClass + '">')
										.appendTo('body').css('height',
												this.clientHeight());
						this.bindMaskClick(this);
					}
				},

				bindMaskClick : function(self) {
					this.mask.off().on('click', function() {
								self.slideLeft__();
							});
				},

				hideMask : function() {
					if (this.mask)
						this.mask.hide();
				},

				recover : function() {
					$('[data-lul-role="body"]').css({
								'height' : ''
							});
					this.page.css({
								'height' : '',
								'overflow' : 'auto'
							});
				},

				tranEndCallBack : function(recover) {
					recover = recover == false ? false : true;
					var self = this;
					this.target.on('transitionend', function() {
								self.target.css({
											'right' : 0,
											'width' : 0,
											'height' : 0
										});
								if (recover)
									self.recover();
								self.target.off('transitionend');
								// 动画完成后发布事件
								self.emit('transitionend');
							});
				},

				slideLeft__ : function(recover) {
					this.tranEndCallBack(recover);
					var self = this;
					setTimeout(function() {
								self.target.removeClass('lui-panel-animate');
								this.active = false;
							}, 100);
					this.hideMask();
				},

				slide : function(options) {
					switch (options.pos || 'left') {
						case 'left' :
							this.action = 'slideLeft';
							this.right = 9999;
							break;
					}
				},
				destroy : function() {
					this._super();
					if (this.target) {
						this.target.off();
						this.target.remove();
						this.target = null;
					}
				}
			});
}(window);

~~function(win) {
	Pda.Base.Widget.register('category');
	Pda.Category = Pda.Panel.extend({

		init : function(options) {
			this._super(options);
			this.modelName = options.modelName;
			this.mainModelName = options.mainModelName;
			this.href = options.href;
			this.isSelect = options.isSelect ? true : false;
			this.children = [];
			// 当前分类是否有效，用于分类选择权限控制
			this.disable = options.disable;
		},

		startup : function() {
			this._super();
			if (!this.___c__config) {
				var component = this.target.find('[data-lui-role="component"]');
				this.___c__config = Pda.Util.toJSON($(component)
						.find("script[type='text/config']").html());
			}
		},

		draw : function() {
			this._super();
			this.bindClick();
		},

		bindClick : function() {
			var self = this;
			this.target.on('click', function(evt) {
						var $target = $(evt.target);
						// 点击具体分类
						if ($target.hasClass('lui-category-subject')) {
							// 优先缓存中获取
							var fdId = $target.attr('data-lui-id');
							var fdName = $target.text();
							var disable = $target.attr('data-lui-disable');
							var cache = self.getCache(fdId);
							if (cache) {
								cache.slideLeft();
								return;
							}
							var options = {
								parentData : {
									parentId : fdId
								}
							};
							$.extend(options, self.___c__config);
							var sub_com = new Pda.Component(options);
							// 监控是否有筛选项
							var hasFilter = {};
							sub_com.format = function(txt) {
								hasFilter._ = txt.filter;
								if (txt.list)
									return txt;
								else
									return null;
							}
							sub_com.startup();
							sub_com.on('dataoff', function() {
										if (self.isSelect)
											sub_com.emit({
														type : 'dataon',
														data : ''
													});
										else
											self.emitSlide(self, fdId, fdName,
													hasFilter._);
									});
							if (self.isSelect)
								self.buildSub(sub_com, fdId, fdName,
										hasFilter._, disable);
							else
								sub_com.on('dataon', function() {
											self.buildSub(sub_com, fdId,
													fdName, hasFilter._,
													disable);
										});
							sub_com.draw();
						}

						var m = 'data-category-type';
						// 返回
						if ($target.hasClass('lui-back-icon'))
							self.slideLeft__();
						// 文档
						if ($target.attr(m) == 'doc')
							self.buildDoc($target);
						// 确定--用于选择分类
						if ($target.attr(m) == 'ok')
							self.buildOk($target);
					});
		},

		buildOk : function($target) {
			Pda.Topic.emit({
						type : 'category-select-ok',
						id : this.parentId,
						name : this.parentName
					});
			this.slideLeft___();
		},

		buildSub : function(sub_com, fdId, fdName, hasFilter, disable) {
			var sub = new Pda.Category({
						modelName : this.modelName,
						mainModelName : this.mainModelName,
						href : this.href,
						width : this.width,
						isSelect : this.isSelect,
						mask : this.mask,
						canClose : this.canClose,
						disable : disable
					});
			sub.hasFilter = hasFilter ? hasFilter : false;
			sub.___c__config = this.___c__config;
			sub.parent = this;
			sub.parentName = fdName;
			sub.parentId = fdId;
			this.children.push(sub);
			sub_com.parent = sub;
			sub.target.append(sub_com.target);
			sub.startup();
			sub.draw();
			sub.slideLeft();
		},

		bindMaskClick : function(self) {
			this.mask.off().on('click', function() {
						if (self.canClose != false) {
							if (self.isSelect)
								self.slideLeft___();
							else
								self.slideLeft__();
						}
					});
		},

		buildDoc : function() {
			this.emitSlide(this, this.parentId, this.parentName);
		},

		emitSlide : function(claz, cateId, cateName, hasFilter) {
			var self = this;
			Pda.Topic.emit({
						type : 'listChange',
						categoryId : cateId,
						categoryName : cateName,
						target : claz,
						hasFilter : hasFilter ? hasFilter : self.hasFilter
					});
			this.slideLeft___();
		},

		// 点击确定关闭所有分类弹出层
		slideLeft___ : function() {
			var parent = this;
			while (parent) {
				// 所有弹出强制关闭（包括最顶层）
				parent.slideLeft__(true);
				parent = parent.parent;
			}
		},

		getCache : function(fdId) {
			var __ = this.children;
			for (var index = 0; index < __.length; index++) {
				var cate = __[index];
				if (cate['parentId'] && cate['parentId'] == fdId)
					return cate;
			}
			return null;
		},

		destroy : function() {
			if (this.child)
				this.child.destroy();
			this._super();
			if (this.target) {
				this.target.off();
				this.target.remove();
				this.target = null;
			}
		},

		// fire 强制关闭，点击确定时可以关
		slideLeft__ : function(fire) {
			var recover = true;
			if (this.parent) {
				recover = false;
				if (this.isSelect)
					this.parent.bindMaskClick(this.parent);
			} else if (this.canClose == false && !fire)
				// 最顶层分类，canClose为false时不可关闭，fire表示强制关闭，在点击确定时使用
				return;
			this._super(recover);
		},

		hideMask : function() {
			if (this.parent && this.isSelect)
				return;
			this._super();
		},

		buildFilter : function(category, href, fdId, fdName) {
			var filter = this.getFilter(category, href, fdId, fdName);
			filter.slideLeft();
		},

		getFilter : function(category, href, fdId, fdName) {
			var filter = this.getFilterCache(fdId);
			if (filter)
				return filter;
			filter = new Pda.Filter({
						parent : category,
						href : href,
						parentId : fdId,
						parentName : fdName
					});
			filter.startup();
			filter.draw();
			return filter;

		},

		// 根据分类id获取缓存中的属性模板
		getFilterCache : function(cateId) {
			var arr = Pda.Role('filter'), i = 0;
			while (i < arr.length) {
				if (arr[i].__parentId == cateId)
					return arr[i];
				i++;
			}
			return null;
		},

		// 对外方法，供筛选使用
		doFilter : function() {
			Pda.Topic.on('listChange', function(evt) {
				var claz = evt.target, fdId = evt.categoryId, fdName = evt.categoryName;
				claz.buildFilter(claz, claz.href, fdId, fdName);
			});
		}
	});
}(window);
~~function() {

	Pda.Base.Widget.register('filter');
	Pda.Filter = Pda.Category.extend({

		role : 'filter',
		init : function(options) {
			this._super(options);
			this.parent = options.parent;
			this.parentId = options.parentId + 'filter'
			this.__parentId = options.parentId;
			this.parentName = options.parentName;
			this.modelName = this.parent.modelName;
			this.mainModelName = this.parent.mainModelName;
			this.comOptions = options.comOptions || {};
			this.href = options.href;
			this.filterData = {};
		},

		startup : function() {
			this._super();
			var self = this;
			var ___ = {
				source : {
					url : Pda.Util
							.formatUrl('/sys/property/sys_property_filter_pda/sysPropertyFilterPda.do?method=getPropertyFilter&modelName='
									+ self.modelName
									+ '&fdCategoryId='
									+ self.__parentId
									+ '&mainModelName='
									+ self.mainModelName),
					type : 'ajaxJson'
				},
				render : {
					url : Pda.Util
							.formatUrl('/kms/common/pda/core/category/tmpl/filter.jsp')
				},
				lazy : true
			};
			$.extend(___, this.comOptions);
			this.filter = new Pda.Component(___);

			this.target.append(this.filter.target);
			this.filter.parent = this;
			this.child = this.filter;
			this.filter.startup();
		},

		bindClick : function(evt) {
			var self = this;
			self.target.on('click', function(evt) {
						var $target = $(evt.target);
						// 返回
						if ($target.hasClass('lui-back-icon'))
							self.slideLeft__();
						// 构建筛选项
						if ($target.hasClass('lui-filter-item'))
							self.buildItem(evt);

						if ($target.hasClass('lui-category-submit-btn'))
							self.filterSubmit();
					});
		},

		filterSubmit : function() {
			var self = this;
			var data = this.filterData;
			Pda.Topic.emit({
						type : 'listChange',
						data : data,
						categoryId : self.__parentId
					});
			this.slideLeft__();
		},

		draw : function() {
			this._super();
			this.filter.draw();
		},

		buildItem : function(evt) {
			var data = this.filter.__data__;
			if (!data || !data['filters'])
				return;

			var $target_filter = $(evt.target);
			var $prev = $target_filter.prev();
			var fdId = $prev.attr('data-lui-id');
			var fdName = $prev.text();
			$prev = null;
			var arr = [];
			for (var i = 0; i < data['filters'].length; i++) {
				if (fdId == data['filters'][i]['settingId']) {
					arr = data['filters'][i]['options'];
					break;
				}
			}
			var element = new Pda.Component({
				source : {
					data : arr,
					type : 'static'
				},
				render : {
					url : Pda.Util
							.formatUrl('/kms/common/pda/core/category/tmpl/item.jsp')
				}
			});
			element.startup();
			element.draw();

			var dialog = Pda.delement({
						title : fdName,
						element : element.target
					});
			dialog.show();

			var self = this;
			element.target.on('click', function(evt) {
						var $target = $(evt.target);
						if ($target.hasClass('lui-filter-item-subject')) {
							var val = $target.attr('data-lui-id');
							var text = $target.text();
							self.setFilterData(fdId, val);
							$target_filter.html(text);
							dialog.hide();
						}
						$target = null;
					});
		},

		getFilterData : function(key) {
			return this.filterData[key];
		},

		setFilterData : function(key, value) {
			this.filterData[key] = value;
		},

		emptyFilterData : function() {
			this.filterData = {};
		}
	});

	// opts = {modelName:'',action:''}
	Pda.simpleCategoryForNewFile = function(opts) {
		var id = 'category-select-panel';
		if (Pda.Element(id)) {
			// 已经有值，可以关闭
			if (typeof(opts.canClose) != "undefined"
					&& opts.canClose != Pda.Element(id).canColse) {
				Pda.Element(id).canClose = opts.canClose;
				for (var i = 0; i < Pda.Element(id).children.length; i++) {
					Pda.Element(id).children[i].canClose = opts.canClose;
				}
			}
			Pda.Element(id).slideLeft();
			return;
		}
		var modelName = opts.modelName;
		var options = {
			source : {
				url : Com_Parameter.ContextPath
						+ 'kms/common/kms_common_simple_category/KmsCommonSimpleCategory.do?method=list&type=2&modelName='
						+ modelName + '&parentId=!{parentId}',
				type : 'ajaxJson'
			},
			render : {
				url : Com_Parameter.ContextPath
						+ 'kms/common/pda/core/category/tmpl/category_select.jsp'
			},
			lazy : true,
			parent : id
		};

		Pda.Topic.on('category-select-ok', function(evt) {
					opts.action(evt)
				});

		var sub_com = new Pda.Component(options);
		sub_com.startup();
		var sub = new Pda.Category({
					modelName : modelName,
					id : id,
					width : 0.8,
					isSelect : true,
					mask : true,
					canClose : opts.canClose
				});
		sub_com.parent = sub;
		sub.___c__config = options;
		sub.target.append(sub_com.target);
		sub.startup();
		sub.draw();
		sub.slideLeft();
		____pda__cache____[id] = sub;
		sub_com.draw();
	};
}(window);
~~function(win) {
	Pda.Base.Widget.register('fixed');
	Pda.Fixed = Pda.Base.EventClass.extend({

		role : 'fixed',

		init : function(options) {
			this._super(options);
			this.target = $(options.target)
			this.height = this.target.height();
			this.draw();
			this.bindEvent();
		},

		draw : function() {
			this.target.css({
						'position' : 'fixed',
						'z-index' : '1000'
					});
		},

		bindEvent : function() {
			var self = this;
			$(document.body).on('click', function(evt) {
				if ($(evt.target).parents('[data-lui-role="fixed"]').length == 0)
					self.click();
			});
		},

		click : function() {
			var body = document.body;
			var t = this.target;
			if (body.scrollTop > this.height)
				if (t.css('position') == 'fixed')
					t.slideUp('fast', function() {
								t.css({
											'position' : 'absolute',
											'display' : 'block'
										});
							});
				else {
					t.css({
								'position' : 'fixed',
								'display' : 'none'
							});
					t.slideDown('fast');
				}
		}
	})
}(window);

~~function(win) {
	Pda.Base.Widget.register('dialog');
	Pda.Dialog = Pda.Base.EventClass.extend({
				role : 'dialog',
				init : function(options) {
					this._super(options);
				},

				draw : function() {
					// this._super();
				},

				destroy : function() {
					this._super();
					if (this.target) {
						this.target.off();
						this.target.remove();
						this.target = null;
					}
				},

				maskBoxShow : function(className) {
					if (!className)
						className = 'lui-dialog-mask';
					this.mask = $('.' + className);
					if (this.mask && this.mask.length > 0)
						this.mask.show();
					else {
						this.mask = $('<div class="' + className + '"/>');
						$('[data-lul-role="body"]').append(this.mask);
					}
				},
				maskBoxHide : function() {
					if (this.mask && this.mask.length > 0)
						this.mask.hide();
				}
			});

	Pda.DElement = Pda.Dialog.extend({
				init : function(options) {
					this._super();
					if (!options)
						options = {};
					this.title = options.title || '';
					this.canClose = options.canClose || false;
					this.element = options.element ? $(options.element) : null;
				},

				draw : function() {
					this.maskBoxShow();
					this.target = $('<div class="lui-dialog-element">');
					this.titleText = $('<span>');
					// this.close = $('<div>');
					this.titleText.append(this.title);
					this.titleBar = $('<div class="lui-dialog-element-title">');
					this.titleBar.append(this.titleText);
					this.container = $('<div class="lui-dialog-element-container">');
					if (this.element)
						this.container.append(this.element);
					this.target.append(this.titleBar).append(this.container);
					$('[data-lul-role="body"]').append(this.target);
				},

				show : function() {
					this.draw();
					this.target.show();
				},

				hide : function() {
					this.maskBoxHide();
					this.destroy();
				}
			});

	Pda.Loading = Pda.Dialog.extend({

				init : function(options) {
					this._super(options);
				},

				draw : function() {
					this.target = $('<div class="lui-dialog-loading"/>');
					this.maskBoxShow('lui-dialog-mask-loading');
					$('[data-lul-role="body"]').append(this.target);
				},

				hide : function() {
					if (this.target.length > 0)
						this.target.hide();
					this.maskBoxHide()
				},

				show : function() {
					this.target = $('.lui-dialog-loading');
					this.mask = $('.lui-dialog-mask-loading');
					if (this.target && this.target.length > 0) {
						this.target.show();
						this.mask.show();
					} else
						this.draw();
				}
			});
	Pda.loading = function() {
		return new Pda.Loading();
	};

	Pda.delement = function(options) {
		return new Pda.DElement(options);
	};
}(window);

~~function(win) {
	Pda.Base.Widget.register('collapsible');
	Pda.Collapsible = Pda.Base.EventClass.extend({
		role : 'collapsible',
		init : function(options) {
			this._super(options);
			this.target = options.target;
			this.title = options.title || "";
			this.expand = options.expand || false;
			this.childrenContents = [];
			this.group = options.group || "_default_group";
			// 内容是否已经加载
			this.isloaded = false;
			this.expandClass = 'lui-collopsible-expand';
			this.unexpandClass = 'lui-collopsible-unexpand';
			//multi表示是否能与其他小伙伴共存，为true时点击的时候其他小伙伴不会消失
			this.multi = options.multi;
		},

		childrenContents : null,

		startup : function() {
			var self = this;
			this.target.find('[data-lui-role=component]').each(function() {
						var child = Pda.Element(this.id);
						if (child)
							self.childrenContents.push(child);
					});
			self.on("groupon", function(evt) {
						// var self = this;
						if (!evt || !evt.target || evt.target === self)
							return;
						var length = self.childrenContents.length;
						if (self.target.hasClass(self.expandClass)) {
							for (var i = 0; i < length; i++) {
								self.childrenContents[i].target.hide();
							}
							self.target.removeClass(self.expandClass);
							self.target.addClass(self.unexpandClass);
						}
					});
		},

		// 参数为是否强制draw
		_drawChildren : function(isControl) {
			var length = this.childrenContents.length;
			if (isControl ? true : this.expand) {
				for (var i = 0; i < length; i++) {
					this.childrenContents[i].draw();
				}
				this.isloaded = true;
				this.target.removeClass(this.unexpandClass);
				this.target.addClass(this.expandClass);
			}
		},

		draw : function() {
			this.target.addClass('lui-collopsible ' + this.unexpandClass);
			this.target
					.prepend('<a href="javascript:;" class="lui-collopsible-head">'
							+ this.title + '</div>');
			this.bindEvent();
		},

		bindEvent : function() {
			var self = this;
			self.target.find('.lui-collopsible-head').on('click',
					self._toggleContent.bind(self));
		},

		_toggleContent : function() {
			var self = this, ele = self.target;
			if (!this.multi)
				self.emitGroup("groupon");
			if (!self.isloaded) {
				self._drawChildren(true);
			} else {
				var arr = this.childrenContents, length = arr.length, i = 0;
				if (ele.hasClass(self.expandClass)) {
					for (; i < length; i++) {
						arr[i].target.hide();
					}
					ele.removeClass(self.expandClass);
					ele.addClass(self.unexpandClass);
				} else {
					for (; i < length; i++) {
						arr[i].target.show();
					}
					ele.removeClass(self.unexpandClass);
					ele.addClass(self.expandClass);
				}
			}
		},

		selected : function() {
			this._drawChildren(false);
		}

	});
}(window);

~~function(win) {
	Pda.Base.Widget.register('button');
	Pda.Button = Pda.Base.EventClass.extend({

				role : 'button',

				init : function(options) {
					this._super(options);
					this.target = $(options.target);
					this.currentClass = options.currentClass;
					this.toggleClass = options.toggleClass;
					this.onclick = options.onclick;
					this.group = options.group;
					this.text = options.text;
					this.selected = options.selected || false;
					this.enable = options.enable === false ? false : true;
				},

				draw : function() {
					this.addClass(this.currentClass);
					if (this.text)
						this.innerText(this.text);
					if (this.selected)
						this.addClass(this.toggleClass);
					this.bindClick(this.triggleClick.bind(this));
				},

				innerText : function(text) {
					this.target.html(text);
				},

				addClass : function(className) {
					this.target.addClass(className);
					return this.target;
				},

				removeClass : function(className) {
					this.target.removeClass(className);
					return this.target;
				},

				startup : function() {
					var self = this;
					this.on('groupon', function(evt) {
								if (!evt || !evt.target)
									return;

								self.selected = false;
								if (self.toggleClass)
									self.removeClass(self.toggleClass);
								if (evt.target === self) {
									self.addClass(self.toggleClass);
									self.selected = true;
								}
							})
				},

				triggleClick : function() {
					if (this.enable) {
						new Function(this.onclick).apply(this);
						this.emitGroup("groupon");
					}
				},

				bindClick : function(click) {
					var self = this;
					self.target.off('click').on('click', function(e) {
								click(e);
							});
					return self.target;
				},

				disabled : function() {
					this.enable = false;
				},

				enabled : function() {
					this.enable = true;
				}

			})
}(window);
