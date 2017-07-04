define([ "dojo/_base/declare", "dojo/query", "dojo/dom-class",
		"mui/form/_SelectBase", "dojo/dom-construct",
		"mui/form/select/_StoreSelectMixin", "mui/dialog/Dialog",
		'dojo/parser', "dojo/_base/array", "dojo/_base/lang", "dojo/topic" ],
		function(declare, query, domClass, _SelectBase, domConstruct,
				_StoreSelectMixin, Dialog, parser, array, lang, topic) {
			var _field = declare("mui.form.Select", [ _SelectBase,
					_StoreSelectMixin ], {

				value : '',

				text : '',

				type : 'select',

				CHECK_CHANGE : 'mui/form/checkbox/change',

				SELECT_CALLBACK : 'mui/form/select/callback',

				startup : function() {
					this.inherited(arguments);
					this.valueField = this.name;
				},

				// 渲染模板
				renderListItem : function() {
					this.inherited(arguments);
				},

				closeDialog : function(srcObj, evt) {
					if (evt.name == (this.selectBoxPrefix + this.valueField)) {
						this.set('value', evt.value);
						this._closeDialog();
					}
				},

				_closeDialog : function() {
					this.dialog.hide();
					this.dialog = null;
				},

				_buildValue : function() {
					this.inherited(arguments);
					domClass.add(this.inputContent, 'muiSelectInputContnet');
				},

				buildRendering : function() {
					this.inherited(arguments);
					this.textNode = domConstruct.create('div', {
						className : 'muiFormSelectText'
					}, this.inputContent);
				},

				_setTextAttr : function(text) {
					this.textNode.innerHTML = text;
					this.text = text;
				},

				buildEdit : function() {
					this.inherited(arguments);
					this.selectNode = domConstruct.create('input', {
						name : this.name,
						className : 'muiFormSelectInput',
						value : this.value
					}, this.inputContent);
					this.bindEvent();

				},

				buildReadOnly : function() {
					this.selectNode = domConstruct.create('input', {
						name : this.name,
						className : 'muiFormSelectInput',
						value : this.value,
						readOnly : 'readOnly'
					}, this.inputContent);
				},

				buildHidden : function() {
					this.selectNode = domConstruct.create('input', {
						name : this.name,
						className : 'muiFormSelectInput',
						value : this.value
					}, this.inputContent);
				},

				viewValueSet : function(value) {
					if(value!=null && value!=''){
						this.set('text', this.getTextByValue(value));
					}
				},

				editValueSet : function(value) {
					this.set('text', this.getTextByValue(value));
					this.selectNode.value = value;
				},

				hiddenValueSet : function(value) {
					this.editValueSet(value);
				},

				readOnlyValueSet : function(value) {
					this.editValueSet(value);
				},

				bindEvent : function() {
					this.connect(this.domNode, 'click', function(evt){
						this.defer(function(){
							this._onClick(evt);
						},320);
					});
					if (!this.mul) {
						this.subscribe(this.CHECK_CHANGE, 'closeDialog');
					}
				},

				_onClick : function(evt) {
					if (this.dialog)
						return;
					this.contentNode = domConstruct.create('div', {
						className : 'muiFormSelectElement'
					});
					this.renderListItem(this.contentNode);
					var buttons = [];
					if (this.mul) {
						buttons = [ {
							title : '确定',
							fn : lang.hitch(this, this._closeDialog)
						} ];
					}
					this.dialog = Dialog.element({
						title : this.subject || '下拉框',
						element : this.contentNode,
						buttons : buttons,
						showClass : 'muiDialogSelect',
						callback : lang.hitch(this, function() {
							topic.publish(this.SELECT_CALLBACK, this);
							this.dialog = null;
						})
					});
				}
			});
			return _field;
		});