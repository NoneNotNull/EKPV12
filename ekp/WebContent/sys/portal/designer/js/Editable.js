define(function(require, exports, module) {
	var $ = require("lui/jquery");
	var Editbox = require('./Editbox');
	var Util = require('./Util');
	var DragDrop = require('lui/dragdrop');
	var msg = require("lang!sys-portal:desgin.msg");
	var Editable = Editbox.extend({ 
		
		initialize : function($super,config) {
			$super(config);
			if(this.config.vSpacing==null){
				if($.trim(this.element.attr("data-config"))!=""){
					var conf = Util.toJSON(unescape(this.element.attr("data-config")));
					if(conf.vSpacing == null){
						this.config.vSpacing = 15;		
					}else{
						this.config.vSpacing = conf.vSpacing;
					}
				}else{
					this.config.vSpacing = 15;					
				}				
			}
		},
		buildMenu : function($super) {
			var self = this;
			this.menuItems = [
			                 	 Util.addVBox(self),
			                 	 Util.addWidget(self),
			                 	 {
			                 		"icon":"editMenuIconConfig",
									"text":""+msg['desgin.msg.proprty'],
									fn:function(value){
										var dp = {};
										dp.vSpacing = self.config.vSpacing;
										Util.showDialog(this.text,'/sys/portal/designer/jsp/configeditable.jsp',function(value){
											if(!value){
												return;
											}
											var conf = {};
											if($.trim(self.element.attr("data-config"))!=""){
												conf = Util.toJSON(unescape(self.element.attr("data-config")));
											}
											self.config.vSpacing = value.vSpacing;
											conf.vSpacing = value.vSpacing;
											self.element.attr("data-config",escape(JSON.stringify(conf)));
											self.element.children('.widgetDock').css("height",value.vSpacing);
										},400,300).dialogParameter = dp;
									}
			                 	 }
			                 ];	
			return $super(this.menuItems);
		},
		startup : function($super){ 
			var self=this;
			this.dropElement = (function(){
				if(self.element.children().length >0){
					var x = $(self.element.children()[0]);
					if(x.is(".widgetDock")){
						return x;
					}else{
						x = $("<div class='widgetDock'></div>").css("height",self.config.vSpacing);
						self.element.prepend(x);
						return x;
					}
				}else{
					var x = $("<div class='widgetDock'></div>").css("height",self.config.vSpacing);
					self.element.prepend(x);
					return x;
				}
			})();

			this.drop = new DragDrop.Droppable({
				body:self.body,
				element:self.dropElement,
				activeClass: "dropActiveClass",
				hoverClass: "dropHoverClass",
				over: function() {
					//this.element.height(30);
				},
				out : function() {
					this.element.css("height",self.config.vSpacing);
				},
				drop: function(moveObj) {
					moveObj.parent.children.splice($.inArray(moveObj,moveObj.parent.children),1);
					moveObj.parent = self;
					self.children.push(moveObj);
					this.element.after(moveObj.dropElement.css("height",self.config.vSpacing));
					this.element.after(moveObj.element);
				}
			});
			$super(); 
		},
		destroy : function(){			
			this.editMenu.remove();
			for(var i=this.children.length-1;i>=0;i=this.children.length-1){
				this.children[i].destroy();				
			}
			this.element.remove();
			this.dropElement.remove();
			//父容器中删除自己
			var x = $.inArray(this,this.parent.children);
			this.parent.children.splice(x,1);
			try{delete this;}catch(e){};
		}
	}); 
	module.exports = Editable;
});