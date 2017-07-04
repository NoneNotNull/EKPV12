define([ "dojo/_base/declare", "mui/property/filter/FilterBase",
		"dojo/dom-construct", "dojo/_base/array", "dojo/topic",
		"dojo/text!./address/tmpl.jsp", "dojo/html", "dojo/_base/lang" ],
		function(declare, FilterBase, domConstruct, array, topic, tmpl, html,
				lang) {
			var claz = declare("mui.property.FilterAddress", [ FilterBase ], {

				buildRendering : function() {
					this.inherited(arguments);
					var self = this;
					var dhs = new html._ContentSetter({
						parseContent : true,
						cleanContent : true,
						node : this.contentNode,
						onBegin : function() {
							this.content = lang.replace(this.content, {
								type : self.type,
								idField : self.name,
								nameField : self.name
							});
							this.inherited("onBegin", arguments);
						}
					});
					dhs.set(tmpl);
					dhs.parseDeferred.then(lang.hitch(this, function(
							parseResults) {
						self.addressWidget = parseResults[0];
					}));
					dhs.tearDown();
				},

				startup : function() {
					this.inherited(arguments);
					this.subscribe('/mui/Category/valueChange', 'addValue');
				},

				addValue : function(obj, evt) {
					if (!evt || obj != this.addressWidget)
						return;
					this.values[0] = evt.curIds;
					this.setValue();
				}

			});
			return claz;
		});