define(
		[ "dojo/_base/declare", "dojo/text!./tmpl/excelViewer.jsp",
				"sys/attachment/mobile/viewer/base/BaseViewer",
				"dojo/dom-attr", "dojo/parser", "dojo/request",
				"dojo/dom-construct", "dojo/query", "dojo/_base/array",
				"mui/util", "dojo/Deferred", "dojo/dom-style",
				"dojo/_base/lang", "dojo/touch" ],
		function(declare, tmpl, BaseViewer, domAttr, parser, request,
				domConstruct, query, array, util, Deferred, domStyle, lang,
				touch) {

			return declare(
					"sys.attachment.ExcelViewer",
					[ BaseViewer ],
					{

						templateString : tmpl,

						resetH_W : function(target) {
							var w_h = util.getScreenSize();
							domStyle.set(target, {
								height : w_h.h + 'px',
								width : w_h.w + 'px'
							});
						},

						buildRendering : function() {
							this.inherited(arguments);
							var def = new Deferred();
							var self = this;
							def.then(function() {
								self.resetH_W(self.pageNode);
								self.append();
								self.connect(self.pageNode, 'load',
										'iframeLoad');
								domAttr.set(self.pageNode, 'src', self
										.getSrc(1));
							});
							this.expandProps(def);
						},

						iframeLoad : function(evt) {
							this.toggle(this, null, true);
						},

						append : function() {
							if (this.fileresource.length <= 1)
								return;
							for (var i = 1; i < this.fileresource.length; i++) {
								var node = lang.clone(this.pageNode);
								domConstruct.place(node, this.pageContent,
										'last');
								domAttr.set(node, 'src', this.getSrc(i + 1));
								this.resetH_W(node)
							}
						},

						getSrc : function(i) {
							var fileresource = this.getFileresource(i), _fileresource = '';
							if (fileresource)
								_fileresource = '&fileresource=' + fileresource;
							return this.getUrl() + '&filekey='
									+ this.getFileName(1) + _fileresource;
						},

						getFileresource : function(i) {
							return this.fileresource[i - 1];
						},

						fileresource : [],

						expandProps : function(def) {
							var self = this;

							request
									.post(
											this.getUrl()
													+ '&filekey=aspose_office2html_page-1&fileresource=tabstrip.htm',
											{
												timeout : 30000
											}).response
									.then(function(data) {
										if (data.status == 200) {
											var htmlDom = data.data;
											var dom = domConstruct
													.toDom(htmlDom);
											array
													.forEach(
															dom.childNodes,
															function(item) {
																if (item.tagName == "TABLE")
																	query('a',
																			item)
																			.forEach(
																					function(
																							_item) {
																						self.fileresource
																								.push(util
																										.getUrlParameter(
																												domAttr
																														.get(
																																_item,
																																'href'),
																												'fileresource'));
																					});
															});
											def.resolve();
										}
									});
						},

						toggle : function() {
							domStyle.set(this.pageSlider, 'display', this
									.inherited(arguments));
						}

					});
		});
