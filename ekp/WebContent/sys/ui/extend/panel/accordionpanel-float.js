layout.contents = [];
layout.navs = [];
function createContentNav(content){
	var ndom = $("<div class='lui_accordionpanel_float_nav_item'></div>");
	var nitem = $("<div class='lui_accordionpanel_float_nav_item_l'><div class='lui_accordionpanel_float_nav_item_r'><div class='lui_accordionpanel_float_nav_item_c'></div></div></div>");
	nitem.find(".lui_accordionpanel_float_nav_item_c").append(content.title);
	return ndom.append(nitem);
}
function createContent(content){
	var cdom = $("<div class='lui_accordionpanel_float_content'></div>");
	var ch = $("<div class='lui_accordionpanel_float_header_l'><div class='lui_accordionpanel_float_header_r'><div class='lui_accordionpanel_float_header_c'></div></div></div>");
	var cc = $("<div class='lui_accordionpanel_float_content_l'><div class='lui_accordionpanel_float_content_r'><div class='lui_accordionpanel_float_content_c'></div></div></div>");
	var cf = $("<div class='lui_accordionpanel_float_footer_l'><div class='lui_accordionpanel_float_footer_r'><div class='lui_accordionpanel_float_footer_c'></div></div></div>");
	var ct = $("<div class='lui_accordionpanel_float_header_text'></div>").append(content.title);
	var cx = $("<div class='lui_accordionpanel_float_header_close'></div>");
	var cht = $("<div class='lui_accordionpanel_float_header_title'></div>");
	cht.append(ct);
	if(content.getToggle()){
		cx.click((function(index){
			return function(){
				layout.accordionpanel.onToggle(index);
			};
		})(i));
		cht.append(cx);
	}
	ch.find(".lui_accordionpanel_float_header_c").append(cht);
	cc.find(".lui_accordionpanel_float_content_c").append(content.element);
	cdom.append(ch).append(cc).append(cf).hide();
	return cdom;
}

var dom = $("<div class='lui_accordionpanel_frame'></div>");
//内容
var csNode = $("<div class='lui_accordionpanel_float_contents'></div>");
for(var i=0;i<layout.accordionpanel.contents.length;i++){
	var ni = createContent(layout.accordionpanel.contents[i]);
	layout.contents.push(ni);
	csNode.append(ni);
}
dom.append(csNode);
//标题
var ns = $("<div class='lui_accordionpanel_float_navs'></div>");
//ns.append($("<div class='lui_accordionpanel_float_nav_item_before'></div>"));
//ns.append($("<div class='lui_accordionpanel_float_nav_item_after'></div>"));
var nb = $("<div class='lui_accordionpanel_float_navs_l'><div class='lui_accordionpanel_float_navs_r'><div class='lui_accordionpanel_float_navs_c'></div></div></div>");
var nsNode = nb.find(".lui_accordionpanel_float_navs_c");
for(var i=0;i<layout.accordionpanel.contents.length;i++){
	var ni = createContentNav(layout.accordionpanel.contents[i]);
	if(layout.accordionpanel.contents[i].getToggle()){
		ni.click((function(index){
			return function(){
				layout.accordionpanel.onToggle(index);
			};
		})(i));
	}
	layout.navs.push(ni);
	nsNode.append(ni);
}

ns.append(nb); 
dom.append(ns);
layout.accordionpanel.on("toggleBefore",function(data){
	var i = data.index;
	var vcontent = layout.contents[i];;
	if(data.visible){
		if(data.init)
			vcontent.hide()
		else
			vcontent.slideUp(); 
		layout.navs[i].removeClass("selected");		
	}else{
		layout.accordionpanel.contents[i].load();
		layout.navs[i].addClass("selected");
		if(data.init){
			vcontent.show(); 
		}else{
			vcontent.slideDown(); 
			$("html,body").animate({scrollTop: vcontent.offset().top}, 300);
		}
	}
	data.cancel = true;
}); 
layout.on("addContent",function(content){
	var nic = createContent(content);
	layout.contents.push(nic);
	csNode.append(nic);
	
	var nin = createContentNav(content);
	if(content.getToggle()){
		nin.click((function(index){
			return function(){
				layout.accordionpanel.onToggle(index);
			};
		})(layout.navs.length));
	}
	layout.navs.push(nin);
	nsNode.append(nin);
});
done(dom);
$(document.body).css("margin-bottom",$(".lui_accordionpanel_float_navs").height());