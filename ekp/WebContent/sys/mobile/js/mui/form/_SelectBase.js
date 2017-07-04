define([ "dojo/_base/declare", "dojo/dom-construct", "mui/form/_FormBase",
		"dojo/dom-class", "dojo/_base/lang", "mui/util" ], function(declare,
		domConstruct, _FormBase, domClass, lang, util) {
	var _field = declare("mui.form._SelectBase", [ _FormBase ], {

		// 构建值区域
		_buildValue : function() {
			this.inherited(arguments);
			var setBuildName = 'build' + util.capitalize(this.showStatus);
			this[setBuildName] ? this[setBuildName]() : '';
			var setMethdName = this.showStatus + 'ValueSet';
			this.showStatusSet = this[setMethdName] ? this[setMethdName]
					: new Function();
		},

		buildRendering : function() {
			this.inherited(arguments);
			domClass.add(this.domNode, 'muiFormSelect');
			this.inputContent = domConstruct.create('div', {
				className : 'muiFormSelectContnet'
			}, this.valueNode);
			if (this.label)
				domClass.add(this.valueNode, 'muiFormInputArea');

			this._buildValue();
		},

		_setValueAttr : function(value) {
			this.showStatusSet(value);
			this.inherited(arguments);
		},

		// 构建编辑视图
		buildEdit : function() {
			domClass.add(this.inputContent, 'edit');
		},
		buildOptIcon:function(optContainer){
			domConstruct.create('span', {}, optContainer);
		}

	});
	return _field;
});