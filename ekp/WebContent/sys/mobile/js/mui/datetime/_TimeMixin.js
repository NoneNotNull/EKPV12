define([ "dojo/_base/declare", "dojo/text!mui/datetime/tmpl_time.jsp",
		"dojo/dom-class", "dojo/dom-construct",
		"mui/datetime/_EditDateTimeMixin" ], function(declare, tmpl, domClass,
		domConstruct, _EditDateTimeMixin) {
	var claz = declare("mui.datetime._TimeMixin", _EditDateTimeMixin, {

		type : 'time',
		
		tmpl : tmpl,
		
		title : '时间选择',
		
		_contentExtendClass:'muiTimeDialogDisContent',

		_buildValue : function() {
			this.inherited(arguments);
			domClass.add(this.inputContent, 'muiTimeInputContnet');
		}
	});
	return claz;
});