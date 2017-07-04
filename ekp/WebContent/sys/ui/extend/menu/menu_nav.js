var topDom = null;
var contentDom = null;
var triggerObject = "all";//目前接收值all、sign
var cssExtend = "";
if(!layout.menu.___data){
	layout.menu.___data = [];
}
if(param!=null ){
	if(param.extend!=null){
		cssExtend = "_" + param.extend;
	}
	if(param.triggerObject!=null){
		triggerObject = param.triggerObject;
	}
}
function createMenuFrame(){
	topDom = $("<div class='lui_menu_frame_nav"+cssExtend+"'></div>");
	contentDom = $("<div class='lui_menu_left'></div>").appendTo(topDom);
	contentDom = $("<div class='lui_menu_right'></div>").appendTo(contentDom);
	contentDom = $("<div class='lui_menu_content'></div>").appendTo(contentDom);
}
function createItem(item){
	if (item.config.value) {
		layout.menu.___data.push({
					value : item.config.value,
					text : item.config.text,
					nodeType : item.config.nodeType
				});
	}
	var itemTop = $("<div class='lui_menu_item'></div>");
	item.element.appendTo(itemTop);
	var itemContent = $("<div class='lui_item_left'></div>").appendTo(item.element);
	itemContent = $("<div class='lui_item_right'></div>").appendTo(itemContent);
	itemContent = $("<div class='lui_item_content'></div>").appendTo(itemContent);
	if(item.triggerObject!=null){
		itemContent.append(item.triggerObject);
	}else{
		if(item.icon){
			itemContent.append($("<div class='lui_icon_s "+item.icon+"'></div>"));
		}
		if(item.text){
			itemContent.append($("<div class='lui_item_txt'>"+item.text+"</div>"));
		}
		item.element.attr("data-lui-switch-class",'lui_item_stitch_class');
	}
	if(item.children.length>0){
		if(item.triggerObject==null){
			var signObj = $("<div class='lui_item_sign lui_icon_s lui_icon_s_icon_3'></div>").click(function(evt){
			    evt.stopPropagation();
			});
			itemContent.append(signObj);
		}
		seajs.use(['lui/popup','lui/menu'],function(popup,menu){
			if(item instanceof menu.MenuItem){
				var tmpmenu = menu.buildMenu(item.children,{
					"type": "Javascript",
					"param":{"extend":"pop"},
					"src":"/sys/ui/extend/menu/menu_vertical.js"
					});
				var containerDiv = $('<div>').attr('class', 'lui_menu_popup_nav'+cssExtend);
				containerDiv.append(tmpmenu.element);
				var parentPop = layout.menu.popup;
				var cfg = null;
				if(parentPop==null){
					cfg = {"align":"down-left"};
				}else{
					cfg = {"parent":parentPop,"align":"down-left"};
				}
				var pp = popup.build(item.element , containerDiv, cfg);
				tmpmenu.popup = pp;
				pp.addChild(tmpmenu);
				item.onErase(function(){pp.destroy();tmpmenu.destroy();});
			}
		});
	}
	return itemTop;
}
function addItem(data, beforeItem) {
	var newItem = createItem(data.item);
	if (typeof(data.index) != 'undefined' && typeof(data.len) != 'undefined'
			&& data.index == data.len - 1) {
		newItem.addClass('lui_menu_item_last');
		newItem.addClass('com_subhead');
	}
	if (data.posItem != null) {
		if (data.isBefore) {
			data.posItem.element.parent().before(newItem);
		} else {
			data.posItem.element.parent().after(newItem);
		}
	} else {
		newItem.appendTo(contentDom);
	}
	newItem.before("<div class='lui_menu_item_split'></div>");
}
function redrawItem(data) {
	if (data.posItem != null) {
		var arguDom = data.posItem.element.parent();
		var newItem = createItem(data.item);
		if (typeof(data.index) != 'undefined'
				&& typeof(data.len) != 'undefined'
				&& data.index == data.len - 1) {
			newItem.addClass('lui_menu_item_last');
			newItem.addClass('com_subhead');
		}
		arguDom.after(newItem);
		arguDom.remove();
	}
}
function removeItem(data){
	if(data.item!=null){
		var arguDom = data.item.element.parent();
		arguDom.prev("div.lui_menu_item_split").remove();
		arguDom.remove();
	}
}
function redrawPopItem(data){
	if(data.popupItem!=null){
		var itemEle = data.popupItem.element;
		if(itemEle!=null){
			itemEle.find(".lui_item_sign").remove();
		}
	}
}
var items = layout.menu.children;
if(items.length>0){
	createMenuFrame();
	for(var i=0;i<items.length;i++){
		if(items[i]!=layout)
			addItem({"item":items[i]});
	}
}

layout.menu.gotoNav = function(index) {
	var href = "";
	var arr;
	if (index > 0) {
		arr = layout.menu.___data[index];
		if (layout.menu.menuSouce) {
			href = layout.menu.menuSouce[0].href.replace(/!{value}/,
					arr['value']);
			href = href.replace(/!{nodeType}/,
					arr['nodeType']);
		}
	} else {
		if (layout.menu.___data.length > 1) {
			arr = layout.menu.___data[layout.menu.___data.length - 2];
			href = layout.menu.menuSouce[0].href.replace(/!{value}/,
					arr['value']);
			href = href.replace(/!{nodeType}/,
					arr['nodeType']);
		} else {
			href = layout.menu.menuSouce[0].href.replace(/!{value}/, '');
			href = href.replace(/!{nodeType}/,'');
		}
	}
	window.open(env.fn.formatUrl(href), '_self');
}

layout.menu.on("addItem",addItem);
layout.menu.on("redrawItem",redrawItem);
layout.menu.on("removeItem",removeItem);
layout.menu.on("popupItemHide",redrawPopItem);
layout.menu.onErase(function(){
	layout.menu.off('addItem', addItem);
	layout.menu.off('redrawItem', redrawItem);
	layout.menu.off('removeItem', removeItem);
	layout.menu.off("popupItemHide",redrawPopItem);
	
});
done(topDom);