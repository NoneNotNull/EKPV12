define(
		[ "dojo/_base/declare", "dojo/topic", "dijit/registry", "dojo/request",
				"mui/util", "dojo/string", "mui/dialog/Confirm",
				"dojo/_base/lang", "mui/dialog/Tip" ],
		function(declare, topic, registry, request, util, string, Confirm,
				lang, tip) {

			return declare(
					"kms.ask.AskCloseButtonsMixin",
					null,
					{

						name : 'docContent',

						_url : '/kms/ask/kms_ask_topic/kmsAskTopic.do?method=close&fdId=${fdId}',

						close : function() {
							var promise = request.post(util.formatUrl(string
									.substitute(this._url, {
										fdId : this.fdId
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

						onClick : function(evt) {
							Confirm('确定结束问题？', null, lang.hitch(this, function(
									flag, dialog) {
								if (flag)
									this.close();
							}));
							this.inherited(arguments);
						}

					});
		});