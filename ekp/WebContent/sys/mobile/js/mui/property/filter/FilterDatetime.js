define([ "dojo/_base/declare", "mui/property/filter/FilterBase",
		"dojo/dom-construct", "dojo/_base/array", "dojo/topic",
		"dojo/text!./datetime/tmpl.jsp", "dojo/html", "dojo/_base/lang" ],
		function(declare, FilterBase, domConstruct, array, topic, tmpl, html,
				lang) {
			var claz = declare("mui.property.FilterDatetime", [ FilterBase ], {

				types : [ 'Date', 'Time', 'DateTime' ],

				buildRendering : function() {
					this.inherited(arguments);
					var _types = array.filter(this.types, function(item) {
						return item.toLowerCase() == this.type;
					}, this);
					if (_types.length == 0)
						return;
					var self = this;
					var dhs = new html._ContentSetter({
						parseContent : true,
						cleanContent : true,
						node : this.contentNode,
						onBegin : function() {
							this.content = lang.replace(this.content, {
								type : _types[0],
								name : self.name
							});
							this.inherited("onBegin", arguments);
						}
					});
					dhs.set(tmpl);
					dhs.parseDeferred.then(lang.hitch(this, function(
							parseResults) {
						// 开始时间和结束时间
						self.startWidget = parseResults[0];
						self.endWidget = parseResults[1];
					}));
					dhs.tearDown();
				},

				startup : function() {
					this.inherited(arguments);
					this.subscribe('/mui/form/datetime/change', 'addValue');
				},

				addValue : function(obj) {
					if (obj == this.startWidget)
						this.values[0] = obj.value;
					if (obj == this.endWidget)
						this.values[1] = obj.value;
					this.setValue();
				}

			});
			return claz;
		});