var topDom = null;
var contentDom = null;
var cssExtend = "";
if (param != null) {
	if (param.extend != null) {
		cssExtend = "_" + param.extend;
	}
}
function createMenuFrame() {
	topDom = $("<div class='lui_menu_frame_cate" + cssExtend + "'></div>");
	contentDom = $("<div class='lui_menu_left'></div>").appendTo(topDom);
	contentDom = $("<div class='lui_menu_right'></div>").appendTo(contentDom);
	contentDom = $("<div class='lui_menu_content'></div>").appendTo(contentDom);
}
function createLayout(html) {
	var li = $("<li lui-button-container='1'/>");
	li.append(html);
	return li;
}
function getLayoutUl() {
	var ulObj = contentDom.find("ul");
	if (ulObj.length <= 0) {
		ulObj = $("<ul class='lui_menu_cate_all_box'/>").appendTo(contentDom);
	}
	return ulObj;
}
function createItem(item) {
	var itemTop = $("<div class='lui_menu_item'></div>");
	item.element.appendTo(itemTop);
	var itemContent = $("<div class='lui_item_left'></div>")
			.appendTo(item.element);
	itemContent = $("<div class='lui_item_right'></div>").appendTo(itemContent);
	itemContent = $("<div class='lui_item_content'></div>")
			.appendTo(itemContent);
	if (item.triggerObject != null) {
		itemContent.append(item.triggerObject);
	} else {
		if (item.icon) {
			itemContent.append($("<div class='lui_icon_s " + item.icon
					+ "'></div>"));
		}
		if (item.text) {
			itemContent.append($("<div class='lui_item_txt' title='"
					+ item.text + "'>" + item.text + "</div>"));
		}
		item.element.attr("data-lui-switch-class", 'lui_icon_on');
	}

	if (item.triggerObject == null) {
		itemContent
				.append($("<div class='lui_item_sign'><i class='lui_item_sign_mtr1'></i><i class='lui_item_sign_mtr2'></i></div>"));
	}
	if (item.children.length > 0) {

		seajs.use(['lui/popup', 'lui/data/source', 'lui/view/render',
						'lui/menu', 'lui/base', 'lui/util/str'], function(
						popup, source, render, menu, base, strutil) {
					if (item instanceof menu.MenuItem) {
						var dataview = new base.DataView();
						if (item.children[0] instanceof menu.MenuItem) {// 静态数据源
							var staticSource = [];
							for (var i = 0; i < item.children.length; i++) {
								var child = {
									text : item.children[i].text,
									href : item.children[i].href,
									children : []
								};
								for (var j = 0; j < item.children[i].children.length; j++) {
									child.children.push({
										text : item.children[i].children[j].text,
										href : item.children[i].children[j].href
									});
								}
								staticSource.push(child);
							}
							dataview.setSource(new source.Static({
										datas : staticSource,
										parent : this
									}));
						}
						if (item.children[0] instanceof menu.MenuSource) {// 动态数据源

							var url = strutil.variableResolver(
									item.children[0].source._url, item.config);

							dataview.setSource(new source.AjaxJson({
										url : url,
										parent : dataview
									}));
							dataview.load = function() {
								var href = item.children[0].href;
								this.source.get(function(data) {
									if (data && data.length == 0) {
										var popupDatas = {
											popupItem : item
										}
										redrawPopItem(popupDatas);
									} else {
										for (var i = 0; i < data.length; i++) {
											if ($.trim(data[i].href) == ""
													&& item.href != null) {
												data[i].href = strutil
														.variableResolver(href,
																data[i]);
												var children = data[i].children;
												for (var j = 0; j < children.length; j++) {
													if ($
															.trim(children[j].href) == "") {
														children[j].href = strutil
																.variableResolver(
																		href,
																		children[j]);
													}
												}
											}
										}
									}
									return data;
								});
							}
						}
						dataview.setRender(new render.Template({
							src : '/sys/ui/extend/dataview/render/treemenu2.tmpl#',
							param : {
								extend : 'cate'
							},
							parent : dataview,
							vars : {
								target : '_self'
							}
						}));
						dataview.render.startup();
						dataview.startup();
						var popDiv = $('<div>').attr('class',
								'lui_menu_cate_popup' + cssExtend);
						popDiv.append(dataview.element);
						var parentPop = layout.menu.popup;
						var cfg = null;
						if (parentPop == null) {
							cfg = {
								"align" : "right-top"
							};
						} else {
							cfg = {
								"parent" : parentPop,
								"align" : "right-top"
							};
						}
						var pp = popup.build(item.element, popDiv, cfg);
						dataview.popup = pp;
						dataview.on('load', function() {
									if (dataview.data
											&& dataview.data.length > 0)
										popDiv.css('width', 600);
								});
						pp.addChild(dataview);
						dataview.draw();
						item.onErase(function() {
									pp.destroy();
									dataview.destroy();
								});
					}
				});
	}
	return itemTop;
}

function addItem(data) {
	var newItemLi = createLayout(createItem(data.item));
	var layoutTab = getLayoutUl();
	if (data.posItem != null) {
		var liObj = data.posItem.element
				.parents('li[lui-button-container="1"]');
		if (data.isBefore) {
			liObj.before(newItemLi);
		} else {
			liObj.after(newItemLi);
		}
	} else {
		newItemLi.appendTo(layoutTab);
	}
}
function redrawItem(data) {
	var newItemTr = createLayout(createItem(data.item));
	if (data.posItem != null) {
		var liObj = data.posItem.element
				.parents('li[lui-button-container="1"]');
		liObj.after(newItemTr);
		liObj.remove();
	}
}
function redrawPopItem(data) {
	if (data.popupItem != null) {
		var itemEle = data.popupItem.element;
		if (itemEle != null) {
			itemEle.find(".lui_item_sign").remove();
		}
	}
}
function removeItem(data) {
	if (data.item != null) {
		var liObj = data.item.element.parents('li[lui-button-container="1"]');
		liObj.remove();
	}
}
var items = layout.menu.children;
if (items.length > 0) {
	createMenuFrame();
	for (var i = 0; i < items.length; i++) {
		if (items[i] != layout)
			addItem({
						"item" : items[i]
					});
	}
}
layout.menu.on("addItem", addItem);
layout.menu.on("redrawItem", redrawItem);
layout.menu.on("removeItem", removeItem);
layout.menu.on("popupItemHide", redrawPopItem);
layout.menu.onErase(function() {
			layout.menu.off('addItem', addItem);
			layout.menu.off('redrawItem', redrawItem);
			layout.menu.off('removeItem', removeItem);
			layout.menu.off("popupItemHide", redrawPopItem);
		});
done(topDom);