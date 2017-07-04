define([ "dojo/_base/declare", "mui/property/filter/FilterRadio",
		"dojo/dom-construct", "dojo/_base/array" ], function(declare,
		FilterRadio, domConstruct, array) {
	var claz = declare("mui.property.FilterCheckBox", [ FilterRadio ], {

		selectChange : function(obj, evt) {

		}

	});
	return claz;
});