define([
        "dojo/_base/declare",
        "dojox/mobile/TabBar",
        "dojo/dom-class",
    	"dojo/dom-geometry",
    	"dojo/_base/array",
	], function(declare, TabBar, domClass, domGeometry, array) {
	
	return declare("mui.tabbar.TabBar", [TabBar], {
		
		fill: 'always',
		
		resize: function(size){
			if (this.fill == 'grid') {
				this.resizeByGrid(size);
				return;
			}
			this.inherited(arguments);
		},
		
		resizeByGrid: function(size) {
			var i, w, h;
			if(size && size.w){
				w = size.w;
			}else{
				w = domGeometry.getMarginBox(this.domNode).w;
			}
			domClass.toggle(this.domNode, "mblTabBarNoIcons",
							!array.some(this.getChildren(), function(w){ return w.iconNode1; }));
			domClass.toggle(this.domNode, "mblTabBarNoText",
							!array.some(this.getChildren(), function(w){ return w.label; }));
			
			//this.containerNode.style.padding = "0 5px";
			
			domClass.add(this.domNode, "muiTabBarGrid");
			var cellWidth = 25;
			var percent = true; 
			if(w > 0){
				cellWidth = w / 4 - 36;
				percent = false;
			}
			array.forEach(this.getChildren(), function(child, i) {
				var colSize = child.colSize || 1;
				if(percent){
					child.domNode.style.width = (cellWidth * colSize-3) + "%";
				}else{
					child.domNode.style.width = (cellWidth * colSize + ((colSize - 1) * 36)) + "px";
				}
			});
			
			if(size && size.w) {
				domGeometry.setMarginBox(this.domNode, size);
			}
		}
	});
});