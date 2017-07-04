define(
		[ "dojo/_base/declare", "dojo/dom-style", "dojo/dom-attr",
				"dojo/query", "dojo/_base/array", "mui/device/adapter",
				"dojo/on", "dojo/_base/lang", ],
		function(declare, domStyle, domAttr, query, array, adapter, on, lang) {

			return declare(
					"mui.rtf._ImageResizeMixin",
					null,
					{

						formatContent : function(domNode) {
							this.inherited(arguments);
							var imgs = [];
							if (typeof (domNode) == "object") {
								imgs = query('img', domNode);
							} else {
								imgs = query(domNode + ' img');
							}
							this.initSrcList();
							array
									.forEach(
											imgs,
											lang
													.hitch(
															this,
															function(item) {
																var src = item.src;
																if (domAttr
																		.get(
																				item,
																				'data-type') != 'face'
																		&& src
																				.indexOf('/images/smiley/wangwang/') < 0) {
																	this
																			.addSrcList(src);
																	this
																			.resizeDom(item);
																}
															}));
						},

						resizeDom : function(item) {
							domAttr.remove(item, "style");
							var styleVar = {
								'height' : 'auto',
								'textIndent' : '0px',
								"max-width" : '100%'
							};
							domStyle.set(item, styleVar);
							var self = this;
							on(item, "click", function(evt) {
								adapter.imagePreview({
									curSrc : item.src,
									srcList : self.getSrcList()
								});
							});
						},

						initSrcList : function() {
							this.srcList = [];
						},

						addSrcList : function(src) {
							this.srcList.push(src);
						},

						getSrcList : function() {
							return this.srcList;
						}
					});

		});