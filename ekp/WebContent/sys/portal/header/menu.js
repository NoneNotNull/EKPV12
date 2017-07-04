var target = render.vars.target?render.vars.target:'_self';

function createHeader(root){
	var domR = $("<div class='lui_portal_header_menu_r'></div>");
	domR.appendTo(root);
	var domC = $("<div class='lui_portal_header_menu_c'></div>");
	domC.appendTo(domR);
	var div = $("<div class='lui_portal_header_menu_item_div'></div>");
	div.appendTo(domC);
	return div;
} 
function createItem(parent,data,createLine){
	var item = $("<div style='display: inline-block;vertical-align: top;'></div>");
	item.appendTo(parent);
	var selected = data.selected == null ? false : data.selected;
	if(selected){
		item.attr("class","lui_portal_header_menu_item_current");
	}else{
		item.attr("class","lui_portal_header_menu_item_div");
	}
	item.hover(
			function () {
				$(this).addClass("lui_portal_header_menu_item_hover");
			},
			function () {
				$(this).removeClass("lui_portal_header_menu_item_hover");
			}
	);
	item.click(function(){
		window.open(env.fn.formatUrl(data.href), data.target);
	});
	var domL = $("<div class='lui_portal_header_menu_item_l'></div>");
	domL.appendTo(item);
	var domR = $("<div class='lui_portal_header_menu_item_r'></div>");
	domR.appendTo(domL);
	var domC = $("<div class='lui_portal_header_menu_item_c'></div>");
	domC.appendTo(domR);
	domC.append(env.fn.formatText(data.text));
	if(createLine){
		parent.append($("<div class='lui_portal_header_menu_item_line' style='display: inline-block;vertical-align: top;'></div>"));
	}
}
var root = $("<div class='lui_portal_header_menu_l'></div>");
var xdiv = createHeader(root);
var left = $("<div class='lui_portal_header_menu_item_left'></div>").hide().appendTo(xdiv);
var frame = $("<div class='lui_portal_header_menu_item_frame'></div>").appendTo(xdiv);
var right = $("<div class='lui_portal_header_menu_item_right'></div>").hide().appendTo(xdiv);
var body = $("<div class='lui_portal_header_menu_item_body'></div>").appendTo(frame);
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