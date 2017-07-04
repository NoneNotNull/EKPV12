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
