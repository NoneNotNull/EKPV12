define([ "dojo/_base/declare", "dijit/_WidgetBase", "dojo/_base/lang",
		"dojo/dom-class", "dojo/dom-construct", "dojo/dom-style" ], function(
		declare, WidgetBase, lang, domClass, domConstruct, domStyle) {

	return declare('mui.dialog._DialogBase', [ WidgetBase ], {

		isShow : false,

		buildRendering : function() {
			this.domNode = this.containerNode;
			this.inherited(arguments);
		},

		show : function() {
			this.set('isShow', true);
			return this;
		},

		hide : function() {
			this.set('isShow', false);
			return this;
		}

	});

})