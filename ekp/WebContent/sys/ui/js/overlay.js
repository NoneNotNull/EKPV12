// JavaScript Document
define(function(require, exports, module) {
	var $ = require("lui/jquery");
	var base = require("lui/base");
	
	var Overlay = base.Base.extend({ 
		initProps : function(builder){
			this.parent = builder.parent;
			
			this.trigger = builder.trigger;
			if(builder.trigger)
				builder.trigger.overlay = this; 
				
			this.position  = builder.position || new DefaultPosition();
			this.position.overlay = this;
				
			this.actor  = builder.actor || new DefaultActor();
			this.actor.overlay = this;
				
			this.content  = builder.content || new DefaultContent();
			this.content.overlay = this;
				
			if(builder.trigger)
				builder.trigger.startup();
			this.position.startup();
			this.actor.startup();
			this.content.startup();
		},
		getPosition : function(){
			return this.position.get();
		},
		getContent : function(){
			return this.content.get();
		},
		getActor : function(){
			return this.actor;
		},
		getTrigger : function(){
			return this.trigger;
		},
		show :function(){
			this.emit('show');
			this.actor.show();
		},
		hide :function(){			
			this.actor.hide();
			this.emit('hide');
		},
		destroy:function($super) {
					if (this.trigger)
						this.trigger.destroy();
					this.position.destroy();
					this.actor.destroy();
					this.content.destroy();
					$super();
				}
	}); 
	var HoverTrigger = base.Base.extend({
 		initProps : function(_config){
 			this.element = $(_config.element);
 			this.event = _config.event;
 			this.position = _config.position;
 		},
 		startup : function(){
 			var self = this;
 			var parentTrigger = self.overlay.parent==null?null:self.overlay.parent.trigger;
 			self.overlay.hide();
 			var show = false;
 			var showTimeout = -1, hideTimeout = -1;
 			
 			//监听事件触发显示
 			self.element.bind(self.event,function(evt){
 				if(show || showTimeout>-1)
 					return;
 				showTimeout = window.setTimeout(function(){
 					show = true;
 					showTimeout = -1;
 					self.overlay.show();
 				},300);
 			});
 			self.element.bind("mouseout",function(evt){
 				if(showTimeout>-1){
 					window.clearTimeout(showTimeout);
 					showTimeout = -1;
 				}
 			});
 			
 			//监听事件触发隐藏
 			self.on('mouseover', function(){
 				if(hideTimeout>-1){
 					window.clearTimeout(hideTimeout);
 					hideTimeout = -1;
 				}
 				$(window).bind("scroll", function() {
					self.emit('mouseout',{timer:1});
				});
 				if(parentTrigger)
 					parentTrigger.emit('mouseover');
 			});
 			self.on('mouseout', function(evt){
 				if(hideTimeout>-1){
 					window.clearTimeout(hideTimeout);
 					hideTimeout = -1;
 				}
 				if(show){
 					var timer = 300;
 					if(evt && evt.timer)
 						timer = evt.timer;
 					hideTimeout = window.setTimeout(function(){
 	 					show = false;
 						hideTimeout = -1;
 	 					self.overlay.hide();
 	 					$(window).unbind("scroll");
 	 				},timer);
 				}
 				if(parentTrigger)
 					parentTrigger.emit('mouseout');
 			});
 			
 			self.hoverEvent = {
 				"mouseover" : function(){
					self.emit('mouseover');
 				},
 				"mouseout":function(){
 					self.emit('mouseout');
 				}
 			}; 
			if(self.position){
				self.position.bind(self.hoverEvent);
			}
			self.element.bind(self.hoverEvent);
			self.overlay.getContent().bind(self.hoverEvent);
 		}
 	});
	var DefaultPosition = base.Base.extend( {
		initProps : function(_config) {
		},

		getClientHeight : function() {
			if (window.innerHeight)
				return window.innerHeight;
			return $(window).height();
		},
		
		getClientWidth : function() {
			return $(window).width();
		},
		
		// 屏幕中间定位
		get : function() {
			var ww = this.getClientWidth(), wh = this.getClientHeight();
			var element = this.overlay.getContent();
			var ow = element.width(), oh = element.height();
			var top = (wh - oh) / 2;
			var left = (ww - ow) / 2;
			return {
				"left" : left,
				"top" : top
			};
		}
	});
	// 自定义定位
	var CustomPosition = base.Base.extend({
				initProps : function($super,_config) {
					$super(_config);
					this.top = this.config.top || 0;
					this.left = this.config.left || 0
				},
				get : function() {
					return {
						"left" : this.left,
						"top" : this.top
					};
				}
			});
			
	// 元素中间定位
	var ElementPosition = base.Base.extend({
				initProps : function($super, _config) {
					$super(_config)
					this.elem = $(this.config.elem);
				},
				get : function() {
					var ww = $(window).width(), wh = $(window).height();
					var element = this.overlay.getContent();
					var ow = element.innerWidth(), oh = element.innerHeight();
					var top = (wh - oh) / 2;
					var left = (ww - ow) / 2;
					if (this.elem && this.elem.length) {
						var ws = $(window).scrollTop();
						var pos = this.elem.offset();
						var el = pos.left, et = pos.top;
						var ew = this.elem.innerWidth(), eh = this.elem
								.innerHeight();
						if (et - ws >= 0) {
							if (eh >= wh || wh - (et - ws) < oh) {
								top = et + (wh - (et - ws) - oh) / 2;
							} else {
								top = et + (eh - oh) / 2;
							}
						}
						if (ws - et > 0) {
							if (eh >= wh) {
								if ((ws - et) <= (eh - wh)) {
									top = et + (ws - et) + (wh - oh) / 2;
								} else {
									top = et + (ws - et)
											+ (eh - (ws - et) - oh) / 2;
								}
							}
							if (eh < wh) {
								top = et + (ws - et) + (eh - (ws - et) - oh)
										/ 2;
							}
						}
						left = el + (ew - ow) / 2;
					}
					return {
						"left" : left,
						"top" : top
					};
				}
			});
	
	// 根据某个元素计算弹出层的坐标
	var RelationPosition = DefaultPosition.extend({
		initProps : function(_config){
			this.borderWidth = _config.border || 0;
			this.element = _config.element;
			this.align = _config.align;
			this.oalign = _config.align;
		},
		getWindowClient:function(){ 
			var l, t, w, h; 
			l = document.documentElement.scrollLeft || document.body.scrollLeft; 
			t = document.documentElement.scrollTop || document.body.scrollTop; 
			w = document.documentElement.clientWidth; 
			h = document.documentElement.clientHeight; 
			return { left: l, top: t, width: w, height: h }; 
		},
		get : function(){
			this.align = this.oalign;
			var self = this;
			var e = this.element.offset();
			var w = this.element.outerWidth(true);
			var h = this.element.outerHeight(true);
			var ml = this.element.css("margin-left");
			var mr = this.element.css("margin-right");
			var mt = this.element.css("margin-top");
			var md = this.element.css("margin-bottom");
			ml = ml ? parseInt(ml) : 0;
			mr = mr ? parseInt(mr) : 0;
			mt = mt ? parseInt(mt) : 0;
			md = md ? parseInt(md) : 0;
			var boxw = this.overlay.getContent().outerWidth(true);
			var boxh = this.overlay.getContent().outerHeight(true);
			var wc = this.getWindowClient();  
			var cal = {
				"down-left":function(){
					return {l:e.left-(self.borderWidth),t:e.top+h-(mt+md)};
				},
				"down-right":function(){
					return {l:e.left-(boxw-w)+(self.borderWidth)-(mr+ml),t:e.top+h-(mt+md)};
				},
				"right-top":function(){
					return {l:e.left+w-(mr+ml),t:e.top-(self.borderWidth)};
				},
				"right-down":function(){
					return {l:e.left+w-(mr+ml),t:e.top-(boxh-h)+(self.borderWidth)-(mr+ml)};
				},
				"top-left":function(){
					return {l:e.left-(self.borderWidth),t:e.top-(boxh)};
				},
				"top-right":function(){
					return {l:e.left-(boxw-w)+(self.borderWidth)-(mr+ml),t:e.top-(boxh)};
				},
				"left-top":function(){
					return {l:e.left-(boxw),t:e.top-(self.borderWidth)};
				},
				"left-down":function(){
					return {l:e.left-(boxw),t:e.top-(boxh-h)+(self.borderWidth)-(mr+ml)};
				}
			};
			var np = cal[this.align]();
			 
			var b = {left:0,top:0};
			var temp = this.align.split("-");
			if(temp[0]=="down"){
				//如果自定在下方显示，但是下方的高度不够,则判断是否能在上方显示
				if((np.t+b.top+boxh)>(wc.top + wc.height)){
					var tnp = cal["top-"+temp[1]]();
					if(tnp.t+b.top>wc.top){
						np = tnp;
						this.align = "top-"+temp[1];
					}
				}
			}else if(temp[0]=="top"){
				//如果自定在上方显示，但是上方的高度不够,则判断是否能在下方显示
				if(np.t+b.top<wc.top){
					var tnp = cal["down-"+temp[1]]();
					if((tnp.t+b.top+boxh)<(wc.top+wc.height)){
						np = tnp;
						this.align = "down-"+temp[1];
					}
				}
			}else if(temp[0]=="right"){				
				//如果自定在右边显示，但是右边的宽度不够,则判断是否能在左边显示
				if((np.l+b.left+boxw) > (wc.left+wc.width)){
					var tnp = cal["left-"+temp[1]]();
					if((tnp.l + b.left)>0){
						np = tnp;
						this.align = "left-"+temp[1];						
					}
				}
			}else if(temp[0]=="left"){				
				//如果自定左边显示，但是左边的宽度不够,则判断是否能在右边显示
				if((np.l+ b.left) < wc.left){
					var tnp = cal["right-"+temp[1]]();
					if((tnp.l + b.left+boxw) < (wc.left+wc.width)){
						np = tnp;
						this.align = "right-"+temp[1];						
					}
				}
			}
			
			var temp = this.align.split("-");
			if(temp[1]=="left"){
				if((np.l + b.left+ boxw) > (wc.left + wc.width)){
					np.l = np.l - ((np.l + b.left+ boxw) - (wc.left + wc.width));
				}
			}else if(temp[1]=="right"){
				if(np.l+ b.left<wc.left){
					np.l = wc.left-b.left;
				}
			}else if(temp[1]=="top"){
				if((np.t + b.top + boxh) > (wc.top + wc.height)){
					np.t = np.t - ((np.t + b.top + boxh) - (wc.top + wc.height));
				}
			}else if(temp[1]=="down"){
				if(np.t+b.top<wc.top){
					np.t = wc.top -b.top;
				}
			}
			this.overlay.getActor().align = this.align;
			return {
				"left":np.l,
				"top":np.t
			};
		}
	});
	var DefaultActor = base.Base.extend({
		initProps : function(){	
		},
		show :function(){
			var pos = this.overlay.getPosition();
			var content = this.overlay.getContent();
			content.css({"left":pos.left,"top":pos.top}).show();
			this.createMark(pos, content);
		},
		createMark:function(pos,cont){
			//debugger;
			this.mark = $("#lui_popup_border_mark_"+this.cid).length > 0 ? $("#lui_popup_border_mark_"+this.cid) : $("<div id='lui_popup_border_mark_"+this.cid+"' class='lui_popup_border_mark'><iframe frameborder='0' style='width:100%;height:100%'></iframe></div>").insertAfter(this.overlay.getContent());
			this.mark.css({"position":"absolute","z-index":this.zIndex-2,"top":pos.top,"left":pos.left});
			//debugger;
			this.mark.height(cont.outerHeight(true));
			this.mark.width(cont.outerWidth(true));
			this.mark.show();
		},
		hide :function(){
			this.overlay.getContent().hide();
			if(this.mark){
				this.mark.hide();
			}
		}
	});
	var BorderActor = DefaultActor.extend({
		initProps : function(_config){
			this.element = _config.element;
			this.borderWidth = _config.border;
			this.align = _config.align;
			this.backgroundColor = _config.bgclolr || "white";
			this.zIndex = _config.zIndex || LUI.zindex();
			this.zIndex = this.zIndex + 1;
		},
		hide :function($super){
			$super();
			$("#lui_popup_border_left_"+this.cid).hide().off();
			$("#lui_popup_border_right_"+this.cid).hide().off();
			$("#lui_popup_border_top_"+this.cid).hide().off();
			$("#lui_popup_border_down_"+this.cid).hide().off();
			$("#lui_popup_border_mark_"+this.cid).hide().off();
			var swclass = $.trim(this.element.attr("data-lui-switch-class"));					
			if(swclass != ""){
				this.element.removeClass(swclass);
			}
		},
		show : function($super){
			var swclass = $.trim(this.element.attr("data-lui-switch-class"));					
			if(swclass != ""){
				this.element.addClass(swclass);
			}
			this.overlay.getContent().css({"border-width":""+(this.borderWidth)+"px"});
			var bgc = this.overlay.getContent().css("background-color");
			if(bgc){
				if(bgc=="rgba(0, 0, 0, 0)" || bgc=="transparent")
					this.backgroundColor="white";
				else
					this.backgroundColor=bgc;
			}
			$super();
			this.createBorder();
		},
		createBorder:function(){
			var pos = this.element.offset();
			var w = this.element.outerWidth(true);
			var h = this.element.outerHeight(true);	
			var fx = this.align.split("-")[0];
			
			var ml = this.element.css("margin-left");
			var mr = this.element.css("margin-right");
			var mt = this.element.css("margin-top");
			var md = this.element.css("margin-bottom");
			ml = ml ? parseInt(ml) : 0;
			mr = mr ? parseInt(mr) : 0;
			mt = mt ? parseInt(mt) : 0;
			md = md ? parseInt(md) : 0;
			w = w - ml - mr;
			h = h - mt - md;
			var borderWidth = this.borderWidth;
			var left = $("#lui_popup_border_left_"+this.cid).length > 0 ? $("#lui_popup_border_left_"+this.cid) : $("<div id='lui_popup_border_left_"+this.cid+"' class='lui_popup_border_stroke'></div>").insertAfter(this.overlay.getContent());	
			var right = $("#lui_popup_border_right_"+this.cid).length > 0 ? $("#lui_popup_border_right_"+this.cid) : $("<div id='lui_popup_border_right_"+this.cid+"' class='lui_popup_border_stroke'></div>").insertAfter(this.overlay.getContent());
			var top = $("#lui_popup_border_top_"+this.cid).length > 0 ? $("#lui_popup_border_top_"+this.cid) : $("<div id='lui_popup_border_top_"+this.cid+"' class='lui_popup_border_stroke'></div>").insertAfter(this.overlay.getContent());
			var down = $("#lui_popup_border_down_"+this.cid).length > 0 ? $("#lui_popup_border_down_"+this.cid) : $("<div id='lui_popup_border_down_"+this.cid+"' class='lui_popup_border_stroke'></div>").insertAfter(this.overlay.getContent());
			if(this.overlay.getTrigger() && this.overlay.getTrigger().hoverEvent){
				left.bind(this.overlay.getTrigger().hoverEvent);
				right.bind(this.overlay.getTrigger().hoverEvent);
				top.bind(this.overlay.getTrigger().hoverEvent);
				down.bind(this.overlay.getTrigger().hoverEvent);
			}
			if(fx == "down" || fx == "top"){
				left.css({"position":"absolute","z-index":this.zIndex,"top":pos.top,"left":pos.left-borderWidth,"width":borderWidth,"height":h});
				right.css({"position":"absolute","z-index":this.zIndex,"top":pos.top,"left":pos.left+w,"width":borderWidth,"height":h});
				top.css({"position":"absolute","z-index":this.zIndex,"top":pos.top-borderWidth,"left":pos.left-borderWidth,"width":w+borderWidth*2,"height":borderWidth});
				down.css({"position":"absolute","z-index":this.zIndex,"top":pos.top+h,"left":pos.left-borderWidth,"width":w+borderWidth*2,"height":borderWidth});
				if(fx == "down"){
					down.css({"background":this.backgroundColor,"left":pos.left,"width":w});
					top.css("background",left.css("background"));
				}
				if(fx == "top"){
					top.css({"background":this.backgroundColor,"left":pos.left,"width":w});
					down.css("background",left.css("background"));
				}
			}else if(fx == "left" || fx == "right"){
				left.css({"position":"absolute","z-index":this.zIndex,"top":pos.top-borderWidth,"left":pos.left-borderWidth,"width":borderWidth,"height":h+borderWidth*2});
				right.css({"position":"absolute","z-index":this.zIndex,"top":pos.top-borderWidth,"left":pos.left+w,"width":borderWidth,"height":h+borderWidth*2});
				top.css({"position":"absolute","z-index":this.zIndex,"top":pos.top-borderWidth,"left":pos.left,"width":w,"height":borderWidth});
				down.css({"position":"absolute","z-index":this.zIndex,"top":pos.top+h,"left":pos.left,"width":w,"height":borderWidth});
				if(fx == "left"){
					left.css({"background":this.backgroundColor,"top":pos.top,"height":h});
					right.css("background",down.css("background"));
				}
				if(fx == "right"){
					right.css({"background":this.backgroundColor,"top":pos.top,"height":h});
					left.css("background-color",down.css("background"));
				}
			}
			left.show(),right.show(),top.show(),down.show();
		}
	});
	var DefaultContent = base.Base.extend({
		initProps : function(_config){
			this.config = _config;
			this.element = _config.element || $("<div>hello</div>").appendTo($(document.body));
		},
		startup : function(){
			
		},
		get : function(){
			return this.element;
		}
	});
	exports.Overlay = Overlay;
	exports.HoverTrigger = HoverTrigger;
	exports.DefaultPosition = DefaultPosition;
	exports.ElementPosition = ElementPosition;
	exports.RelationPosition = RelationPosition;
	exports.CustomPosition = CustomPosition;
	exports.DefaultActor = DefaultActor;
	exports.BorderActor = BorderActor;
	exports.DefaultContent = DefaultContent;
	
});