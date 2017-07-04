define([ "dojo/_base/declare", "dojo/text!mui/datetime/tmpl_datetime.jsp",
		"dojo/dom-class", "dojo/dom-construct",
		"mui/datetime/_EditDateTimeMixin" ], function(declare,
		tmpl, domClass, domConstruct, _EditDateTimeMixin) {
			var claz = declare("mui.datetime._DateTimeMixin", [_EditDateTimeMixin], {
				type : 'datetime',
				
				tmpl : tmpl,

				title : '日期时间选择',
				
				_contentExtendClass:'muiDateTimeDialogDisContent',

				_buildValue : function() {
					this.inherited(arguments);
					domClass.add(this.inputContent, 'muiDateTimeInputContnet');
				}

			});
			return claz;
});