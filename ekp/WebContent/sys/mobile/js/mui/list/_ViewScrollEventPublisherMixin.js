define( [ "dojo/_base/declare", 'dojo/topic', 'dojo/_base/lang', 'dojox/mobile/common' ], function(
		declare, topic, lang, common) {

	return declare("mui.list._ViewScrollEventPublisherMixin", null, {

		/** **** 对外发布事件 ***** */

		// 列表滚动事件
		adjust : '/mui/list/adjustDestination',
		// 列表最终滚动事件
		runSlide : '/mui/list/_runSlideAnimation',
		// 列表滚动完成事件
		afScroll : '/mui/list/afterScroll',
		// 列表滚动隐藏上下导航栏
		hideTopBottomTopic : '/mui/list/hideTopBottom',

		/** **** 对外发布事件 //***** */

		/** **** 对外监听事件 ***** */

		// 列表置顶
		toTop : '/mui/list/toTop',
		
		scrollResizeEvent : '/mui/list/resize',
				
		/** **** 对外监听事件 //***** */

		startup : function() {
			if (this._started) {
				return;
			}
			this.inherited(arguments);
			this.subscribe(this.toTop, 'handleToTopTopic');
			this.subscribe("/mui/list/onReload",function(){
				topic.publish(this.adjust, this, {y : 0});
			});
			this.subscribe(this.scrollResizeEvent, 'scrollResize');
		},
		
		scrollResize : function(){
			if(this.resize){
				this.resize();
			}
		},
		
		handleToTopTopic: function(srcObj, evt) {
			var postion = {y : 0};
			if(evt != null){
				postion = lang.mixin(postion,evt);
			}
			this._fireHideTopBottomTopic(false);
			if(postion.y && postion.y!=0){
				var scrollH = this.domNode.offsetHeight;
				var listH = this.containerNode.offsetHeight;
				var navAreaH = listH + postion.y;
				var yTop = 0;
				if(navAreaH < scrollH){
					if(listH<scrollH){
						yTop = 0;
					}else{
						yTop = 0 - (listH - scrollH);
					}
					postion.y = yTop;
				}
			}
			var time = 0.5;
			if(typeof(postion.time) != "undefined" && postion.time >= 0 ) {
				time = postion.time;
			}
			this.slideTo(postion , time, 'linear');
			window.setTimeout(lang.hitch(this, function() {
				topic.publish(this.adjust, this, postion);
			}), 520);
		},

		adjustDestination : function(to, pos, dim) {
			topic.publish(this.adjust, this , to, pos, dim );
			return this.inherited(arguments);
		},

		// 最终滚动
		_runSlideAnimation : function(from, to, duration, easing, node, idx) {
			topic.publish(this.runSlide, this, {
				from : from,
				to : to
			});
			this.inherited(arguments);
		},

		onAfterScroll : function(evt) {
			topic.publish(this.afScroll,  this, evt );
			return this.inherited(arguments);
		},
		
		onFilter : function() {
			this._runSlideAnimation(this.getPos(), {
				y : 0
			}, 0, "ease-out", this.containerNode, 2);
		},

		hideTopBottom : false,

		_preHideValue : false,

		_fireHideTopBottomTopic : function(hide) {
			if (this._preHideValue === hide) {
				return;
			}
			this._preHideValue = hide;
			topic.publish(this.hideTopBottomTopic,  this, hide );
			common.resizeAll();
		},

		onTouchMove : function(e) {
			this.inherited(arguments);
			if (this.hideTopBottom) {
				var len = this._posY.length;
				if (len < 2) {
					return;
				}
				var pre = this._posY[len - 2];
				var cur = this._posY[len - 1];
				var dy = pre - cur;
				if ((dy > 0 && dy < 5) || (dy < 0 && dy > -10)) {
					return;
				}
				var hide = dy > 0;
				this._fireHideTopBottomTopic(hide);
			}
		}
	});
});