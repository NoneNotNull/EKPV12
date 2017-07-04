define(function(require, exports, module) {
	var $ = require("lui/jquery");
	var base = require("lui/base");
	var overlay = require("lui/overlay");

	var Mask = overlay.DefaultActor
			.extend({
				initProps : function(_config) {
					this.config = _config;
					this.maskIndex = LUI.zindex();
					this.maskBg = '#fff';
					this.maskOpacity = .6;
					this.$window = $(_config.elem || window);
					this.lock = _config.lock;
					this.animate = typeof (_config.animate) != 'undefined' ? _config.animate && true
							: true;
				},

				// 遮罩层
				maskBox : function() {
					var $mask = this.mask = $($(document.body)[0]
							.appendChild(document.createElement('div')));
					var ww = this.$window.width(), wh = this.$window.height();
					var off = this.$window.offset();

					var ot = 0, ol = 0;
					var _p = 'fixed';
					if (off) {
						_p = 'absolute';
						ot = off.top, ol = off.left;
						var st = $(window).scrollTop();
						wh = $(window).height() - (ot - st);
					}

					$mask.css({
						'top' : wh / 2,
						'left' : ww / 2,
						'width' : 0,
						'height' : 0,
						'position' : _p,
						'z-index' : this.maskIndex,
						'background-color' : this.maskBg,
						'opacity' : 0
					});
					// iframe没有部分事件如onclick，导致遮罩层触发部分事件无法实现
					$mask
							.append("<div style='width:100%;height:100%;position:absolute;z-index:2'>");
					$mask
							.append("<iframe frameborder='0' style='width:100%;height:100%;position:absolute;z-index:1'></iframe>");
					var cssSource = this.getCssSource();
					if (this.animate) {
						$mask.animate(cssSource, 10);
					} else {
						$mask.css(cssSource);
					}

					var self = this;
					$(window).bind('scroll', {
						mask : self
					}, this.maskScroll);

					$(window).bind('resize', {
						mask : self
					}, this.maskResize);
				},

				getCssSource : function() {
					var ww = this.$window.width(), wh = this.$window.height();
					var off = this.$window.offset();
					var ot = 0, ol = 0;
					if (off) {
						ot = off.top, ol = off.left;
						var st = $(window).scrollTop();
						wh = $(window).height() - (ot - st);
						if (wh > this.$window.height())
							wh = this.$window.height();
					}

					var cssSource = {
						'top' : ot,
						'left' : ol,
						'width' : ww,
						'height' : wh,
						'opacity' : this.maskOpacity
					};
					return cssSource;
				},

				maskResize : function(evt) {
					var self = evt.data.mask;
					var cssSource = self.getCssSource();
					self.mask.css(cssSource);
				},

				// 窗口位置自适应
				maskScroll : function(evt) {
					var self = evt.data.mask;
					var cssSource = self.getCssSource();
					self.mask.css(cssSource);
				},
				maskHide : function() {
					if (this.mask) {
						this.mask.remove();
						this.mask = null;
						$(window).unbind('scroll', this.maskScroll);
						$(window).unbind('resize', this.maskResize);
					}
				}
			});

	var Default = Mask.extend({
		initProps : function($super, _config) {
			$super(_config);
			this.cache = this.config.cache;
			this.dialogIndex = this.maskIndex + 1;
			this.dialog = this.config.dialog;
		},
		// 监听事件提前，防止content事件触发比监听先
		startup : function($super) {
			$super();
			var self = this;
			if (!this.cache || !this.dialog.isDrawed)
				this.dialog.content.on('layoutDone', function() {
					setTimeout(function(){
						var pos = self.overlay.getPosition();
						var scrollTop = 0;
						// 兼容恶心ie
						if (document.documentMode != null)
							scrollTop = $('body').parent().scrollTop();
						else
							scrollTop = Math.max($('html').scrollTop(),$('body').scrollTop());
						self.overlay.getContent().css({
							'left' : pos.left,
							'top' : pos.top + scrollTop,
							'z-index' : this.dialogIndex,
							'overflow' : 'hidden'
						}).show();
						self.dialog.emit('show');
					},0);
				})
		},

		show : function() {
			var self = this;
			// 随窗口重新定位
			$(window).bind('resize', {
				'default' : self
			}, self.resize);
			if (this.lock) {
				this.maskBox();
			}
			var content = this.overlay.getContent();
			// 更改为绝对定位，拖拽使用
			content.css({
				'z-index' : this.dialogIndex,
				'overflow' : 'hidden',
				'position' : 'absolute'
			});
			if (this.cache && this.dialog.isDrawed)
				self.overlay.getContent().show();
			this.hideScroll();
		},

		hide : function() {
			$(window).unbind('resize', this.resize);

			// 遮罩层清除
			this.maskHide();
			// 定时器清除
			if (this.timer) {
				clearTimeout(this.timer);
			}
			// 弹出框清除
			if (!this.cache) {
				this.dialog.destroy();
				this.overlay.destroy();
			} else {
				this.overlay.getContent().hide();
			}
			this.showScroll();
		},

		// 窗口位置自适应
		resize : function(evt) {
			var self = evt.data['default'];
			var pos = self.overlay.getPosition();
			self.overlay.getContent().css({
				'left' : pos.left,
				'top' : pos.top
			});
		},

		/***********************************************************************
		 * 弹出框时候屏蔽滚动
		 **********************************************************************/
		hideScroll : function() {
			$('body').css({
				'overflow' : 'hidden',
				'height' : this.overlay.position.getClientHeight() + 'px'
			});
		},

		showScroll : function() {
			$('body').css({
				'overflow' : 'auto',
				'height' : 'auto'
			});
		}

	});

	var Loading = Mask.extend({
		initProps : function($super, _config) {
			$super(_config);
			this.drawed = false;
			this.cache = this.config.cache;
			this.dialogIndex = this.maskIndex + 1;
			this.dialog = this.config.dialog;
		},

		startup : function($super) {
			$super();
			var self = this;
			if (!this.cache || !this.dialog.isDrawed)
				this.dialog.content.on('layoutDone', function() {
					var pos = self.overlay.getPosition();
					self.overlay.getContent().css({
						'left' : pos.left,
						'top' : pos.top,
						'z-index' : this.dialogIndex,
						'overflow' : 'hidden'
					}).show();
					self.drawed = true;
					self.dialog.emit('show');
				});
		},

		show : function() {
			var self = this;
			$(window).bind('resize', {
				loading : self
			}, self.resize);
			$(window).bind('scroll', {
				loading : self
			}, self.scroll);
			if (this.lock) {
				this.maskBox();
			}
			var _p = 'absolute';
			if (!this.dialog.elem) {
				_p = "fixed";
			}
			var content = this.overlay.getContent();
			content.css({
				'z-index' : this.dialogIndex,
				'overflow' : 'hidden',
				'position' : _p
			});
			if (this.cache && this.dialog.isDrawed)
				self.overlay.getContent().show();
		},

		hide : function() {
			var self = this;
			if (this.drawed) {
				$(window).unbind('resize', self.resize);
				$(window).unbind('scroll', self.scroll);
				// 遮罩层清除
				this.maskHide();
				// 定时器清除
				if (this.timer) {
					clearTimeout(this.timer);
				}
				// 弹出框清除
				if (!this.cache) {
					this.dialog.destroy();
					this.overlay.destroy();
				} else {
					this.overlay.getContent().hide();
				}

			} else {
				setTimeout(function() {
					self.hide();
				}, 100);
			}

		},

		position : function(self) {
			var pos = self.overlay.getPosition();
			self.overlay.getContent().css({
				'left' : pos.left,
				'top' : pos.top
			})

		},

		// 滚动位置自适应
		scroll : function(evt) {
			var self = evt.data.loading;
			self.position(self);
		},

		// 窗口位置自适应
		resize : function(evt) {
			var self = evt.data.loading;
			self.position(self);
		}
	});

	var Slide = Mask.extend({
		initProps : function($super, _config) {
			$super(_config);
			this.cache = this.config.cache;
			this.dialog = this.config.dialog;
			this.dialogIndex = this.maskIndex + 1;
		},

		startup : function($super) {
			$super();
			var _p = 'absolute';
			if (!this.dialog.elem) {
				_p = "fixed";
			}
			var self = this;
			this.dialog.content.on('layoutDone', function() {
				var content = self.overlay.getContent();

				var pos = self.overlay.getPosition();
				content.css({
					'overflow' : 'hidden',
					'position' : _p,
					'top' : pos.top,
					'left' : pos.left,
					'z-index' : self.dialogIndex
				}).show();
				var height = content.height() > 0 ? content.height()
						: self.dialog.height;
				content.animate({
					height : height
				});

				self.dialog.emit('show');
			});
		},

		show : function() {
			var self = this;
			$(window).bind('resize', {
				silde : self
			}, self.resize);
			$(window).bind('scroll', {
				silde : self
			}, self.scroll);

			if (this.lock) {
				this.maskBox();
			}
			var content = this.overlay.getContent();
			$(document.body).append(content);

		},

		position : function(self) {
			var pos = self.overlay.getPosition();
			self.overlay.getContent().css({
				'left' : pos.left,
				'top' : pos.top
			});

		},

		// 滚动位置自适应
		scroll : function(evt) {
			var self = evt.data.silde;
			self.position(self);
		},

		// 窗口位置自适应
		resize : function(evt) {
			var self = evt.data.silde;
			self.position(self);
		},

		hide : function() {
			// 弹出框清除
			var self = this;
			this.overlay.getContent().animate({
				height : 0
			}, function() {
				if (!self.cache) {
					self.dialog.destroy();
					self.overlay.destroy();
				}
				self.maskHide();
				$(window).unbind('resize', self.resize);
				$(window).unbind('scroll', self.scroll);
			});
		}
	});

	exports.Default = Default;
	exports.Slide = Slide;
	exports.Loading = Loading;
});