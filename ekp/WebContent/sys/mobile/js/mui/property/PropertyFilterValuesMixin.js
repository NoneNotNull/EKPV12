define([ "dojo/_base/declare", "dojo/topic", "dojo/_base/lang" ], function(
		declare, topic, lang) {

	return declare("mui.property.PropertyFilterValuesMixin", null, {

		// 数据格式{'id':[value]}
		buildRendering : function() {
			this.inherited(arguments);
			this.subscribe('/mui/property/filter/value/set', 'setValue');
			this.values = {};
		},

		setValue : function(obj, evt) {
			if (!evt)
				return;
			var key = evt.key;
			var value = evt.value;
			this.values[key] = value;
			topic.publish('/mui/property/filter/values', this, {
				values : this.values
			});
		}
	});
});
