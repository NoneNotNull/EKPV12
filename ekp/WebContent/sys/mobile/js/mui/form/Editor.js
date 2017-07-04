define(
		[ "dojo/_base/declare", "dijit/_WidgetBase", "dojo/dom-construct",
				"dojo/dom-class", "mui/util", "dojo/_base/array", "dojo/topic",
				"dojo/touch", "mui/form/editor/EditorPluginMixin",
				"dojo/text!./editor/tmpl/layout.html", "dojo/html",
				"dojo/_base/lang", "dojo/query", "dojo/Deferred",
				"dojo/dom-style", "dojo/dom-attr" ],
		function(declare, WidgetBase, domConstruct, domClass, util, array,
				topic, touch, EditorPluginMixin, layout, html, lang, query,
				Deferred, domStyle, domAttr) {

			return declare(
					"mui.form.Editor",
					[ WidgetBase, EditorPluginMixin ],
					{

						edit : true,

						name : null,

						options : {},

						baseClass : 'muiEditor',

						showStatus : 'edit',
						// 支持自定义布局
						layout : layout,

						EVENT_VALUE_CHANGED : '/mui/form/valueChanged',

						buildRendering : function() {
							// 格式化内容
							this.formatContent = [];
							this.inherited(arguments);
							domClass.add(this.domNode, this.baseClass);
							this.edit = this.showStatus != 'view';
							this._buildValue();
							this.synValue();
						},

						// 提交时候设置同步textarea值
						synValue : function() {
							if (typeof (Com_Parameter) == 'undefined')
								return;
							var self = this;
							Com_Parameter.event["submit"].push(function() {
								self._synValue();
								return true;
							});
						},

						format : function() {
							return util.base64Encode(this._format());
						},

						_format : function() {
							if (this.__textNode) {
								var html = this.__textNode.innerHTML;
								for (var i = 0; i < this.formatContent.length; i++) {
									html = this.formatContent[i](html);
								}
								return html;
							}
							return "";
						},

						_synValue : function() {
							this.valueNode.value = this.format();
						},

						_buildValue : function() {
							this.inherited(arguments);
							var setBuildName = 'build'
									+ util.capitalize(this.showStatus);
							this[setBuildName] ? this[setBuildName]() : '';
							var setMethdName = this.showStatus + 'ValueSet';
							this.showStatusSet = this[setMethdName] ? this[setMethdName]
									: new Function();
						},

						buildEdit : function() {
							this.editorDeferred = new Deferred();

							// 容器节点
							this.editorNode = domConstruct.create('div', {
								className : 'muiEditorContainer'
							}, this.domNode);
							this.inherited(arguments);
							var self = this;
							var dhs = new html._ContentSetter({
								parseContent : true,
								cleanContent : true,
								node : this.editorNode,
								onBegin : function() {
									if (self.name)
										self.options.name = self.name;
									this.content = lang.replace(this.content,
											self.options);
									this.inherited("onBegin", arguments);
								}
							});
							if (this.layout)
								dhs.set(this.layout);
							else
								dhs.set(layout);
							dhs.parseDeferred.then(lang.hitch(this,
									function(parseResults) {
										this.pluginNode = query(
												'.muiEditorPlugin',
												this.editorNode)[0];
										this.textContainerNode = query(
												'.muiEditorTextContainer',
												this.editorNode)[0];
										this.__textNode = query(
												'div.muiEditorTextarea',
												this.textContainerNode)[0];
										if (this.placeholder)
											domAttr.set(this.__textNode,
													'placeholder',
													this.placeholder);
										this.connect(this.__textNode, 'blur',
												'onBlur');
										this.connect(this.__textNode, 'input',
												'onInput');
										this.valueNode = query(
												'textarea.muiEditorTextarea',
												this.textContainerNode)[0];
										this.editorDeferred.resolve();
									}));
							dhs.tearDown();
						},

						placeholder : null,

						onInput : function(evt) {
							this.publishValueChange();
						},

						onBlur : function(evt) {
							var selection = document.getSelection(), range = selection
									.getRangeAt(0);
							var pos = range.endOffset, container = range.endContainer;
							if (container.nodeType === 3) { // 文本节点
								this.isText = true;
							} else
								this.isText = false;
							this.__pos = pos;
							this.__container = container;
						},

						// 当前位置插入dom节点
						insertElement : function(node) {
							var c = this.__container;
							if (!c) {
								domConstruct.place(node, this.__textNode,
										'last');
							} else {
								var p = this.__pos;
								if (this.isText) {
									c.splitText(p);
									c.parentNode.insertBefore(node,
											c.nextSibling);
								} else
									c.insertBefore(node, c.childNodes[p]);
							}
							this.publishValueChange();
						},

						_getValueAttr : function() {
							return this.__textNode.innerHTML;
						},

						publishValueChange : function() {
							topic.publish(this.EVENT_VALUE_CHANGED, this, {
								value : this._format()
							});
						},

						_setValueAttr : function(value) {
							this._set("value", value);
							if (this.showStatusSet)
								this.showStatusSet(value);
							this.publishValueChange();
						},

						viewValueSet : function(value) {
							this.editValueSet(value);
						},

						editValueSet : function(value) {
							if (this.valueNode)
								this.valueNode.value = value;
							if (this.__textNode)
								this.__textNode.innerHTML = value;
						},

						readOnlyValueSet : function(value) {
							this.editValueSet(value);
						},

						hiddenValueSet : function(value) {
							if (this.valueNode)
								this.valueNode.value = value;
						}
					});
		});