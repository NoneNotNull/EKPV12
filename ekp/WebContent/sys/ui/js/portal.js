// JavaScript Document
define(function(require, exports, module) { 
	var $ = require("lui/jquery");
	var base = require('lui/base');
	var panel = require('lui/panel');
	
	
	var AbstractBase = base.Component.extend({
		draw: function(){
			for ( var i = 0; i < this.children.length; i++) {
				if(this.children[i].draw)
					this.children[i].draw();
			}
		}
	});
	var Container = AbstractBase.extend({
		initProps : function(config){
			this.boxs = [];
			this.widget = [];
		},
		addChild : function($super, child, attrName) {
			if(child instanceof VBox){
				this.boxs.push(child);
			}
			if(child instanceof panel.AbstractPanel){
				this.widget.push(child);
			}
			$super(child,attrName);
	    },
	    resize : function(isFirst){
	    	for(var i=0;i<this.boxs.length;i++){
				this.boxs[i].resize(isFirst);
			}
	    	if(isFirst==null || isFirst == false){
		    	for(var i=0;i<this.widget.length;i++){
					this.widget[i].resize();
				}
	    	}
	    }
	});
	var VBox = AbstractBase.extend({
		initProps : function(config){
			this.oldWidth = this.config.boxWidth;
			this.boxs = [];
		},
		resizeTimeout : function(func,timeout){
			//resize要做一定延时否则在拖动窗口大小时触发频率太高。
			var resizeIng = new Array();
			$(window).resize(function(){
				if(resizeIng.length > 0){
					for(var i=0;i<resizeIng.length;i++){
						window.clearTimeout(resizeIng[i]);
					}
					resizeIng = new Array();
				}
				resizeIng.push(window.setTimeout(function(){
					func();
				},timeout));
			});
		},
		startup : function(){
			this.resize(true);
			 
			//最外层的容器需要监听Windows的resize事件然后向下传递。
			if(this.parent == null){
				var self = this;
				this.resizeTimeout(function(){
					self.resize();
				},500);
			}
			 
		},
		resize : function(isFirst){
			var boxWidth = this.element.parent().width();
			if(this.parent == null){
				// 最外层Vbox需要判断最小宽度
				if(boxWidth < this.oldWidth){
					boxWidth = this.oldWidth;
				}
			} 
			if(boxWidth == this.config.boxWidth){
				return;
			}
			this.element.attr("width",boxWidth);	
			//最终宽度
			this.config.boxWidth = boxWidth;
			//旧的总宽度
			var oldTotal = 0;
			//列间距宽度
			var totalSpacing = 0;
			for(var i=0;i<this.boxs.length;i++){
				if(i>0){
					totalSpacing += parseInt(this.boxs[i].config.hSpacing);
				}else{
					this.boxs[i].config.hSpacing = 0;
				}
				oldTotal += parseInt(this.boxs[i].config.columnWidth);
			}
			
			//除去列间距之后的宽度
			boxWidth = boxWidth - totalSpacing;
			
			//找到最后一列不锁定宽度的列序号,并且计算每列的比例值;
			var unLock = 0;
			for(var i=0;i<this.boxs.length;i++){
				if(this.boxs[i].config.columnLock!=null && Boolean(this.boxs[i].config.columnLock)){
					//锁定列
				}else{
					//非锁定列，计算每列所占的比列
					this.boxs[i].config.columnProportion = parseFloat(this.boxs[i].config.columnWidth) / parseFloat(oldTotal);					
					unLock = i;
				}
			}

			var tempTotal = 0;
			//计算除了unLock列以为的列宽度
			for(var i=0;i<this.boxs.length;i++){
				if(i!=unLock){
					var columnWidth = 0;
					if(this.boxs[i].config.columnLock!=null && Boolean(this.boxs[i].config.columnLock)){
						columnWidth = this.boxs[i].config.columnWidth;
					}else{
						columnWidth = Math.round(boxWidth * this.boxs[i].config.columnProportion);
					} 
					tempTotal += columnWidth;
					this.boxs[i].config.columnWidth = columnWidth;
					this.boxs[i].element.attr("width",columnWidth);					
				}
			}
			
			//计算unLock列的宽度	
			var columnWidth = boxWidth - tempTotal;			
			this.boxs[unLock].config.columnWidth = columnWidth;
			this.boxs[unLock].element.attr("width",columnWidth);
			this.boxs[unLock].resize(isFirst);	
			
			//向子容器传递resize
			for(var i=0;i<this.boxs.length;i++){
				if(this.boxs[i].config.columnLock!=null && Boolean(this.boxs[i].config.columnLock)){
					
				}else{
					//只有非锁定列需要向子容器传递
					this.boxs[i].resize(isFirst);
				}
			}			
		},
		addChild: function($super, child, attrName) {
			if(child instanceof Container){
				this.boxs.push(child);
			}
			$super(child,attrName);
	    }
	});

	exports.VBox = VBox;  
	exports.Container = Container; 
});