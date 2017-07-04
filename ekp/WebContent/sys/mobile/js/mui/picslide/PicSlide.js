define(
		[ "dojo/_base/array", "dojo/_base/lang","dojo/_base/declare", "dojo/dom-class",
				"dojo/dom-style", "dojo/dom-construct", "dojo/topic",
				"dojo/store/JsonRest", "dijit/_WidgetBase", "dijit/_Contained",
				"dijit/_Container", "dojox/mobile/_StoreListMixin",
				"dojox/mobile/SwapView", "mui/picslide/PicItem", "mui/util" ],
		function(array,lang, declare, domClass, domStyle, domConstruct, topic,
				JsonRest, WidgetBase, Contained, Container, StoreListMixin,
				SwapView, PicItem, util) {
			var picslide = declare(
					"mui.picslide.PicSlide",
					[ WidgetBase, Container, Contained, StoreListMixin ],{

						width : "inherit",

						height : "inherit",
						//图片数据请求URL，为空，标识无需通过数据请求构造图片播放
						url : "",
						//图片数据信息
						items : [],
						//图片是否拉伸
						picTensile : false,

						picResizeEvt : "/mui/picitem/resize",

						viewChanged : "/dojox/mobile/viewChanged",

						changeView : "/mui/picslide/changeview",

						_getSource : function() {
							if (!this.store && this.url != null
									&& this.url != '')
								this.store = new JsonRest( {
									idProperty : 'fdId',
									target : util.formatUrl(this.url)
								});
						},

						buildRendering : function() {
							this.containerNode = domConstruct.create("div", {
								className : "muiListPicslideContainer",
								id : this.id + "_container"
							});
							this.inherited(arguments);
							var i, len;
							if (this.srcNodeRef) {
								for (i = 0, len = this.srcNodeRef.childNodes.length; i < len; i++) {
									this.containerNode
											.appendChild(this.srcNodeRef.firstChild);
								}
							}
							var pagingNode = domConstruct.create("div", {
								className : "muiListPicslidePaging"
							}, this.containerNode);
							this.curPagingNode = domConstruct.create("span", {
								className : "muiListPicslideCur"
							}, pagingNode);
							this.totalPagingNode = domConstruct.create("span",
									{
										className : "muiListPicslideTotal"
									}, pagingNode);
							this.titleNode = domConstruct.create("div", {
								className : "muiListPicslideTitle"
							}, this.containerNode);
							this.domNode.appendChild(this.containerNode);
							this._getSource();
						},

						postCreate : function() {
							this.inherited(arguments);
							this.subscribe(this.viewChanged,
									"_handleViewChanged");
							this
									.subscribe(this.changeView,
											"_changView");
						},

						startup : function() {
							if (this._started) {
								return;
							}
							//高宽处理
							var h, w;
							if (this.height === "inherit") {
								if (this.domNode.parentNode) {
									h = this.domNode.parentNode.offsetHeight + "px";
								}
							} else if (this.height) {
								h = this.height;
							}
							if (h) {
								this.domNode.style.height = h;
							}
	
							if (this.width === "inherit") {
								if (this.domNode.parentNode) {
									w = this.domNode.parentNode.offsetWidth + "px";
								}
							} else if (this.width) {
								w = this.width;
							}
							if (w) {
								this.domNode.style.width = w;
							}
	
							if (this.store) {
								this.setQuery( {}, {});
							} else {
								this.onComplete(this.items);
							}
							this.inherited(arguments);
					},

					//子对象resize
						resizeItems : function() {
							var h = this.domNode.offsetHeight, w = this.domNode.offsetWidth;
							topic.publish(this.picResizeEvt, this, {
								height : h,
								width : w,
								tensile : this.picTensile
							});
						},

						//数据请求回调
						onComplete : function(items) {
							array.forEach(this.getChildren(), function(child) {
								if (child instanceof SwapView) {
									child.destroyRecursive();
								}
							});
							this.items = items;
							var currV, h = this.domNode.offsetHeight;
							for ( var i = 0; i < items.length; i++) {
								var w = new SwapView( {
									height : h + "px",
									lazy : true
								});
								w.addChild(new PicItem(lang.mixin(items[i],{itemIndex:i})));
								this.addChild(w);
								if (i === 0) {
									w.show();
									currV = w;
								} else {
									w.hide();
								}
							}
							this.resizeItems();
							this._handleViewChanged(currV);
						},

						//图片切换事件
						_handleViewChanged : function(evt) {
							var view = null;
							var idx = 0;
							if (evt instanceof SwapView) {
								view = evt;
								idx = this.getIndexOfChild(view);
								if (this.currentView != view) {
									this.curPagingNode.innerHTML = (idx + 1);
									this.totalPagingNode.innerHTML = "/"
											+ this.getChildren().length;
									if (this.items[idx].label
											|| this.items[idx].alt) {
										this.titleNode.innerHTML = this.items[idx].label ? this.items[idx].label
												: this.items[idx].alt;
										domStyle.set(this.titleNode, {
											display : 'block'
										});
									} else {
										domStyle.set(this.titleNode, {
											display : 'none'
										});
									}
									this.currentView = view;
								}
							}
						},
						_changView:function(scrObj,evt){
							if(evt){
								var view = this.getChildren()[evt.curIndex];
								if (this.currentView != view) {
									view.show();
									this._handleViewChanged(view);
								}
							}
						}
					});
			return picslide;
		});