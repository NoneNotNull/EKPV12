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
					"kms.ask.AskEvaluationMixin",
					null,
					{
						evaluationUrl : '/kms/ask/kms_ask_comment/kmsAskComment.do?method=save&fdPostId=${fdId}',

						canEvalB : null,

						buildTooltip : function() {
							this.inherited(arguments);
							if (this.canEvalB == 'true') {
								var self = this;
								this.operas
										.push({
											'icon' : 'mui-evaluation',
											'text' : '点评',
											'func' : function() {
												EditorUtil
														.popup(
																self.evaluationUrl,
																{
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