define(
		[ "dojo/_base/declare", "dojo/text!./tmpl/imgViewer.jsp",
				"sys/attachment/mobile/viewer/base/BaseViewer",
				"dojo/dom-attr", "dojo/dom-construct", "mui/util",
				"dojo/dom-style", "dojo/touch" ],
		function(declare, tmpl, BaseViewer, domAttr, domConstruct, util,
				domStyle, touch) {

			return declare(
					"sys.attachment.ImgViewer",
					[ BaseViewer ],
					{

						templateString : tmpl,

						fdId : '',

						buildRendering : function() {
							this.inherited(arguments);
							domAttr
									.set(
											this.pageImg,
											'src',
											util
													.formatUrl('/sys/attachment/sys_att_main/sysAttMain.do?method=download&fdId='
															+ this.fdId));

							this.toggle(this, null, true);
							this.connect(document.body, touch.press,
									'onTouchStart');
							this.connect(document.body, touch.release,
									'onTouchEnd');

							var w_h = util.getScreenSize();
							domStyle.set(this.pageContent, {
								height : w_h.h + 'px',
								'line-height' : w_h.h + 'px'
							});
						},

						toggle : function() {
							domStyle.set(this.pageSlider, 'display', this
									.inherited(arguments));
						}

					});
		});
