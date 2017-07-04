var _accordionPanel;
var accordionPanel;
var ___href = '';
var ___currId = '';
var ___target = '';
if (layout.parent.menuSouce && layout.parent.menuSouce.length > 0) {
	___href = layout.parent.menuSouce[0].config.href;
	___currId = layout.parent.menuSouce[0].config.currId;
	___target = layout.parent.menuSouce[0].config.target;
}

function createMenuFrame(items) {
	seajs
			.use(	['lui/panel', 'lui/view/layout', 'lui/menu',
							'lui/data/source', 'lui/util/str', 'lui/jquery',
							'lui/base', 'lui/view/render'], function(panel,
							layout, menu, source, strutil, $, base, render) {
						accordionPanel = new panel.AccordionPanel({
									expand : false
								});
						accordionPanel.layout = new layout.Javascript({
							src : '/sys/ui/extend/panel/accordionpanel_slide.js',
							parent : accordionPanel
						});
						accordionPanel.layout.startup();

						accordionPanel.parseToggleMark = function(dom) {
							// 切换按钮
							var self = accordionPanel;
							var toggleNode = dom
									.find("[data-lui-mark='panel.nav.toggle']");
							toggleNode.each(function(index, domEle) {
										var toggleNode = $(domEle);
										var len = self.togglesNode.length;
										self.togglesNode.push(toggleNode);
										if (self.contents[len].getToggle()) {
											toggleNode.click(function(evt) {
														self
																.onToggle(len,
																		null,
																		null,
																		evt);
													});
										} else {
											toggleNode.hide();
										}
									});
						};

						// 防止seajs异步引入产生的问题
						for (var i = 0; i < items.length; i++) {
							if (items[i] != layout)
								(function(i) {
									return function() {
										___createItem(panel, menu, source,
												strutil, $, items[i], base,
												render);
									}()
								}(i));

						}
						done(accordionPanel.element);
					});
}
function ___createItem(panel, menu, source, strutil, $, item, base, render) {
	if (!item.config.text)
		return;
	var cfg = {
		title : "<a href='"
				+ env.fn.formatUrl(strutil.variableResolver(___href,
						item.config)) + "' target='_self' title='"
				+ item.config.text + "'> " + item.config.text + "</a>",
		style : 'padding:0'
	};
	if (___currId == item.config.value)
		cfg.expand = true;
	var content = new panel.Content(cfg);

	if (___currId == item.config.value) {
		accordionPanel.children.unshift(content);
		accordionPanel.contents.unshift(content);
	} else {
		accordionPanel.addChild(content);
	}
	content.parent = accordionPanel;
	// 构建子dataview对象
	var url = "";
	if (item.children.length > 0) {
		if (item instanceof menu.MenuItem) {
			if (item.children[0] instanceof menu.MenuSource) {
				url = item.children[0].source._url || '';
				var _dataview = new base.DataView({
							parent : content
						});
				_dataview.setRender(new render.Javascript({
							parent : _dataview,
							src : '/sys/ui/extend/dataview/render/cate.js',
							vars : {
								href : ___href,
								target : ___target || '_self'
							}
						}));
				_dataview.render.startup();
				var source = new source.AjaxJson({
							url : url,
							parent : _dataview
						});
				source.resolveUrl({
							value : item.config.value
						});
				_dataview.setSource(source);
				content.addChild(_dataview);
				_dataview.element.appendTo(content.element);
				_dataview.startup();
			}
		}
	}
	content.startup();
}

function createItem(item) {
	seajs.use(['lui/panel', 'lui/menu', 'lui/data/source', 'lui/util/str',
					'lui/jquery', 'lui/base', 'lui/view/render'], function(
					panel, menu, source, strutil, $, base, render) {
				___createItem(panel, menu, source, strutil, $, item, base,
						render);
			});
}

function addItem(data) {
	createItem(data.item);
}
function redrawItem(data) {
	createItem(data.item);
}
function redrawPopItem(data) {
}
function removeItem(data) {
}
var items = layout.menu.children;
if (items.length > 0) {
	createMenuFrame(items);
}

function toggle2text(toggle) {
	return toggle.parents("[data-lui-mark='panel.nav.head']")
			.find("[data-lui-mark='panel.nav.text']");
}
layout.menu.on('popupShow', function() {
	accordionPanel.on('toggleAfter', function(evt) {
		if (!evt)
			return;
		if (evt.visible) {
			var toggle = accordionPanel.togglesNode[evt.index], text = toggle2text(toggle);
			text.addClass(text.attr("data-lui-switch-class"));
		}
	});

	// 置于首次toggle事件后面，避免因为加载速度问题导致报错
	accordionPanel.on('layoutDone', function() {
				accordionPanel.onToggle = function(i, isInit, isShow, event) {
					var self = accordionPanel;
					var content = accordionPanel.contentsNode[i];
					var toggle = accordionPanel.togglesNode[i];
					var evt = {};
					if (!isInit && !event)
						return;
					var ___toggle = $(event.target), top;
					for (var k = 0; k < accordionPanel.contentsNode.length; k++) {
						var content = accordionPanel.contentsNode[k];
						var ____toggle = accordionPanel.togglesNode[k];
						top = ___toggle.position().top;
						evt.visible = accordionPanel.contents[k].isShow;
						if (k == i) {
							if (evt.visible) {
								content.slideUp(300);
								if (toggle) {
									toggle.addClass(toggle
											.attr("data-lui-switch-class"));
									var text = toggle2text(toggle);
									text.addClass(text
											.attr("data-lui-switch-class"));
								}
							} else {
								if (!accordionPanel.contents[k].isLoad)
									content.show();
								else
									content.slideDown(300);
								accordionPanel.contents[k].load();
								if (toggle) {
									toggle.removeClass(toggle
											.attr("data-lui-switch-class"));
									var text = toggle2text(toggle);
									text.removeClass(text
											.attr("data-lui-switch-class"));
								}
							}
							if (evt.visible) {
								accordionPanel.contents[k].isShow = false;
							} else {
								accordionPanel.contents[k].isShow = true;
							}
						} else {
							if (evt.visible) {
								// 兼容ie
								var scrollTop = $(document).scrollTop();
								content.hide();
								if (____toggle) {
									____toggle.addClass(____toggle
											.attr("data-lui-switch-class"));
									var ____text = toggle2text(____toggle);
									____text.addClass(____text
											.attr("data-lui-switch-class"));
								}
								accordionPanel.contents[k].isShow = false;
								$('html,body').animate({
									'scrollTop' : ___toggle.position().top
											- (top - scrollTop)
								}, 400);
							}
						}
					}
				};
			});
	accordionPanel.draw();

})
layout.menu.on("addItem", addItem);
layout.menu.on("redrawItem", redrawItem);
layout.menu.onErase(function() {
			layout.menu.off('addItem', addItem);
			layout.menu.off('redrawItem', redrawItem);
		});