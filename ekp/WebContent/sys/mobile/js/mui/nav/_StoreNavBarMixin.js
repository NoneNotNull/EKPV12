define("mui/nav/_StoreNavBarMixin", ["dojo/_base/declare", "dojo/dom-class",
				"dojox/mobile/_StoreMixin", "dojo/_base/array", "./NavItem",
				"dojo/store/JsonRest", "dojo/topic", "mui/util"], function(
				declare, domClass, StoreMixin, array, NavItem, JsonRest, topic,
				util) {
			var cls = declare('mui.nav._StoreNavBarMixin', StoreMixin, {
				// 渲染模板
				itemRenderer : NavItem,
				
				// 默认请求url
				defaultUrl : '',

				// 是否默认过，防止请求死循环
				defaulted : false,

				buildRendering : function() {
					this.inherited(arguments);
				},

				_setUrlAttr : function(url) {
					this.url = util.formatUrl(url);
					this._url = util.formatUrl(url);
				},

				_setDefaultUrlAttr : function(url) {
					this.defaultUrl = util.formatUrl(url);
				},

				onComplete : function(items) {
					// // 无数据启用默认url
					if (items.length == 0 && !this.defaulted && this.defaultUrl) {
						this.set('defaulted', true);
						this.url = this.defaultUrl;
						this.store.target = this.url;
						this.setQuery();
						return;
					}
					this.generateList(items);
					topic.publish('/mui/nav/onComplete', this, items);
//					var self = this;
//					this.selectedItem = self.getChildren()[2]; //TODO read ls to set
					if (this.selectedItem) {
						this.selectedItem.setSelected();
//						if (this.selectedItem.moveTo) {
//							this.selectedItem.makeTransition();
//						}
					}
				},

				generateList : function(items) {
					array.forEach(items, function(item, index) {
						if (index == 0) {
							this.addFirstChild(this.createListItem(item));
							return;
						}
						this.addChild(this.createListItem(item));
						if (item[this.childrenProperty]) {
							array.forEach(item[this.childrenProperty], function(child,
									index) {
								this.addChild(this.createListItem(child));
							}, this);
						}
					}, this);
				},

				selectedItem : null,
				
				addFirstChild:function(item){
					this.addChild(item);
				},

				// 构建子项
				createListItem : function(item) {
					var item = new this.itemRenderer(this
							._createItemProperties(item));
					if (item.selected === true)
						this.selectedItem = item;
					return item;
				},

				// 格式化数据
				_createItemProperties : function(item) {
					return item;
				},

				startup : function() {
					if (this._started)
						return;

					if (!this.url) {
						this.url = this.defaultUrl;
						this.set('defaulted', true);
					}

					if (!this.store && !this.url)
						return;
					if (!this.store && this.url)
						var store = new JsonRest({
									idProperty : 'fdId',
									target : this.url
								});
					else
						store = this.store;
					this.store = null;
					this.setStore(store, this.query, this.queryOptions);
					this.inherited(arguments);
				}
			});
			return cls;
		});