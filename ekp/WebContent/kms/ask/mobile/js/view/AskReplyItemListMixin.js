define(
		[ "dojo/_base/declare", "mui/list/_TemplateItemListMixin",
				"kms/ask/mobile/js/view/item/AskReplyItemMixin",
				"dojo/request", "mui/util", "dojo/_base/array",
				"dojo/_base/json", "dojo/dom-construct", "dojo/query",
				"mui/rtf/RtfResizeUtil", "dojo/_base/lang" ],
		function(declare, _TemplateItemListMixin, AskReplyItemMixin, request,
				util, array, json, domConstruct, query, RtfResizeUtil, lang) {

			return declare(
					"kms.ask.AskReplyItemListMixin",
					[ _TemplateItemListMixin ],
					{

						itemRenderer : AskReplyItemMixin,

						evalDataUrl : '/kms/ask/kms_ask_comment/kmsAskComment.do?method=listComment',

						additionDataUrl : '/kms/ask/kms_ask_addition/kmsAskAddition.do?method=listAddition',

						buildRendering : function() {
							this.inherited(arguments);
							this.subscribe('/mui/list/loaded', 'requestEval');
							this.subscribe('/mui/list/loaded',
									'requestAddition');
						},

						// 构建点评列表
						requestEval : function(obj, evt) {
							if (obj != this)
								return;
							if (!evt)
								return;
							this.buildPostIds(evt);
							var self = this;

							request.post(util.formatUrl(this.evalDataUrl), {
								data : {
									fdPostIds : this.fdPostIds
								}
							}).response.then(function(data) {
								var jsonData = json.fromJson(data.text);
								self.renderEvalList(jsonData);
							});
						},

						buildPostIds : function(evt) {
							if (this.fdPostIds)
								return;
							this.fdPostIds = '';
							var datas = evt.datas;
							array.forEach(datas, function(data, index) {
								if (data[0] && data[0].value) {
									var id = data[0].value;
									this.fdPostIds += (index == 0 ? id : ';'
											+ id);
								}
							}, this);
						},

						// 构建补充回复列表
						requestAddition : function(obj, evt) {
							if (obj != this)
								return;
							if (!evt)
								return;
							this.buildPostIds(evt);
							var self = this;
							request.post(util.formatUrl(this.additionDataUrl),
									{
										data : {
											fdIds : this.fdPostIds
										}
									}).response.then(function(data) {
								var jsonData = json.fromJson(data.text);
								self.renderAdditionList(jsonData);
							});

						},

						// 渲染补充列表
						renderAdditionList : function(datas) {
							if (datas.length == 0) {
								query('.muiAskPostAddition').style('display',
										'none');
								return;
							}
							array
									.forEach(
											datas,
											function(data, index) {
												var fdPostId = data.fdPostId;
												var additionNode = query('#addition_'
														+ fdPostId)[0], contentNode = query(
														'div', additionNode)[0];

												if (contentNode.childNodes.length == 0) {
													domConstruct
															.create(
																	'span',
																	{
																		innerHTML : '补充回答：'
																	},
																	additionNode,
																	'first')
												}

												var content = domConstruct
														.create(
																'div',
																{
																	innerHTML : '<div class="muiAskInfo"><div class="muiAskContent">'
																			+ data.docContent
																			+ '<span class="muiAskTime">'
																			+ data.fdTime
																			+ '</span></div></div>',
																	className : 'muiAskAdditionItem'
																}, contentNode,
																'last');
												var resize = new RtfResizeUtil(
														{
															channel : 'ask',
															containerNode : content
														});
												this
														.subscribe(
																'/mui/list/onPull',
																lang
																		.hitch(
																				resize,
																				resize.destroy));
											}, this);
						},

						// 渲染点评列表
						renderEvalList : function(datas) {
							array
									.forEach(
											datas,
											function(data, index) {
												var fdPostId = data.fdPostId;
												var content = domConstruct
														.create(
																'div',
																{
																	innerHTML : '<span class="muiAuthor">'
																			+ data.fdName
																			+ '：</span>'
																			+ data.docContent
																			+ '<i class="muiTopicReplyEvaTime">'
																			+ data.fdTime
																			+ '</i>',
																	className : 'muiTopicReplyEvaluationLi'
																},
																query('#evaluation_'
																		+ fdPostId)[0],
																'last');
												var resize = new RtfResizeUtil(
														{
															channel : 'ask',
															containerNode : content
														});

												this
														.subscribe(
																'/mui/list/onPull',
																lang
																		.hitch(
																				resize,
																				resize.destroy));
											}, this);
						}
					});
		});