var element = render.parent.element;
var target = render.vars.target?render.vars.target:'_self';

function createHeader(root){
	var domR = $("<div class='lui_portal_nav_page_menu_r'></div>");
	domR.appendTo(root);
	var domC = $("<div class='lui_portal_nav_page_menu_c'></div>");
	domC.appendTo(domR);
	var div = $("<div class='lui_portal_nav_page_menu_items_div'></div>");
	div.appendTo(domC);
	return div;
} 
function createItem(parent,data,createLine){
	var item = $("<div style='display: inline-block;vertical-align: top;'></div>");
	item.appendTo(parent);
	
	var selected = data.selected == null ? false : data.selected;
	if(selected){
		item.attr("class","lui_portal_nav_page_menu_item_current");
	}else{
		item.attr("class","lui_portal_nav_page_menu_item_div");
	}
	item.click(function(){ 
		window.open(env.fn.formatUrl(data.href), data.target);
	});
	/**
	item.click((function(__target){
		return function(){ 
			window.open(env.fn.formatUrl(data.href), __target);
		};
	})(data.target));
	**/
	
	var domL = $("<div class='lui_portal_nav_page_menu_item_l'></div>");
	domL.appendTo(item);
	var domR = $("<div class='lui_portal_nav_page_menu_item_r'></div>");
	domR.appendTo(domL);
	var domC = $("<div class='lui_portal_nav_page_menu_item_c'></div>");
	domC.appendTo(domR);
	
	var iconDiv = $('<div>').attr('class','lui_icon_l').appendTo(domC);
	$('<div>').attr('class', 'lui_icon_l '+data.icon).appendTo(iconDiv);
	if(selected){
		iconDiv.addClass("lui_icon_on");
	}else{
		item.hover(
				function () {
					$(this).addClass("lui_portal_nav_page_menu_item_hover");
					iconDiv.addClass("lui_icon_on");
				},
				function () {
					$(this).removeClass("lui_portal_nav_page_menu_item_hover");
					iconDiv.removeClass("lui_icon_on");
				}
		);
	}
	var textDiv = $('<div>').attr('class', 'textEllipsis lui_portal_nav_page_menu_txt').appendTo(domC);
	textDiv.text(data.text);	 
}
var root = $("<div class='lui_portal_nav_page_menu_l'></div>");
var xdiv = createHeader(root);
var left = $("<div class='lui_portal_nav_page_menu_items_left'></div>").hide().appendTo(xdiv);
var frame = $("<div class='lui_portal_nav_page_menu_items_frame'></div>").appendTo(xdiv);
var right = $("<div class='lui_portal_nav_page_menu_items_right'></div>").hide().appendTo(xdiv);
var body = $("<div class='lui_portal_nav_page_menu_items_body'></div>").appendTo(frame);
frame.css("width","10000");
for(var i=0; i<data.length; i++){
	createItem(body,data[i],(i<data.length-1));
} 
done(root);
var w1 = xdiv.width();
var w2 = body.width();
if(w2>w1){
	left.show();
	right.show();
	body.css("width",body.width());
	frame.css("left",left.width());
	frame.css("right",right.width());
	frame.css("width","");
	left.click(function(){
		var xl = frame.scrollLeft();
		var scro = xl - 300;
		frame.animate({scrollLeft: scro}, 200);
	});
	right.click(function(){
		var xl = frame.scrollLeft();
		var scro = xl + 300;
		frame.animate({scrollLeft: scro}, 200);
	});
}