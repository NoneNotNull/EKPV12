define([ "dojo/_base/declare", "mui/form/_FormBase",
		"mui/form/_StoreFormMixin", "dojo/dom-construct" ], function(declare,
		_FormBase, _StoreFormMixin, domConstruct) {
	var _field = declare("mui.form._GroupBase", [ _FormBase, _StoreFormMixin ],
			{

				name : null,

				addValue : function(value) {

				},

				removeValue : function(value) {

				},

				/***************************************************************
				 * 构建隐藏域
				 **************************************************************/
				buildRendering : function() {
					this.inherited(arguments);
					if (this.edit) {
						this.hiddenNode = domConstruct.create('input', {
							type : 'hidden',
							name : this.name
						}, this.domNode);
					}
				},

				_setValueAttr : function(value) {
					this.inherited(arguments);
					if (this.edit)
						this.hiddenNode.value = value;
				}
			});
	return _field;

});