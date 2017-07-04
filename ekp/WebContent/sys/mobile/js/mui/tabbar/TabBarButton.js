define(	["dojo/_base/declare", "dojox/mobile/TabBarButton", "dojo/dom-class",
				"dojo/dom-style", "dojox/mobile/Badge", "mui/util",
				"dojo/_base/lang"], function(declare, TabBarButton, domClass,
				domStyle, Badge, util, lang) {

			return declare("mui.tabbar.TabBarButton", [TabBarButton], {
						inheritParams : function() {
							this.inherited(arguments);
							// 修复疑似dojo重复绘制icon缺陷
							return !!this.getParent();
						},
						
						transition:"slide",
						
						colSize: 1,

						href : null,

						align : 'center',
						
						tabIndex : '',

						_setAlignAttr : function(align) {
							this.align = align;
						},

						buildRendering : function() {
							this.inherited(arguments);
							if (!this.label && this.getParent() != null)
								domClass.add(this.getParent().domNode,
										'muiNavBarButton');
						},

						startup : function() {
							if (this._started)
								return;

							if (this.align != 'center')
								domStyle.set(this.iconDivNode, {
											"float" : this.align
										});
							if (this.iconDivNode) {
								domClass.add(this.iconDivNode, 'mui-scale');
								this.defer(lang.hitch(this, function() {
													domClass.remove(
															this.iconDivNode,
															'mui-scale');
												}), 500);
							}
							this.inherited(arguments);
						},

						// 重写数字结构
						_setBadgeAttr : function(value) {
							if (!this.badgeObj) {
								this.badgeObj = new Badge();
								domStyle.set(this.badgeObj.domNode, {
											position : 'absolute',
											left : '80%',
											top : '2px'
										});
							}
							// 出现三位数字显示为99+
							if (parseInt(value) >= 100)
								this.value = value = '99+';
							this.badgeObj.setValue(value);
							if (value) {
								this.iconDivNode
										.appendChild(this.badgeObj.domNode);
							} else {
								if (this.domNode === this.badgeObj.domNode.parentNode) {
									this.domNode
											.removeChild(this.badgeObj.domNode);
								}
							}
						},

						onClick : function() {
							if (this.href) {
								location.href = util.formatUrl(this.href);
								return false;
							}
							this.inherited(arguments);
						}

					});
		});