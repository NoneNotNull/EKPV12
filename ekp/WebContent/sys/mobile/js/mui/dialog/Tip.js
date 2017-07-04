define(	["dojo/_base/declare", "dijit/_WidgetBase", "dojo/_base/lang",
				"dojo/dom-class", "dojo/dom-construct", "dojo/dom-style",
				"dojo/text!mui/dialog/tip.html", "mui/dialog/_DialogBase",
				"dojo/html","dojo/window",
		        "dojo/touch",
		        "dojo/_base/event",
		        "dojo/on"], function(declare, WidgetBase, lang, domClass,
				domConstruct, domStyle, tmpl, _DialogBase, html, win, touch, event, on) {

			var claz = declare('mui.dialog.Tip', [_DialogBase], {

						icon : null,
						text : null,
						time : 2300,
						callback : null,
						cover: false,
						coverNode: null,

						buildRendering : function() {
							this.textNode = domConstruct.create('span', {
										innerHTML : this.text
									});
							if(this.icon){
								this.iconNode = domConstruct.create('div', {
											className : this.icon
										});
							}
							var self = this;
							var dhs = new html._ContentSetter({
										parseContent : true,
										onBegin : function() {
											this.content = this.content
													.replace(/!{text}/g,
															self.textNode.outerHTML);
											if(self.iconNode){
												this.content = this.content
														.replace(/!{icon}/g,
																self.iconNode.outerHTML);
											}else{
												this.content = this.content.replace(/!{icon}/g,
														'');
											}
											this.inherited("onBegin",
															arguments);
										}
									});
							this.containerNode = domConstruct.create('div', {
										'className' : 'muiDialogTip'
									}, document.body, 'last');
							var winBox = win.getBox();
							domStyle.set(this.containerNode,{'max-width':(winBox.w*0.75) + 'px','max-height':winBox.h + 'px'});
							dhs.node = this.containerNode;
							dhs.set(tmpl);
							var _self = this;
							dhs.parseDeferred.then(function() {
								_self.defer(function(){//bug 加延时的原因是ios渲染速度慢致使left,top计算不准确
									var left = (winBox.w - _self.containerNode.offsetWidth)/2;
									var top = (winBox.h - _self.containerNode.offsetHeight)/2;
									domStyle.set(_self.containerNode,{'top':top + 'px', 'left': left + 'px'});
								},320);
							});
							dhs.tearDown();
							this.inherited(arguments);
						},
						
						_initCoverNode: function() {
							if (this.coverNode) {
								return;
							}
							this.coverNode = domConstruct.create("div",{className:'muiButtonAfter'}, document.body,'last');
							on(this.coverNode, touch.press, event.stop);
							on(this.coverNode, touch.move, event.stop);
							on(this.coverNode, touch.release, event.stop);
							on(this.coverNode, touch.cancel, event.stop);
						},

						show : function() {
							domStyle.set(this.domNode, {
								display : ""
							});
							domStyle.set(this.containerNode, {
										opacity : 1
									});
							if (this.cover) {
								this._initCoverNode();
								domStyle.set(this.coverNode, "display", "");
							}
							if (this.time > -1) {
								setTimeout(lang.hitch(this, this.hide), this.time);
							}
							return this.inherited(arguments);
						},

						hide : function(destroy) {
							domStyle.set(this.containerNode, {
										opacity : 0
									});
							domStyle.set(this.domNode, {
								display : "none"
							});
							if (this.cover) {
								this._initCoverNode();
								domStyle.set(this.coverNode, "display", "none");
							}
							if (this.callback)
								this.callback.call();
							this.inherited(arguments);
							if (destroy === false)
								return;
							setTimeout(lang.hitch(this, this.destroy), 1000);
						}
					});
			
			var pTip = declare([claz], {
				icon: "mui mui-loading mui-spin",
				time: -1, 
				cover: true,
				text: "处理中...",
				hide : function() {
					this.inherited(arguments, [false]);
				}
			});
			
			var _processing = new pTip();
			
			setTimeout(function() {_processing.hide();}, 500); // 需要保证计算位置准确

			return {
				tip : function(options) {
					return new claz(options).show();
				},
				success : function(options) {
					return new claz(lang.mixin(options, {
								icon : 'mui mui-success'
							})).show();
				},
				fail : function(options) {
					return new claz(lang.mixin(options, {
								icon : 'mui mui-wrong'
							})).show();
				},
				processing: function(text) {
					if (text)
						_processing.text = text;
					return _processing;
				},
				Tip: claz
			};

		})