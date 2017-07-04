define(function(require, exports, module) {
	var base = require('lui/base');
	var layout = require('lui/view/layout');
	var render = require('lui/view/render');
	var source = require('lui/data/source');
	var $ = require('lui/jquery');
	var tmpl = require("lui/view/Template");
	var env = require("lui/util/env");
	var topic = require('lui/topic');
	var dialog = require('lui/dialog');
	var lang = require('lang!sys-ui');

	var CATEGORY_SELECTE_DCHANGE = "category.selected.changed";
	var CATEGORY_QSEARCH = "category.qsearch";
	var CATEGORY_REFRESH_SCROLL = "category.refresh.scroll";

	var CLASSNAME = {
		SELECTED : 'lui_category_qsearch_selected',
		UNSELECTED : 'lui_category_qsearch_unselected',
		ITEMON : 'lui_category_li_on',
		ITEMNEXT : 'lui_category_itemLink_next'
	};

	var Category = base.Container.extend({

				initProps : function($super, cfg) {
					$super(cfg);
					exports.url = this.config.url;
					this.mul = this.config.mulSelect;
					this.elem = $(this.config.elem);
					this.currId = this.config.currId;
					this.errorMsg = this.config.errorMessage;
					this.showFavorite = (this.config.noFavorite == 'true'
							|| this.config.noFavorite === true ? false : true);
					this.startup();
				},

				isMul : function() {
					return this.mul == "false" ? false : true;
				},

				startup : function() {
					if (!this.layout) {
						this.setLayout(new layout.Template({
									src : require.resolve('./category.html#'),
									parent : this
								}));
						this.layout.startup();
						this.children.push(this.layout);
					}
					if (!this.selectedValues) {
						this.selectedValues = new SelectedValues({
									parent : this
								});
					}
					if (!this.nav && !this.isMul()) {
						this.nav = new Nav({
									parent : this
								});
						this.children.push(this.nav);
					}
					if (!this.qSearch) {
						this.qSearch = new QSearch({
									parent : this
								});
						this.children.push(this.qSearch);
					}

					if (!this.selectedBox && this.isMul()) {
						this.selectedBox = new SelectedBox({
									parent : this
								});
						this.children.push(this.selectedBox);
					}

					if (!this.selectArea) {
						this.selectArea = new SelectArea({
									currId : this.currId,
									parent : this
								});
						this.children.push(this.selectArea);
					}

					if (!this.gCategory && this.showFavorite) {
						this.gCategory = new GCategory({
									parent : this
								});
						this.children.push(this.gCategory);
					}
				},

				setLayout : function(_layout) {
					this.layout = _layout;
				},

				doLayout : function(obj) {
					this.elem.append(this.element);
					this.element.append($(obj));
					this.__nav = this.element
							.find('[data-lui-mark="category.nav"]');
					this.__selectArea = this.element
							.find('[data-lui-mark="category.selectarea"]');
					this.__selectedBox = this.element
							.find('[data-lui-mark="category.selectedbox"]');
					this.__qSearch = this.element
							.find('[data-lui-mark="category.qsearch"]');
					this.__gCategory = this.element
							.find('[data-lui-mark="category.gcategory"]');
					for (var i = 0; i < this.children.length; i++) {
						if (this.children[i] instanceof Nav) {
							this.children[i].setParentNode(this.__nav);
						}
						if (this.children[i] instanceof QSearch) {
							this.children[i].setParentNode(this.__qSearch);
						}
						if (this.children[i] instanceof SelectArea) {
							this.children[i].setParentNode(this.__selectArea);
						}
						if (this.children[i] instanceof SelectedBox) {
							this.children[i].setParentNode(this.__selectedBox);
						}
						if (this.children[i] instanceof GCategory) {
							this.children[i].setParentNode(this.__gCategory);
						}
						if (this.children[i].draw) {
							this.children[i].draw();
						}
					}
				}
			});

	// 导航
	var Nav = base.Container.extend({
				initProps : function($super, cfg) {
					$super(cfg);
					this.data = [];
					this.startup();
				},
				draw : function($super) {
					$super();
				},
				setLayout : function(_layout) {
					this.layout = _layout;
				},
				startup : function() {
					if (!this.layout) {
						this.setLayout(new layout.Template({
									src : require.resolve('./nav.jsp#'),
									parent : this
								}));

						this.layout.startup();
						this.children.push(this.layout);
					}

					topic.subscribe(CATEGORY_SELECTE_DCHANGE,
							this.selectedChanged, this);
				},
				doLayout : function(obj) {
					this.element.html($(obj));
				},
				selectedChanged : function(evt) {
					this.erase();
					this.data.length = 0;
					if (evt && evt.data) {

						for (var i = 0; i < evt.data.length; i++) {
							this.data.push(evt.data[i]['data']);
						}
					}
					this.draw();
				}
			});

	// 快速搜索
	var QSearch = base.Container.extend({
				initProps : function($super, cfg) {
					$super(cfg);
					this.startup();
				},

				startup : function() {
					if (!this.layout) {
						this.setLayout(new layout.Template({
									src : require.resolve('./q-search.jsp#'),
									parent : this
								}));
						this.layout.startup();
						this.children.push(this.layout);
					}
				},
				setLayout : function(_layout) {
					this.layout = _layout;
				},
				doLayout : function(obj) {
					this.element.append($(obj));
					var self = this;
					this.element.bind({
								'click' : function(evt) {
									self.onClick(evt);
								},
								'keydown' : function(evt) {
									self.onEnter(evt);
								}
							});
					LUI.placeholder(this.element);
				},

				onSearch : function(evt) {
					var input = this.element
							.find('[data-lui-mark="search.input"]');
					var evt = {
						searchText : encodeURIComponent(input.val()),
						type : '03'
					};
					topic.publish(CATEGORY_QSEARCH, evt);
				},

				onClick : function(evt) {
					var $target = $(evt.target);
					if ($target.attr('data-lui-mark') == "search.btn") {
						this.onSearch(evt);
					}
				},

				onEnter : function(evt) {
					var $target = $(evt.target);
					if ($target.attr('data-lui-mark') === 'search.input'
							&& evt.keyCode == 13) {
						this.onSearch(evt);
					}
				}
			});

	// 常用分类
	var GCategory = base.DataView.extend({
		initProps : function($super, cfg) {
			$super(cfg);
			this.startup();
		},
		startup : function($super) {
			if (!this.render) {
				this.setRender(new render.Template({
							src : require.resolve('./g-category.jsp#'),
							parent : this
						}));
				this.render.startup();
				this.children.push(this.render);
			}
			if (!this.source) {
				var url = '/sys/person/sys_person_favorite_category/sysPersonFavoriteCategory.do?method=favorite&modelName='
						+ this.parent.config.modelName;
				this.setSource(new source.AjaxJson({
							url : url,
							parent : this
						}));
				this.children.push(this.source);
			}
			$super();
			this.selectedValues = this.parent.selectedValues;
			this.bindAddFavorite();
			this.bindSelectFavorite();
			topic.subscribe(CATEGORY_SELECTE_DCHANGE, this.selectedChanged,
					this);
		},

		selectedChanged : function(evt) {
			if (evt && evt._data) {
				if (!this.selectBox)
					this.selectBox = this.element
							.find('.lui_category_gcategory_select_favorite');
				var value = evt._data.value;
				if (value && value != this.selectBox.val()) {
					var __in__ = false;
					this.selectBox.find('option').each(function() {
								if (value === $(this).val()) {
									__in__ = true;
									return;
								}
							});
					if (!__in__)
						value = undefined;
					this.selectBox.val(value);
				}
			}
		},

		bindSelectFavorite : function() {
			var self = this;
			this.element.delegate('.lui_category_gcategory_select_favorite',
					'change', function(evt) {
						var $target = $(evt.target);
						var __val = $target.val()
						if (!__val)
							return;
						self.parent.selectArea.selectBlock
								.redrawHierarchyBlock(__val, $target);
					});
		},
		bindAddFavorite : function() {
			var self = this;
			var modelName = this.parent.config.modelName;
			this.element.delegate('.lui_category_gcategory_add_favorite',
					'click', function() {
						var selArray = self.selectedValues.get();
						var ids = [], names = [];
						$.each(selArray, function(k, vals) {
							for (var i = 0; i < vals.data.length; i++) {
								var val = vals.data[i];
								if (!val.nodeType || val.nodeType == 'template') {
									ids.push(val.value);
									names.push(val.text);
									break;
								}
							}
						});
						if (ids.length == 0) {
							dialog.alert(self.parent.errorMsg);
							return;
						}
						var url = '/sys/person/sys_person_favorite_category/sysPersonFavoriteCategory.do?method=quickAdd';
						var data = {
							modelName : modelName,
							ids : ids,
							names : names
						};
						$.ajax({
									type : "POST",
									url : require.resolve(env.fn.formatUrl(url)
											+ "#"),
									data : $.param(data, true),
									dataType : 'json',
									success : function(result) {
										dialog.success(result.msg,
												$(window.frameElement));
										if (self.source)
											self.source.get();
									},
									error : function(result) {
										dialog.failure(result.msg,
												$(window.frameElement));
									}
								});
					});
		}
	});

	// 选择区域
	var SelectArea = base.Container.extend({
				initProps : function($super, cfg) {
					$super(cfg);
					this.startup();
				},

				isMul : function() {
					if (!this.parent.isMul) {
						return true;
					}
					return this.parent.isMul();
				},

				getCurrId : function() {
					return this.config.currId ? this.config.currId : '';
				},

				startup : function($super) {
					$super();
					if (!this.layout) {
						this.setLayout(new layout.Template({
									src : require.resolve('./select-area.jsp#'),
									parent : this
								}));
						this.layout.startup();
						this.children.push(this.layout);
					}
					if (!this.selectedValues) {
						this.selectedValues = this.parent.selectedValues;
					}
					if (!this.selectBlock) {
						if (this.isMul())
							this.selectBlock = new MulSelectBlock({
										parent : this,
										currId : this.getCurrId()
									});
						else
							this.selectBlock = new SingleSelectBlock({
										parent : this,
										currId : this.getCurrId()
									});

						this.children.push(this.selectBlock);
					}

					var self = this;
					this.element.bind('click', function(evt) {
								self.onClick(evt);
							});

					topic.subscribe(CATEGORY_REFRESH_SCROLL,
							this.scrollRefresh, this);
				},
				// 滑动按钮样式更新
				scrollRefresh : function(evt) {
					if (!evt || !evt.__type__)
						return;
					this.__scorllRefresh(evt);
				},

				__scorllRefresh : function(evt) {
					var ___ = this.element.find('[data-lui-mark="scroll.'
							+ evt.__type__ + '"]');
					if (true == evt.__scroll__)
						___.addClass('validity');
					else
						___.removeClass('validity');
				},

				onClick : function(evt) {
					var $target = $(evt.target);
					while ($target.length > 0) {
						if ($target.attr('data-lui-mark') === 'scroll.right') {
							this.selectBlock.scrollRight();
							break;
						}
						if ($target.attr('data-lui-mark') === 'scroll.left') {
							this.selectBlock.scrollLeft();
							break;
						}
						$target = $target.parent();
					}
				},

				setLayout : function(_layout) {
					this.layout = _layout;
				},

				doLayout : function(obj) {
					this.element.append($(obj));
					this.area = this.element
							.find('[data-lui-mark="select.area.content"]');
					for (var i = 0; i < this.children.length; i++) {
						var c = this.children[i];
						if (c instanceof SelectBlock) {
							c.setParentNode(this.area);
							c.draw();
						}
					}
				}
			});

	// 选择区块
	var SelectBlock = base.DataView.extend({
		initProps : function($super, cfg) {
			$super(cfg);
			this.index = 0;
			this.searchText = '';
			this.max = 3;
			this.slot = 0;
			this.startup();
		},

		startup : function($super) {

			if (!this.source) {
				this.setSource(new source.AjaxJson({
							url : exports.url,
							parent : this
						}));
				var type = this.config.currId
						? (!this.isMul ? '02' : '04')
						: '03';
				var param = {
					currId : this.config.currId,
					type : type
				};
				this.source.resolveUrl(param);
				this.children.push(this.source);

			}
			if (!this.selectedSource) {
				this.selectedSource = new SelectedSource();
			}

			if (!this.selectedValues) {
				this.selectedValues = this.parent.selectedValues;
			}

			topic.subscribe(CATEGORY_SELECTE_DCHANGE, this.selectedChanged,
					this);
			topic.subscribe(CATEGORY_QSEARCH, this.qSearchChanged, this);

			var self = this;
			this.element.bind('click', function(evt) {
						self.onClick(evt);
					});

			this.element.bind('dblclick', function(evt) {
						self.onDblclick(evt);
					});

			this.element.bind('keydown', function(evt) {
						self.onEnter(evt);
					});
			$super();
		},

		qSearchChanged : function(evt) {
			this.source.resolveUrl(evt);
			this.source.url += "&qSearch=true";
			this.source.get(function(data) {
						data = {
							type : 'qsearch',
							data : data[0]
						};
						return data;
					});
		},

		getSelectedBlock : function() {
			var arr = [];
			this.element.find('[data-lui-block-index]').each(function() {
						arr.push($(this));
					});
			return arr;
		},

		scrollLeft : function() {
			var sb = this.getSelectedBlock();
			if (this.slot > 0) {
				if (this.slot + this.max - 1 <= sb.length
						&& sb[this.slot + this.max - 1]
						&& sb[this.slot + this.max - 1].css('display') != 'none') {
					sb[this.slot + this.max - 1].hide();
				}
				if (this.slot >= 1
						&& sb[this.slot - 1].css('display') === 'none') {
					sb[this.slot - 1].show();
					this.slot--;
				}
			}
			this.refreshScroll(sb);
		},

		scrollRight : function() {
			var sb = this.getSelectedBlock();
			if (sb.length > this.max) {
				if (sb.length - this.slot > this.max) {
					if (sb[this.slot].css('display') != 'none') {
						sb[this.slot].hide();
						this.slot++;
					}
					if ((this.slot + this.max - 1) < sb.length) {
						sb[(this.slot + this.max - 1)].show();
					}
				}
			}
			this.refreshScroll(sb);
		},

		// 是否可滚动样式提示
		refreshScroll : function(sb) {
			if (sb.length == 0)
				return;

			var __evt = {
				'__type__' : 'left'
			}
			if (sb[0].css('display') == 'none')
				__evt['__scroll__'] = true;
			else
				__evt['__scroll__'] = false;
			topic.publish(CATEGORY_REFRESH_SCROLL, __evt);

			var ___evt = {
				'__type__' : 'right'
			};
			if (sb[sb.length - 1].css('display') == 'none')
				___evt['__scroll__'] = true;
			else
				___evt['__scroll__'] = false;
			topic.publish(CATEGORY_REFRESH_SCROLL, ___evt);
		},

		selectedChanged : function(evt) {
			if (evt && evt._data) {
				// 分级联动
				var data = evt._data;
				this.blockSelectedChanged(data);
				this.qSearchSelectedChanged(data);
			}
		},

		qSearchRender : function(data) {
		},

		hSearchRender : function(data) {
		},

		triggerExpandCate : function($target) {
		},

		getQSearchInnerHTML : function(data) {
		},

		onClick : function(evt) {
		},

		onDblclick : function(evt) {
		},

		onEnter : function(evt) {
			var $target = $(evt.target);
			while ($target.length > 0) {
				if ($target.attr('data-lui-mark') === 'search.input') {
					if (evt.keyCode == 13)
						this.triggerBlockSearch($target.prev());
					break;
				}
				$target = $target.parent();
			}
		},

		getSelectedVal : function(data) {
			var selected = {};
			if (data && data.length > 0) {
				var pa = [];
				for (var i = data.length - 1; i >= 0; i--) {
					var d = data[i];
					var value = "";
					for (var j = 0; j < d.length; j++) {
						if (d[j].selected && d[j].selected == true) {
							value = d[j].value;
							var p = {
								value : d[j].value,
								text : d[j].text
							};
							pa.push(p);
							break;
						}
					}
				}
				selected = {
					value : value,
					data : pa
				};
			}
			return selected;
		},

		doRender : function($super, html) {
			this.loading.remove();
			if (html)
				this.element.append(html);
			this.scrollRight();

			if (this.isInit) {
				this.isInit = false;
			}
			this.lock = false;
		},

		// 快速搜索数据源解析
		getSelectedItemDataByQSearch : function(fdId) {
			var dd, dt = [], id = fdId, qs = this.qsearchSource;
			for (var j = 0; j < qs.length; j++) {
				if (qs[j]['value'] == id) {
					dt.push({
								value : id,
								text : qs[j]['text'],
								nodeType : qs[j]['nodeType']
							});
					break;
				}
			}
			dd = {
				value : fdId,
				data : dt
			};
			return dd;
		},

		// 标准数据源解析--根据当前id获取层级数据数组
		getSelectedItemData : function(fdId, i, _next) {
			var dd, dt = [], id = fdId, ss = this.selectedSource.get();
			if (ss[i]) {
				for (var kk = i; kk >= 0; kk--) {
					var data = ss[kk]['data'], len = ss[kk]['data'].length;
					for (var j = len - 1; j >= 0; j--) {
						if (data[j]['value'] === id) {
							dt.push({
										value : id,
										text : data[j]['text'],
										nodeType : data[j]['nodeType']
									});
							break;
						}
					}
					if (!ss[kk]['value']) {
						break;
					}
					id = ss[kk]['value'];
				}
			}
			dd = {
				value : fdId,
				_next : _next,
				data : dt
			};
			return dd;
		},
		triggerCloseQSearch : function() {
			if (this.qSearchDiv && this.qSearchDiv.length > 0) {
				var self = this;
				this.qSearchDiv.animate({
							width : 0
						}, {
							queue : false,
							duration : 500,
							complete : function() {
								self.qSearchDiv.remove();
								self.qSearchDiv = null;
							}
						});
			}
		},
		triggerBlockSearch : function($target) {
			var block = $target.parents('[data-lui-block-index]');
			this.index = parseInt(block.attr('data-lui-block-index')) - 1;
			var $input = $target.next();
			var ss = this.selectedSource.get();
			this.value = ss[this.index].value;
			var param = {
				parentId : this.value,
				searchText : encodeURIComponent($input.val()),
				type : '03'
			};
			this.source.resolveUrl(param);
			if (window.console) {
				console.log(this.source.url);
			}
			if (block.prev().length > 0)
				block.prev().nextAll().remove();
			else
				block.parent().children().remove();
			this.source.get(function(data) {
						data = {
							type : 'search',
							data : data
						};
						return data;
					});
		},
		triggerClickQsearchItem : function($target) {
			var id = $target.attr('data-lui-item-id');
			this.selectedQSearchdata = this.getSelectedItemDataByQSearch(id);
			var param = {
				currId : id,
				type : '01'
			};
			this.source.resolveUrl(param);
			this.source.get(function(data) {
						data = {
							type : 'hsearch',
							data : data
						};
						return data;
					});
		},

		qSearchRender : function(data) {
			var self = this;
			if (!this.qSearchDiv) {
				var parent = this.parent.element;
				// 去边框+去padding
				var w = parent.width() - 2 - 20, h = parent.height() - 2 - 10;
				var t = parent.position().top;
				this.qSearchDiv = $('<div>')
						.addClass('lui_category_qsearch_content');

				// 分割线
				var ______splitDiv = $('<div>')
						.addClass('lui_category_qsearch_split').css({
									height : h,
									position : 'fixed',
									left : w / 2,
									width : 1,
									'z-index' : 1000,
									top : t + 6
								}).appendTo(this.qSearchDiv);

				// 更换为表格布局，方便两列分布
				var $table = $('<table>').addClass('clearfloat')
						.appendTo(this.qSearchDiv);
				$table.css({
							width : w,
							'table-layout' : 'fixed'
						});

				this.qSearchDiv.appendTo(this.element);

				this.qSearchClose = $('<div data-lui-mark="qsearch.close">')
						.addClass('lui_icon_s_close_x')
						.addClass('lui_category_qsearch_close')
						.appendTo(this.qSearchDiv);

				this.qSearchDiv.css({
							position : 'absolute',
							width : 0,
							top : 0,
							left : 0,
							'z-index' : 999,
							'background-color' : '#eaf4fd',
							'height' : h
						});
				this.qSearchDiv.animate({
							width : w
						}, 300);
			}
			this.qSearchDiv.find('.clearfloat').each(function() {
						$(this).html(self.getQSearchInnerHTML(data));
					});
		},

		noRecode : function() {
			var self = this;
			$.ajax({
						url : env.fn
								.formatUrl('/resource/jsp/list_norecord.jsp'),
						dataType : 'text',
						success : function(data, textStatus) {
							self.noRecodeLoaded(data);
						}
					})
		},

		noRecodeLoaded : function(data) {
			this.element.html('<div style="float:left;width:90%">' + data
					+ '</div>');
		},

		redrawHierarchyBlock : function() {
		}

	});

	var SingleSelectBlock = SelectBlock.extend({
		startup : function($super) {
			this.isMul = false;
			if (!this.render) {
				this.setRender(new render.Template({
							src : require
									.resolve('./single-select-block.html#'),
							parent : this
						}));
				this.children.push(this.render);
				this.render.startup();
			}
			$super();
		},

		// 是否为初始数据
		_isInit : function(data) {
			var isInit = false;
			if (data.length > 1) {
				isInit = true;
			}
			if (data.length > 0 && data.length <= 1) {
				for (var j = 0; j < data[0].length; j++) {
					if (data[0][j].selected) {
						isInit = true;
						break;
					}
				}
			}
			return isInit;
		},
		hSearchRender : function(_data) {
			var dd = this.selectedQSearchdata;
			dd.data = dd.data.concat(_data.data);
			this.selectedValues.replace(dd);
		},

		qSearchSelectedChanged : function(data) {
			// 快速搜索联动
			if (this.qSearchDiv) {
				this.qSearchDiv.find('[data-lui-item-id]').each(function() {
							$(this).removeClass(CLASSNAME.SELECTED);
							if ($(this).attr('data-lui-item-id') == data.value) {
								$(this).addClass(CLASSNAME.SELECTED);
							}
						});
			}
		},

		blockSelectedChanged : function(_data) {
			var index = _data.data.length, b = this.element
					.find('[data-lui-block-index="' + index + '"]');
			b.find('[data-lui-mark="select.item.li"]').removeClass([
					CLASSNAME.ITEMON, CLASSNAME.ITEMNEXT].join(' '));
			b.find('[data-lui-item-id="' + _data.value + '"]').each(function() {
						var p = $(this);
						p.addClass(CLASSNAME.ITEMON);
						if (_data._next)
							p.addClass(CLASSNAME.ITEMNEXT);
					});
		},

		onClick : function(evt) {
			var $target = $(evt.target);
			while ($target.length > 0) {
				if ($target.attr('data-lui-mark') === 'qsearch.close') {
					this.triggerCloseQSearch();
					break;
				}

				// 快速搜索模板点击事件
				if ($target.attr('data-lui-mark') == "select.qsearch.li") {
					this.triggerClickQsearchItem($target);
					break;
				}

				// 内部搜索
				if ($target.attr('data-lui-mark') === "search.btn") {
					this.triggerBlockSearch($target);
					break;
				}

				// 点击展开下一级
				if ($target.attr('data-lui-mark') == "select.item.li") {
					var self = this;
					// 解决点击延迟效果
					$target.parent().find('[data-lui-mark="select.item.li"]')
							.removeClass(CLASSNAME.ITEMON);
					$target.addClass(CLASSNAME.ITEMON);
					if (this.____click____)
						clearTimeout(this.____click____);
					// 延迟加载单击事件，防止跟双击事件冲突
					this.____click____ = setTimeout(function() {
								self.triggerExpandCate($target);
							}, 200);
					break;
				}
				$target = $target.parent();
			}
		},

		// 双击菜单
		onDblclick : function(evt) {
			var $target = $(evt.target);
			while ($target.length > 0) {
				if ($target.attr('data-lui-mark') == "select.item.li") {
					// 清除单击事件
					if (this.____click____)
						clearTimeout(this.____click____);
					// 获取当前层级
					var ____val = $target.attr('data-lui-item-id'), ____block = $target
							.parents('[data-lui-block-index]');
					var data = this.getSelectedItemData(____val,
							parseInt(____block.attr('data-lui-block-index'))
									- 1);
					this.selectedValues.replace(data);
					// 强制触发确定
					if (window['$dialog']) {
						var btns = window['$dialog'].content.buttonsConfig;
						if (btns.length)
							btns[0].fn(true, window['$dialog']);
					}
					// 展开下一级
					// this.triggerExpandCate($target);
					break;
				}
				$target = $target.parent();
			}
		},

		onDataLoad : function(data) {
			if (!($.isArray(data))) {
				// 快速搜索
				if (data.type == 'qsearch') {
					data = data.data;
					this.qSearchRender(data);
					return;
				}
				// 快速搜索中项的层级获取
				if (data.type == 'hsearch') {
					this.hSearchRender(data);
					return;
				}
				// 分类同级搜索
				if (data.type == 'search') {
					this.index++;
					this.render.get(data.data);
					return;
				}
			}
			this.isInit = this._isInit(data);
			if (!this.isInit) {
				this.selectedSource.modify(this.index, {
							value : this.value || '',
							data : data[0]
						});
				this.selectedValues.replace(this.getSelectedItemData(
						this.value, this.index - 1, data.length > 0));
				this.index++;
			}
			if (this.isInit) {
				var selected = this.getSelectedVal(data);
				var sd = selected.data;
				// 正常加载分类层级
				this.selectedValues.add(selected, true);
				for (var i = 0; i < data.length; i++) {
					this.selectedSource.modify(i, {
								value : sd && i > 0
										? sd[sd.length - i].value
										: '',
								data : data[i]
							});
					this.index++;
				}
				// 如果是级联带出，默认需要清空之前展现
				this.element.html('');
			}

			// 打开默认初始无数据
			if (1 === this.index && data.length === 0)
				this.noRecode();
			if (data.length > 0)
				this.render.get(data);
			else
				this.lock = false;
		},

		getSelectedVal : function(data) {
			var selected = {};
			if (data && data.length > 0) {
				var pa = [];
				var value = "";
				for (var i = data.length - 1; i >= 0; i--) {
					var d = data[i];
					for (var j = 0; j < d.length; j++) {
						if (d[j].selected && d[j].selected == true) {
							!value ? value = d[j].value : '';
							pa.push(d[j]);
							break;
						}
					}
				}
				selected = {
					value : value,
					data : pa
				};
			}
			return selected;
		},

		triggerExpandCate : function($target) {
			if (this.lock)
				return;
			this.lock = true;
			this.value = $target.attr('data-lui-item-id');
			this.pAdmin = $target.attr('data-lui-item-padmin');
			var param = {
				parentId : this.value,
				type : '03'
			};
			if (this.pAdmin)
				param.pAdmin = this.pAdmin;
			if (this.source.resolveUrl) {
				this.source.resolveUrl(param);
			}
			// 当前选中块
			var block = $target.parents('[data-lui-block-index]');
			block.nextAll().remove();
			this.index = parseInt(block.attr('data-lui-block-index'));
			this.source.get();
		},

		getQSearchInnerHTML : function(data) {
			if (!data || data.length == 0) {
				return "";
			}
			this.qsearchSource = $.isArray(data[0])
					? data[data.length - 1]
					: data;
			var html = '';
			var ____tr = "<tr>", tr____ = "</tr>";
			for (var i = 0; i < data.length; i++) {
				if (data[i].nodeType && data[i].nodeType == 'category')
					continue;
				var selected = false;
				var sv = this.selectedValues.get();
				for (var j = 0; j < sv.length; j++) {
					if (sv[j]['value'] == data[i].value) {
						selected = true;
						break;
					}
				}
				var htmls = [
						'',
						'<td width="45%" data-lui-mark="select.qsearch.li" data-lui-item-id="',
						data[i].value, '" ', '',
						'><span class="textEllipsis">', data[i].text,
						'</span></td>', ''];
				if (selected)
					htmls[4] = 'class="lui_category_qsearch_selected"';
				if (i % 2 === 0)
					htmls[0] = ____tr;
				if (i % 2 === 1)
					htmls[8] = tr____;
				html += htmls.join('');
			};
			return html;
		},
		redrawHierarchyBlock : function(__val) {

			// 单选改变数据同时重新绘制
			this.selectedValues.removeAll();
			var __source = this.source;
			var param = {
				currId : __val,
				type : '02'
			};
			__source.resolveUrl(param);
			__source.get();
		}

	});

	var MulSelectBlock = SelectBlock.extend({

		startup : function($super) {
			this.isMul = true;
			if (!this.render) {
				this.setRender(new render.Template({
							src : require.resolve('./mul-select-block.html#'),
							parent : this
						}));
				this.children.push(this.render);
				this.render.startup();
			}

			$super();
		},

		blockSelectedChanged : function(data) {
			if (data.data) {
				var index = data.data.length, block = this.element
						.find('[data-lui-block-index="' + index + '"]');
				block.find('[data-lui-item-id="' + data.value + '"]').each(
						function() {
							var checkbox = $(this)
									.find('[data-lui-mark="select.item.checkbox"]')[0], checked = checkbox.checked == true
									? true
									: false;
							if (checked) {
								$(this)
										.removeClass('lui_category_itemLink_checked');
								checkbox.checked = false;
							} else {
								$(this)
										.addClass('lui_category_itemLink_checked');
								checkbox.checked = true;
							}
						});
			}
		},

		qSearchSelectedChanged : function(data) {
			// 快速搜索联动
			if (this.qSearchDiv) {
				this.qSearchDiv.find('[data-lui-item-id="' + data.value + '"]')
						.each(function() {
									if ($(this).hasClass(CLASSNAME.SELECTED)) {
										$(this).removeClass(CLASSNAME.SELECTED);
										$(this).addClass(CLASSNAME.UNSELECTED);
									} else {
										$(this)
												.removeClass(CLASSNAME.UNSELECTED);
										$(this).addClass(CLASSNAME.SELECTED);
									}
								});
			}
		},

		hSearchRender : function(_data) {
			var dd = this.selectedQSearchdata;
			dd.data = dd.data.concat(_data.data);
			this.selectedValues.toggle(dd);
		},

		triggerExpandCate : function($target) {
			if (this.lock)
				return;
			this.lock = true;
			this.value = $target.attr('data-lui-item-id');
			var param = {
				parentId : this.value,
				type : '03'
			};
			if (this.source.resolveUrl) {
				this.source.resolveUrl(param);
			}
			// 当前选中块
			var block = $target.parents('[data-lui-block-index]');
			block.nextAll().remove();
			this.index = parseInt(block.attr('data-lui-block-index'));
			this.source.get();
			$target.parent().find('[data-lui-mark="select.item.li"]')
					.removeClass(CLASSNAME.ITEMON);
			$target.addClass(CLASSNAME.ITEMON);
		},

		onDataLoad : function(data) {
			if (!($.isArray(data) && data.length > 0)) {
				// 快速搜索
				if (data.type == 'qsearch') {
					data = data.data;
					this.qSearchRender(data);
					return;
				}
				// 快速搜索中项的层级获取
				if (data.type == 'hsearch') {
					this.hSearchRender(data);
					return;
				}
				// 分类同级搜索
				if (data.type == 'search')
					data = data.data;
				else {
					this.lock = false;
					return;
				}
			}
			this.selectedSource.modify(this.index, {
						value : this.value || '',
						data : data[0]
					});
			this.index++;
			if (data[1]) {
				var selecteds = [];

				for (var j = 0; j < data[1].length; j++) {
					var selected = [];
					var jt = {
						text : data[1][j].text,
						value : data[1][j].value
					};
					selected.push(jt);
					var h = data[1][j].hierarchyId;
					if (h) {
						var hs = h.substring(1, h.length - 1).split('x');
						if (hs.length > 1) {
							hs.pop();
							for (var hh in hs) {
								var jt = {
									value : hh[hs]
								};
								selected.push(jt);
							}
						} else {
							selected.push({
										value : h
									});
						}
					}

					selecteds.push({
								value : data[1][j].value,
								data : selected
							});
				}
				this.selectedValues.addAll(selecteds, true);
			}
			this.render.get(data);
		},

		onClick : function(evt) {
			var $target = $(evt.target);
			while ($target.length > 0) {
				if ($target.attr('data-lui-mark') === 'qsearch.close') {
					this.triggerCloseQSearch();
					break;
				}

				// 内部搜索
				if ($target.attr('data-lui-mark') === "search.btn") {
					this.triggerBlockSearch($target);
					break;
				}

				// 点击删除移动当前选中
				if ($target.attr('data-lui-mark') === "select.item.remove") {
					var id = $target.parents('[data-lui-item-id]')
							.attr('data-lui-item-id');
					var index = parseInt($target
							.parents('[data-lui-block-index]')
							.attr('data-lui-block-index'))
							- 1;
					var data = this.getSelectedItemData(id, index);
					this.selectedValues.remove(data);
					break;
				}
				// 点击多选框暂存当前选中数据
				if ($target.attr('data-lui-mark') === "select.item.checkbox") {
					var id = $target.parents('[data-lui-item-id]')
							.attr('data-lui-item-id');

					var index = parseInt($target
							.parents('[data-lui-block-index]')
							.attr('data-lui-block-index'))
							- 1;
					var data = this.getSelectedItemData(id, index);
					if (!$target[0].checked) {
						$target[0].checked = true;
						this.selectedValues.remove(data);
					} else {
						$target[0].checked = false;
						this.selectedValues.add(data);
					}
					break;
				}
				// 点击展开下一级
				if ($target.attr('data-lui-mark') == "select.item.li") {
					this.triggerExpandCate($target);
					break;
				}

				// 快速搜索模板点击事件
				if ($target.attr('data-lui-mark') == "select.qsearch.li") {
					this.triggerClickQsearchItem($target);
					break;
				}
				$target = $target.parent();
			}
		},

		getQSearchInnerHTML : function(data) {
			this.qsearchSource = data;
			var html = '';
			for (var i = 0; i < data.length; i++) {
				var selected = false;
				var sv = this.selectedValues.get();
				for (var j = 0; j < sv.length; j++) {
					if (sv[j]['value'] == data[i].value) {
						selected = true;
						break;
					}
				}
				var htmls = [
						'<li data-lui-mark="select.qsearch.li" data-lui-item-id="',
						data[i].value, '" ', '', '><span>', data[i].text,
						'</span></li>'];
				if (selected) {
					htmls[3] = 'class="lui_category_qsearch_selected"';
				}
				html += htmls.join('');
			};
			return html;
		},

		redrawHierarchyBlock : function(__val, $target) {
			var dd = {
				data : [{
							value : __val,
							text : $target.find('option:selected').text(),
							nodeType : false
						}],
				value : __val
			};
			this.selectedValues.add(dd);
		}

	});

	// 已选择区域
	var SelectedBox = base.Container.extend({
				initProps : function($super, cfg) {
					$super(cfg);
					this.data = [];
					this.startup();
					this._data = [];
				},
				setLayout : function(_layout) {
					this.layout = _layout;
				},
				startup : function($super) {
					if (!this.layout) {
						this.setLayout(new layout.Template({
									src : require
											.resolve('./selected-box.html#'),
									parent : this
								}));

						this.layout.startup();
					}
					if (!this.selectedValues) {
						this.selectedValues = this.parent.selectedValues;
					}

					topic.subscribe(CATEGORY_SELECTE_DCHANGE,
							this.selectedChanged, this);
					var self = this;
					this.element.bind('click', function(evt) {
								self.onClick(evt);
							});
					$super();
				},

				onClick : function(evt) {
					var $target = $(evt.target);
					if ($target.attr('data-lui-mark-id')) {
						var value = $target.attr('data-lui-mark-id');
						for (var k = 0; k < this._data.length; k++) {
							if (value === this._data[k].value) {
								this.selectedValues.remove(this._data[k]);
							}
						}
					}
				},

				draw : function($super) {
					$super();
				},
				doLayout : function(obj) {
					this.element.html($(obj));
				},
				selectedChanged : function(evt) {
					this.erase();
					this.data.length = 0;
					if (evt && evt.data) {
						this._data = evt.data;
						for (var i = 0; i < evt.data.length; i++) {
							this.data.push(evt.data[i]['data'][0]);
						}
					}
					this.draw();
				}
			});

	var SelectedSource = base.Base.extend({
				initProps : function($super, cfg) {
					$super(cfg);
					this.selectedSource = [];
				},
				add : function(source) {
					this.selectedSource.push(source);
					this.emit('add');
				},
				remove : function(i, source) {
					this.selectedSource.splice(i, 1);
					this.emit('remove');
				},
				modify : function(i, source) {
					this.selectedSource[i] = source;
					this.emit('modify');
				},
				get : function() {
					return this.selectedSource;
				}

			});

	var SelectedValues = base.Base.extend({

				initProps : function($super, cfg) {
					$super(cfg);
					this.selectedValues = [];
				},

				add : function(val, fire) {
					fire = fire === false ? false : true;
					var selected = false;
					for (var i = 0; i < this.selectedValues.length; i++) {
						if (this.selectedValues[i].value == val.value) {
							selected = true;
							break;
						}
					}
					if (!selected) {
						this.selectedValues.push(val);
						this.emit('add');
						if (fire)
							this.selectedChanged(val);
					}
				},

				addAll : function(vals, fire) {
					fire = fire === false ? false : true;
					for (var j = 0; j < vals.length; j++) {
						var val = vals[j];
						for (var i = 0; i < this.selectedValues.length; i++) {
							if (this.selectedValues[i].value == val.value) {
								break;
							}
						}
						this.selectedValues.push(val);
					}
					this.emit('addAll');
					if (fire)
						this.selectedChanged(val);
				},

				remove : function(val, fire) {
					fire = fire === false ? false : true;
					for (var i = 0; i < this.selectedValues.length; i++) {
						if (this.selectedValues[i].value == val.value) {
							this.selectedValues.splice(i, 1);
							break;
						}
					}
					this.emit('remove');
					if (fire)
						this.selectedChanged(val);
				},

				toggle : function(val, fire) {
					fire = fire === false ? false : true;
					var iR = false;
					for (var i = 0; i < this.selectedValues.length; i++) {
						if (this.selectedValues[i].value == val.value) {
							this.selectedValues.splice(i, 1);
							iR = true;
							break;
						}
					}
					if (!iR) {
						this.selectedValues.push(val);
					}
					this.emit('toggle');
					if (fire)
						this.selectedChanged(val);
				},

				replace : function(val, fire) {
					fire = fire === false ? false : true;
					this.selectedValues.length = 0;
					this.selectedValues.push(val);
					this.emit('replace');
					if (fire)
						this.selectedChanged(val);
				},

				removeAll : function(fire) {
					fire = fire === false ? false : true;
					this.selectedValues.length = 0;
					this.emit('removeAll');
					if (fire)
						this.selectedChanged({
									data : [],
									value : ''
								});
				},

				get : function() {
					return this.selectedValues;
				},

				selectedChanged : function(_data) {
					var evt = {
						_data : _data,
						data : this.get()
					};
					topic.publish(CATEGORY_SELECTE_DCHANGE, evt);
				}

			});

	exports.Category = Category;
	exports.Nav = Nav;
	exports.QSearch = QSearch;
	exports.GCategory = GCategory;
	exports.SelectArea = SelectArea;
	exports.SelectBlock = SelectBlock;
	exports.MulSelectBlock = MulSelectBlock;
	exports.SingleSelectBlock = SingleSelectBlock;
	exports.SelectedBox = SelectedBox;
	exports.SelectedValues = SelectedValues;
});