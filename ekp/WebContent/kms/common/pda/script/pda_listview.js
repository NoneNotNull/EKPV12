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
				'height' : h - 40
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