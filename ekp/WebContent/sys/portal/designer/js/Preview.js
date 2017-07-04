define(function(require, exports, module) {
	var $ = require("lui/jquery");
	var Preview = function(widget){
		this.widget = widget;
	};
	Preview.prototype = {
		render : function(){
			
			if(this.widget.infoView == null){
				if(this.widget.element.children(".preview").length > 0){
					this.widget.infoView = this.widget.element.children(".preview");
				}else{
					this.widget.infoView = $("<div class='preview'></div>").appendTo(this.widget.element);
				}
			}
			this.widget.infoView.empty();
			if(this.widget.setting == null){
				this.widget.infoView.append("<div>部件配置信息丢失</div>");
			}else{			
				this.__preview__(this.widget.infoView);
			}
		},
		__typeText__:function(){
			var type = this.widget.setting.panel;
			if(type == "panel"){
				return "单标签";
			}else if(type == "tabpanel"){
				return "多标签";
			}
		},
		__preview__:function(xdiv){
			if(this.widget.setting.panel == "panel"){
				if(this.widget.setting.panelType == "none"){
					//无边框和标题
					var xcontent = $("<div class='preview_panel_contnet'></div>");
					xcontent.append("<div>内容："+this.widget.setting.portlet[0].sourceName+"</div>");
					xcontent.append("<div>呈现："+this.widget.setting.portlet[0].renderName+"</div>");
					xcontent.append("<div>类型："+this.__typeText__()+"</div>");
					xcontent.append("<div>高度："+this.widget.setting.height+"</div>");
					xcontent.append("<div>布局："+this.widget.setting.layoutName+"</div>");	
					xdiv.append(xcontent);
				}else if(this.widget.setting.panelType == "panel"){
					//有边框和标题
					var xdivnav = $("<div class='preview_panel_nav'></div>");
					var xdivitems = $("<div class='preview_panel_nav_items'></div>");
					xdivnav.append(xdivitems);
					var xtitle = $("<span class='preview_panel_nav_item_2'></span>");
					xtitle.html(""+this.widget.setting.portlet[0].title);
					xtitle.addClass("current");
					xdivitems.append("<span class='preview_panel_nav_item_f'></span>");
					xdivitems.append(xtitle);
					var xcontent = $("<div class='preview_panel_contnet'></div>");
					xcontent.append("<div>内容："+this.widget.setting.portlet[0].sourceName+"</div>");
					xcontent.append("<div>呈现："+this.widget.setting.portlet[0].renderName+"</div>");
					xcontent.append("<div>类型："+this.__typeText__()+"</div>");
					xcontent.append("<div>高度："+this.widget.setting.height+"</div>");
					xcontent.append("<div>布局："+this.widget.setting.layoutName+"</div>");	

					xdiv.append(xdivnav);
					xdiv.append(xcontent);
				}
			}else if(this.widget.setting.panel == "tabpanel"){
				if(this.widget.setting.panelType == "h"){
					//横向排列
					var xdivn = $("<div class='preview_panel_nav'></div>");
					var xdivnav = $("<div class='preview_panel_nav_items'></div>");
					xdiv.append(xdivn.append(xdivnav));
					for(var i=0;i<this.widget.setting.portlet.length;i++){
						var xtitle = $("<span class='preview_panel_nav_item'></span>");
						xtitle.html(""+this.widget.setting.portlet[i].title);
						xtitle.mouseover((function(index){
							return function(){
								xdivnav.children(".preview_panel_nav_item").removeClass("current");
								$(xdivnav.children(".preview_panel_nav_item")[index]).addClass("current");
								xdiv.children(".preview_panel_contnet").hide();
								$(xdiv.children(".preview_panel_contnet")[index]).show();
							};
						})(i));
						xdivnav.append("<span class='preview_panel_nav_item_f'></span>");
						xdivnav.append(xtitle);
						var xcontent = $("<div class='preview_panel_contnet'></div>");
						xcontent.append("<div>内容："+this.widget.setting.portlet[i].sourceName+"</div>");
						xcontent.append("<div>呈现："+this.widget.setting.portlet[i].renderName+"</div>");
						xcontent.append("<div>类型："+this.__typeText__()+"</div>");
						xcontent.append("<div>高度："+this.widget.setting.height+"</div>");
						xcontent.append("<div>布局："+this.widget.setting.layoutName+"</div>");	
						if(i==0){
							xcontent.show();
							xtitle.addClass("current");
						}else{
							xcontent.hide();					
						}
						xdiv.append(xcontent);
					}					
				}else if(this.widget.setting.panelType == "v"){
					//纵向排列
					for(var i=0;i<this.widget.setting.portlet.length;i++){
						var xtitle = $("<div class='preview_panel_nav_item_2'></div>");
						xtitle.html(""+this.widget.setting.portlet[i].title);
						xtitle.addClass("current");
						var xdivnav = $("<div class='preview_panel_nav'></div>");
						xdivnav.append("<div class='preview_panel_nav_item_f'></div>");
						xdiv.append(xdivnav.append(xtitle));
						var xcontent = $("<div class='preview_panel_contnet'></div>");
						xcontent.append("<div>内容："+this.widget.setting.portlet[i].sourceName+"</div>");
						xcontent.append("<div>呈现："+this.widget.setting.portlet[i].renderName+"</div>");
						xcontent.append("<div>类型："+this.__typeText__()+"</div>");
						xcontent.append("<div>布局："+this.widget.setting.layoutName+"</div>");	
						xdiv.append(xcontent);
					}
				}				
			}
			return xdiv;
		}
	};
	module.exports = Preview;
});