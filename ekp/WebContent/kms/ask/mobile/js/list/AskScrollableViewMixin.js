define([ "dojo/_base/declare", "dojo/dom-geometry", "dojo/touch",
		"dojo/_base/window", "dojo/topic", "dojo/_base/array", "mui/util",
		'dojo/dom-style', "dojox/mobile/_css3" ], function(declare,
		domGeometry, touch, win, topic, array, util, domStyle, css3) {
	var claz = declare("kms.ask.AskScrollableViewMixin", null, {

		SCROLL_UP : '/kms/ask/scrollup',
		SCROLL_DOWN : '/kms/ask/scrolldown',

		connects : [],

		dy : 0,

		buildRendering : function() {
			this.inherited(arguments);
			this.bindEvent();
			this.subscribe(this.SCROLL_DOWN, 'scollDown');
			this.subscribe(this.SCROLL_UP, '_scrollUp');
		},

		bindEvent : function() {
			this.touchStartHandle = this.connect(this.domNode, touch.press,
					"onTouchStart");
		},

		unBindEvent : function() {
			this.disconnect(this.touchStartHandle);
		},

		_scrollUp : function() {
			this.unBindEvent();
		},

		// 触发向上滑事件
		scrollUp : function(y) {
			topic.publish(this.SCROLL_UP, this, {
				y : y
			});
		},

		// 触发向下滑事件
		scollDown : function(y) {
			this.bindEvent();
		},

		onTouchStart : function(e) {
			this.dy = 0;
			this.connects
					.push(this.connect(win.doc, touch.move, "onTouchMove"));
			this.connects.push(this.connect(win.doc, touch.release,
					"onTouchEnd"));
			this.touchStartY = e.touches ? e.touches[0].pageY : e.clientY;
			this.startPos = domGeometry.position(this.domNode);
		},

		onTouchMove : function(e) {
			var y = e.touches ? e.touches[0].pageY : e.clientY;
			this.dy = y - this.touchStartY;
			if (this.dy > 0)
				return;

			if (Math.abs(this.dy) >= window._header_height
					- window.___header_height)
				return;

			this.scrollTo({
				y : this.dy
			});
		},

		onTouchEnd : function(e) {
			var y = 0, top = 0;
			var header_height = window._header_height;
			if (this.dy <= 0 && Math.abs(this.dy) >= header_height >> 1) {
				y = -(header_height - window.___header_height);
				this.scrollUp(y);
			}
			this.defer(function() {
				this.scrollTo({
					y : 0
				}, true);
			}, 100)

			this.disconnects();
		},

		disconnects : function() {
			array.forEach(this.connects, function(item) {
				this.disconnect(item);
			}, this);
			this.connects = [];
		},

		/***********************************************************************
		 * 下面为滑动方法
		 **********************************************************************/
		makeTranslateStr : function(to) {
			var y = to.y + "px";
			return "translate3d(0," + y + ",0px)";
		},

		scrollTo : function(to, smooth) {
			if (smooth)
				this.smooth();
			var s = this.domNode.style;
			s[css3.name("transform")] = this.makeTranslateStr(to);
		},

		// 让惯性变得平滑
		smooth : function() {
			var cssKey = '-webkit-transition';
			domStyle.set(this.domNode, cssKey,
					' -webkit-transform 100ms linear');
			this.defer(function() {
				domStyle.set(this.domNode, cssKey, '')
			}, 100);
		}
	});
	return claz;
});