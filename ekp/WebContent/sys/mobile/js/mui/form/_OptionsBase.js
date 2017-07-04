define(
		[ "dojo/_base/declare", "dojo/dom-construct", "mui/form/_FormBase",
				"dojo/dom-class", "dojo/_base/lang", "mui/util",
				"mui/form/_GroupBase" ],
		function(declare, domConstruct, _FormBase, domClass, lang, util,
				_GroupBase) {
			var _field = declare(
					"mui.form._OptionsBase",
					[ _FormBase ],
					{

						text : '',

						alignment : '',

						// 构建值区域
						_buildValue : function() {
							this.inherited(arguments);
							var setBuildName = 'build'
									+ util.capitalize(this.showStatus);
							this[setBuildName] ? this[setBuildName]() : '';
							var setMethdName = this.showStatus + 'ValueSet';
							this.showStatusSet = this[setMethdName] ? this[setMethdName]
									: new Function();
						},

						buildRendering : function() {
							if (!this.domNode)
								this.domNode = this.srcNodeRef
										|| this.ownerDocument
												.createElement("div");

							this.fieldItem = domConstruct.create('div', {
								className : 'muiField muiFormOptionsField'
							}, this.domNode, 'after');

							this.fieldOptions = domConstruct.create('div', {
								className : 'muiFieldOptions'
							}, this.fieldItem, 'last');

							if (this.text) {
								this.textNode = domConstruct.create("div", {
									className : 'muiFieldText',
									innerHTML : this.text
								}, this.fieldOptions);
							}
							this._buildValue();
						},

						_setCheckedAttr : function(checked) {
							this._set("checked", checked);
							this.domNode.checked = checked;
							var type = checked ? 'add' : 'remove';
							domClass[type]
									(this.fieldOptions, this.checkedClass);
							var parent = this.getParent();
							if (parent && parent instanceof _GroupBase)
								parent[type + 'Value'](this.value);
						},

						_setValueAttr : function(value) {
							this.inherited(arguments);
							this.showStatusSet(value);
						},

						/*******************************************************
						 * scrollable嵌套点击事件重复执行临时解决方案
						 ******************************************************/
						holdTime : 250,

						lastTime : null,

						fireClick : function(evt) {
							var time = this.lastTime;
							this.lastTime = new Date().getTime()
							if (time && this.lastTime - time <= this.holdTime)
								return false;
							return true;
						}
					});
			return _field;
		});