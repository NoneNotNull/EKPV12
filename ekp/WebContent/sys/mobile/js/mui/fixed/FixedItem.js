define("mui/fixed/FixedItem", ["dojo/dom-construct", 'dojo/_base/declare',
				"dojo/dom-class", "dojo/dom-style", "dojo/topic",
				"dojo/_base/lang", "dijit/_WidgetBase", "dijit/_Contained",
				"dijit/_Container"], function(domConstruct, declare, domClass,
				domStyle, topic, lang, WidgetBase, Contained, Container) {
			return declare('mui.fixed.FixedItem', [WidgetBase, Contained,
							Container], {

						buildRendering : function() {
							this.inherited(arguments);
						},

						showNav : function() {

						},

						hideNav : function() {

						},

						startup : function() {
							if (this._started)
								return;
							this.inherited(arguments);
							// this.top = this.domNode.offsetTop;
						}
					});
		});