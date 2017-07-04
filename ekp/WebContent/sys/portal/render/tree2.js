var target = render.vars.target?render.vars.target:'_top';
var dom = $("<div class='lui_accordionpanel_frame'></div>");
var bodys=[];
var arraws=[];
for(var i=0; i<data.length; i++){
	var lv1 = data[i];
	var content  = $("<div class='lui_accordionpanel_content_frame'></div>");
	var header = $("<div class='lui_accordionpanel_header_l'></div>");
	var html = [];
	html.push('<div class="lui_accordionpanel_header_r">');
	html.push('<div class="lui_accordionpanel_header_c">');
	html.push('<div class="lui_accordionpanel_nav_l" style="cursor: pointer;">');
	html.push('<div class="lui_accordionpanel_nav_r">');
	html.push('<div class="lui_accordionpanel_nav_c">');
	html.push('<span class="lui_accordionpanel_nav_text">'+lv1.text+'</span>');
	html.push('<span data-lui-mark="panel.nav.toggle" class="lui_accordionpanel_toggle_up" data-lui-switch-class="lui_accordionpanel_toggle_down">&nbsp;</span>');
	html.push('</div>');
	html.push('</div>');
	html.push('</div>');
	html.push('</div>');
	html.push('</div>');
	header.html(html.join(''));
	var title = header.find(".lui_accordionpanel_nav_c");
	var arraw = header.find("[data-lui-mark='panel.nav.toggle']");
	arraws.push(arraw);
	var aclass2 = arraw.attr("data-lui-switch-class");
	title.click((function(index){
		return function(){
			if(arraws[index].is("."+aclass2)){
				bodys[index].slideDown();
				arraws[index].removeClass(aclass2);
			}else{
				bodys[index].slideUp();
				arraws[index].addClass(aclass2);
			}
		};
	})(i));
	
	var body = $('<div class="lui_accordionpanel_content_l"></div>');
	html = [];
	html.push('<div class="lui_accordionpanel_content_r">');
	html.push('<div class="lui_accordionpanel_content_c" style="padding: 8px;">');
	html.push('<div class="lui_panel_content_inside">');			
	html.push('</div>');
	html.push('</div>');
	html.push('</div>');
	body.html(html.join(''));
	bodys.push(body);
	var xbody = body.find(".lui_panel_content_inside");
	var xul = $("<ul class='lui_list_nav_list'></ul>");
	for(var j=0;j<lv1.children.length;j++){
		xul.append('<li><a href="'+env.fn.formatUrl(lv1.children[j].href)+'" target="'+target+'" title="'+lv1.children[j].text+'">'+lv1.children[j].text+'</a></li>');
	}
	xbody.append(xul);
	
	var footer = $('<div class="lui_accordionpanel_footer_l"></div>');
	html = [];
	html.push('<div class="lui_accordionpanel_footer_r">');
	html.push('<div class="lui_accordionpanel_footer_c">');			
	html.push('</div>');
	html.push('</div>');
	footer.html(html.join(''));
	
	content.append(header).append(body).append(footer);
	
	dom.append(content);
}

done(dom);