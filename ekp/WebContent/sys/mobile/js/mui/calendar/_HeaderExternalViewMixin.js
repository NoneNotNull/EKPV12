define([ "dojo/_base/declare", "dojo/date", "dojo/topic", "dojo/dom-style",
		"dojox/mobile/TransitionEvent", "mui/util" ], function(declare,
		dateClaz, topic, domStyle, TransitionEvent, util) {
	var claz = declare("mui.calendar._HeaderExternalViewMixin", null, {

		startup : function() {
			this.inherited(arguments);
			this.connect(this.rightNode, 'click', 'onRightClick');
			this.connect(this.leftNode, 'click', 'onLeftClick');
		},

		onTransition : function(opts) {
			new TransitionEvent(this.domNode, opts).dispatch();
		},

		opts : {
			transition : 'scaleOut'
		},

		onLeftClick : function(evt) {
			if (this.left.href) {
				location.href = util.formatUrl(this.left.href);
				return false;
			} else if (this.left.moveTo) {
				this.opts.moveTo = this.left.moveTo;
				this.onTransition(this.opts);
			}
		},

		onRightClick : function(evt) {
			if (this.right.href) {
				location.href = util.formatUrl(this.right.href);
				return false;
			} else if (this.right.moveTo) {
				this.opts.moveTo = this.right.moveTo;
				this.onTransition(this.opts);
			}
		}
	});
	return claz;
});