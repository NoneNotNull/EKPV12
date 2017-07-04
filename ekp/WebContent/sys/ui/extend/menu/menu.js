var topDom = null;
var contentDom = null;
var cssExtend = "";
if(param!=null ){
	if(param.extend!=null){
		cssExtend = "_" + param.extend;
	}
}
function createMenuFrame(){
	topDom = $("<div class='lui_menu_frame"+cssExtend+"'></div>");
	contentDom = $("<div class='lui_menu_left'></div>").appendTo(topDom);
	contentDom = $("<div class='lui_menu_right'></div>").appendTo(contentDom);
	contentDom = $("<div class='lui_menu_content'></div>").appendTo(contentDom);
}
function createItem(item){
	var itemTop = $("<div class='lui_menu_item'></div>");
	item.element.appendTo(itemTop);
	var itemContent = $("<div class='lui_item_left'></div>").appendTo(item.element);
	itemContent = $("<div class='lui_item_right'></div>").appendTo(itemContent);
	itemContent = $("<div class='lui_item_content'></div>").appendTo(itemContent);
	if(item.triggerObject!=null){
		itemContent.append(item.triggerObject);
	}else{
		if(item.icon){
			itemContent.append($("<div class='lui_icon_l "+item.icon+"'></div>"));
		}
		if(item.text){
			itemContent.append($("<div class='lui_item_txt'>"+item.text+"</div>"));
		}
		if(item.selected){
			item.element.addClass("lui_icon_on");
		}
		item.element.attr("data-lui-switch-class",'lui_icon_on');
	}
	if(item.children.length > 0){
		if(item.triggerObject == null){
			var signObj = $("<div class='lui_item_sign'></div>").click(function(evt){
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
				var containerDiv = $('<div>').attr('class', 'lui_menu_popup'+cssExtend);
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

function addItem(data){
	var newItem = createItem(data.item);
	if(data.posItem!=null){
		if(data.isBefore){
			data.posItem.element.parent().before(newItem);
		}else{
			data.posItem.element.parent().after(newItem);
		}
	}else{
		newItem.appendTo(contentDom);
	}
}
function redrawItem(data){
	if(data.posItem!=null){
		var arguDom = data.posItem.element.parent();
		var newItem = createItem(data.item);
		arguDom.after(newItem);
		arguDom.remove();
	}
}
function removeItem(data){
	if(data.item!=null){
		var arguDom = data.item.element.parent();
		arguDom.remove();
	}
}
function redrawPopItem(data){
	if(data.popupItem!=null){
		var itemEle = data.popupItem.element;
		if(itemEle!=null){
			var sign = itemEle.find(".lui_item_sign");
			sign.attr("class","lui_item_sign_dis");
		}
	}
}
var items = layout.menu.children;
if(items.length>0){
	createMenuFrame();
	for(var i=0;i<items.length;i++){
		if(items[i] != layout)
			addItem({"item":items[i]});
	}
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