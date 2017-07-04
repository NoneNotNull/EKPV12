define([ "dojo/_base/declare", "mui/form/_SelectBase", "dojo/query",
		"mui/datetime/_DateMixin", "mui/datetime/_TimeMixin","mui/datetime/_DateTimeMixin",
		"dojo/_base/lang", "dojo/topic" ], function(declare, _SelectBase,
		query, _DateMixin, _TimeMixin, _DateTimeMixin, lang, topic) {
	var _field = declare("mui.form.DateTime", [ _SelectBase ], {

		nameField : null,

		value : '',

		VALUE_CHANGE : '/mui/form/datetime/change',

		_setValueAttr : function(value) {
			var changed = value != this.value;
			this.inherited(arguments);
			// 值发生改变发出事件
			if (changed)
				topic.publish(this.VALUE_CHANGE, this);
		}
	});

	// 对外方法
	var exports = {
		selectDate : function(event, fieldname, format, callback, type) {
			var dom = query('[name="' + fieldname + '"]');
			if (dom.length == 0)
				return;
			var date = new declare([ _field, _DateMixin ])({
				valueDom : dom[0],
				value : dom[0].value
			});
			date.openDateTime();
		},

		selectTime : function(event, fieldname, format, callback, type) {
			var dom = query('[name="' + fieldname + '"]');
			if (dom.length == 0)
				return;
			var date = new declare([ _field, _TimeMixin ])({
				valueDom : dom[0],
				value : dom[0].value
			});
			date.openDateTime();
		},
		
		selectDateTime : function(event, fieldname, format, callback, type) {
			var dom = query('[name="' + fieldname + '"]');
			if (dom.length == 0)
				return;
			var date = new declare([ _field, _DateTimeMixin ])({
				valueDom : dom[0],
				value : dom[0].value
			});
			date.openDateTime();
		}
	};

	return lang.mixin(_field, exports);
});
