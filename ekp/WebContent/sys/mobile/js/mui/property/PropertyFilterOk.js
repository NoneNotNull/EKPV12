define([ "dojo/_base/declare", "dojo/dom-style", "dijit/registry",
		"dojo/topic", 'dojox/mobile/viewRegistry' ], function(declare,
		domStyle, registry, topic, viewRegistry) {

	return declare("mui.property.PropertyFilterOk", null, {

		values : null,

		listId : null,

		buildRendering : function() {
			this.inherited(arguments);
			this.subscribe('/mui/property/filter/values', 'setValues');
		},

		setValues : function(obj, evt) {
			if (!evt)
				return;
			this.values = evt.values;
		},

		show : function(evt) {
			var id = this.listId;
			if (!id)
				return;
			var list = registry.byId(id);
			if (!this._url)
				this._url = list.url;
			var arr = [ this._url ];
			for ( var k in this.values) {
				for (var j = 0; j < this.values[k].length; j++) {
					arr.push("q._prop_." + encodeURIComponent(k) + '='
							+ encodeURIComponent(this.values[k][j]));
				}
			}
			list.url = arr.join('&');
			topic.publish('/mui/property/hide', this, null);
			topic.publish('/mui/list/onReload', viewRegistry
					.getEnclosingScrollable(list.domNode), null);

		}
	});
});
