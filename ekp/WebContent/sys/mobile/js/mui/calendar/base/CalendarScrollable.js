define([ "dojo/_base/declare", "dojox/mobile/_css3",
		"mui/calendar/base/CalendarBase", "dojo/dom-style" ], function(declare,
		css3, CalendarBase, domStyle) {
	var claz = declare("mui.calendar.CalendarScrollable", [ CalendarBase ], {

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