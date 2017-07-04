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
