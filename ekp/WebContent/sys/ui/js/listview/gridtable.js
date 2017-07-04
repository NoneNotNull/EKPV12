define(function(require, exports, module) {
	var listview = require('lui/listview/listview');
	var layout = require('lui/view/layout');
	var template = require('lui/listview/template');
	var source = require('lui/data/source');
	var topic = require('lui/topic');
	var $ = require('lui/jquery');
	var env = require('lui/util/env');
	var strutil = require('lui/util/str');

	var GridTable = listview.AbstractTable.extend(listview.ResourceTable, {

				className : 'gridTable',

				initProps : function($super, _cfg) {
					$super(_cfg);
					this.selected = this.config.isDefault;
					this.channel = this.config.channel;
					this.gridHref = this.config.gridHref;
					this.target = this.config.target || '_blank';
					this.onGridClick = this.config.onGridClick;
					this.name = this.config.name;
					this.columnNum = this.config.columnNum;
				},

				startup : function($super) {
					if (this.isStartup) {
						return;
					}
					if (!this.source) {
						this.setSource(this.parent.source);
					}
					if (!this.layout) {
						this.setLayout(new layout.Template({
									src : require
											.resolve('./grid-table-layout.html#'),
									parent : this
								}));
					}
					if (!this.template) {
						this.setTemplate(new template.Template({
									src : require
											.resolve('./grid-table-render.html#'),
									parent : this
								}));
					}

					this.on('show', this.onSourceGet, this);
					this.source.on('error', this.onError, this);
					this.source.on('data', this.onSourceLoaded, this);
					this.template.on('error', this.onError, this);
					this.template.on('html', this.doTemplate, this);
					$super();
				},

				onSourceLoaded : function(_data) {
					if (!this.isSelected()) {
						return;
					}
					this.parent._data = {};
					$.extend(true, this.parent._data, _data);

					this._data = _data;
					topic.channel(this.parent).publish('list.changed', _data);
					if (!_data.datas || _data.datas.length == 0) {
						this.noRecode();
						return;
					}
					this.template.get(_data);
				},

				noRecodeLoaded : function(data) {
					this.element.html(data);
				},

				setTemplate : function(_template) {
					this.template = _template
				},

				setLayout : function(_layout) {
					this.layout = _layout
				},

				addChild : function($super, child) {
					if (child instanceof template.AbstractTemplate) {
						this.setTemplate(child);
					}
					if (child instanceof source.BaseSource) {
						this.setSource(child);
					}
					$super(child);
				},

				onClick : function(evt) {
					var $target = $(evt.target);
					while ($target.length > 0) {
						if ($target.attr('data-lui-mark-id')) {
							var code = '';
							var rowId = $target.attr('data-lui-mark-id');
							if (this.gridHref) {
								for (var j = 0; j < this.kvData.length; j++) {
									if (rowId === this.kvData[j]['rowId']) {
										var href = strutil.variableResolver(
												this.gridHref, this.kvData[j])
										code = ["window.open('",
												env.fn.formatUrl(href), "','",
												this.target, "')"].join('');
										break;
									}
								}

							} else if (this.onGridClick) {
								for (var j = 0; j < this.kvData.length; j++) {
									if (rowId === this.kvData[j]['rowId']) {
										code = strutil.variableResolver(
												this.onGridClick,
												this.kvData[j]);
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

				draw : function() {
					if (this.isDrawed)
						return;

					var self = this;
					if (this.layout) {
						this.layout.on("error", function(msg) {
									self.element.append(msg);
								});
						this.layout.get(this, function(obj) {
									self.doLayout(obj);
								});
					}
					this.element.show();
					this.isDrawed = true;
					return this;
				},

				doLayout : function(html) {
					this.layoutHtml = html;
					if (this.isSelfInit())
						this.resolveUrls();
				},

				clearHtml : function() {
					this.element.empty();
				},

				doTemplate : function(html) {
					if (this.template._datas) {
						this.kvData = this.template._datas;
					}
					this.element.html(this.layoutHtml);
					this.element.find("[data-lui-mark='table.content.inside']")
							.html(html);
					this.isLoad = true;
					this.fire({
								"name" : "load",
								'table' : this
							});
				},

				renderLoaded : function($super, datas, render) {
					var width = 100 / this.columnNum + '%';
					var tr = '<tr>', _tr = '</tr>';
					var td = "<td width='" + width + "'>", _td = '</td>';
					var txt = '<table class="lui_listview_gridtable_table">';
					if (render) {
						for (var i = 0; i < datas.length; i++) {
							if (i % this.columnNum === 0)
								txt += tr;
							txt += td;
							txt += (render).call(this.template, datas[i], i,
									'grid');
							txt += _td;
							if (i % this.columnNum === this.columnNum-1)
								txt += _tr;
						}
						var _num = datas.length % this.columnNum;
						if (_num > 0) {

							for (var j = 0; j < this.columnNum - _num; j++) {
								txt += (td + _td);
							}
							txt += _tr;
						}
						txt += '</table>';
					} else
						txt = this.template.html.call(this.template, datas);
					this.template.fireHtml(txt);
					$super(datas, render);
				}
			});

	exports.GridTable = GridTable;
})