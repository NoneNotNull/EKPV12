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
					this.canClose = options.canClose = 'true' ? true : false;
					this.element = options.element ? $(options.element) : null;
				},

				draw : function() {
					var self = this;
					this.maskBoxShow();
					this.target = $('<div class="lui-dialog-element">');
					this.titleText = $('<span>');
					// this.close = $('<div>');
					this.titleText.append(this.title);
					this.titleBar = $('<div class="lui-dialog-element-title">');
					this.titleBar.append(this.titleText);
					if (this.canClose) {
						this.closeDiv = $('<span class="close">').on('click',
								function() {
									self.hide();
								});
						this.titleBar.append(this.closeDiv);
					}
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
