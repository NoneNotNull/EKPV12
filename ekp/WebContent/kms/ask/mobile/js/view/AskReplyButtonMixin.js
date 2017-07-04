define(
		[ "dojo/_base/declare", "mui/form/editor/EditorPopupMixin",
				"dojo/topic", "dijit/registry" ],
		function(declare, EditorPopupMixin, topic, registry) {

			return declare(
					"kms.ask.AskReplyButtonsMixin",
					EditorPopupMixin,
					{

						name : 'docContent',

						_url : '/kms/ask/kms_ask_post/kmsAskPost.do?method=save&fdTopicId=${fdId}',

						onClick : function(evt) {
							this.defer(function() {
								this.onEditorClick(evt);
							}, 300);
							this.inherited(arguments);
						},

						afterHideMask : function() {
							this.inherited(arguments);
							location.reload();
						}
					});
		});