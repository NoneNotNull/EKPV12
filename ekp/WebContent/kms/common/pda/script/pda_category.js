~~function(win) {
	Pda.Base.Widget.register('category');
	Pda.Category = Pda.Panel.extend({

		init : function(options) {
			this._super(options);
			this.modelName = options.modelName;
			this.mainModelName = options.mainModelName;
			this.href = options.href;
			this.isSelect = options.isSelect ? true : false;
			this.children = [];
			// 当前分类是否有效，用于分类选择权限控制
			this.disable = options.disable;
		},

		startup : function() {
			this._super();
			if (!this.___c__config) {
				var component = this.target.find('[data-lui-role="component"]');
				this.___c__config = Pda.Util.toJSON($(component)
						.find("script[type='text/config']").html());
			}
		},

		draw : function() {
			this._super();
			this.bindClick();
		},

		bindClick : function() {
			var self = this;
			this.target.on('click', function(evt) {
						var $target = $(evt.target);
						// 点击具体分类
						if ($target.hasClass('lui-category-subject')) {
							// 优先缓存中获取
							var fdId = $target.attr('data-lui-id');
							var fdName = $target.text();
							var disable = $target.attr('data-lui-disable');
							var cache = self.getCache(fdId);
							if (cache) {
								cache.slideLeft();
								return;
							}
							var options = {
								parentData : {
									parentId : fdId
								}
							};
							$.extend(options, self.___c__config);
							var sub_com = new Pda.Component(options);
							// 监控是否有筛选项
							var hasFilter = {};
							sub_com.format = function(txt) {
								hasFilter._ = txt.filter;
								if (txt.list)
									return txt;
								else
									return null;
							}
							sub_com.startup();
							sub_com.on('dataoff', function() {
										if (self.isSelect)
											sub_com.emit({
														type : 'dataon',
														data : ''
													});
										else
											self.emitSlide(self, fdId, fdName,
													hasFilter._);
									});
							if (self.isSelect)
								self.buildSub(sub_com, fdId, fdName,
										hasFilter._, disable);
							else
								sub_com.on('dataon', function() {
											self.buildSub(sub_com, fdId,
													fdName, hasFilter._,
													disable);
										});
							sub_com.draw();
						}

						var m = 'data-category-type';
						// 返回
						if ($target.hasClass('lui-back-icon'))
							self.slideLeft__();
						// 文档
						if ($target.attr(m) == 'doc')
							self.buildDoc($target);
						// 确定--用于选择分类
						if ($target.attr(m) == 'ok')
							self.buildOk($target);
					});
		},

		buildOk : function($target) {
			Pda.Topic.emit({
						type : 'category-select-ok',
						id : this.parentId,
						name : this.parentName
					});
			this.slideLeft___();
		},

		buildSub : function(sub_com, fdId, fdName, hasFilter, disable) {
			var sub = new Pda.Category({
						modelName : this.modelName,
						mainModelName : this.mainModelName,
						href : this.href,
						width : this.width,
						isSelect : this.isSelect,
						mask : this.mask,
						canClose : this.canClose,
						disable : disable
					});
			sub.hasFilter = hasFilter ? hasFilter : false;
			sub.___c__config = this.___c__config;
			sub.parent = this;
			sub.parentName = fdName;
			sub.parentId = fdId;
			this.children.push(sub);
			sub_com.parent = sub;
			sub.target.append(sub_com.target);
			sub.startup();
			sub.draw();
			sub.slideLeft();
		},

		bindMaskClick : function(self) {
			this.mask.off().on('click', function() {
						if (self.canClose != false) {
							if (self.isSelect)
								self.slideLeft___();
							else
								self.slideLeft__();
						}
					});
		},

		buildDoc : function() {
			this.emitSlide(this, this.parentId, this.parentName);
		},

		emitSlide : function(claz, cateId, cateName, hasFilter) {
			var self = this;
			Pda.Topic.emit({
						type : 'listChange',
						categoryId : cateId,
						categoryName : cateName,
						target : claz,
						hasFilter : hasFilter ? hasFilter : self.hasFilter
					});
			this.slideLeft___();
		},

		// 点击确定关闭所有分类弹出层
		slideLeft___ : function() {
			var parent = this;
			while (parent) {
				// 所有弹出强制关闭（包括最顶层）
				parent.slideLeft__(true);
				parent = parent.parent;
			}
		},

		getCache : function(fdId) {
			var __ = this.children;
			for (var index = 0; index < __.length; index++) {
				var cate = __[index];
				if (cate['parentId'] && cate['parentId'] == fdId)
					return cate;
			}
			return null;
		},

		destroy : function() {
			if (this.child)
				this.child.destroy();
			this._super();
			if (this.target) {
				this.target.off();
				this.target.remove();
				this.target = null;
			}
		},

		// fire 强制关闭，点击确定时可以关
		slideLeft__ : function(fire) {
			var recover = true;
			if (this.parent) {
				recover = false;
				if (this.isSelect)
					this.parent.bindMaskClick(this.parent);
			} else if (this.canClose == false && !fire)
				// 最顶层分类，canClose为false时不可关闭，fire表示强制关闭，在点击确定时使用
				return;
			this._super(recover);
		},

		hideMask : function() {
			if (this.parent && this.isSelect)
				return;
			this._super();
		},

		buildFilter : function(category, href, fdId, fdName) {
			var filter = this.getFilter(category, href, fdId, fdName);
			filter.slideLeft();
		},

		getFilter : function(category, href, fdId, fdName) {
			var filter = this.getFilterCache(fdId);
			if (filter)
				return filter;
			filter = new Pda.Filter({
						parent : category,
						href : href,
						parentId : fdId,
						parentName : fdName
					});
			filter.startup();
			filter.draw();
			return filter;

		},

		// 根据分类id获取缓存中的属性模板
		getFilterCache : function(cateId) {
			var arr = Pda.Role('filter'), i = 0;
			while (i < arr.length) {
				if (arr[i].__parentId == cateId)
					return arr[i];
				i++;
			}
			return null;
		},

		// 对外方法，供筛选使用
		doFilter : function() {
			Pda.Topic.on('listChange', function(evt) {
				var claz = evt.target, fdId = evt.categoryId, fdName = evt.categoryName;
				claz.buildFilter(claz, claz.href, fdId, fdName);
			});
		}
	});
}(window);
~~function() {

	Pda.Base.Widget.register('filter');
	Pda.Filter = Pda.Category.extend({

		role : 'filter',
		init : function(options) {
			this._super(options);
			this.parent = options.parent;
			this.parentId = options.parentId + 'filter'
			this.__parentId = options.parentId;
			this.parentName = options.parentName;
			this.modelName = this.parent.modelName;
			this.mainModelName = this.parent.mainModelName;
			this.comOptions = options.comOptions || {};
			this.href = options.href;
			this.filterData = {};
		},

		startup : function() {
			this._super();
			var self = this;
			var ___ = {
				source : {
					url : Pda.Util
							.formatUrl('/sys/property/sys_property_filter_pda/sysPropertyFilterPda.do?method=getPropertyFilter&modelName='
									+ self.modelName
									+ '&fdCategoryId='
									+ self.__parentId
									+ '&mainModelName='
									+ self.mainModelName),
					type : 'ajaxJson'
				},
				render : {
					url : Pda.Util
							.formatUrl('/kms/common/pda/core/category/tmpl/filter.jsp')
				},
				lazy : true
			};
			$.extend(___, this.comOptions);
			this.filter = new Pda.Component(___);

			this.target.append(this.filter.target);
			this.filter.parent = this;
			this.child = this.filter;
			this.filter.startup();
		},

		bindClick : function(evt) {
			var self = this;
			self.target.on('click', function(evt) {
						var $target = $(evt.target);
						// 返回
						if ($target.hasClass('lui-back-icon'))
							self.slideLeft__();
						// 构建筛选项
						if ($target.hasClass('lui-filter-item'))
							self.buildItem(evt);

						if ($target.hasClass('lui-category-submit-btn'))
							self.filterSubmit();
					});
		},

		filterSubmit : function() {
			var self = this;
			var data = this.filterData;
			Pda.Topic.emit({
						type : 'listChange',
						data : data,
						categoryId : self.__parentId
					});
			this.slideLeft__();
		},

		draw : function() {
			this._super();
			this.filter.draw();
		},

		buildItem : function(evt) {
			var data = this.filter.__data__;
			if (!data || !data['filters'])
				return;

			var $target_filter = $(evt.target);
			var $prev = $target_filter.prev();
			var fdId = $prev.attr('data-lui-id');
			var fdName = $prev.text();
			$prev = null;
			var arr = [];
			for (var i = 0; i < data['filters'].length; i++) {
				if (fdId == data['filters'][i]['settingId']) {
					arr = data['filters'][i]['options'];
					break;
				}
			}
			var element = new Pda.Component({
				source : {
					data : arr,
					type : 'static'
				},
				render : {
					url : Pda.Util
							.formatUrl('/kms/common/pda/core/category/tmpl/item.jsp')
				}
			});
			element.startup();
			element.draw();

			var dialog = Pda.delement({
						title : fdName,
						element : element.target
					});
			dialog.show();

			var self = this;
			element.target.on('click', function(evt) {
						var $target = $(evt.target);
						if ($target.hasClass('lui-filter-item-subject')) {
							var val = $target.attr('data-lui-id');
							var text = $target.text();
							self.setFilterData(fdId, val);
							$target_filter.html(text);
							dialog.hide();
						}
						$target = null;
					});
		},

		getFilterData : function(key) {
			return this.filterData[key];
		},

		setFilterData : function(key, value) {
			this.filterData[key] = value;
		},

		emptyFilterData : function() {
			this.filterData = {};
		}
	});

	// opts = {modelName:'',action:''}
	Pda.simpleCategoryForNewFile = function(opts) {

		var id = 'category-select-panel';
		if (Pda.Element(id)) {
			// 已经有值，可以关闭
			if (typeof(opts.canClose) != "undefined"
					&& opts.canClose != Pda.Element(id).canColse) {
				Pda.Element(id).canClose = opts.canClose;
				for (var i = 0; i < Pda.Element(id).children.length; i++) {
					Pda.Element(id).children[i].canClose = opts.canClose;
				}
			}
			Pda.Element(id).slideLeft();
			return;
		}
		var modelName = opts.modelName;

		// 扩展参数
		var params = opts.params;

		var sourceurl = Com_Parameter.ContextPath
				+ 'kms/common/kms_common_simple_category/KmsCommonSimpleCategory.do?method=list&type=2&authType=2&modelName='
				+ modelName + '&parentId=!{parentId}';
		if (params) {
			var array = [];
			for (var kk in params) {
				array.push('qq.' + encodeURIComponent(kk) + '='
						+ encodeURIComponent(params[kk]));
			}
			sourceurl += ('&' + array.join('&'));
		}
		var options = {
			source : {
				url : sourceurl,
				type : 'ajaxJson'
			},
			render : {
				url : Com_Parameter.ContextPath
						+ 'kms/common/pda/core/category/tmpl/category_select.jsp'
			},
			lazy : true,
			parent : id
		};

		Pda.Topic.on('category-select-ok', function(evt) {
					opts.action(evt)
				});

		var sub_com = new Pda.Component(options);
		sub_com.startup();
		var sub = new Pda.Category({
					modelName : modelName,
					id : id,
					width : 0.8,
					isSelect : true,
					mask : true,
					canClose : opts.canClose
				});
		sub_com.parent = sub;
		sub.___c__config = options;
		sub.target.append(sub_com.target);
		sub.startup();
		sub.draw();
		sub.slideLeft();
		____pda__cache____[id] = sub;
		sub_com.draw();
	};
}(window);