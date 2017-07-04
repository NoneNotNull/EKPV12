define(
		[ "dojo/_base/declare", "dojo/dom-construct", "dojo/dom-style",
				"mui/form/Editor", "dojo/string", "dojo/query", "dojo/request",
				"mui/dialog/Tip", "dojo/_base/array", "mui/util",
				"dojo/Deferred", "dojo/_base/lang", "dojo/when", "dojo/topic",
				"dijit/registry", "dojo/dom-attr",
				"mui/form/editor/EditorPopupMixin", "dojo/_base/lang",
				"mui/device/adapter", "dojo/dom-class",
				"dojo/text!./tmpl/layout.jsp" ],
		function(declare, domConstruct, domStyle, Editor, string, query,
				request, tip, array, util, Deferred, lang, when, topic,
				registry, domAttr, EditorPopupMixin, lang, adapter, domClass,
				layout) {

			return declare(
					"kms.ask.AskEditEditorMixin",
					EditorPopupMixin,
					{

						layout : layout,

						scoreChange : '/kms/ask/scoreChange',

						buildRendering : function() {
							this.inherited(arguments);

							this.scoreBtnNode = domConstruct.create('div', {
								className : 'muiAskScoreSubmit',
								innerHTML : '悬赏'
							}, this.pluginNode);
							this.scoreNode = domConstruct
									.create(
											'span',
											{
												className : 'muiAskScoreCount',
												innerHTML : '<span class="mui mui-score"></span>&nbsp;'
											}, this.scoreBtnNode);
							this.countNode = domConstruct.create('span', {
								innerHTML : 0
							}, this.scoreNode);
							this.subscribe(this.scoreChange, '_scoreChange');
						},

						_url : '/kms/ask/kms_ask_topic/kmsAskTopic.do?method=save',

						buildForm : function() {
							return {
								docSubject : this.textClaz.format(),
								fdScore : query('[name="fdScore"]')[0].value,
								fdKmsAskCategoryId : query('[name="fdKmsAskCategoryId"]')[0].value
							}
						},

						_scoreChange : function(obj, evt) {
							if (!evt)
								return;
							var score = evt.score;
							this.countNode.innerHTML = score;
						}
					});
		});