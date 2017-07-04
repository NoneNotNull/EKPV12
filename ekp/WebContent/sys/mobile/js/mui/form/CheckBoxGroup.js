define(
		[ "dojo/_base/declare", "dojo/dom-construct", "dojo/parser",
				"mui/form/_GroupBase" ],
		function(declare, domConstruct, parser, _GroupBase) {
			var _field = declare(
					"mui.form.CheckBoxGroup",
					[ _GroupBase ],
					{

						tmpl : '<input type="checkbox" data-dojo-type="mui/form/CheckBox" data-dojo-props="showStatus:\'!{showStatus}\',checked:!{checked},name:\'!{name}\',text:\'!{text}\',value:\'!{value}\'">',

						valueField : null,

						opt : false,

						name : null,

						value : '',

						text : '',

						values : [],
						// 是否只显示有值内容，view状态有效
						concentrate : false,

						_buildValue : function() {
							this.inherited(arguments);
						},

						isConcentrate : function(props) {
							return this.concentrate
									&& this.value_s.indexOf(props.value) < 0
									&& this.showStatus == 'view';
						},

						createListItem : function(props) {
							if (this.isConcentrate(props))
								return null;
							var tmpl = this.tmpl.replace('!{showStatus}',
									this.showStatus).replace('!{name}',
									this.name.replace('.', '_') + '_single')
									.replace('!{value}', props.value).replace(
											'!{text}', props.text).replace(
											'!{checked}',
											props.checked ? true : false);
							return domConstruct.toDom(tmpl);
						},

						addChild : function(item) {
							this.inherited(arguments);
							domConstruct.place(item, this.valueNode, 'last');
						},

						generateList : function(items) {
							if (!this.value)
								this.value_s = [];
							else
								this.value_s = this.value.split(';');
							this.inherited(arguments);
							parser.parse(this.valueNode);
						},

						addValue : function(value) {
							if (this.value_s.indexOf(value) >= 0)
								return;
							this.value_s.push(value);
							this.set('value', this.value_s.join(';'));
						},

						removeValue : function(value) {
							var index = this.value_s.indexOf(value);
							if (index < 0)
								return;
							this.value_s.splice(index, 1);
							this.set('value', this.value_s.join(';'));
						}
					});
			return _field;
		});