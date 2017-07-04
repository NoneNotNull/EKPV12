define([ "dojo/_base/declare", "dojo/topic" ], function(declare, topic) {

	return declare("mui.property.PropertyFilterCancel", null, {

		show : function(evt) {
			topic.publish('/mui/property/hide', this, null);
		}
	});
});
