define([ "dojo/_base/declare", "dojo/query", "dojo/dom-class",
		"mui/form/_InputBase", "dojo/dom-construct", "dojo/topic" ], function(
		declare, query, domClass, _InputBase, domConstruct, topic) {
	var claz = declare("mui.form.Input", [ _InputBase ], {
		edit : true,

		type : 'input',

		name : null,

		inputClass : 'muiFormInput',

		buildOptIcon : function(optContainer) {
			domConstruct.create("i", {
				className : 'mui mui-insert mui-rotate-45'
			}, optContainer);
		},

		buildEdit : function() {
			this.inputNode = domConstruct.create('input', {
				name : this.name,
				className : this.inputClass,
				placeholder : this.placeholder
			}, this.valueNode);
			this.connect(this.inputNode, 'focus','_onFocus');
		},
	
		_getValueAttr : function() {
			if (this.inputNode)
				return this.inputNode.value;
		},

		buildReadOnly : function() {
			this.inputNode = domConstruct.create('input', {
				name : this.name,
				className : this.inputClass,
				readonly : 'readonly'
			}, this.valueNode);
		},

		buildHidden : function() {
			this.inputNode = domConstruct.create('input', {
				name : this.name,
				className : this.inputClass,
				style : 'display:none'
			}, this.valueNode);
		},

		viewValueSet : function(value) {
			this.valueNode.innerHTML = value;
		},

		editValueSet : function(value) {
			this.inputNode.value = value;
		},

		readOnlyValueSet : function(value) {
			this.inputNode.value = value;
		},

		hiddenValueSet : function(value) {
			this.inputNode.value = value;
		}
	});

	return claz;
});