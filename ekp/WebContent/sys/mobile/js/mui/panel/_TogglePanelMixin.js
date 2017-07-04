define(
		"mui/panel/_TogglePanelMixin",
		[ "dojo/dom-construct", 'dojo/_base/declare', "dojo/dom-style",
				"dojo/topic", "dojo/_base/lang" ],
		function(domConstruct, declare, domStyle, topic, lang) {
			return declare(
					'mui.panel._TogglePanelMixin',
					null,
					{

						toggle : true,

						startup : function() {
							this.inherited(arguments);
							if (this.toggle)
								this.bindTitleClick();
						},

						// 绑定标题点击事件
						bindTitleClick : function() {
							this
									.connect(
											this.domNode,
											"onclick",
											function(evt) {
												var target = evt.target;
												for (var i = 0; i < this.titleList.length; i++) {
													if (target.tagName == 'DIV')
														if (target
																&& target.parentNode == this.titleList[i]) {
															var content = this.contentList[i];
															var claz = content.claz;
															if (content.show) {
																claz.hide();
																content.show = false;
															} else {
																claz.show();
																content.show = true;
															}
														}
												}
											});
						}
					});
		});