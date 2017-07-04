define(function(require, exports, module) {
	var listview = require('lui/listview/listview');
	var layout = require('lui/view/layout');
	var template = require('lui/listview/template');
	var source = require('lui/data/source');
	var topic = require('lui/topic');
	var $ = require('lui/jquery');
	var env = require('lui/util/env');
	var strutil = require('lui/util/str');

	var RowTable = listview.AbstractTable.extend(listview.ResourceTable, {

				className : 'rowTable',

				initProps : function($super, cfg) {
					$super(cfg);
					this.selected = this.config.isDefault;
					this.channel = this.config.channel;
					this.rowHref = this.config.rowHref;
					this.target = this.config.target;
					this.onRowClick = this.config.onRowClick;
					this.name = this.config.name;

				},

				onClick : function(evt) {
					var $target = $(evt.target);
					while ($target.length > 0) {
						if ($target.attr('data-lui-mark-id')) {
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
										code = strutil
												.variableResolver(
														this.onRowClick,
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
											.resolve('./row-table-layout.html#'),
									parent : this
								}));
					}

					if (!this.template) {
						this.setTemplate(new template.Template({
									src : require
											.resolve('./row-table-render.html#'),
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

				onError : function(msg) {
					this.doTemplate(msg);
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
				doLayout : function($super,html) {
					this.layoutHtml = html;
					if (this.isSelfInit())
						this.resolveUrls(this.parent.cacheEvt);
					$super(html);
				},
				clearHtml : function() {
					this.element.empty();
				},

				noRecodeLoaded : function(data) {
					this.element.html(data);
				},

				renderLoaded : function($super, datas, render) {
					var txt = '';
					if (render)
						for (var i = 0; i < datas.length; i++) {
							txt += (render).call(this.template, datas[i], i,
									'row');
						}
					else
						txt = this.template.html.call(this.template, datas);
					this.template.fireHtml(txt);
					$super(datas, render);
				}
			});

	exports.RowTable = RowTable;
})