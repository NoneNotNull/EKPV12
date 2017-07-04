define(function(require, exports, module) {
			var $ = require("lui/jquery");
			var base = require("lui/base");
			var toolbar = require('lui/toolbar');

			// 回到顶部
			var totop = base.Component.extend({
						initialize : function($super, config) {
							$super(config);
						},
						initProps : function(_config) {
							var self = this;
							this.element.addClass("com_goto");

							// this.b = this.element.css("bottom");

							this.____display = $('<div />');
							$(window).bind({
										"scroll" : function() {
											self.isShow();
										},
										"resize" : function() {
											self.isShow();
										}
									});
						},
						startup : function() {
						},
						isShow : function() {
							var self = this;
							if ($("html").scrollTop() > 30
									|| $("body").scrollTop() > 30) {
								if (!$("html,body").is(":animated")) {
									if (self.gototop.css('visibility') != 'visible') {
										self.gototop.stop();
										self.__btnShow();
										self.gototop.css({
													"visibility" : "visible",
													"opacity" : 0,
													'cursor' : 'pointer'
												});
										self.gototop.animate({
													"opacity" : 1,
													"bottom" : 0
												});
										self.emit('top.status', {
													status : 'show'
												})

									}
								} else {
									// 动画中
									// $(document.body).stop();
								}
							} else {
								self.gototop.stop();
								// self.gototop.fadeOut(180);
								self.gototop.animate({
											"opacity" : 0,
											'visibility' : 'hidden'
										}, function() {
											self.gototop.css({
														'visibility' : 'hidden',
														'opacity' : 1,
														'cursor' : ''
													});
										});
								self.__btnHide();
								self.emit('top.status', {
											status : 'hide'
										})
							}
						},
						addChild : function($super, obj) {
							$super(obj);
						},
						draw : function($super) {
							if (this.isDrawed)
								return;

							var self = this;
							if (this.children.length > 0)
								this.children = this.children.sort(function(
												oneBtn, twoBtn) {
											return twoBtn.weight
													- oneBtn.weight;
										});

							this.___display = [];
							this.___hide = [];
							for (var k = 0; k < this.children.length; k++) {
								var __child = this.children[k];
								if (__child.config.display)
									this.___display.push(__child);
								else
									this.___hide.push(__child);
								__child.setParentNode(this.element);
								__child.draw();
							}
							this.gototop = $('<div class="com_gototop"/>');
							this.element.append(this.gototop);
							this.gototop.click(function() {
										self.gototop.animate({
													"opacity" : 0,
													"bottom" : 200
												}, 200, function() {
													$("html,body").animate({
																scrollTop : 0
															}, 400, function() {
																$("html,body")
																		.scrollTop(0);
															});
												});
									});

							if ($("html").scrollTop() > 0
									|| $("body").scrollTop() > 0)
								this.element.show();
							else {
								this.gototop.css({
											'visibility' : 'hidden',
											'cursor' : ''
										});
								this.__btnHide();
							}
							this.element.show();
							this.isDrawed = true;
							return this;
						},

						addButton : function(btn) {
							if (btn instanceof toolbar.AbstractButton) {
								this.addChild(btn);
								this.children = this.children.sort(function(
												oneBtn, twoBtn) {
											return twoBtn.weight
													- oneBtn.weight;
										});
								for (var k = 0; k < this.children.length; k++) {
									var __child = this.children[k];
									this.gototop.before(__child.element);
									__child.draw();
								}
							}
						},
						__btnHide : function() {
							for (var j = 0; j < this.___hide.length; j++) {
								this.___hide[j].element.css({
											'visibility' : 'hidden',
											'cursor' : ''
										});
							}
						},
						__btnShow : function() {
							for (var j = 0; j < this.___hide.length; j++) {
								this.___hide[j].element.css({
											'visibility' : 'visible',
											'cursor' : 'pointer'
										});
							}
						}

					});

			module.exports.totop = totop;
		});
