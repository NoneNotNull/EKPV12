define([ "dojo/_base/declare", "dojo/topic", "dojo/dom-class" ], function(
		declare, topic, domClass) {
	return declare("kms.ask.mobile.AskHomeButton", null, {

		SCROLL_DOWN : '/kms/ask/scrolldown',

		icon : 'mui mui-home-opposite',

		buildRendering : function() {
			this.inherited(arguments);
			domClass.add(this.domNode, "muiHrefBack");
		},

		show : function() {
			topic.publish(this.SCROLL_DOWN, this, {});
		}
	});
});