~~function(win, $) {
	Pda.Base.Widget.register('expertGrid');
	Pda.ExpertGrid = Pda.Column.extend({
				padding : 0,

				swipeThreshold : 5,

				swipeY : 20,

				currentY : 0,

				startup : function() {
					this._super();
					this.container
							.css('padding-left', 80 * this.rate2 / 2 + 15);
					var self = this;
					// 监听加载完事件，用于重置当前孩子节点对象
					this.on('loaded', function() {
								self.__children = self.container
										.find('.lui-expert-grid');
								self.scale(self.__children[self.index]);
							});
				},

				onTm : function() {
					this.__draw();
				},

				slided : false,

				tsHandler : function(e) {
					e.preventDefault();
					e.stopPropagation();
					this.moved = false;
					var event = Pda.Util.getTouchEvent(e);
					this.touchStartPoint = Pda.Util
							.getTouchPoint(event.touches);
					this.start = Pda.Util.getTouchPoint(event.touches);
				},

				tmHandler : function(e) {
					e.preventDefault();
					e.stopPropagation();
					this.moved = true;
					var event = Pda.Util.getTouchEvent(e);
					this.touchStartPoint = Pda.Util
							.getTouchPoint(event.touches);
				},

				teHandler : function(e) {
					e.preventDefault();
					e.stopPropagation();
					var distance = this.touchStartPoint.x - this.start.x;
					if (Math.abs(distance) >= this.swipeThreshold)
						if (distance < 0)
							this.slideLeft();
						else
							this.slideRight();
					if (!this.moved)
						this.__click(e);
				},

				currentX : 0,

				index : 0,

				_3dChange : function(x) {
					return {
						'-webkit-transform' : 'translate3d(' + x + ', 0, 0)',
						'-moz-transform' : 'translate3d(' + x + ', 0, 0)',
						'transform' : 'translate3d(' + x + ', 0, 0)'
					}
				},

				rate1 : 0.75,

				rate2 : 0.9,

				slideDistance : function() {
					return this.clientWidth() - 80 - 30;
				},

				slideLeft : function() {
					var children = this.__children, len = children.length;
					if (this.index + 2 >= len)
						this.onTm();
					if ((this.index + 1) >= len)
						return;
					this.index = this.index + 1;
					this.slide(-this.slideDistance() * this.index);
				},

				slideRight : function() {
					if (this.index == 0) {
						this.parent.slideRight();
						return;
					}
					this.index = this.index - 1;
					this.slide(-this.slideDistance() * this.index);
				},

				// 滑动
				slide : function(x) {
					var self = this;
					this.slided = true;
					this.container.css(this._3dChange(x + 'px'));
					this.container.on('transitionend', function() {
								self.slided = false;
								self.container.off('transitionend');
							});
					this.scale(this.__children[this.index]);
				},

				// 放大缩小
				scale : function(current) {
					this.__children.removeClass('current');
					$(current).addClass('current');
				},

				change : function() {
					this.index = 0;
					if (!this.__children || this.__children.length == 0)
						return;
					this.slide(this.index);
				}
			})
}(window, $);