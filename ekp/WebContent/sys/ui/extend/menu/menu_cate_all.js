var topDom = null;
var contentDom = null;
function createMenuFrame() {
	topDom = $("<div class='lui_menu_frame_cate_all'></div>");
	contentDom = $("<div class='lui_menu_left'></div>").appendTo(topDom);
	contentDom = $("<div class='lui_menu_right'></div>").appendTo(contentDom);
	contentDom = $("<div class='lui_menu_content'></div>").appendTo(contentDom);
}

function createItem(item) {
	var itemTop = $("<div class='lui_menu_item'></div>");
	item.element.appendTo(itemTop);
	var itemContent = $("<div class='lui_item_left'></div>")
			.appendTo(item.element);
	itemContent = $("<div class='lui_item_right'></div>").appendTo(itemContent);
	itemContent = $("<div class='lui_item_content clearfloat'></div>")
			.appendTo(itemContent);
	if (item.triggerObject != null) {
		itemContent.append(item.triggerObject);
	} else {
		if (item.icon) {
			itemContent.append($("<div class='lui_icon_l " + item.icon
					+ "'></div>"));
		}
		if (item.text) {
			itemContent.append($("<div class='lui_item_txt'>" + item.text
					+ "</div>"));
		}
		item.element.attr("data-lui-switch-class", 'lui_icon_on');
	}
	if (item.children.length > 0) {
		if (item.triggerObject == null) {
			itemContent
					.append($("<div data-lui-mark='menu.nav.toggle' class='lui_menu_frame_cate_toggle_down'></div>"));
		}
		seajs.use(['lui/popup', 'lui/menu'], function(popup, menu) {
			if (item instanceof menu.MenuItem) {
				var tmpmenu = menu.buildMenu(item.children, {
							"type" : "Javascript",
							"src" : env.fn
									.formatUrl("/sys/ui/extend/menu/menu_cate.js")
						});
				var containerDiv = $('<div>').attr('class', 'lui_menu_popup');
				containerDiv.css('width', item.parent.element.width());
				containerDiv.append(tmpmenu.element);
				var parentPop = layout.menu.popup;
				var cfg = null;
				if(parentPop==null){
					cfg = {"align":"down-left"};
				}else{
					cfg = {"parent":parentPop,"align":"down-left"};
				}
				var pp = popup.build(item.element , containerDiv, cfg);
				pp.on('show', function() {
					addToggle(item.element);
				});
				pp.on('hide', function() {
					removeToggle(item.element);
				});
				tmpmenu.popup = pp;
				pp.addChild(tmpmenu);
				item.onErase(function(){pp.destroy();tmpmenu.destroy();});
			}
		});
	}
	return itemTop;
}

function removeToggle(obj) {
	var toggle = obj.find('[data-lui-mark="menu.nav.toggle"]');
	if (toggle.hasClass('lui_menu_frame_cate_toggle_up'))
		toggle.removeClass('lui_menu_frame_cate_toggle_up');
	toggle.addClass('lui_menu_frame_cate_toggle_down');
}

function addToggle(obj) {
	var toggle = obj.find('[data-lui-mark="menu.nav.toggle"]');
	if (toggle.hasClass('lui_menu_frame_cate_toggle_down'))
		toggle.removeClass('lui_menu_frame_cate_toggle_down');
	toggle.addClass('lui_menu_frame_cate_toggle_up');
}

function addItem(data) {
	var newItem = createItem(data.item);
	if (data.posItem != null) {
		if (data.isBefore) {
			data.posItem.element.parent().before(newItem);
		} else {
			data.posItem.element.parent().after(newItem);
		}
	} else {
		newItem.appendTo(contentDom);
	}
}
function redrawItem(data) {
	if (data.posItem != null) {
		var arguDom = data.posItem.element.parent();
		var newItem = createItem(data.item);
		arguDom.after(newItem);
		arguDom.remove();
	}
}
function removeItem(data) {
	if (data.item != null) {
		var arguDom = data.item.element.parent();
		arguDom.remove();
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
layout.menu.onErase(function() {
			layout.menu.off('addItem', addItem);
			layout.menu.off('redrawItem', redrawItem);
			layout.menu.off('removeItem', removeItem);

		});
done(topDom);