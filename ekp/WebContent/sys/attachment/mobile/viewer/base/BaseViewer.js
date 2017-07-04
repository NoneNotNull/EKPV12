define(
		[ "dojo/_base/declare", "dijit/_TemplatedMixin", "dojo/_base/window",
				"dojo/dom-style", "dijit/_WidgetBase", 'mui/util',
				"dojo/topic", "dojo/dom-geometry", "mui/device/adapter",
				"dojo/dom-construct", "dojo/touch" ],
		function(declare, _TemplatedMixin, win, domStyle, _WidgetBase, util,
				topic, domGeometry, adapter, domConstruct, touch) {

			return declare(
					"sys.attachment.BaseViewer",
					[ _WidgetBase, _TemplatedMixin ],
					{

						templateString : null,

						fdId : null,

						viewerParam : null,

						isShow : true,

						defaultUrl : function() {
							return util
									.formatUrl('/sys/attachment/mobile/viewer/base/default.jsp')
						},

						getPageNum : function() {
							return 1;
						},

						getUrl : function() {
							return util
									.formatUrl('/sys/attachment/sys_att_main/sysAttMain.do?method=view&fdId='
											+ this.fdId);
						},

						getSrc : function(num) {
							return this.getUrl()
									+ '&filekey='
									+ this.getFileName(num ? num : this
											.getPageNum());
						},

						getFileName : function(i) {
							return "aspose_office2html_page-" + i;
						},

						setH_W : function(target) {
							var _body = target.contentDocument.body;
							this.getNodeSize(_body);
							var s = util.getScreenSize();
							var rate1 = s.h / s.w, rate2 = this._height
									/ this._width;

							if (rate1 > rate2)
								this._height = this._width * rate1
							else {
								this._height += 50;
								this._width = this._height / rate1;
							}
						},

						iframeLoad : function(evt) {
							var target = evt.target;
							this.setH_W(target);

							domStyle.set(target, {
								height : this._height + 'px',
								width : this._width + 'px'
							});

							// 屏幕真实高度
							this.toggle(this, null, true);

							// 为了兼容低端android，不得已，写死缩放比例
							this
									.defer(
											function() {
												topic
														.publish(
																'/mui/attachment/viewer/iframeLoaded',
																this,
																{
																	h : this._height,
																	w : this._width,
																	scale : util
																			.getScreenSize().h
																			/ 10
																			/ this.pageSliderScale.offsetHeight
																});
											}, 100);
						},

						onBack : function(evt) {
							var rtn = adapter.goBack();
							if (rtn == null) {
								history.back();
							}
						},

						getNodeSize : function(node) {
							var margin = domGeometry.getMarginExtents(node);
							this._height = node.offsetHeight + margin.h;
							this._width = node.scrollWidth + margin.w;
							return {
								h : this._height,
								w : this._width
							}
						},

						buildRendering : function() {
							// 记录原始屏幕高宽度
							this.s_w_h = util.getScreenSize();
							this.inherited(arguments);
							if (this.pageBackScale)
								this.connect(this.pageBackScale, 'click',
										'onBack');
							this.subscribe('/mui/attachment/viewer/click',
									'toggle');
							this.subscribe(
									'/mui/attachment/viewer/iframeLoaded',
									'loaded');

						},

						// 对工具栏对象进行缩放
						loaded : function(obj, evt) {
							var scale = evt.scale;
							for (name in this) {
								if (/^page(.*)Scale$/.test(name)) {
									var node = this[name];
									var height = node.offsetHeight * scale
											+ 'px';

									var style = {
										height : height,
										'line-height' : height
									}
									var fontSize = domStyle.get(node,
											'font-size');
									if (fontSize)
										style['font-size'] = parseFloat(fontSize)
												* scale + 'px';

									var paddingL = domStyle.get(node,
											'padding-left');
									if (paddingL)
										style['padding-left'] = parseFloat(paddingL)
												* scale + 'px';

									var paddingR = domStyle.get(node,
											'padding-right');
									if (paddingR)
										style['padding-right'] = parseFloat(paddingR)
												* scale + 'px';
									domStyle.set(node, style);
								}
							}
						},

						toggle : function(obj, evt, fire) {
							var show = fire ? 'block' : (this.isShow ? 'none'
									: 'block');
							this.isShow = fire ? true : (this.isShow ? false
									: true);
							return show;
						},

						buildOverlay : function() {
							var s = util.getScreenSize();
							// 建立遮罩
							this.overlayNode = domConstruct.create('div', {
								className : 'muiAttViewerOverlay'
							}, this.domNode);
							this.connect(this.overlayNode, touch.press,
									'onTouchStart');
							this.connect(this.overlayNode, touch.release,
									'onTouchEnd');
							this.connect(this.overlayNode, touch.move,
									'onTouchMove');
						},

						onBack : function(evt) {
							adapter.goBack();
						},

						/*******************************************************
						 * 短暂点击触发事件
						 ******************************************************/
						getTime : function() {
							return new Date().getTime();
						},

						eventStop : function(evt) {
							if (!evt)
								return;
							evt.preventDefault();
							evt.stopPropagation();
						},

						// 点击次数，用于判断是否为双击
						pressTimes : 0,

						doubleTime : 150,

						swipeThreshold : 50,

						onTouchStart : function(e) {
							this.time = this.getTime();
							if (!this.timmer)
								this.timmer = this.defer(function() {
									this.pressTimes = 0;
								}, this.doubleTime);
							this.pressTimes++;

							this.touchStartX = e.touches ? e.touches[0].pageX
									: e.clientX;
							this.touchStartY = e.touches ? e.touches[0].pageY
									: e.clientY;
						},

						onTouchMove : function(e) {
							var x = e.touches ? e.touches[0].pageX : e.clientX;
							var y = e.touches ? e.touches[0].pageY : e.clientY;
							this.dx = x - this.touchStartX;
							this.dy = y - this.touchStartY;
						},

						onTouchEnd : function(e) {

							if (this.pressTimes > 1) {
								if (this.timmer) {
									clearTimeout(this.timmer);
									this.pressTimes = 0;
								}

								this.dx = this.dx ? this.dx : 0;
								this.dy = this.dy ? this.dy : 0;

								if ((new Date().getTime() - this.time < 100)
										&& Math.abs(this.dy) < this.swipeThreshold
										&& Math.abs(this.dx) < this.swipeThreshold) {
									topic.publish(
											'/mui/attachment/viewer/click',
											this);
									return;
								}
							}
							this.dx = 0;
							this.dy = 0;
						}
					});
		});
