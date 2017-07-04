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
