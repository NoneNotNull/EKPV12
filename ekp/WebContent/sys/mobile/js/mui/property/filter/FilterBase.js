define([ "dojo/_base/declare", "dijit/_WidgetBase", "dojo/dom-construct",
		"dijit/_Contained", "dijit/_Container", "dojo/topic" ], function(
		declare, _WidgetBase, domConstruct, Contained, Container, topic) {
	var claz = declare("mui.property.FilterBase", [ _WidgetBase, Contained,
			Container ], {

		baseClass : 'muiPropertyFilter',

		subject : null,

		name : null,

		SET_EVENT : '/mui/property/filter/value/set',

		buildRendering : function() {
			this.inherited(arguments);
			this.titleNode = domConstruct.create('div', {
				className : 'muiPropertyFilterTitle',
				innerHTML : '<span>' + this.subject + '</span>'
			}, this.domNode, 'first');
			this.contentNode = domConstruct.create('div', {
				className : 'muiPropertyFilterContent'
			}, this.domNode, 'last');
			this.values = [];
		},

		startup : function() {
			this.inherited(arguments);
		},

		setValue : function() {
			topic.publish(this.SET_EVENT, this, {
				key : this.name,
				value : this.values
			});
		}

	});
	return claz;
});