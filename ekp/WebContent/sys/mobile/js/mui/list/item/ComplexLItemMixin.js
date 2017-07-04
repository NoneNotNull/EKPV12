define(	["dojo/_base/declare", 
       	 "dojox/mobile/_ItemBase", 
       	 "dojo/dom-construct",
       	 "dojo/dom-class", 
       	 "dojo/dom-style", 
       	 "mui/util",
       	 "./_ListLinkItemMixin"], function(
				declare, ItemBase, domConstruct, domClass, domStyle, util, _ListLinkItemMixin) {

			return declare("mui.list.item.ComplexLItemListItem", [ItemBase, _ListLinkItemMixin], {
				tag : 'li',
				// 图片url
				icon : '',
				// 描述
				summary : '',
				// 标题
				label : '',
				// 链接
				href : 'javascript:;',
				// 主键
				fdId : '',
				// 创建者
				creator : '',
				// 创建时间
				created : '',
				// 数量
				count : 0,

				buildRendering : function() {
					this._templated = !!this.templateString;
					if (!this._templated) {
						this.domNode = this.containerNode = this.srcNodeRef
								|| domConstruct.create(this.tag, {
											className : 'muiComplexlItem'
										});
						this.contentNode = domConstruct.create(
										'div', {
											className : 'muiListItem'
										}, this.domNode);
					}
					this.inherited(arguments);
					if (!this._templated)
						// 构建内部元素
						this.buildInternalRender();
				},

				buildInternalRender : function() {

					this.articleNode = domConstruct.create('a', null,
							this.contentNode);
					if (this.icon)
						this.iconNode = domConstruct.create('span', {
									innerHTML : '<img src="' + this.icon + '">'
								}, this.articleNode);

					if (this.label) {
						this.hrefNode = domConstruct.create('h3', {
									className : 'textEllipsis muiSubject',
									innerHTML : this.label
								}, this.articleNode);
					}
					if (this.summary) {
						this.descNode = domConstruct.create('p', {
									innerHTML : this.summary,
									className : 'muiListSummary'
								}, this.articleNode);
					}
					if (this.href) {
						this.makeLinkNode(this.articleNode);
					}

					this.infoNode = domConstruct.create('div', {
								className : 'muiComplexlBottom muiListInfo'
							}, this.articleNode);

					if (this.creator) {
						this.creatorNode = domConstruct.create('div', {
									className : 'muiComplexlCreator muiAuthor',
									innerHTML : this.creator
								}, this.infoNode);
					}
					
					if (this.created) {
						this.createdNode = domConstruct.create('div', {
									className : 'muiComplexlCreated',
									innerHTML : '<i class="mui mui-time"></i>' + this.created
								}, this.infoNode);
					}
					
					if (this.count) {
						this.countNode = domConstruct.create('div', {
									className : 'mui mui-eyes mui-2x muiComplexlRead',
									innerHTML : '&nbsp;&nbsp;<span class="muiNumber">' + this.count + '</span>'
								}, this.infoNode);
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
		});