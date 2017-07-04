define(	["dojo/_base/declare", "dojo/dom-construct", "dojo/dom-class",
				"dojo/dom-style", "dojo/dom-attr", "dojox/mobile/_ItemBase",
				"dojox/mobile/iconUtils", "mui/util", "./_ListLinkItemMixin"],
		function(declare, domConstruct, domClass, domStyle, domAttr, ItemBase,
				iconUtils, util, _ListLinkItemMixin) {
			var item = declare("mui.list.item.TextItemMixin", [ItemBase,
							_ListLinkItemMixin], {

						// 标题
						label : '',
						// 文档附件类型
						icon : '',
						// 创建时间
						created : '',
						// 创建者
						creator : '',
						
						tag : 'li',

						leftIcon : '',
						rightIcon : '',

						inheritParams : function() {
							if (this.icon)
								this.set('rightIcon', this.icon);
						},

						buildRendering : function() {
							this._templated = !!this.templateString;
							if (!this._templated) {
								this.domNode = this.containerNode = this.srcNodeRef
										|| domConstruct.create(this.tag, {
											className : 'muiTextItem'
										});
								this.contentNode = domConstruct.create(
										'div', {
											className : 'muiListItem'
										}, this.domNode);
							}
							this.inherited(arguments);

							if (!this._templated)
								this.buildInternalRender();
						},

						buildInternalRender : function() {

							this.titleNode = domConstruct.create('a', null,
									this.contentNode);
							if (this.leftIcon) {
								domClass.add(this.contentNode, 'muiTextItemL');
								iconUtils.setIcon(this.leftIcon, null,
										this.leftIconNode, null, this.contentNode);
							}

							if (this.label) {
								this.labelNode = domConstruct.create('span', {
											'innerHTML' : this.label,
											'className' : 'muiSubject'
										}, this.titleNode);
							}

							if (this.rightIcon)
								iconUtils.setIcon(this.rightIcon, null,
										this.rightIconNode, null,
										this.titleNode);

							if (this.href) {
								this.makeLinkNode(this.titleNode);
							}

							this.otherNode = domConstruct.create('p', {
										className : 'muiListInfo'
									}, this.contentNode);

							if (this.creator) {
								this.creatorNode = domConstruct.create('div',
										{
											'innerHTML' : this.creator,
											'className' : 'muiAuthor muiTextCreator'
										}, this.otherNode);
							}

							if (this.created) {
								this.createdNode = domConstruct.create('div',
										{
											'innerHTML' : '<i class="mui mui-todo_date"></i>' + this.created,
											'className' : 'muiTextCreated'
										}, this.otherNode);
							}

						},

						startup : function() {
							if (this._started) {
								return;
							}
							this.inherited(arguments);
						},

						_setLabelAttr : function(text) {
							if (text)
								this._set("label", text);
						}
					});
			return item;
		});