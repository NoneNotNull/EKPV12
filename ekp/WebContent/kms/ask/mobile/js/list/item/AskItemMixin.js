define(
		[ "dojo/_base/declare", "dojo/dom-construct", "dojo/dom-class",
				"dojo/dom-style", "dojo/dom-attr", "dojox/mobile/_ItemBase",
				"mui/util", "mui/list/item/_ListLinkItemMixin", "dojo/string",
				"mui/device/device", "dojo/_base/array",
				"mui/list/item/_ListThumbItemMixin" ],
		function(declare, domConstruct, domClass, domStyle, domAttr, ItemBase,
				util, _ListLinkItemMixin, string, device, array) {
			var item = declare(
					"kms.ask.item.AskItemMixin",
					[ ItemBase, _ListLinkItemMixin ],
					{

						tag : "li",

						thumbs : null,

						buildRendering : function() {
							this._templated = !!this.templateString;
							if (!this._templated) {
								this.domNode = this.containerNode = this.srcNodeRef
										|| domConstruct.create(this.tag, {
											className : 'muiMixContentItem'
										});
								this.contentNode = domConstruct.create('a', {
									className : 'muiListItem'
								}, this.domNode);
								this.makeLinkNode(this.contentNode);
							}
							this.inherited(arguments);
							if (!this._templated)
								this.buildInternalRender();
						},

						buildInternalRender : function() {
							var infoNode = domConstruct.create('div', {
								className : 'muiMixContentTop'
							}, this.contentNode);
							// 头像节点
							this.imageNode = domConstruct.create('div', {
								innerHTML : string.substitute(
										'<img src="${d}">', {
											d : this.icon
										}),
								className : 'muiMixContentIcon'
							}, infoNode);

							var infoSubNode = domConstruct.create('div', {
								className : 'muiMixContentCreate'
							}, infoNode);

							// 提问者名称节点
							this.nameNode = domConstruct
									.create(
											'div',
											{
												innerHTML : '<span>'
														+ this.creator
														+ '</span>',
												className : 'muiMixContentCreator muiAuthor'
											}, infoSubNode);

							// 是否已经结束
							if (this.fdStatus && this.fdStatus != 0)
								domConstruct
										.create(
												'div',
												{
													innerHTML : '<i class="mui-asklist-close mui"></i>',
													className : 'muiAskStatus'
												}, infoNode);

							var otherInfoNode = domConstruct.create('div', {
								className : 'muiMixContentCreated'
							}, infoSubNode);

							// 发布时间节点
							this.timeNode = domConstruct.create('span', {
								innerHTML : '<i class="mui mui-time"></i>'
										+ this.created,
								className : 'muiAskTime'
							}, otherInfoNode);

							if (this.fdPostFrom && this.fdPostFrom >= 0)
								this.fromNode = domConstruct
										.create(
												'span',
												{
													innerHTML : '来自'
															+ device
																	.getClientTypeStr(this.fdPostFrom),
													className : 'muiAskFrom'
												}, otherInfoNode);

							var contentNode = domConstruct.create('div', {
								className : 'muiMixContentMiddle'
							}, this.contentNode);

							if (this.label) {
								// 悬赏节点
								this.scoreNode = domConstruct
										.create(
												'div',
												{
													className : 'mui mui-score',
													innerHTML : '&nbsp;<span class="muiAskScore">'
															+ this.fdScore
															+ '</span>'
												});
								// 标题节点
								this.labelNode = domConstruct.create('div', {
									className : 'muiMixContentTitle',
									innerHTML : this.scoreNode.outerHTML
											+ this.label
								}, contentNode);
							}

							// this.buildThumb(this.thumbs, this.contentNode);

							if (this.tagName) {
								var tagNode = domConstruct.create('div', {
									className : 'muiAskTag'
								}, this.contentNode);

								var tagPre = domConstruct.create('i', {
									className : 'mui mui-label'
								}, tagNode);

								var tagContentNode = domConstruct.create(
										'span', {
											innerHTML : this.tagName
										}, tagNode);
							}

							var feedBackNode = domConstruct.create('div', {
								className : 'muiMixContentBottom'
							}, this.contentNode);

							// 回复数
							this.replyNode = domConstruct
									.create(
											'div',
											{
												className : 'muiMixContentNum',
												innerHTML : '<i class="mui mui-eval"></i><span class="muiNumber">'
														+ this.fdReplyCount
														+ '</span>'
											}, feedBackNode);
						},

						startup : function() {
							if (this._started)
								return;
							this.inherited(arguments);
						},

						_setLabelAttr : function(text) {
							if (text)
								this._set("label", text);
						}
					});
			return item;
		});