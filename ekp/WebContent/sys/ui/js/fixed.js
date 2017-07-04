define(function(require, exports, module) {
	var $ = require("lui/jquery");
	var base = require("lui/base");

	var Fixed = base.Component.extend({

		initProps : function($super, cfg) {
			$super(cfg);
			this.__obj = $(this.config.elem);
			this.__content = $(this.config.content);
			this.___objCss = {};
		},

		startup : function() {
		},

		addChild : function($super, obj) {
			$super(obj);
		},

		beingFixed : function() {
			if (!this._top)
				this._top = this.__obj.position().top;

			if (this.tmpl && this.tmpl.position().top > 0) {
				this._top = this.tmpl.position().top;
				this.__obj.css('left', +this.tmpl.position().left
								- $(window).scrollLeft());
			}

			if (!this.__bottom)
				this.__bottom = this.__content.position().top
						+ this.__content.outerHeight();

			if ($(document).scrollTop() >= this._top
					&& $(document).scrollTop() <= this.__bottom) {
				if (this.__obj.css('position') == 'fixed')
					return;
				if (!this.tmpl)
					this.tmpl = this.__obj.clone();
				this.__obj.before(this.tmpl);
				this.___objCss = {
					'width' : '',
					'position' : this.__obj.css('position'),
					'top' : this.__obj.css('top'),
					'left' : this.__obj.css('left'),
					'z-index' : this.__obj.css('z-index')
				};

				this.__obj.css({
							'width' : this.__obj.width(),
							'position' : 'fixed',
							'top' : 0,
							'left' : this.__obj.position().left,
							'z-index' : 8
						});

			} else {
				if (this.__obj.css('position') == '')
					return;
				if (this.tmpl && this.tmpl.length > 0) {
					this.tmpl.remove();
					this.__obj.css(this.___objCss);
				}
			}
		},

		bindScroll : function() {
			var self = this;
			$(window).bind("scroll", function() {
				self.beingFixed();
			});
			if (document.body.attachEvent) {
				// ie8浏览器body高度发生变化不处罚body的resize事件
				if (document.documentMode && document.documentMode < 9)
					window.onresize = function() {
						// 延迟一毫米用于终极状态的位置判断
						setTimeout(function() {
							self.beingFixed();
						},1);
					};
				else
					document.body.attachEvent('onresize', function() {
						// 延迟一毫米用于终极状态的位置判断
						setTimeout(function() {
							self.beingResize();
						}, 1);
					});

			} else
				$(window).bind("resize", function() {
					self.beingResize();
				});
		},

		beingResize : function() {
			this.beingFixed();
			if (this.tmpl && this.tmpl.length > 0 && this.tmpl.innerWidth() > 0) {
				this.___objCss.width = this.tmpl.css('width');
				this.__obj.css({
							'width' : this.___objCss.width,
							'left' : this.tmpl.position().left
									- $(window).scrollLeft()
						});
			}
		},

		draw : function($super) {
			if (this.isDrawed)
				return;

			if (this.__obj.length == 0)
				return;

			if (this.__content.length == 0)
				this.__bottom = 10000;
			this.bindScroll();
			this.onErase(function() {
						$(window).unbind('scroll');
					})
			this.isDrawed = true;
			return this;
		}

	})

	exports.Fixed = Fixed;

})
