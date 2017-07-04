define(
		[ "dojo/_base/declare", "mui/form/_GroupBase", "dojo/dom-construct",
				"dojo/parser", "dojo/_base/array" ],
		function(declare, _GroupBase, domConstruct, parser, array) {
			var _field = declare(
					"mui.form.RadioGroup",
					[ _GroupBase ],
					{

						tmpl : '<input type="radio" data-dojo-type="mui/form/Radio" data-dojo-props="checked:!{checked},showStatus:\'!{showStatus}\',name:\'!{name}\',text:\'!{text}\',value:\'!{value}\'">',

						valueField : null,

						opt : false,

						name : null,

						value : '',

						text : '',
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
									this.name.replace('.', '_') + '_group')
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
							this.value_s = this.value.split(';');
							this.inherited(arguments);
							return parser.parse(this.valueNode);
						},

						addValue : function(value) {
							this.set('value', value);
						}
					});
			return _field;
		});