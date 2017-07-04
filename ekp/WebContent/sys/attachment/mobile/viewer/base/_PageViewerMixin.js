define(
		[ "dojo/_base/declare", "dojo/dom-attr", "dojo/dom-style",
				"dojo/dom-construct", "dojo/_base/array", 'dojo/parser',
				"dojo/topic", "sys/attachment/mobile/viewer/base/PageValues" ],
		function(declare, domAttr, domStyle, domConstruct, array, parser,
				topic, PageValues) {

			return declare(
					"sys.attachment._PageViewerMixin",
					null,
					{

						pageNode : null,

						viewerParam : null,

						pageNodes : {},

						buildRendering : function() {
							this.pageValues = new PageValues();
							this.inherited(arguments);
							this.expandProps();
							this.bindEvent();
							this.subscribe('/mui/attachment/viewer/pageChange',
									'pageChange');
							var self = this;
							parser
									.parse(this.pageSliderScale)
									.then(
											function(widgetList) {
												widgetList[0].pageValues = self.pageValues;
												self.connect(self.pageNode,
														'load', 'iframeLoad');
												self.pageNodes[1] = self.pageNode;
												domAttr.set(self.pageNode,
														'src', self.getSrc());
											});
						},

						toggle : function() {
							domStyle.set(this.pageSliderScale, 'display', this
									.inherited(arguments));
						},

						pageChange : function(obj, evt) {
							if (obj == this)
								return;
							if (!evt)
								return;
							var fire = evt.fire;
							this.swapPage(evt.pageNum, fire);
							if (fire)
								return;
							evt.pageNum + 1 <= this.getPageCount() ? this
									.swapPage(evt.pageNum + 1) : '';
						},

						pageIframeTmpl : function() {
							return '<iframe src="'
									+ this.defaultUrl()
									+ '" style="border: none;width:!{width}px;height:!{height}px"></iframe>';
						},

						expandProps : function() {
							if (!this.viewerParam)
								return;
							array.forEach(this.viewerParam.split(','),
									function(param) {
										var ps = param.split(':');
										if (ps[0] == 'totalPageCount') {
											this.pageValues.set('pageCount',
													parseInt(ps[1]));
											return false;
										}
									}, this);
						},

						bindEvent : function() {
							this.connect(window, 'scroll', 'onScroll');
						},

						getPageNum : function() {
							return this.pageValues.get('pageNum');
						},

						getPageCount : function() {
							return this.pageValues.get('pageCount');
						},

						/*******************************************************
						 * 切换页码
						 ******************************************************/
						swapPage : function(num, fire, lazy) {

							if (fire) {
								this._swapPage(num);
								return;
							}
							var pageNode = this.pageNodes[num];
							if (!pageNode)
								this.buildIframe(num, lazy);
							else if (domAttr.get(pageNode, 'src') == this
									.defaultUrl()) {
								domAttr.set(pageNode, 'src', this.getSrc(num));
							}
						},

						/*******************************************************
						 * 强制跳转到对应页面，中间页面补全
						 ******************************************************/
						_swapPage : function(num) {
							if (!this.pageNodes[num]) {
								domStyle.set(this.pageContent, {
									height : this._height * num + 'px'
								});
								for (var i = 1; i < num; i++) {
									if (i == num - 1) {
										this.swapPage(i);
										continue;
									}
									this.swapPage(i, false, true);
								}
							}
							window.scrollTo(0, (num - 1) * this._height);
						},

						buildIframe : function(num, fire) {
							var html = this.pageIframeTmpl().replace(
									'!{width}', this._width).replace(
									'!{height}', this._height);
							this.pageNodes[num] = node = domConstruct
									.toDom(html);
							if (!fire)
								domAttr.set(node, 'src', this.getSrc(num));
							domConstruct.place(node, this.pageContent, 'last');
						},

						onScroll : function(evt) {
							if (!this._height)
								return;
							var target = document.body;
							var scrollTop = target.scrollTop;
							this.pageValues.set('pageNum', Math.round(scrollTop
									/ this._height) + 1);
						},

						/*******************************************************
						 * 首个iframe加载完毕后相关设置
						 ******************************************************/
						iframeLoad : function(evt) {
							if (this.iframeLoaded)
								return;
							this.inherited(arguments);
							// 设置遮罩，便于触发标准事件
							this.buildOverlay();
							this.defer(function() {
								this.pageValues.set('pageNum', 1);
							}, 200);
							this.iframeLoaded = true;
						}

					});
		});
