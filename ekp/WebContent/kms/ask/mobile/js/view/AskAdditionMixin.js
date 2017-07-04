define(
		[ "dojo/_base/declare", "dojo/dom-construct", "dojo/dom-style",
				"mui/form/Editor", "dojo/string", "dojo/query", "dojo/request",
				"mui/dialog/Tip", "dojo/_base/array", "mui/util",
				"dojo/Deferred", "dojo/_base/lang", "dojo/when", "dojo/topic",
				"dijit/registry", "mui/form/editor/EditorUtil" ],
		function(declare, domConstruct, domStyle, Editor, string, query,
				request, tip, array, util, Deferred, lang, when, topic,
				registry, EditorUtil) {

			return declare(
					"kms.ask.AskAdditionMixin",
					null,
					{

						additionUrl : '/kms/ask/kms_ask_addition/kmsAskAddition.do?method=save&fdKmsAskTopicId=${fdTopicId}&fdKmsAskPostId=${fdId}',

						canAdditionB : null,

						buildTooltip : function() {
							this.inherited(arguments);
							if (this.canAdditionB == 'true') {
								var self = this;
								this.operas
										.push({
											'icon' : 'mui-addInfo',
											'text' : '补充',
											'func' : function() {
												EditorUtil
														.popup(
																self.additionUrl,
																{
																	fdTopicId : self.fdTopicId,
																	fdId : self.fdId,
																	name : 'docContent'
																},
																function(data) {
																	topic
																			.publish(
																					"/mui/list/onPull",
																					registry
																							.byId('askPostList'));
																});
											}
										});
							}
						}

					});
		});