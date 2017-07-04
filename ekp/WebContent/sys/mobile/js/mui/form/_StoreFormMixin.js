define([ "dojo/_base/declare", "dojox/mobile/_StoreMixin",
		"dojo/store/JsonRest", "dojo/store/Memory", "dojo/_base/array" ],
		function(declare, StoreMixin, JsonRest, Memory, array) {
			var claz = declare("mui.form._StoreFormMixin", StoreMixin, {

				url : '',

				query : {},

				queryOptions : {},

				values : [],

				onComplete : function(items) {
					this.generateList(items);
				},

				addChild : function(item) {
				},

				generateList : function(items) {
					this.values = items;
					array.forEach(items, function(item, index) {
						var claz = this.createListItem(item);
						if (claz)
							this.addChild(claz);
					}, this);
				},

				createListItem : function(props) {
				},

				startup : function() {
					if (this._started)
						return;
					this.inherited(arguments);
					if (!this.store && !this.url)
						return;
					if (!this.store && this.url)
						var store = new JsonRest({
							target : this.url
						});
					else
						store = new Memory({
							data : this.store
						});
					this.setStore(store, this.query, this.queryOptions);
				}
			});
			return claz;
		});