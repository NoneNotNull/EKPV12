define(function(require, exports, module) {
	require('theme!listview');
	var base = require("lui/base");
	var layout = require("lui/view/layout");
	var source = require("lui/data/source");
	var topic = require('lui/topic');
	var $ = require('lui/jquery');
	var env = require('lui/util/env');
	var strutil = require('lui/util/str');
	var dialog = require('lui/dialog');

	var CRITERIA_CHANGED = 'criteria.changed';// 监听筛选事件
	var CRITERIA_INIT = 'criteria.init';
	var PAGING_CHANGED = 'paging.changed';// 监听分页事件
	var SORT_CHANGED = 'sort.changed';// 监听排序事件
	var SELECTED_REQUEST = 'selected.request';// 监听接受选中事件
	var SELECTED_RESPONSE = 'selected.response';// 发布返回选中事件
	var LIST_LOADED = 'list.loaded';// 发布列表渲染完毕事件
	var LIST_RERESH = 'list.refresh';// 监控列表刷新事件
	var LIST_CLEAR = 'list.clear';
	var LIST_CHANGED = 'list.changed';// 发布列表数据请求完毕事件

	var rowId = 1;

	var UniqueId = function() {
		return "lui-rowId-" + (rowId++);
	};

	var ListView = base.Container.extend({
		className : 'listview',
		initProps : function($super, cfg) {
			$super(cfg);
			this.tables = [];
			this.sorts = [];
			this.query = [];
			this.criterions = [];
			this.lock = false;
			this.cacheEvt = [];// 缓存事件，防止重复初始化
			// 初始化监听
			if(cfg.criteriaInit && $.trim(cfg.criteriaInit) === "true"){
				this.criteriaInit = true;
			}
			this.subscribePool();
		},

		addChild : function($super, child, attr) {
			$super(child, attr);
			if (child instanceof base.DataSource) {
				this.source = child;
			}
			if (child instanceof AbstractTable) {
				this.tables.push(child);
			}
		},

		clearHtml : function() {
			for (var i = 0; i < this.tables.length; i++) {
				this.tables[i].clearHtml();
			}
		},

		// 构建随机数，用于无缓存刷新
		buildRag : function() {
			return {
				"key" : "__seq",
				"value" : [(new Date()).getTime()]
			};
		},
		
		getUrl:function(data){
			this.cacheEvt.push(data);
			// 筛选器请求统一无缓存处理
			this.cacheEvt.push({
						others : [this.buildRag()]
					});
			if(!this.table)
				this.initTable();
			return this.table._resolveUrls(this.cacheEvt);
		},

		criteriaChange : function(data) {
			if (!this.loading) {
				this.element.css('min-height', 200);
				this.loading = dialog.loading(null, this.element);
			}
			this.cacheEvt.push(data);
			// 筛选器请求统一无缓存处理
			this.cacheEvt.push({
						others : [this.buildRag()]
					});
			if(!this.table)
				this.initTable();
			this.table.resolveUrls(this.cacheEvt);
			this.cacheEvt.length = 0;
		},

		listChanged : function(data) {
			if (this.loading) {
				this.loading.hide();
				this.element.css('min-height', 'inherit');
				this.loading = null;
			}
		},

		tableResolve : function(evt) {
			if (!this.isDrawed) {
				this.cacheEvt.push(evt);
				return;
			}
			if (!this.loading) {
				this.element.css('min-height', 200);
				this.loading = dialog.loading(null, this.element);
			}
			this.table.resolveUrl(evt);
		},

		tableRefresh : function(evt) {
			// 加随机数
			var query = {
				query : [this.buildRag()]
			};
			evt = evt == null ? query : evt;
			this.tableResolve(evt);
		},

		subscribePool : function() {
			// 监听刷新列表
			topic.channel(this).subscribe(LIST_RERESH, this.tableRefresh, this);
			// 监听筛选控件
			topic.channel(this).subscribe(CRITERIA_CHANGED,
					this.criteriaChange, this);
			topic.channel(this).subscribe(PAGING_CHANGED, this.tableResolve,
					this);
			topic.subscribe(SORT_CHANGED, this.tableResolve, this);
			topic.channel(this).subscribe(SORT_CHANGED, this.tableResolve, this);
			topic.channel(this).subscribe(SELECTED_REQUEST,
					this.responseCheckboxSelected, this);
			topic.channel(this).subscribe(LIST_CLEAR, this.clearHtml, this);
			topic.channel(this).subscribe(LIST_CHANGED, this.listChanged, this);
			topic.channel(this).subscribe(CRITERIA_INIT, this.isCriteriaInit,
					this);
			return this;
		},

		isCriteriaInit : function() {
			this.criteriaInit = true;
		},

		responseCheckboxSelected : function(_data) {
			this.table.responseCheckboxSelected(_data);
		},

		unsubscribePool : function() {
			topic.channel(this).unsubscribe(SELECTED_REQUEST,
					this.responseCheckboxSelected);
			topic.channel(this).unsubscribe(CRITERIA_CHANGED,
					this.criteriaChange);
			topic.channel(this).unsubscribe(PAGING_CHANGED, this.tableResolve);
			topic.channel(this).unsubscribe(LIST_RERESH, this.tableResolve);
			topic.channel(this).unsubscribe(LIST_CLEAR, this.clearHtml);
			topic.channel(this).unsubscribe(LIST_CHANGED, this.listChanged);
			return this;
		},

		startup : function($super) {
			if (this.isStartup) {
				return;
			}
			if (!this.source) {
				if (this.config.url) {
					this.source = new source.AjaxJson({
								url : this.config.url
							});
				} else {
					this.source = new source.Static({
								datas : {}
							});
				}
				if (this.source.startup)
					this.source.startup();
			}

			var self = this;
			this.on('load', function(evt) {
						topic.channel(self).publish(LIST_LOADED, {
									'listview' : this,
									'table' : evt.table
								});
					});
			this.on(SELECTED_RESPONSE, function(evt) {
						topic.channel(self).publish(SELECTED_RESPONSE,
								$.extend(evt, {
											'listview' : self
										}));
					});
			$super();
		},

		_initTableByCriteria : function() {
			this.table = this.getSelectedTable();
			this.element.show();
			this.table.element.show();
		},

		getSelectedTable : function() {
			var t = this.table;
			if (!t) {
				if (this.tables.length <= 0)
					return;
				for (var i = 0; i < this.tables.length; i++) {
					if (this.tables[i].isSelected())
						t = this.tables[i];
				}
				if (!t) {
					t = this.tables[0];
					t.setSelected(true);
				}
			}
			return t;
		},
		
		initTable : function(){
			if (this.criteriaInit) {// 筛选器初始化列表
				this._initTableByCriteria();
			} else
				// 列表本身自初始化
				this._initTable();
		},

		draw : function($super) {
			this.initTable();
			$super();
		},

		_initTable : function() {
			this.clearHtml();
			this.table = this.getSelectedTable();
			this.table.setSelfInit(true);
		},

		typeChange : function(data) {
			this.clearHtml();
			this.table = this.getSelectedTable();
			this.table.buildUrl(this.criterions.concat(this.query), {},
					this.sorts);
			this.table.emit('show');
		},

		clearSelected : function() {
			for (var i = 0; i < this.tables.length; i++) {
				this.tables[i].setSelected('false');
			}
		},
		setLock : function(lock) {
			this.lock = lock;
		},

		getLock : function() {
			return this.lock;
		},

		// 以下为对外api

		// 切换视图类型
		switchType : function(type) {
			if (type) {
				for (var i = 0; i < this.tables.length; i++) {
					if (this.tables[i].name && this.tables[i].name === type) {
						this.table = this.tables[i];
						if (this.table.isSelected())
							break;
						this.table.setSelected(true);
						if (this.isDrawed)
							this.table.typeChange();
						break;
					}
				}
			}
		}
	});

	var AbstractTable = base.Container.extend({
				initProps : function($super, cfg) {
					$super(cfg);
					// 新增简单无数据展示选项
					this.norecodeLayout = cfg.norecodeLayout || 'default';
					this.queue = [];
				},
				
				startup : function($super) {
					this.on('load', this.bindEvent, this);
					$super();
				},

				setSelfInit : function(flag) {
					this.selfTable = flag;
				},

				isSelfInit : function(flag) {
					return this.selfTable || false;
				},

				getData : function() {
					return this.datas;
				},
				isSelected : function() {
					return this.selected == 'false' ? false : true;
				},
				setSelected : function(selected) {
					this.selected = '' + selected;
				},
				clearHtml : function() {
				},
				responseCheckboxSelected : function() {
				},
				resolveUrl : function() {
				},
				noRecodeLoaded : function() {
				},
				runQueue : function() {
					this.queue.shift();
					if( this.queue.length > 0 )
						this.queueGet(this.queue[0]);
				},
				doLayout : function(html) {
					this.runQueue();
				},
				renderLoaded : function(){
					this.runQueue();
				}
			});

	var ResourceTable = {
		buildUrl : function(ps, page, sorts, others) {
			var urlParam = serializeParams(ps);
			if (this.source.resolveUrl)
				this.source.resolveUrl();
			if (this.source.url) {
				if (urlParam) {
					if (this.source.url.indexOf('?') > 0) {
						this.source.url += "&" + urlParam;
					} else {
						this.source.url += "?" + urlParam;
					}
				}
				// 重复参数采取替换方式
				this.source.url = this.replaceParams(page, this.source.url);
				this.source.url = this.replaceParams(sorts, this.source.url);
				if (others)
					this.source.url = this.replaceParams(others,
							this.source.url);
				if (window.console) {
					console.info('listview:source:url', this.source.url);
				}
			}
			return this.source.url;
		},
		
		_resolveUrls : function(cacheEvt){
			var cache = cacheEvt, ps;
			this.page = [];
			for (var kk in cache) {
				if (cache[kk].query)
					this.parent.query = cache[kk].query;
				if (cache[kk].criterions)
					this.parent.criterions = cache[kk].criterions;
				if (cache[kk].page)
					this.page = cache[kk].page;
				if (cache[kk].sorts)
					this.parent.sorts = cache[kk].sorts;
				if (cache[kk].others)
					this.parent.others = cache[kk].others;
			}
			return this.buildUrl(this.parent.criterions.concat(this.parent.query),
					this.page, this.parent.sorts, this.parent.others);
			
		},

		// 缓存数据拼装
		resolveUrls : function(cacheEvt) {
			var url = this._resolveUrls(cacheEvt);
			this.onSourceGet();
			return url;
		},

		bindEvent : function() {
			var self = this;
			this.element.find('input[type=checkbox][name!="List_Tongle"]')
					.each(function() {
								$(this).bind('click', function(evt) {
											evt.stopPropagation();
										})
							})
			this.element.find('[data-lui-mark-id]').each(function() {
						$(this).click(function(evt) {
									self.onClick(evt);
								});

						if (self.rowHref || self.onRowClick) {
							$(this).css('cursor', 'pointer');
						}
					});
		},

		resolveUrl : function(params) {
			params = params == null ? {} : params;
			this.parent.query = params.query || this.parent.query || [];
			// 暂时增加query属性支持额外参数查询
			this.parent.criterions = params.criterions
					|| this.parent.criterions || [];
			this.page = params.page || this.page || [];
			this.parent.sorts = params.sorts || this.parent.sorts || [];

			this.buildUrl(this.parent.criterions.concat(this.parent.query),
					this.page, this.parent.sorts);
			this.onSourceGet();
		},

		replaceParam : function(param, value, url) {
			var re = new RegExp();
			re.compile("([\\?&]" + param + "=)[^&]*", "i");
			if (value == null) {
				if (re.test(url)) {
					url = url.replace(re, "");
				}
			} else {
				value = encodeURIComponent(value);
				if (re.test(url)) {
					url = url.replace(re, "$1" + value);
				} else {
					url += (url.indexOf("?") == -1 ? "?" : "&") + param + "="
							+ value;
				}
			}
			if (url.charAt(url.length - 1) == "?")
				url = url.substring(0, url.length - 1);
			return url;
		},

		replaceParams : function(params, url) {
			for (var i = 0; i < params.length; i++) {
				var p = params[i];
				for (var j = 0; j < p.value.length; j++) {
					url = this.replaceParam(p.key, p.value[j], url);
				}
			}
			return url;
		},

		setSource : function(_source) {
			this.source = _source;
			this.source.parent = this;
		},

		// 返回选中的数据
		responseCheckboxSelected : function() {
			var evt = {
				'name' : SELECTED_RESPONSE,
				'table' : this,
				'datas' : []
			};

			var self = this;
			this.element.find('[data-lui-mark="table.content.checkbox"]').each(
					function() {
						if (this.checked) {
							var $parent = $(this);
							while ($parent.length > 0) {
								var rowId = $parent.attr('data-lui-mark-id');
								if (rowId) {
									for (var i = 0; i < self.kvData.length; i++) {
										if (rowId === self.kvData[i]['rowId']) {
											evt.datas
													.push(self.kvData[i]['fdId']);
											break;
										}
									}
									break;
								}
								$parent = $parent.parent();
							}
						}
					});
			this.fire(evt);
			return evt;
		},
		onClick : function(evt) {
			var $target = $(evt.target);
			var goon = true;
			var tagName = evt.target.tagName.toUpperCase();
			if (tagName == 'A' || tagName == 'INPUT')
				goon = false;
			while ($target.length > 0) {
				if ($target.attr('data-lui-mark-id')) {
					if (!goon)
						return;
					var code = '';
					var rowId = $target.attr('data-lui-mark-id');
					if (this.rowHref) {

						for (var j = 0; j < this.kvData.length; j++) {
							if (rowId === this.kvData[j]['rowId']) {
								var href = strutil.variableResolver(
										this.rowHref, this.kvData[j])
								code = ["window.open('",
										env.fn.formatUrl(href), "','",
										this.target, "')"].join('');
								break;
							}
						}

					} else if (this.onRowClick) {
						for (var j = 0; j < this.kvData.length; j++) {
							if (rowId === this.kvData[j]['rowId']) {
								code = strutil.variableResolver(
										this.onRowClick, this.kvData[j]);
								break;
							}
						}
					}

					new Function(code).apply(this.element.get(0));
					break;
				}
				$target = $target.parent();
			}
		},

		typeChange : function(evt) {
			this.parent.clearSelected();
			this.setSelected(true);
			this.parent.typeChange();
		},
		
		onSourceGet : function() {
			if (!this.parent.sourceURL
					|| this.parent.sourceURL != this.source.url) {
				this.queue.push(this.source.url);
				this.parent.sourceURL = this.queue[0];
				if(this.queue.length > 1)
					return;
				this.source.get();
			} else {
				this.onSourceLoaded($.extend(true, {}, this.parent._data));
			}
		},
		
		// 队列数据抓取
		queueGet : function(url) {
			if (!this.parent.sourceURL
					|| this.parent.sourceURL != url) {
				this.parent.sourceURL = url;
				this.source.url = url;
				this.source.get();
			} else {
				this.onSourceLoaded($.extend(true, {}, this.parent._data));
			}
		},
		
		// 对外替换数据源使用
		redrawBySource : function(_source) {
			if (_source == this.source) {
				return;
			}
			this.source.destroy();
			this.setSource(_source);
			this.source.on('data', this.onSourceLoaded, this);
			this.clearHtml();
			this.onSourceGet();
		},

		noRecode : function() {
			this.runQueue();
			var self = this;
			var __url = "";
			if (self.norecodeLayout === 'default')
				__url = '/resource/jsp/list_norecord.jsp';
			if (self.norecodeLayout === 'simple')
				__url = '/resource/jsp/list_norecord_simple.jsp';
			if (self.norecodeLayout === 'none')
				__url = '';
			if(__url!=''){
				$.ajax({
							url : env.fn.formatUrl(__url),
							dataType : 'text',
							success : function(data, textStatus) {
								self.noRecodeLoaded(data);
								// 补充加载完毕事件
								topic.channel(self.parent).publish(LIST_LOADED, {
											'listview' : self.parent,
											'table' : self
										});
							}
						});
			}else{
				//self.noRecodeLoaded(null);
				topic.channel(self.parent).publish(LIST_LOADED, {
					'listview' : self.parent,
					'table' : self
				});
			}
		}
	};

	function serializeParams(params) {
		var array = [];
		for (var i = 0; i < params.length; i++) {
			var p = params[i];
			if (p.nodeType) {
				array.push('nodeType=' + p.nodeType);
			}
			for (var j = 0; j < p.value.length; j++) {
				array.push("q." + encodeURIComponent(p.key) + '='
						+ encodeURIComponent(p.value[j]));
			}
			if (p.op) {
				array.push(encodeURIComponent(p.key) + '-op='
						+ encodeURIComponent(p.op));
			}
			for (var k in p) {
				if (k == 'key' || k == 'op' || k == 'value' || k == 'nodeType') {
					continue;
				}
				array.push(encodeURIComponent(p.key + '-' + k) + "="
						+ encodeURIComponent(p[k] || ""));
			}
		}
		var str = array.join('&');
		return str;
	}

	exports.ListView = ListView;
	exports.AbstractTable = AbstractTable;
	exports.UniqueId = UniqueId;
	exports.ResourceTable = ResourceTable;
});