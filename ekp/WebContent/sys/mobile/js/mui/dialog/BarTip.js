define(	["dojo/_base/declare", "dojo/_base/lang",
				"dojo/dom-class", "dojo/dom-construct", "dojo/dom-style",
				"mui/dialog/_DialogBase","dojo/_base/window", "dojo/_base/fx", "mui/util"], 
			function(declare, lang, domClass,
				domConstruct, domStyle, _DialogBase, win, fx, util) {

			var BarTip = declare('mui.dialog.BarTip', [_DialogBase], {
				
						baseClass: "muiDialogBarTip mblIn",

						icon : "mui mui-label",
						text : null,
						time : -1,

						buildRendering : function() {
							this.inherited(arguments);

							this.textNode = domConstruct.create('span', {
										innerHTML : this.text
									});
							
							this.iconNode = domConstruct.toDom("<div class='iconNode'></div>");
							domConstruct.place(domConstruct.create('i', {
								className : this.icon
							}), this.iconNode, "last");
							
							this.closeNode = domConstruct.toDom("<div class='closeNode'><i class='mui mui-close'></i></div>");
							
							var containerNode = domConstruct.toDom("<div class='containerNode'></div>");
							
							
							domConstruct.place(this.iconNode, containerNode, "last");
							domConstruct.place(this.textNode, containerNode, "last");
							domConstruct.place(this.closeNode, containerNode, "last");
							domConstruct.place(containerNode, this.domNode, "last");
							
						},
						
						postCreate: function() {

							domConstruct.place(this.domNode, win.body(), "last");
							
							this.connect(this.closeNode, "click", function() {
								this.hide();
							});
							domStyle.set(this.textNode, "width", (util.getScreenSize().w - 50) + "px");
						},

						show : function() {
						    domStyle.set(this.domNode, "opacity", "0");
							fx.fadeIn({
						        node: this.domNode,
						        duration: 1000
						    }).play(300);
							return this.inherited(arguments);
						},

						hide : function() {
							var domNode = this.domNode;
							fx.fadeOut({
						        node: this.domNode,
						        duration: 1000,
						        end: function() {
									domStyle.set(domNode, "display", "none");
						        }
						    }).play();
							return this.inherited(arguments);
						}
					});

			return {
				tip : function(options) {
					return new BarTip(options).show();
				},
				BarTip: BarTip
			};

		})