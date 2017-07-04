define([ "dojo/_base/declare", "dojo/text!mui/datetime/tmpl_date.jsp",
		"dojo/dom-class", "dojo/dom-construct",
		"mui/datetime/_EditDateTimeMixin", "dojo/query" ], function(declare,
		tmpl, domClass, domConstruct, _EditDateTimeMixin, query) {
	var claz = declare("mui.datetime._DateMixin", [ _EditDateTimeMixin ], {

		type : 'date',
		tmpl : tmpl,

		title : '日期选择',
		
		_contentExtendClass:'muiDateDialogDisContent',

		_buildValue : function() {
			this.inherited(arguments);
			domClass.add(this.inputContent, 'muiDateInputContnet');
		}
	
	});
	return claz;
});