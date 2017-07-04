define(function(require, exports, module) {
	var tmpl = require('lui/view/Template');
	var $ = require('lui/jquery');
	var topic = require('lui/topic');
	var listview = require('lui/listview/listview');
	var layout = require("lui/view/layout");
	var base = require("lui/base");
	var env = require('lui/util/env');
	var source = require('lui/data/source');
	var strutil = require('lui/util/str');
	var lang = require('lang!sys-ui');
	var LIST_CHANGED = 'list.changed';// 发布列表数据请求完毕事件
	var SORT_CHANGED = 'sort.changed';// 监听排序事件

	var ColumnTable = listview.AbstractTable.extend(listview.ResourceTable, {
		className : 'columnTable',

		initProps : function($super, cfg) {
			$super(cfg);
			this.selected = this.config.isDefault;
			this.channel = this.config.channel;
			this.columns = [];
			this.rowHref = this.config.rowHref;
			this.target = this.config.target;
			this.onRowClick = this.config.onRowClick;
			this.sort = this.config.sort;
			this.sortTemp = {};
			this.name = this.config.name;
		},

		startup : function($super) {

			var self = this;
			if (this.isStartup) {
				return;
			}
			if (!this.layout) {
				this.addChild(new layout.Template({
					src : require
							.resolve('sys/ui/extend/listview/column-table.html#'),
					parent : this
				}));
			}
			if (!this.source) {
				this.setSource(this.parent.source);
			}
			this.source.on('error', function(msg) {
						self.element.html(msg);
					}, this);
			this.on('show', this.onSourceGet, this);
			this.source.on('data', this.onSourceLoaded, this);
			$super();
		},

		onSourceLoaded : function(_data) {
			if (!this.isSelected()) {
				return;
			}
			var self = this;
			topic.channel(this.parent).publish(LIST_CHANGED, _data);

			this.datas = {
				columns : [],
				datas : []
			};
			this.parent._data = {};
			$.extend(true, this.parent._data, _data);
			this._data = _data;

			for (var i = 0; i < _data.datas.length; i++) {
				this.datas.datas.push([]);
			}
			this.dataFormat(this.datas, this._data);

			if (!_data.datas || _data.datas.length == 0) {
				this.noRecode();
				return;
			}

			if (this.layout) {
				this.layout.on("error", function(msg) {
							self.element.html(msg);
						});
				this.layout.get(this, function(obj) {
							self.doLayout(obj);
						});
			}
		},

		converKvDatas : function(_data) {

			var _datas = _data.datas;
			this.kvData = [];
			for (var i = 0; i < _datas.length; i++) {
				var json = {};
				for (var j = 0; j < _datas[i].length; j++) {
					json[_datas[i][j]['col']] = _datas[i][j]['value'];
				}
				json['rowId'] = listview.UniqueId();
				this.kvData.push(json);
			}

			var _columns = _data.columns;
			for (var i = 0; i < _columns.length; i++) {
				_columns[i]['rowId'] = listview.UniqueId();
				_columns[i]['sort'] = '';
			}
			return this.kvData;
		},

		// 依据列元素调整数据源结构
		dataFormat : function(data, _data) {
			var kvData = this.converKvDatas(_data);
			for (var i = 0; i < this.columns.length; i++) {
				this.columns[i].format(data, _data, kvData);
			}
		},

		addChild : function($super, child) {
			$super(child);
			if (child instanceof source.BaseSource) {
				this.setSource(child);
			}
			if (child instanceof AbstractColumn) {
				this.columns.push(child);
			}
		},

		draw : function() {
			if (this.isDrawed)
				return;
			this.element.show();
			if (this.isSelfInit())
				this.resolveUrls(this.parent.cacheEvt);
			this.isDrawed = true;
			return this;
		},

		// 绑定列标题事件
		bindHeaderEvt : function() {
			var self = this;
			this.element.find('[data-lui-mark="column.table.header"]').bind(
					'click', function(evt) {
						self.headerClick(evt);
					})
		},

		// 暂存内部排序信息
		getSortTemp : function() {
			return this.sortTemp;
		},

		setSortTemp : function(property, index) {
			this.sortTemp = {
				property : property,// 排序字段
				index : index
				// 方法索引
			};
			if (window.console) {
				// console.log(this.sortTemp);
			}
		},

		emptySortTemp : function() {
			this.setSortTemp('', '');
		},

		// 点击标题事件
		headerClick : function(evt) {
			var self = this;
			var $target = $(evt.target);
			while ($target.length > 0) {
				if ($target.attr('data-lui-mark-row-id')) {
					var rowId = $target.attr('data-lui-mark-row-id'), columns = this.datas.columns;
					for (var i = 0; i < columns.length; i++) {
						if (rowId === columns[i]['rowId']) {
							if (columns[i]['onHeaderClick']) {
								new Function(columns[i]['onHeaderClick'])
										.call($target[0]);
							} else if ($target.attr('data-lui-mark-sort')) {
								var index = parseInt($target
										.attr('data-lui-mark-toggle-index')
										? $target
												.attr('data-lui-mark-toggle-index')
										: 0);
								if (index < self.getToggleBehave().length - 1) {
									index++;
								} else {
									index = 0
								}
								var sort = $target.attr('data-lui-mark-sort');
								$target.attr('data-lui-mark-toggle-index',
										index);
								this.setSortTemp(sort, index);
								var icon = $target.find('.lui_icon_s');
								self.sortToggleClick(index, icon, sort);
							}
							break;
						}
					}
					break;
				}
				$target = $target.parent();
			}
		},

		getToggleBehave : function() {
			return [this.defaulToggle, this.downToggle, this.upToggle];
		},

		sortToggleClick : function(i, obj, sort) {
			this.getToggleBehave()[i].call(this, obj, sort);
		},

		defaulToggle : function(obj, sort) {
			this.orderBydesc(false);
		},

		downToggle : function(obj, sort) {
			this.orderBydesc('down', sort);
		},

		upToggle : function(obj, sort) {
			this.orderBydesc('up', sort);
		},

		orderBydesc : function(desc, sort) {

			var evt = {
				sort : this.id,
				sorts : []
			};

			if (desc) {
				evt['sorts'].push({
							key : 'orderby',
							value : [sort]
						})
				var sort = {
					key : 'ordertype'
				}
				sort['value'] = [desc];
				evt['sorts'].push(sort);
			}
			topic.channel(this.parent).publish(SORT_CHANGED, evt);
		},

		doLayout : function($super, html) {
			this.clearHtml();
			this.element.append($(html));
			this.fire({
						"name" : "load",
						'table' : this
					});
			this.bindHeaderEvt();
			this.setTitleCursor();
			$super(html);
		},

		setTitleCursor : function() {
			var columns = this.datas.columns;
			this.element.find('[data-lui-mark-row-id]').each(function() {
				var rowId = $(this).attr('data-lui-mark-row-id');
				for (var i = 0; i < columns.length; i++) {
					if (rowId === columns[i]['rowId']) {
						if (columns[i]['onHeaderClick']
								|| $(this).attr('data-lui-mark-sort')) {
							$(this).css('cursor', 'pointer');
						}
						break;
					}
				}
			});
		},

		clearHtml : function() {

			this.tempFrame = $("<div data-lui-mark='temp'/>");
			this.element.append(this.tempFrame);
			for (var i = 0; i < this.columns.length; i++) {
				this.tempFrame.append(this.columns[i].getRootElement());
			}
			
			var cd = this.element.children();
			for (var i = cd.length - 1; i >= 0; i--) {
				if ((cd[i].getAttribute("data-lui-mark") || "") != "temp") {
					$(cd[i]).remove();
				}
			}
			for (var i = 0; i < this.columns.length; i++) {
				this.element.append(this.columns[i].getRootElement());
			}
			this.tempFrame.remove();
			this.emptySortTemp();
		},

		noRecodeLoaded : function(data) {
			this.clearHtml();
			this.element.append(data);
		},

		getSort : function() {
			return this.sort == 'false' ? false : true;
		}
	});

	var AbstractColumn = base.Component.extend({
				initProps : function($super, cfg) {
					$super(cfg);
				},

				format : function(data, _data, kvData) {
					return data;
				},

				remove : function(array, index) {
					return (array.slice(0, index).concat(array.slice(index + 1,
							array.length)));
				},
				dataHtmlBuilder : function(value) {
					return value;
				},

				columnHtmlBuilder : function(title, flag) {
					if (flag) {
						return this.columnCustomHtmlBuilder(title);
					}
					return title;
				},

				columnCustomHtmlBuilder : function(title) {
					var html = [
							'<div >',
							'<div class="lui_listview_columntable_table_title">',
							title,
							'</div>',
							'<div class="lui_listview_columntable_table_icon">',
							'<div class="',
							this.getSortIcon(this.getSortIndex()),
							' lui_icon_s">', '</div>', '</div>', '</div>']
							.join('');

					return html;
				},

				getSort : function() {
					if (this.sort) {
						this.sortProperty = this.sort;
					} else if (this.parent.getSort()) {
						if (this.property) {
							this.sortProperty = this.property;
						}
					}
					return this.sortProperty;
				},

				getSortIndex : function() {
					var index;
					if (this.parent.getSortTemp()
							&& this.getSort()
							&& this.parent.getSortTemp().property == this
									.getSort()) {
						index = this.parent.getSortTemp().index;
					}
					return parseInt(index ? index : 0);
				},

				getSortIcon : function(i) {
					return ['lui_icon_s_default_filter',
							'lui_icon_s_on_filter', 'lui_icon_s_up_filter'][i];
				}
			});

	var CheckboxColumn = AbstractColumn.extend({

				initProps : function($super, cfg) {
					$super(cfg);
					this.name = this.config.name || 'List_Selected';
					this.style = this.config.style || 'width:5%';
					this.styleClass = this.config.styleClass;
					this.headerStyle = this.config.headerStyle;
				},

				dataHtmlBuilder : function(name, value) {
					return ['<input type="checkbox" name="', name, '" value="',
							value, '" data-lui-mark="table.content.checkbox">']
							.join('');
				},

				columnHtmlBuilder : function(name) {
					return ['<input type="checkbox" name="', name, '">']
							.join('');
				},

				format : function(data, _data, kvData) {
					var columns = _data.columns;
					var datas = _data.datas;
					data.columns.push({
								title : this.columnHtmlBuilder('List_Tongle'),
								headerStyle : this.headerStyle,
								sort : ''
							});
					for (var i = 0; i < datas.length; i++) {
						var d = data.datas[i];
						d.push({
									col : 'fdId',
									value : this.dataHtmlBuilder(this.name,
											kvData[i].fdId),
									style : this.style
								});
					}
					this.callAllSelected();
				},

				callAllSelected : function() {
					var self = this;
					var parent = this.parent.element;
					parent.bind('click', function(evt) {
								var $target = $(evt.target);
								while ($target.length > 0) {
									if ($target.attr('name') == 'List_Tongle') {
										var checked = ($target[0].checked
												? true
												: false);

										parent
												.find('input[type=checkbox][name='
														+ self.name + ']')
												.each(function() {
													$(this)[0].checked = checked;
												});
										break;
									}
									$target = $target.parent();
								}
							});
				}
			});

	var SerialColumn = AbstractColumn.extend({
				initProps : function($super, cfg) {
					$super(cfg);
					this.title = this.config.title
							|| lang['ui.listview.columntable.serial'];
					this.headerStyle = this.config.headerStyle;
					this.style = this.config.style || 'width:5%';
				},

				format : function(data, _data) {
					var columns = _data.columns;
					var datas = _data.datas;
					data.columns.push({
								title : this.columnHtmlBuilder(this.title),
								headerStyle : this.headerStyle,
								sort : ''
							});
					for (var i = 0; i < datas.length; i++) {
						var d = data.datas[i];
						d.push({
									col : 'serial',
									value : this.dataHtmlBuilder(i + 1),
									style : this.style
								});
					}
				}
			});

	var Column = AbstractColumn.extend({

		initProps : function($super, cfg) {
			$super(cfg);
			this.title = this.config.title;
			this.property = this.config.property;
			this.style = this.config.style;
			this.styleClass = this.config.styleClass;
			this.onHeaderClick = this.config.onHeaderClick;
			this.headerStyle = this.config.headerStyle;
			this.headerClass = this.config.headerClass;
			this.sort = this.config.sort;
		},

		format : function(data, _data) {
			var datas = data.datas, columns = data.columns;
			var _datas = _data.datas, _columns = _data.columns;
			for (var i = 0; i < _data.columns.length; i++) {
				if (_data.columns[i].property == this.property) {
					var sort = this.getSort();
					columns.push($.extend(_data.columns[i], {
								title : this
										.columnHtmlBuilder(
												this.title
														|| _data.columns[i].title,
												sort),
								headerStyle : this.headerStyle,
								headerClass :this.headerClass,
								onHeaderClick : this.onHeaderClick,
								sort : sort,
								index : this.getSortIndex()
							}));

					_data.columns = this.remove(_data.columns, i);
				}
			}
			for (var i = 0; i < _datas.length; i++) {
				var d = datas[i];
				for (var j = 0; j < _datas[i].length; j++) {
					if (_datas[i][j].col == this.property) {
						_datas[i][j].value = env.fn
								.formatText(_datas[i][j].value);
						if (this.style) {
							_datas[i][j].style = this.style;
						}
						if (this.styleClass) {
							_datas[i][j].styleClass = this.styleClass;
						}
						d.push(_data.datas[i][j]);
						_datas[i] = this.remove(_datas[i], j);
					}
				}
			}
		}
	});

	var Columns = AbstractColumn.extend({
		initProps : function($super, cfg) {
			$super(cfg);
			this.properties = this.config.properties;
		},

		format : function(data, _data) {

			var _datas = _data.datas, _columns = _data.columns;
			var datas = data.datas, columns = data.columns;

			var property = this.properties ? this.properties.split(/[;,]/) : '';
			if (property && property.length > 0) {
				for (var k = 0; k < property.length; k++) {

					for (var i = 0; i < _data.columns.length; i++) {
						if (_data.columns[i].property == property[k]) {
							this.property = _data.columns[i].property;
							var sort = this.getSort();
							_data.columns[i]['title'] = this.columnHtmlBuilder(
									_data.columns[i]['title'], sort);
							_data.columns[i]['index'] = this.getSortIndex();
							_data.columns[i]['sort'] = sort;
							columns.push(_data.columns[i]);
							_data.columns = this.remove(_data.columns, i);
						}
					}
					for (var i = 0; i < _datas.length; i++) {
						var d = datas[i];
						for (var j = 0; j < _datas[i].length; j++) {
							if (_datas[i][j].col == property[k]) {

								_datas[i][j].value = _datas[i][j].value;
								d.push(_data.datas[i][j]);
								_datas[i] = this.remove(_datas[i], j);
							}
						}
					}
				}
			} else {
				var index = [];
				for (var j = 0; j < _columns.length; j++) {
					if (!_columns[j]['title']) {
						index.push(j);
						_columns = this.remove(_columns, j);
						j--;
					} else {

						var sort = this.getSort();
						_columns[j]['title'] = this.columnHtmlBuilder(
								_columns[j]['title'], sort);
						_columns[j]['index'] = this.getSortIndex();
						_columns[j]['sort'] = sort;
					}

				}
				data.columns = columns.concat(_columns);
				for (var i = 0; i < _datas.length; i++) {
					for (var j = 0; j < index.length; j++) {
						_datas[i] = this.remove(_datas[i], index[j]);
					}
					datas[i] = datas[i].concat(_datas[i]);
				}
			}
		}
	});

	var HtmlColumn = AbstractColumn.extend({

				initProps : function($super, cfg) {
					$super(cfg);
					this.onHeaderClick = this.config.onHeaderClick;
					this.title = this.config.title;
					this.style = this.config.style;
					this.styleClass = this.config.styleClass;
					this.headerStyle = this.config.headerStyle;
					this.headerClass = this.config.headerClass;
					this.sort = this.config.sort;
				},

				getCodeHtml : function() {
					var code = this.element
							.children("script[type='text/code']");
					return code.html();
				},

				html : function(row) {
					if (this.parent && this.parent.emit)
						this.parent.emit("earse", this.parent);
					return (this.tmpl.render({
								"row" : row,
								"env" : env,
								"$" : $,
								"strutil" : strutil
							}));
				},

				setTmpl : function(_tmpl) {
					this.tmpl = _tmpl;
				},

				format : function(data, _data, kvData) {
					this.setTmpl(new tmpl(this.getCodeHtml()));
					var datas = data.datas, columns = data.columns;
					var _datas = _data.datas, _columns = _data.columns;
					var sort = this.getSort();
					columns.push({
								title : this
										.columnHtmlBuilder(this.title, sort),
								headerStyle : this.headerStyle,
								headerClass : this.headerClass,
								rowId : listview.UniqueId(),
								onHeaderClick : this.onHeaderClick,
								sort : sort,
								index : this.getSortIndex()
							});

					var txt = '';
					for (var i = 0; i < kvData.length; i++) {
						txt = this.html(kvData[i]);
						var d = datas[i];
						d.push({
									value : txt,
									style : this.style,
									styleClass : this.styleClass
								});
					}
				}
			});

	exports.ColumnTable = ColumnTable;
	exports.AbstractColumn = AbstractColumn;
	exports.CheckboxColumn = CheckboxColumn;
	exports.SerialColumn = SerialColumn;
	exports.Column = Column;
	exports.Columns = Columns;
	exports.HtmlColumn = HtmlColumn;

})