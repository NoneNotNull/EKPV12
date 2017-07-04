define(function(require, exports, module) {	 
	var $ = require("lui/jquery");
	var dialog = require('lui/dialog');
	var Editbox = require('./Editbox');
	var DragDrop = require('lui/dragdrop');
	var Preview = require('./Preview');
	var Util = require('./Util');

	var msg = require("lang!sys-portal:desgin.msg");
	module.exports = Editbox.extend({
		initialize : function($super,config) {
			config.align = "right";
			config.menuIconClass = "widgetIcon";
			$super(config);
			if(this.element.children("script[type='text/config']").length > 0){
				this.setting = Util.toJSON($(this.element.children("script[type='text/config']")[0]).html());
			}
			if(this.setting.panelType=="v"){
				//竖排多标签没有高度设置
				this.element.css("height","");
			} else {
				if($.trim(this.setting.height) != ""){
					this.element.css("height",this.setting.height);
				}
			}
			//this.element.css("height",this.setting.height);
			this.sss = Util.configWidget(this);
			this.preview = new Preview(this);
			var self =this;
			this.element.dblclick(function(){
				self.sss.fn();
			});
		},
		buildMenu : function($super) {
			var self = this;
			this.menuItems = [
						          	Util.configWidget(self),
						          	{
											"icon":"editMenuIconDelete",
											"text":""+msg['desgin.msg.delete'],
											fn:function(value){
												dialog.confirm(msg['desgin.msg.cdelete'],function(value){
													if(value){
														self.destroy();
													}
												});
											}
						          	}
						        ];
			return $super(this.menuItems);
		},
		destroy : function($super){
			this.editMenu.remove();
			this.element.remove();
			this.dropElement.remove();
			var x = $.inArray(this,this.parent.children);
			this.parent.children.splice(x,1);
			try{delete this;}catch(e){};
		},
		startup : function(){
			var self = this;
			this.element.bind("contextmenu",function(evt){ 
				//+self.eidtMenuItem.width()
				self.editMenu.css({"top":evt.pageY-10,"left":evt.pageX-10});
				self.eidtMenuItem.show();
				evt.preventDefault();
				evt.stopPropagation();
			});
			this.element.addClass("widget");
			this.drag = new DragDrop.Draggable({
				body:self.body,
				element:self.element,
				drop:self
			});
			//
			this.dropElement = (function(){
				if(self.element.next("div").is(".widgetDock")){
					return self.element.next("div");
				}else{
					return $("<div class='widgetDock'></div>").css("height",self.parent.config.vSpacing);
				}
			})();
				//$("<div class='widgetDock'></div>").css("height",this.parent.config.vSpacing);
			this.element.after(this.dropElement);
			this.drop = new DragDrop.Droppable({
				body:self.body,
				element:self.dropElement,
				activeClass: "dropActiveClass",
				hoverClass: "dropHoverClass",
				over: function() {
					//this.element.height(30);
				},
				out : function() { 
					this.element.css("height",self.parent.config.vSpacing);
				},
				drop: function(moveObj) {
					if(moveObj != self){
						moveObj.parent.children.splice($.inArray(moveObj,moveObj.parent.children),1);
						moveObj.parent = self.parent;
						self.parent.children.push(moveObj);
						this.element.after(moveObj.dropElement.css("height",self.parent.config.vSpacing));
						this.element.after(moveObj.element);
					}
				}
			});
			
			this.preview.render();
		}
	});
});