define(
		[ "dojo/_base/declare", "dojo/_base/array",
				"dojox/mobile/ScrollableView", "dojo/dom-construct",
				"dojo/dom-class", "mui/util", "dojo/dom-style",
				"dojox/mobile/_css3", "dojo/dom-attr", "dojo/topic",
				"dojo/request", "dojo/_base/lang", "dojo/touch" ],
		function(declare, array, ScrollableView, domConstruct, domClass, util,
				domStyle, css3, domAttr, topic, request, lang, touch) {

			return declare(
					"mui.panel.SlidePanel",
					[ ScrollableView ],
					{
						// 数据源
						store : [],

						// 相关view
						relView : null,

						dir : 'left',

						width : '170',

						templateUrl : null,
						sourceUrl : null,

						icon : null,

						swipeThreshold : 100,

						SLIDE_PANEL_CLICK : '/mui/panel/slide/click',

						startup : function() {
							if (this._started)
								return;

							this.navNodes = [];
							var defaultIcon = this.icon;
							array.forEach(this.store, function(item, index) {
								var icon = item.icon;
								if (!icon) {
									icon = defaultIcon;
								}
								icon = icon ? '<span class="mui ' + icon
										+ '"></span>' : '';
								var className = "muiSlidePanelCatalog";
								if (item.selected == true)
									className += " selected";
								domConstruct.create('div', {
									className : className,
									innerHTML : icon + '<div>' + item.text
											+ '</div>',
									title : item.text,
									'data-mui-index' : index
								}, this.containerNode);
							}, this);

							this.customRender();

							var tmpWidth = "100%";
							if (this.width) {
								tmpWidth = this.width;
							}
							if (tmpWidth.toString().indexOf("%") > -1) {
								tmpWidth = tmpWidth;
							} else {
								tmpWidth = tmpWidth + 'px';
							}
							domStyle.set(this.domNode, {
								width : tmpWidth
							});
							domClass.add(this.domNode, 'muiSlidePanel '
									+ this.dir);
							this.inherited(arguments);
							this.play();
							this._started = true;
						},

						customRender : function() {
							var self = this;
							if (!this.sourceUrl || !this.templateUrl)
								return;

							request
									.post(util.formatUrl(this.sourceUrl))
									.then(
											function(data) {
												if (!data)
													return;
												var store = (new Function(
														"return (" + data
																+ ");"))();
												request
														.post(
																util
																		.formatUrl(self.templateUrl))
														.then(
																function(_data) {
																	var html = "";
																	array
																			.forEach(
																					store,
																					function(
																							item) {
																						html += lang
																								.replace(
																										_data,
																										item);
																					});
																	domConstruct
																			.place(
																					domConstruct
																							.toDom(html),
																					self.containerNode,
																					'last');
																});
											});
						},

						transformKey : css3.name('transform'),

						play : function() {
							this.domNode.style['display'] = 'block';
							this.domNode.style['height'] = util.getScreenSize().h
									+ 'px';
							this.overlayNode = domConstruct.create('div', {
								className : 'muiPanelOverlay'
							}, document.body);
							domConstruct.place(this.domNode, this.overlayNode,
									'last');
							this
									.defer(
											function() {
												this.domNode.style[this.transformKey] = 'translate3d(0, 0, 0)';
											}, 1);

							this.connect(this.overlayNode, 'click', 'onClose');
							this.connect(this.overlayNode, touch.press,
									'onPress');
							this.connect(this.overlayNode, touch.release,
									'onRelease');
							this
									.connect(this.overlayNode, touch.move,
											'onMove');
							if (this.store)
								this.connect(this.domNode, 'click',
										'onNavClick');
						},

						onNavClick : function(evt) {
							var target = evt.target;
							while (target) {
								var index = domAttr.get(target,
										'data-mui-index');
								if (index) {
									topic.publish(this.SLIDE_PANEL_CLICK, this,
											{
												index : index,
												title : domAttr.get(target,
														'title')
											});
									this.onClose();
									break;
								}
								target = target.parentNode;
							}
						},

						onClose : function() {
							var t3d = 'translate3d(-100%, 0, 0)';
							if (this.dir == 'right')
								t3d = 'translate3d(100%, 0, 0)';
							this.defer(function() {
								this.domNode.style[this.transformKey] = t3d;
							}, 1);

							this.defer(function() {
								this.destroy();
								domConstruct.destroy(this.overlayNode);
							}, 1000);

						},

						onPress : function(e) {
							this.eventStop(e);
							this.touchStartX = e.touches ? e.touches[0].pageX
									: e.clientX;
						},

						onRelease : function(e) {
							if (Math.abs(this.dx) >= this.swipeThreshold) {
								if (this.dx > 0 && this.dir == 'right') {
									this.onClose();
								} else if (this.dx < 0 && this.dir == 'left') {
									this.onClose();
								}
							}
							this.dx = 0;
						},

						onMove : function(e) {
							this.eventStop(e);
							var x = e.touches ? e.touches[0].pageX : e.clientX;
							this.dx = x - this.touchStartX;
						},

						eventStop : function(evt) {
							evt.preventDefault();
						}
					});
		});
