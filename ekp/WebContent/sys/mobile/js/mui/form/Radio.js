define([ "dojo/_base/declare", "dojo/query", "dojo/dom-class",
		"mui/form/_OptionsBase", "dojo/dom-construct", "dojo/topic",
		"dojo/_base/lang", "dojo/dom-style" ], function(declare, query,
		domClass, _OptionsBase, domConstruct, topic, lang, domStyle) {
	var _field = declare("mui.form.Radio", [ _OptionsBase ], {

		valueField : null,

		// 与标准html属性重名会出问题
		// name : null,

		opt : false,

		edit : true,

		type : 'radio',

		checked : false,

		checkedClass : 'muiFormRadioChecked',

		RADIO_CHANGE : 'mui/form/radio/change',

		checkedIcon : 'mui-radio-checked',
		unCheckedIcon : 'mui-radio-unchecked',

		_buildValue : function() {
			// 多选外部容器
			this.radioNode = domConstruct.create('div', {
				className : 'muiFormRadio'
			}, this.fieldOptions, 'first');
			// 多选遮罩
			this.overlay = domConstruct.create('div', {
				className : 'muiFormRadioOverlay mui ' + this.unCheckedIcon
			}, this.radioNode, 'last');
			domConstruct.place(this.domNode, this.radioNode, 'last');
			this.inherited(arguments);
		},

		checkedChange : function(obj, evt) {
			if (!evt)
				return;
			if (evt.name == this.name && obj != this)
				this.set('checked', false);
		},

		_setCheckedAttr : function(checked) {
			this.inherited(arguments);
			if (this.checked) {
				domClass.replace(this.overlay, this.checkedIcon,
						this.unCheckedIcon);
				topic.publish(this.RADIO_CHANGE, this, {
					name : this.name
				});
			} else
				domClass.replace(this.overlay, this.unCheckedIcon,
						this.checkedIcon);
		},

		_onClick : function(evt) {
			if (!this.fireClick())
				return;
			this.set('checked', true);
		},

		buildEdit : function() {
			this.connect(this.fieldOptions, 'click', '_onClick');
			this.subscribe(this.RADIO_CHANGE, lang.hitch(this,
					this.checkedChange));
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