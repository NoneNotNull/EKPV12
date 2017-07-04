define([ "dojo/_base/declare", "dojo/query", "dojo/dom-class",
		"mui/form/_InputBase", "dojo/dom-construct", "dojo/dom-style",
		"dojo/topic" ], function(declare, query, domClass, _InputBase,
		domConstruct, domStyle, topic) {
	var claz = declare("mui.form.Textarea", [ _InputBase ], {
		edit : true,

		type : 'textarea',

		name : null,

		inputClass : 'muiFormTextarea',

		buildOptIcon : function(optContainer) {
			domConstruct.create("i", {
				className : 'mui mui-insert mui-rotate-45'
			}, optContainer);
		},

		_onInput : function(evt) {
			var target = evt.target;
			this.resizeHeight(target);
		},

		_onChange : function(srcObj , evt) {
			if(srcObj==this){
				this.resizeHeight(this.textareaNode);
				topic.publish('/mui/list/resize', this);
			}
		},

		resizeHeight : function(obj) {
			var scrollHeight = obj.scrollHeight;
			if (scrollHeight <= 0)
				return;
			domStyle.set(obj, {
				height : scrollHeight + 'px'
			});
		},

		// 构建编辑视图
		buildEdit : function() {
			this.textareaNode = domConstruct.create('textarea', {
				name : this.name,
				className : this.inputClass,
				placeholder : this.placeholder
			}, this.valueNode);
			this.connect(this.textareaNode, 'input', '_onInput');
			this.connect(this.textareaNode, 'focus','_onFocus');
			this.subscribe("/mui/form/valueChanged","_onChange");
		},

		buildReadOnly : function() {
			this.textareaNode = domConstruct.create('textarea', {
				name : this.name,
				className : this.inputClass,
				readonly : 'readonly'
			}, this.valueNode);
		},

		_getValueAttr : function() {
			if (this.textareaNode)
				return this.textareaNode.value;
		},

		buildHidden : function() {
			this.textareaNode = domConstruct.create('textarea', {
				name : this.name,
				className : this.inputClass,
				style : 'display:none'
			}, this.valueNode);
		},

		viewValueSet : function(value) {
			this.valueNode.innerHTML = value;
		},

		editValueSet : function(value) {
			this.textareaNode.value = value;
			this.resizeHeight(this.textareaNode);
		},

		readOnlyValueSet : function(value) {
			this.editValueSet(value);
		},

		hiddenSet : function(value) {
			this.editValueSet(value);
		}
	});

	return claz;
});