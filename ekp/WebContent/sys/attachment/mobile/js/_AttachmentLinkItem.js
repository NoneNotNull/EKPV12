define([ "dojo/_base/declare", "dijit/_WidgetBase", "dijit/_Contained",
		"dijit/_Container", "dojox/mobile/_ItemBase", "dojo/dom-class",
		"dojo/on" ], function(declare, WidgetBase, Contained, Container,
		ItemBase, domClass, on) {

	return declare("sys.attachment.mobile.js._AttachmentLinkItem", null, {

		_selClass : 'mblListItemSelected',
		_selStartMethod : "touch",
		_setSelectedAttr : function(selected) {
			this.inherited(arguments);
			domClass.toggle(this.domNode, this._selClass, selected);
		},
		handleSelection : function(e) {
			this.set("selected", true);
		},
		makeTransition : function(e) {
			this.defer(function() {
				this.set("selected", false);
			}, 100);
		},
		_onClick : function(e) {
			this.defaultClickAction(e);
		}
	});
});