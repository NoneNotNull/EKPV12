define([ "dojo/_base/declare", "dojo/query", "dojo/dom-class",
		"mui/form/_OptionsBase", "dojo/dom-construct", "dojo/topic",
		"dojo/_base/lang", "dojo/dom-style" ], function(declare, query,
		domClass, _OptionsBase, domConstruct, topic, lang, domStyle) {
	var _field = declare("mui.form.CheckBox", [ _OptionsBase ], {

		valueField : null,

		// 与标准html属性重名会出问题
		// name : null,

		opt : false,

		type : 'checkbox',

		checked : false,

		mul : true,

		CHECK_CHANGE : 'mui/form/checkbox/change',

		ITEMVALUE_CHANGE : 'mui/form/checkbox/valueChange',

		checkedClass : 'muiFormCheckBoxChecked',

		_buildValue : function() {
			// 多选外部容器
			this.checkboxNode = domConstruct.create('div', {
				className : 'muiFormCheckBox'
			}, this.fieldOptions, 'first');

			// 多选遮罩
			this.overlay = domConstruct.create('div', {
				className : 'muiFormCheckBoxOverlay mui mui-checked'
			}, this.checkboxNode, 'last');
			domConstruct.place(this.domNode, this.checkboxNode, 'last');
			this.inherited(arguments);

		},

		_checkedChange : function(obj, evt) {
			if (!evt)
				return;
			if (evt.name == this.name && obj != this)
				this.set('checked', false);
		},

		_onClick : function(evt) {
			if (!this.fireClick())
				return;
			this.set('checked', this.checked ? false : true);
			topic.publish(this.ITEMVALUE_CHANGE, this, {
				name : this.name
			});
			if (!this.mul) {
				topic.publish(this.CHECK_CHANGE, this, {
					name : this.name,
					value : this.value
				});
			}
		},

		buildEdit : function() {
			this.connect(this.fieldOptions, 'click', '_onClick');
			if (!this.mul) {
				domClass.add(this.fieldItem, 'sgl');
				this.subscribe(this.ITEMVALUE_CHANGE, '_checkedChange');
			}
		},

		buildHidden : function() {
			domStyle.set(this.domNode, {
				display : 'none'
			});
		},

		buildReadOnly : function() {
			domStyle.set(this.domNode, {
				readOnly : 'readOnly'
			});
		},

		buildView : function() {
			this.buildReadOnly();
		},

		viewValueSet : function(value) {
			this.domNode.value = value;
		},

		editValueSet : function(value) {
			this.viewValueSet(value);
		},

		hiddenValueSet : function(value) {
			this.viewValueSet(value);
		},

		readOnlyValueSet : function(value) {
			this.viewValueSet(value);
		}
	});
	return _field;
});