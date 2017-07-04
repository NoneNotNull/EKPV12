define([
    "dojo/_base/declare",
    "dojo/topic",
	"dojox/mobile/View","dojox/mobile/TransitionEvent"
	], function(declare,topic, View, TransitionEvent, registry) {
	//点击粉丝或关注的更多按钮之后滑动过来的view
	return declare("sys.zone.mobile.js.view.PersonMoreView", [View], {
		
		scrollBar : false,
		
		hasData: false,
		
		postCreate : function() {
			this.inherited(arguments);
			this.subscribe('/sys/zone/onSlide',
					'handleViewSilde');
		},

		handleViewSilde : function(obj, evt) {
			if(evt.moreViewId) {
				if(evt.moreViewId == this.id) {
					var opts = {
							transition : 'slide',
							moveTo: this.id
						};
					new TransitionEvent(evt.target, opts).dispatch();
					this.onReload();
				}
			}
		},
		
		onReload: function(widget, handle) {
			if(!this.hasData) {
				//加载数据
				this.getChildren()[1].reload();
				this.hasData = true;
			}
		}
		
	});
});