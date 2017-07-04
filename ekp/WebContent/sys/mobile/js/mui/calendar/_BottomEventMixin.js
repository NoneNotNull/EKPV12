define(
		[ "dojo/_base/declare", "dojo/dom-geometry", "dojo/touch",
				"dojo/_base/window", "dojo/topic", "dojo/_base/array",
				"mui/util",'dojo/dom-style' ,'dojo/dom-construct'],
		function(declare, domGeometry, touch, win, topic, array, util,domStyle,domConstruct) {
			var claz = declare(
					"mui.calendar._BottomEventMixin",
					null,
					{

						eventNode : null,

						// 事件数组
						connects : [],

						dy : 0,

						url : null,
						addName:null,

						buildRendering : function() {
							this.inherited(arguments);
							this.bindEvent();
							if(this.url){
								this.eventNode.innerHTML='添加事件';
								domConstruct.create('div',{className:'mui-plus mui'},this.eventNode,'first');
								this.connect(this.eventNode, touch.release,'eventClick');
							}
						},

						eventClick : function() {
							if (this.url)
								location.href = util.formatUrl(this.url);
						},

						eventStop : function(evt) {
							evt.preventDefault();
							evt.stopPropagation();
						},

						bindEvent : function() {
							this.touchStartHandle = this.connect(this.domNode,
									touch.press, "onTouchStart");
						},

						unBindEvent : function() {
							this.disconnect(this.touchStartHandle);
						},

						onTouchStart : function(e) {
							this.dy = 0;
							this.eventStop(e);
							this.connects.push(this.connect(win.doc,
									touch.move, "onTouchMove"));
							this.connects.push(this.connect(win.doc,
									touch.release, "onTouchEnd"));
							this.touchStartY = e.touches ? e.touches[0].pageY
									: e.clientY;
							this.startPos = domGeometry.position(this.domNode);
						},

						onTouchMove : function(e) {
							this.eventStop(e);
							var y = e.touches ? e.touches[0].pageY : e.clientY;
							this.dy = y - this.touchStartY;
							if (this.dy > 0)
								return;

							var _y = this.startPos.y - this.weekHeight
									- this.headerHeight;
							if (Math.abs(this.dy) > _y)
								return;

							this.scrollTo({
								y : this.dy
							});

							this.publishScroll({
								y : this.dy,
								top : (this.weekHeight + this.headerHeight)
										* (1 - Math.abs(this.dy) / _y)
							});
						},

						onTouchEnd : function(e) {
							var y = 0, top = 0;
							if (this.contentHeight >> 1 > Math.abs(this.dy)) {
								top = this.weekHeight + this.headerHeight;
							} else {
								y = -(this.contentHeight - this.weekHeight);
								top = 0;
								this.unBindEvent();
								this._bindEvent();
								this.publishStatus(false);
							}
							this.scrollTo({
								y : y
							}, true);
							this.publishScroll({
								y : y,
								top : top
							});

							this.disconnects();
						},

						_bindEvent : function() {
							this._touchStartHandle = this.connect(this.domNode,
									touch.press, "_onTouchStart");
						},

						_unBindEvent : function() {
							this.disconnect(this._touchStartHandle);
						},

						_onTouchStart : function(e) {
							this.dy = 0;
							this.eventStop(e);
							this.connects.push(this.connect(win.doc,
									touch.move, "_onTouchMove"));
							this.connects.push(this.connect(win.doc,
									touch.release, "_onTouchEnd"));
							this.subscribe('/mui/calendar/listScrollableTop',
									'listScrollableTop');
							this.touchStartY = e.touches ? e.touches[0].pageY
									: e.clientY;
						},

						// 列表滚动是否到顶
						listTop : true,

						listScrollableTop : function(obj, to) {
							this.listTop = (to.y >= 0);
						},

						_onTouchMove : function(e) {
							this.eventStop(e);
							var y = e.touches ? e.touches[0].pageY : e.clientY;
							this.dy = y - this.touchStartY;

							if (this.dy < 0
									|| this.dy >= this.contentHeight
											- (this.weekHeight))
								return;

							if (!this.listTop)
								return;

							var dy = -(this.contentHeight - this.weekHeight)
									+ this.dy;
							this.scrollTo({
								y : dy
							});

							this
									.publishScroll({
										y : dy,
										top : (this.weekHeight + this.headerHeight)
												* (1 - Math.abs(dy)
														/ (this.startPos.y
																- this.weekHeight - this.headerHeight))
									});

						},

						_onTouchEnd : function(e) {
							if (!this.listTop)
								return;

							var y = -(this.contentHeight - this.weekHeight), top = 0;

							if (this.contentHeight >> 1 > Math.abs(this.dy)) {
								top = 0;// 还原
							} else {
								y = 0;
								top = this.weekHeight + this.headerHeight;
								this._unBindEvent();
								this.bindEvent();
								this.publishStatus(true);
							}
							this.scrollTo({
								y : y
							}, true);

							this.publishScroll({
								y : y,
								top : top
							});
							this.disconnects();
						},

						publishScroll : function(to) {
							topic.publish('/mui/calendar/bottomScroll', this,
									to);
						},

						publishStatus : function(status) {
							// true代表默认模式
							topic.publish('/mui/calendar/bottomStatus', this, {
								status : status
							});
						},

						disconnects : function() {
							array.forEach(this.connects, function(item) {
								this.disconnect(item);
							}, this);
							this.connects = [];
						}
					});
			return claz;
		});