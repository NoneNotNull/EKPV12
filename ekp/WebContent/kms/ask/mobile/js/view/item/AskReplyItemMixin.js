define(
		[ "dojo/_base/declare", "dojox/mobile/_ItemBase", "dojo/dom-construct",
				"dojo/string", "dojox/mobile/Tooltip", "dojo/dom-class",
				"dojo/touch", "mui/util",
				"kms/ask/mobile/js/view/AskEvaluationMixin", "dojo/request",
				"kms/ask/mobile/js/view/AskBeBestMixin",
				"mui/rtf/RtfResizeUtil", "dojo/_base/lang",
				"kms/ask/mobile/js/view/AskAdditionMixin",
				"mui/dialog/OperaTip" ],
		function(declare, ItemBase, domConstruct, string, Tooltip, domClass,
				touch, util, AskEvaluationMixin, request, AskBeBestMixin,
				RtfResizeUtil, lang, AskAdditionMixin, OperaTip) {
			var item = declare(
					"kms.ask.item.AskReplyItemMixin",
					[ ItemBase, AskEvaluationMixin, AskBeBestMixin,
							AskAdditionMixin ],
					{

						tag : "li",

						buildRendering : function() {
							this._templated = !!this.templateString;
							if (!this._templated) {
								this.domNode = this.containerNode = this.srcNodeRef
										|| domConstruct.create(this.tag, {
											className : 'muiPostItem'
										});
								this.contentNode = domConstruct.create('div', {
									className : 'muiPostContent'
								}, this.domNode);
							}
							this.canOperate = this.beOperate();
							this.inherited(arguments);
							if (!this._templated)
								this.buildInternalRender();
						},

						beOperate : function() {
							var bool = false;
							for (name in this) {
								if (/^can[A-Z](.*)B$/.test(name)) {
									bool = bool || this[name] == 'true';
								}
							}
							return bool;
						},

						onBodyClick : function(evt) {
							var target = evt.target, isHide = true;
							while (target) {
								if (target == this.operationNode) {
									isHide = false;
									break;
								}
								target = target.parentNode;
							}
							if (isHide) {
								this.defer(function() {
									this.tooltip.hide();
									this.tooltip.destroy();
									this.show = false;
									this.disconnect(this.handle);
								}, 500);
							}
						},

						buildInternalRender : function() {

							this.infosNode = domConstruct.create('div', {
								className : 'muiPostContentT'
							}, this.contentNode);

							this.infoNode = domConstruct.create('div', {
								className : 'muiPostHead'
							}, this.infosNode);

							// 头像节点
							this.imageNode = domConstruct.create('div', {
								innerHTML : string.substitute(
										'<img src="${d}">', {
											d : this.icon
										}),
								className : 'muiPostIcon'
							}, this.infoNode);

							this.creatNode = domConstruct.create('div', {
								className : 'muiPostCreate'
							}, this.infoNode);

							this.nameNode = domConstruct.create('div', {
								innerHTML : this.fdName,
								className : 'muiPostCreator muiAuthor'
							}, this.creatNode);

							this.timeNode = domConstruct
									.create(
											'div',
											{
												innerHTML : '<span><i class="mui mui-time"></i>'
														+ this.fdPostTime
														+ '</span>',
												className : 'muiPostCreated'
											}, this.creatNode);

							this.bestIconNode = domConstruct.create('span', {
								className : 'muiAskBestIcon'
							}, this.infoNode);

							if (this.canOperate) {
								this.operationNode = domConstruct
										.create(
												'div',
												{
													className : 'muiPostReplyOpt',
													innerHTML : '<div class="muiTopicReplyOperation"><span class="l"></span><span class="f"></span><i class="mui mui-more"></i></div>'
												}, this.infoNode);
								this.connect(this.operationNode, 'click',
										'onOperationClick');
							}

							var contentNode = domConstruct.create('div', {
								className : 'muiPostContentC',
								innerHTML : '<div class="muiFieldRtf">'
										+ this.label + '</div>'
							}, this.contentNode);
							
							var resize = new RtfResizeUtil({
								channel : 'ask',
								containerNode : contentNode
							});

							this.subscribe('/mui/list/onPull', lang.hitch(
									resize, resize.destroy));

							// 补充节点
							this.additionNode = domConstruct.create('div', {
								className : 'muiAskPostAddition',
								innerHTML : '<div></div>',
								id : 'addition_' + this.fdId
							}, this.contentNode);

							// 点评节点
							this.evaluatoinNode = domConstruct.create('div', {
								className : 'muiTopicReplyEvaluation',
								id : 'evaluation_' + this.fdId
							}, this.contentNode);

							if (this.fdIsBest == 'true') {
								domConstruct
										.create(
												'img',
												{
													src : util
															.formatUrl('/kms/ask/mobile/css/images/best.png')
												}, this.bestIconNode);
							}
						},

						_setLabelAttr : function(text) {
							if (text)
								this._set("label", text);
						},

						buildTooltip : function() {
							this.inherited(arguments);
						},

						onOperationClick : function(evt) {
							if (this.operaTip && this.operaTip.isShow)
								return;
							this.operas = [];
							this.buildTooltip();
							this.operaTip = OperaTip.tip({
								refNode : this.operationNode,
								operas : this.operas
							});
							this.inherited(arguments);
						}
					});
			return item;
		});