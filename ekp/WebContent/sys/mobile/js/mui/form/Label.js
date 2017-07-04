define([ "dojo/_base/declare", "dojo/query", "dojo/dom-class",
		"dojo/dom-construct", "dijit/_WidgetBase" ], function(declare, query,
		domClass, domConstruct, _WidgetBase) {
	var claz = declare("mui.form.Label", [ _WidgetBase ], {

		value : null,

		baseClass : 'muiField',

		buildRendering : function() {
			this.inherited(arguments);
			if (this.value)
				this.labelNode = domConstruct.create('div', {
					className : 'muiFieldLabel',
					innerHTML : this.value
				}, this.domNode);
		}
	});

	return claz;
})
