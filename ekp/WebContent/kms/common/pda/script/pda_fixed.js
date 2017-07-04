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
