define(
		[ "dojo/_base/declare", "mui/dialog/Confirm", "dojo/request",
				"mui/util", "dojo/_base/lang", "dojo/string", "dijit/registry",
				"dojo/topic", "dojo/dom-construct" ],
		function(declare, Confirm, request, util, lang, string, registry,
				topic, domConstruct) {

			return declare(
					"kms.ask.AskBeBestMixin",
					null,
					{
						canSetBestB : null,

						bestUrl : '/kms/ask/kms_ask_post/kmsAskPost.do?method=best&fdPostId=${fdId}&fdTopicId=${fdTopicId}',

						buildTooltip : function() {
							this.inherited(arguments);
							if (this.canSetBestB == 'true') {
								var self = this;
								this.operas.push({
									'icon' : 'mui-checked',
									'text' : '采纳',
									'func' : function() {
										self.onBeBest();
									}
								})
							}
						},

						best : function() {
							var promise = request.post(util.formatUrl(string
									.substitute(this.bestUrl, {
										fdId : this.fdId,
										fdTopicId : this.fdTopicId
									})), {});
							var self = this;
							promise.response.then(function(data) {
								if (data.status == 200) {
									location.reload();
								} else
									tip.fail({
										text : '操作失败'
									});
							});
						},

						onBeBest : function(evt) {
							Confirm('确定置为最佳？', null, lang.hitch(this, function(
									flag, dialog) {
								if (flag)
									this.best();
							}));
						}

					});
		});