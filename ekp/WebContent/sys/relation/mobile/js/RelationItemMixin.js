define(
		[ "dojo/_base/declare", "dojo/dom-construct", "dojo/dom-class",
				"dojo/dom-style", "dojo/dom-attr", "dojox/mobile/_ItemBase",
				"mui/util", "mui/list/item/_ListLinkItemMixin" ],
		function(declare, domConstruct, domClass, domStyle, domAttr, ItemBase,
				util, _ListLinkItemMixin) {
			var item = declare(
					"sys.relation.RelationItemMixin",
					[ ItemBase, _ListLinkItemMixin ],
					{
						tag : "li",
						// 创建时间
						created : "",
						// 标题
						label : "",
						// 创建者
						creator : "",
						// 链接
						href : "",

						buildRendering : function() {
							this._templated = !!this.templateString;
							if (!this._templated) {
								this.domNode = this.containerNode = this.srcNodeRef
										|| domConstruct.create(this.tag, {
											className : 'muiRelationItem'
										});
							}
							this.inherited(arguments);
							if (!this._templated)
								this.buildInternalRender();
						},

						buildInternalRender : function() {
							this.contentNode = domConstruct.create('div', {
								className : 'muiRelationContent'
							}, this.domNode, 'last');

							if (this.href) {
								this.connect(this.contentNode, 'click',
										'doClick');
							}

							if (this.label) {
								domConstruct.create("span", {
									className : "muiRelationLabel muiSubject",
									innerHTML : this.label
								}, this.contentNode);
							}

							this.infoNOde = domConstruct.create('div', {
								className : 'muiRelationInfo'
							}, this.contentNode);

							if (this.creator) {
								this.createdNode = domConstruct.create("div", {
									className : "muiRelationCreator muiAuthor",
									innerHTML : this.creator
								}, this.infoNOde);
							}

							if (this.created) {
								this.createdNode = domConstruct.create("div", {
									className : "muiRelationCreated",
									innerHTML : this.created
								}, this.infoNOde);
							}

							this.contentRNode = domConstruct
									.create(
											'div',
											{
												className : 'muiRelationContentR',
												innerHTML : '<i class="muiRelationContentRExpand mui mui-forward"></i>'
											}, this.domNode, 'last');

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
						},

						doClick : function(evt) {
							evt.stopPropagation();
							evt.preventDefault();
							location.href = util.formatUrl(this.href);
						}
					});
			return item;
		});