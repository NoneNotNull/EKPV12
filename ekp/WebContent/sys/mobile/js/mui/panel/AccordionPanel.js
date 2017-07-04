define(
		"mui/panel/AccordionPanel",
		[ "dojo/dom-construct", 'dojo/_base/declare', "dojo/dom-class",
				"dojo/dom-style", "dojo/topic", "dojo/_base/lang",
				"dijit/_WidgetBase", "dijit/_Contained", "dijit/_Container",
				"mui/panel/_TogglePanelMixin", "mui/panel/_FixedPanelMixin",
				"mui/panel/_SlidePanelMixin", "mui/panel/Content" ],
		function(domConstruct, declare, domClass, domStyle, topic, lang,
				WidgetBase, Contained, Container, _TogglePanelMixin,
				_FixedPanelMixin, _SlidePanelMixin, Content) {
			return declare(
					'mui.panel.AccordionPanel',
					[ WidgetBase, Contained, Container, _FixedPanelMixin,
							_SlidePanelMixin ],
					{

						baseClass : 'muiAccordionPanel',

						startup : function() {
							if (this._started)
								return;
							this.buildContent();
							this.inherited(arguments);
						},

						// 所有标题位置
						titleList : [],

						contentList : [],

						containDom : function(dom) {
							var children = this.getChildren();
							for (var i = 0; i < children.length; i++) {
								if (children[i].domNode == dom)
									return children[i];
							}
							return null;
						},

						// 构建内容
						buildContent : function() {
							var childrenNodes = [];
							for (var j = 0; j < this.domNode.childNodes.length; j++) {
								childrenNodes.push(this.domNode.childNodes[j]);
							}

							for (var i = 0; i < childrenNodes.length; i++) {
								var c = this.containDom(childrenNodes[i]);
								if (c) {
									if (c instanceof Content) {
										var container = domConstruct
												.create(
														'div',
														{
															className : 'muiAccordionPanelContainer'
														}, this.domNode);
										var title = domConstruct
												.create(
														'div',
														{
															className : 'muiAccordionPanelTitle'
														}, container);

										this.titleList.push(title);

										var __content = c;
										if (__content.initContent)
											__content.initContent();
										this.contentList.push({
											show : __content.expand,
											claz : __content
										});
										// 非延迟则显示内容
										var icon = __content.icon ? '<span class="mui '
												+ __content.icon + '"></span>'
												: '', titleMsg = __content.title;
										if (titleMsg)
											title.innerHTML = icon + '<div>'
													+ titleMsg + '</div>';
										domConstruct.place(__content.domNode,
												container);
									}
								} else
									domConstruct.place(childrenNodes[i],
											this.domNode);

							}
						}

					});
		});