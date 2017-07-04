// JavaScript Document
define(function(require, exports, module) {
	require("theme!popup");
	var base = require("lui/base");
	var $ = require("lui/jquery");
	var overlay = require("lui/overlay");
	 	
	var Popup = base.Container.extend({	
		initProps : function($super,_config){
			this.config = _config;
			this.borderWidth = this.config.borderWidth || 1;
			this.align = this.config.align ? this.config.align : "down-left";
			
			this.triggerEvent = this.config.triggerEvent ? this.config.triggerEvent : "mouseover";			
			this.popupObject = this.element;
			$super(_config);
		},
		startup :function(){	
			this.zindex = LUI.zindex();
			this.popupObject.hide().css({"position":"absolute","z-index":this.zindex});
			this.positionObject = this.config.positionObject ? $(this.config.positionObject) : this.element.parent();
			this.triggerObject = this.config.triggerObject ? $(this.config.triggerObject) : this.positionObject; 
			this.popupObject.appendTo($(document.body));
		},
		draw :function($super){			
			if(this.isDrawed)
				return;
			if(this.config.builder==null)
				this.config.builder = {};
			if(this.config.parentOverlay) {
				this.config.builder.parentOverlay = LUI(this.config.parentOverlay);
				if(this.config.builder.parentOverlay)
					this.config.builder.parentOverlay = this.config.builder.parentOverlay.overlay;
			} else {
				for(var p = this.parent; p!=null; p = p.parent){
					if(p.overlay && p.overlay instanceof overlay.Overlay){
						this.config.builder.parentOverlay = p.overlay;
						break;
					}
				}
			}
			this.overlay = new overlay.Overlay({
				"trigger":this.config.builder.trigger || new overlay.HoverTrigger({"element":this.triggerObject,"event":this.triggerEvent,"position":this.positionObject}),
				"position":this.config.builder.position || new overlay.RelationPosition({"element":this.positionObject,"border":this.borderWidth,"align":this.align}),
				"actor":this.config.builder.actor || new overlay.BorderActor({"element":this.positionObject,"border":this.borderWidth,"align":this.align,"zIndex":this.zindex}), 
				"content":this.config.builder.content || new overlay.DefaultContent({"element":this.popupObject.addClass("lui_popup_border_content")}),
				"parent":this.config.builder.parentOverlay
			});
			
			this.config.builder = null;
			this.isDrawed = true;
			this.isChildrenDrawed = false;
			
			var self = this;
			this.overlay.on("show",function(){
				if(!self.isChildrenDrawed){
					for ( var i = 0; i < self.children.length; i++) {
						if(self.children[i].draw){
							self.children[i].draw();
						}
					}
					self.isChildrenDrawed = true;
				}
				self.emit("show");
			});
			this.overlay.on("hide",function(){
				self.emit("hide");
			});
		},
		destroy: function($super) {
			$super();
			if (this.overlay) {
				this.overlay.destroy();
			}
		}
	});
	var build = function(_text,_box,_cfg){
		var text =$(_text);
		var popupBox = $(_box);  
		var config = {
			"element":popupBox,
			"positionObject":text,
			"popupObject":popupBox
		};
		if(_cfg)
			Object.extend(config,_cfg);
		 
		var pp = new Popup(config);
		pp.startup();
		pp.draw();
		return pp;
	};
	exports.Popup = Popup; 
	exports.build = build;
});