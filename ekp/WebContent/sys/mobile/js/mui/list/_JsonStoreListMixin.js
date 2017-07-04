
define([
	'dojo/_base/declare', 
	'dojo/_base/lang', 
	"dojo/on",
	'dojox/mobile/_StoreListMixin', 
	'mui/store/JsonRest','mui/store/JsonpRest',
	'dojox/mobile/viewRegistry',
	'dojo/when',
	'dojo/topic',
	'mui/util'
	], function(declare, lang, on,
		_StoreListMixin, JsonStore, JsonpStore ,viewRegistry, when, topic, 
		util) {
	
	return declare("mui.list._JsonStoreListMixin", [_StoreListMixin], {
		// 支持URL
		url: '',
		
		pageno: 1,
		
		rowsize: null,
		
		busy: false,
		
		dataType : "json",
		
		//是否马上请求数据
		lazy: true,
		
		_setUrlAttr: function(url){
			this.url = util.formatUrl(url);
		},
		
		handleOnPush: function(widget, handle) {
			var scroll = viewRegistry.getEnclosingScrollable(this.domNode);
			if (widget === scroll) {
				this.loadMore(handle);
			}
		},
		
		handleOnReload: function(widget, handle) {
			var scroll = viewRegistry.getEnclosingScrollable(this.domNode);
			if (widget === scroll) {
				if (!this.url && scroll.rel && scroll.rel.url) {
					this.set('url', scroll.rel.url);
				}
				this.reload(handle);
			}
		},
		
		startup : function() {
			if(this._started){ return; }
			this.inherited(arguments);
			if(!this.lazy){
				this.doLoad();
			}
			this.subscribe('/mui/list/onPush', 'handleOnPush');
			this.subscribe('/mui/list/onPull', 'handleOnReload');
			this.subscribe('/mui/list/onReload', 'handleOnReload');
		},
		
		onComplete: function(items) {
			this.busy = false;
			var list = this.resolveItems(items);
			this.generateList(list);
			topic.publish('/mui/list/loaded', this, items);
		},

		onError: function(error) {
			this.busy = false;
		},

		doLoad: function(handle, append) {
			if (this.busy) {
				return;
			}

			if (handle)
				handle.work(this);
			
			this.busy = true;
			this.append = !!append;
			
			if (this.append && this._loadOver) {
				if (handle)
					handle.done(this);
				this.busy = false;
				return;
			}

			var promise = null;
			if (this.store) {
				this.store.target = this.url;
				promise = this.setQuery(this.buildQuery(), {});
			} else {
				if(this.dataType == 'jsonp') {
					promise = this.setStore(new JsonpStore(
							{idProperty: 'fdId', target: util.urlResolver(this.url, this)}), 
							this.buildQuery(), {});
				} else {
					promise = this.setStore(new JsonStore(
							{idProperty: 'fdId', target: util.urlResolver(this.url, this)}), 
							this.buildQuery(), {});
				}
			}
			var self = this;
			if (handle) {
				when(promise, 
						function() {handle.done(self);}, 
						function() {handle.error(self);});
			}
			return promise;
		},
		
		reload: function(handle) {
			this.pageno = 1;
			this._loadOver = false;
			return this.doLoad(handle, false);
		},
		
		loadMore: function(handle) {
			return this.doLoad(handle, true);
		},

		formatDatas : function(datas) {
			var dataed = [];
			for (var i = 0; i < datas.length; i++) {
				var datasi = datas[i];
				dataed[i] = {};
				for (var j = 0; j < datasi.length; j++) {
					dataed[i][datasi[j].col] = datasi[j].value;
				}
			}
			return dataed;
		},

		resolveItems : function(items) {
			this._loadOver = false;
			var page = {};
			if (items) {
				if (items['datas']){//分页数据
					this.listDatas = this.formatDatas(items['datas']);
					page = items['page'];
					if (page) {
						this.pageno = parseInt(page.currentPage, 10) + 1;
						this.rowsize = parseInt(page.pageSize, 10);
						this.totalSize = parseInt(page.totalSize, 10);
						if(parseInt(page.totalSize || 0, 10) <= (this.pageno-1) * this.rowsize) {
							this._loadOver = true;
						}
					}
				}else{//直接数据,不分页
					this.listDatas = items;
					this.totalSize = items.length;
					this.pageno = 1;
					this._loadOver = true;
				}
			}
			
			if (this._loadOver) {
				topic.publish('/mui/list/pushDomHide',this);
			} else {
				topic.publish('/mui/list/pushDomShow',this);
			}
				
			return this.listDatas;
		},
		
		// 筛选
		handleFilter : function(widget, evt, handle) {
			this.pageno = 1;
			topic.publish('/mui/list/pushDomShow',this);
			if (!this.url && evt.url) {
				this.set('url', evt.url);
			}
			return this.doLoad(handle, false);
		},
		
		// 构建
		buildQuery : function() {
			return lang.mixin([] , {
						pageno : this.pageno,
						rowsize : this.rowsize
			});
		}
	});
});