define(
		"mui/nav/NavBar",
		[ "dojo/dom-construct", 'dojo/_base/declare', "dojo/dom-class",
				"dojox/mobile/_ScrollableMixin", "dojo/dom-style",
				"dojo/topic", "dojo/_base/lang", "dijit/_WidgetBase",
				"dijit/_Contained", "dijit/_Container",
				"dojox/mobile/SwapView", "dojo/_base/array",
				"mui/nav/_ShareNavBarMixin" ],
		function(domConstruct, declare, domClass, ScrollableMixin, domStyle,
				topic, lang, WidgetBase, Contained, Container, SwapView, array,
				_ShareNavBarMixin) {
			var cls = declare(
					'mui.nav.NavBar',
					[ WidgetBase, Contained, Container, ScrollableMixin,
							_ShareNavBarMixin ],
					{

						scrollDir : "h",

						curIndex : 0,

						lastIndex : 0,

						height : 'inherit',

						width : '100%',

						// 不显示滚动条
						scrollBar : false,

						buildRendering : function() {
							this.inherited(arguments);
							domClass.add(this.domNode, "mblScrollableView");
							domClass.add(this.domNode, "muiNavbar");
							domStyle.set(this.domNode, {
								overflow : 'hidden',
								top : 0
							});
							// 外围容器，滚动需要该特定名对象
							this.containerNode = domConstruct.create("ul", {
								className : "muiNavbarContainer"
							}, this.domNode);
							// 选中区域
							this.selectedNode = domConstruct.create('div', {
								className : 'muiNavbarSelected'
							}, this.domNode);
							// 监听item改变事件
							this.subscribe('/mui/navitem/_selected',
									'handleItemChanged');
						},

						handleItemChanged : function(srcObj, evt) {
							var children = this.getChildren(), child = evt.target;
							var index = this.getIndexOfChild(child);

							if (index > -1) {
								// 上一次点击索引
								this.lastIndex = this.curIndex;
								// 这次点击索引
								this.curIndex = index;

								var idx = this.curIndex - this.lastIndex;
								var dim = this._dim || this.getDim(), x = 0, scroll = false;
								if (idx > 0) {// 往后点
									var len = children.length;
									if (len - index >= 2) {
										var domNode_next = children[index + 1].domNode;
										x = -domNode_next.offsetLeft
												+ (dim.v.w - domNode_next.offsetWidth);
										if (x < 0)
											scroll = true;
									} else {
										x = -(this.containerNode.offsetWidth - this.domNode.offsetWidth);
										scroll = true;
									}

								} else if (idx < 0) {// 往前点
									if (index >= 1) {
										var domNode_next = children[index - 1].domNode;
										x = -domNode_next.offsetLeft;
										if (x > -dim.c.w
												&& x > -(dim.c.w - dim.v.w))
											scroll = true;
									} else {
										x = 0;
										scroll = true;
									}
								}
								evt = this.formatEvt(evt);
								if (scroll) {
									this.slideEvt = evt;
									this.slideTo({
										x : x
									}, 0.3, "ease-out");
								} else
									this
											.selectedNodeChange(evt);

							}
						},

						// 格式化参数，用于做最大宽限制
						formatEvt : function(evt) {
							var m_width = domStyle.get(this.selectedNode,
									'max-width'), width = evt.width;
							if (width > m_width)
								evt.left = evt.left + (width - m_width) / 2;
							return evt;
						},

						selectedNodeChange : function(evt) {
							domStyle.set(this.selectedNode, {
								width : evt.width + 'px',
								'-webkit-transform' : 'translate3d(' + evt.left
										+ 'px, 0px, 0px)'
							});
						},

						slideTo : function() {
							this.inherited(arguments);
							if (this.slideEvt) {
								this.selectedNodeChange(this.slideEvt);
								this.slideEvt = null;
							}
						},

						_setWidthAttr : function(width) {
							this.width = width;
						},

						startup : function() {
							if (this._started)
								return;
							this.reparent();
							this.inherited(arguments);
							if (this.height == "inherit") {
								if (this.domNode.parentNode) {
									h = this.domNode.parentNode.style.height;
									this.height = h;
								}
							} else if (this.height) {
								h = this.height;
							}
							if (h && h != '') {
								var styleVar = {
									'height' : h,
									'line-height' : h
								};
								domStyle.set(this.domNode, styleVar);
								if (this.domNode != this.containerNode) {
									domStyle.set(this.containerNode, styleVar);
								}
							}
						},

						// 移动内容到相应位置
						reparent : function() {
							var i, idx, len, c;
							for (i = 0, idx = 0,
									len = this.domNode.childNodes.length; i < len; i++) {
								c = this.domNode.childNodes[idx];
								if (c === this.containerNode) {
									idx++;
									continue;
								}
								this.containerNode.appendChild(this.domNode
										.removeChild(c));
							}
						}
					});
			return cls;
		});