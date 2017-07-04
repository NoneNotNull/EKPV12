define(function(require, exports, module) {	 
	var $ = require("lui/jquery");
	var Base = require("./Base");
	var DragDrop = require('lui/dragdrop');
	var Util = require('./Util');
	var VBox = Base.extend({
		initialize : function($super,config) {
			$super(config);
		},
		startup : function(){
			var self = this;
			//this.dropElement = $("<div class='widgetDock'></div>").css("height",this.parent.config.vSpacing);
			this.dropElement = (function(){
				if(self.element.next("div").is(".widgetDock")){
					return self.element.next("div");
				}else{
					return $("<div class='widgetDock'></div>").css("height",self.parent.config.vSpacing);
				}
			})();
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
		},
		alculateWidth : function(){
			var vBoxConfig = Util.toJSON(unescape(this.element.attr("data-config")));
			var boxWidth = vBoxConfig.boxWidth;
			var total = 0;
			var totalSpacing = 0;
			var cols = [];
			for(var i=0;i<this.children.length;i++){
				var col = Util.toJSON(unescape(this.children[i].element.attr("data-config")));
				cols.push(col);
				total += parseInt(col.columnProportion);
				if(i>0){
					totalSpacing += parseInt(col.hSpacing);
				}
			}
			var tempTotal = 0;
			boxWidth = boxWidth - totalSpacing;
			for(var i=0;i<this.children.length;i++){				 
				var columnWidth = 0;
				if(i==this.children.length-1){
					//最后一列等于总数减去前面所有列的和
					columnWidth=boxWidth-tempTotal;
				}else{
					columnWidth=Math.round(boxWidth * (parseInt(cols[i].columnProportion) / total));	
					tempTotal += columnWidth;
				} 
				cols[i].columnWidth = columnWidth;
				if(i==0)
					cols[i].hSpacing = 0;
				this.children[i].element.attr("data-config",escape(JSON.stringify(cols[i])));
				this.children[i].element.attr("width",columnWidth);
				//计算子对象里面表格宽度 

				for(var j=0;j<this.children[i].children.length;j++){
					if(this.children[i].children[j] instanceof VBox){
						var xbox = Util.toJSON(unescape(this.children[i].children[j].element.attr("data-config")));
						xbox.boxWidth = columnWidth;
						this.children[i].children[j].element.attr("data-config",escape(JSON.stringify(xbox)));
						this.children[i].children[j].element.attr("width",xbox.boxWidth);
						this.children[i].children[j].alculateWidth();
					} 
				}
			}
			vBoxConfig.column = this.children.length;
			this.element.attr("data-config",escape(JSON.stringify(vBoxConfig)));
			this.element.attr("width",vBoxConfig.boxWidth);
		},
		destroy : function(){
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
	module.exports = VBox;
});